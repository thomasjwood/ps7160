# =============================================================================
# Bright Line Watch -- build the PUBLIC and EXPERT stacked (pooled) files
# -----------------------------------------------------------------------------
# Input : per-wave .rds files from github.com/thomasjwood/ps7160/tree/master/blw
#         (originally from brightlinewatch.org/survey-data-and-replication-material/)
# Output: build/_intermediate.rds  (harmonized but unlabelled; read by 03 and 04)
#         Final, wave-suffixed files are written by 04_label_and_save.R.
#
# Run from the project root:  source("syntax/run_all.R")
# =============================================================================

source("syntax/00_item_dictionary.R")
source("syntax/01_helpers.R")

# per-wave source files: raw/ in a standalone copy, or the parent folder when this
# lives at ps7160/blw/stacked/ next to the original .rds files
raw_dir <- if (file.exists("raw/public_wave30.rds")) "raw" else ".."
for (dd in c("data", "docs", "build")) dir.create(dd, showWarnings = FALSE)

# ---- 1. which file holds which wave ------------------------------------------
# Notes on the repo files (verified in syntax/03_checks.R):
#  * expert_wave7.rds is a second copy of wave 6 (same 679 response IDs, July 2018
#    dates). The real wave 7 (n = 747, Oct-Nov 2018) is taken from
#    expert_waves1_to_7.rds.
#  * public_wave_unk.rds == public_wave9.rds; unknown_wave_unk.rds == public_wave10.rds;
#    expert_wave_unk.rds is wave 9 stored as factors. All three are ignored.
#  * BLW wave 11 (July 2020) and waves 1-2 were expert-only; there is no public file.
#  * The *_waves1_to_N / *_waves3_to_N files are BLW's earlier cumulative files and
#    duplicate the single-wave files (used here only for expert wave 7).
wave_files <- bind_rows(
  tibble(survey = "public", wave = c(3:10, 12:30)) |> mutate(file = paste0("public_wave", wave, ".rds")),
  tibble(survey = "expert", wave = 1:30) |> mutate(file = if_else(wave == 7, "expert_waves1_to_7.rds", paste0("expert_wave", wave, ".rds")))
)

read_wave <- function(survey, wave, file) {
  d <- readRDS(file.path(raw_dir, file))
  if (survey == "expert" && wave == 7) {
    d <- d |> filter(.data$wave == 7)
    d <- d[, map_lgl(d, \(x) any(!is.na(x) & as_text(x) != ""))]    # drop columns never asked in wave 7
  }
  if (survey == "public" && wave == 30) {
    # wave 30 ships BLW-harmonized columns plus the raw YouGov columns (raw_*);
    # strip the prefix and keep the first copy of any duplicated name.
    names(d) <- str_remove(names(d), "^raw_")
    d <- d[, !duplicated(names(d))]
  }
  if (survey == "public" && wave == 18) {
    # wave 18 (Nov-Dec 2022) re-asked the profile items post-election as <var>_post;
    # use them where the base name is absent (the battery keeps its _post names)
    post <- names(d)[str_detect(names(d), "_post$") & !str_detect(names(d), "^statments")]
    base <- str_remove(post, "_post$")
    ren  <- !base %in% names(d)
    names(d)[match(post[ren], names(d))] <- base[ren]
  }
  d
}

# ---- 2. battery crosswalk ------------------------------------------------------
name_alias <- c(foreign = "foreign_influence", judicial_independence = "judicial_ind",
                contributions_determine = "contributions", common_understanding = "common_und")

looks_like <- function(x) {
  v <- norm_txt(unique(c(as_text(x), if (is.factor(x)) levels(x), names(attr(x, "labels")))))
  if (any(str_detect(v, "meets? this standard|partly meets|^does not meet"), na.rm = TRUE)) "perf"
  else if (any(str_detect(v, "^not relevant|^beneficial|^essential"), na.rm = TRUE)) "imp"
  else NA_character_
}

battery_xwalk <- function(d, survey, wave) {
  vars <- names(d)
  lab  <- map_chr(vars, \(v) { l <- attr(d[[v]], "label"); if (is.null(l)) "" else paste(l, collapse = " ") })
  out  <- list()

  # (a) variables already named perf_<key> / imp_<key>
  m <- str_match(vars, "^(perf|imp)_(.+)$")
  k <- coalesce(unname(name_alias[m[, 3]]), m[, 3])
  ok <- !is.na(m[, 1]) & k %in% blw_items$key
  if (any(ok)) out$name <- tibble(source_var = vars[ok], battery = m[ok, 2], key = k[ok],
                                  method = "variable name", provenance = "BLW variable name")

  # (b) index-based specs (grid position -> item), from the questionnaires
  sp <- battery_specs |> filter(.data$survey == !!survey, .data$wave == !!wave)
  for (i in seq_len(nrow(sp))) {
    idx <- as.integer(str_match(vars, sp$rx[i])[, 2])
    ord <- unlist(sp$order[[i]])
    key <- ifelse(!is.na(idx) & idx <= length(ord), ord[pmin(idx, length(ord))], NA)
    hit <- !is.na(key)
    if (any(hit)) out[[paste0("spec", i)]] <- tibble(source_var = vars[hit], battery = sp$battery[i], key = key[hit],
                                                     method = if_else(sp$role[i] == "map", "grid position", "variable label"),
                                                     provenance = sp$source[i], role = sp$role[i])
  }
  xw <- bind_rows(out)

  # (c) remaining variables whose label names a BLW principle and whose values are a PERF/IMP scale
  rest <- setdiff(vars[nzchar(lab)], if (nrow(xw)) xw$source_var else character())
  rest <- rest[!str_detect(rest, "Click|Submit|_DO_|_rnd$|treat|split|observed|excluded|_text$|future|2027|_post_|pipe")]
  if (length(rest)) {
    lk <- blw_match_label(lab[match(rest, vars)])
    bt <- map_chr(rest, \(v) looks_like(d[[v]]))
    keep <- !is.na(lk) & !is.na(bt)
    if (any(keep)) xw <- bind_rows(xw, tibble(source_var = rest[keep], battery = bt[keep], key = lk[keep],
                                              method = "variable label", provenance = "variable label"))
  }
  if (!nrow(xw)) return(tibble())

  # label check for every mapped variable that carries a usable label
  xw |>
    mutate(source_label = lab[match(source_var, vars)],
           label_key = blw_match_label(source_label),
           label_agrees = case_when(key == "COURT" ~ NA, is.na(label_key) ~ NA, TRUE ~ label_key == key),
           survey = survey, wave = as.integer(wave)) |>
    distinct(source_var, .keep_all = TRUE)
}

# ---- 3. recode one wave's battery into perf_<key> / imp_<key> -----------------
recode_battery <- function(d, xw, survey, wave) {
  n <- nrow(d); res <- list()
  # role "check" rows agree with labels by construction of the specs; if a label
  # disagrees we trust the label (and it is reported in build/qa_crosswalk_disagreements.csv)
  xw <- xw |> mutate(key = if_else(!is.na(label_agrees) & !label_agrees, label_key, key))
  # public wave 28: the first grid row was piped (judiciary / Supreme Court / lower courts)
  if (any(xw$key == "COURT")) {
    court <- norm_txt(as_text(d$limit_executive_power_text))
    ck <- case_when(str_detect(court, "^the judiciary") ~ "judiciary_check",
                    str_detect(court, "supreme court") ~ "judiciary_check_scotus",
                    str_detect(court, "lower courts") ~ "judiciary_check_lwr")
  }
  for (j in seq_len(nrow(xw))) {
    .ctx$var <- xw$source_var[j]
    v <- recode_scheme(d[[xw$source_var[j]]], S[[xw$battery[j]]], target = paste0(xw$battery[j], "_item"),
                       num_valid = if (xw$battery[j] == "perf") 1:5 else 1:4)
    keys <- if (xw$key[j] == "COURT") ck else rep(xw$key[j], n)
    for (kk in unique(na.omit(keys))) {
      nm <- paste0(xw$battery[j], "_", kk)
      vv <- ifelse(keys == kk, v, NA)
      if (is.null(res[[nm]])) res[[nm]] <- vv
      else {
        both <- !is.na(res[[nm]]) & !is.na(vv)
        if (any(both)) qa_unmatched$coalesce <- bind_rows(qa_unmatched$coalesce,
          tibble(survey = survey, wave = wave, target = nm, n_both = sum(both), n_disagree = sum(res[[nm]][both] != vv[both])))
        res[[nm]] <- coalesce(res[[nm]], vv)
      }
    }
  }
  as_tibble(res)
}

# ---- 4. public core variables ------------------------------------------------
build_public_core <- function(d, wave) {
  n <- nrow(d); .ctx$survey <- "public"; .ctx$wave <- wave
  g <- function(...) pick(d, ...)
  r <- function(x, s, target, ...) { if (is.null(x)) na_vec(n) else recode_scheme(x, S[[s]], target, ...) }

  start <- parse_dt(g("starttime", "start_date", "start")); end <- parse_dt(g("endtime", "end_date", "end"))
  out <- tibble(
    # waves 18/24/28 have no `caseid`; their own-wave YouGov id sits under the project code
    # (complete and unique in each file; the other caseid_* columns are recontact links)
    resp_id     = as.character(g("caseid", "caseid_DART0049_W3", "caseid_w9", "caseid_DART0057_W3") %||% rep(NA, n)),
    weight      = as.numeric(g("weight", "wt") %||% na_vec(n)),
    start_time  = start %||% as.POSIXct(rep(NA, n)),
    end_time    = end %||% as.POSIXct(rep(NA, n)),
    rating_USA  = parse_num(g("rating_USA", "rating_USA_post", "USrating", "US_democracy_rating") %||% na_vec(n)),
    pid3        = r(g("pid3"), "pid3", "pid3", num_valid = 1:5),
    pid7        = r(g("pid7"), "pid7", "pid7", num_map = c(`1` = 1, `2` = 2, `3` = 3, `4` = 4, `5` = 5, `6` = 6, `7` = 7, `8` = 8, `9` = 8)),
    ideo7       = r(g("ideo7"), "ideo7", "ideo7", num_map = c(`1` = 7, `2` = 6, `3` = 5, `4` = 4, `5` = 3, `6` = 2, `7` = 1)),
    ideo5       = r(g("ideo5"), "ideo5", "ideo5", num_valid = 1:6),
    birthyr     = parse_num(g("birthyr") %||% na_vec(n), 1900, 2012),
    age_src     = parse_num(g("age") %||% na_vec(n), 17, 110),
    gender      = r(g("gender", "gender_o"), "gender", "gender", num_valid = 1:3),
    hispanic    = r(g("hispanic"), "yesno", "hispanic", num_valid = 1:2),
    race8       = r(g("race"), "race8", "race8", num_valid = 1:8),
    ethnicity   = r(g("ethnicity"), "ethnicity", "ethnicity", num_valid = 1:7),
    faminc      = r(g("faminc_new"), "faminc", "faminc", num_valid = 1:16),
    state_fips  = recode_state(g("inputstate")) %||% na_vec(n),
    votereg     = r(g("votereg"), "votereg", "votereg", num_valid = 1:3),
    newsint     = r(g("newsint"), "newsint", "newsint", num_valid = c(1:4, 7)),
    polinterest = r(g("polinterest"), "polinterest", "polinterest", num_valid = 1:5),
    presvote16  = r(g("presvote16post"), "presvote16", "presvote16", num_valid = 1:7),
    presvote20  = r(g("presvote20post"), "presvote20", "presvote20", num_valid = 1:6),
    presvote24  = r(g("presvote24post"), "presvote24", "presvote24", num_valid = c(1:6, 8, 9)),
    religpew    = r(g("religpew"), "religpew", "religpew", num_valid = 1:12),
    pew_churatd = r(g("pew_churatd"), "churatd", "pew_churatd", num_valid = 1:7),
    pew_bornagain = r(g("pew_bornagain"), "yesno", "pew_bornagain", num_valid = 1:2),
    pew_religimp  = r(g("pew_religimp"), "religimp", "pew_religimp", num_valid = 1:4),
    pew_prayer  = r(g("pew_prayer"), "prayer", "pew_prayer", num_valid = 1:8),
    marstat     = r(g("marstat"), "marstat", "marstat", num_valid = 1:6),
    employ      = r(g("employ"), "employ", "employ", num_valid = 1:9),
    child18     = r(g("child18"), "yesno", "child18", num_valid = 1:2),
    ownhome     = r(g("ownhome"), "ownhome", "ownhome", num_valid = 1:3)
  )
  # education: 7-category BLW item (educ7; called educ in waves 3-6) or YouGov 6-category educ
  e7 <- g("educ7"); e <- g("educ")
  e_is7 <- !is.null(e) && !is_bare_numeric(e) && any(str_detect(norm_txt(as_text(e)), "bachelor|master"), na.rm = TRUE)
  out$educ7 <- if (!is.null(e7)) recode_scheme(e7, S$educ7, "educ7", num_valid = 1:7) else if (e_is7) recode_scheme(e, S$educ7, "educ7") else na_vec(n)
  out$educ6 <- if (!is.null(e) && !e_is7) recode_scheme(e, S$educ6, "educ6", num_valid = 1:6) else na_vec(n)

  # sitting-president job approval (Trump: waves 3-13 and 24-30; Biden: waves 14-23)
  pres_var <- if (wave <= 13) c("approve_trmp", "approve_trump") else if (wave <= 23) c("approve_biden", "approve_Biden")
              else c("approve_Trump_second_term", "trump_appr", "approve_trump")
  out$approve_pres     <- r(g(pres_var), "approve", "approve_pres", num_valid = 1:4)
  out$approve_pres_src <- .ctx$var
  out
}

# ---- 5. expert core variables -------------------------------------------------
build_expert_core <- function(d, wave) {
  n <- nrow(d); .ctx$survey <- "expert"; .ctx$wave <- wave
  g <- function(...) pick(d, ...)
  rating <- if (wave == 17) coalesce(parse_num(d$rusa_d50_now_1), parse_num(d$rusa_dblank_now_1))
            else parse_num(g("rating_USA", "rusa_now_1", "rusa_now", "Q3_2_1", "Q3_2__1", "_v40",
                             "US_2017_FEB", "US_2017_MAY", "US_2017_SEPT") %||% na_vec(n))
  fin <- g("Finished", "finished")
  fin <- if (is.null(fin)) na_vec(n) else {
    t <- norm_txt(as_text(fin)); case_when(t %in% c("true", "1", "yes", "finished") ~ 1, t %in% c("false", "0", "no") ~ 0, TRUE ~ NA_real_)
  }
  fld <- find_by_values(d, c("^american", "^comparative")); fld_src <- .ctx$var
  occ <- find_by_values(d, c("faculty", "^adjunct|^post-?doc")); occ_src <- .ctx$var
  tibble(
    # waves 29-30 ship only the panel identifier (luthid); it doubles as the respondent id there
    resp_id      = as.character(g("ResponseId", "responseid", "record_id", "recordID", "caseid", "response_id", "luthid") %||% rep(NA, n)),
    panel_id     = as.character(g("LuthID", "luth_id", "luthid") %||% rep(NA, n)),
    start_time   = parse_dt(g("StartDate", "startdate", "start", "start_date")) %||% as.POSIXct(rep(NA, n)),
    end_time     = parse_dt(g("EndDate", "enddate", "end", "end_date")) %||% as.POSIXct(rep(NA, n)),
    duration_sec = parse_num(g("Duration__in_seconds_", "duration__in_seconds_", "Duration_in_seconds", "duration") %||% na_vec(n), 0, 1e8),
    progress     = parse_num(g("Progress", "progress") %||% na_vec(n), 0, 100),
    finished     = fin,
    rating_USA   = rating,
    field        = { .ctx$var <- fld_src; if (is.null(fld)) na_vec(n) else recode_scheme(fld, S$field, "field", num_valid = 1:6) },
    occupation   = { .ctx$var <- occ_src; if (is.null(occ)) na_vec(n) else recode_scheme(occ, S$occupation, "occupation", num_valid = 1:6) }
  )
}

# ---- 6. loop over waves ---------------------------------------------------------
qa_unmatched$coalesce <- tibble()
all_xw <- list(); stacked <- list(public = list(), expert = list())

for (i in seq_len(nrow(wave_files))) {
  sv <- wave_files$survey[i]; w <- wave_files$wave[i]; f <- wave_files$file[i]
  d  <- read_wave(sv, w, f)
  .ctx$survey <- sv; .ctx$wave <- w
  xw <- battery_xwalk(d, sv, w) |> mutate(source_file = f)
  all_xw[[paste(sv, w)]] <- xw
  core <- if (sv == "public") build_public_core(d, w) else build_expert_core(d, w)
  bat  <- if (nrow(xw)) recode_battery(d, xw, sv, w) else tibble(.rows = nrow(d))
  stacked[[sv]][[as.character(w)]] <- bind_cols(tibble(survey = sv, wave = as.integer(w), source_file = f, source_row = seq_len(nrow(d))), core, bat)
  message(sprintf("%-6s wave %2d  n = %5d  battery vars = %3d", sv, w, nrow(d), nrow(xw)))
}

xwalk <- bind_rows(all_xw) |>
  mutate(target = if_else(key == "COURT", paste0(battery, "_judiciary_check{,_scotus,_lwr}"), paste0(battery, "_", key))) |>
  select(survey, wave, source_file, source_var, target, battery, key, method, provenance, source_label, label_key, label_agrees)

# ---- 7. finalize each survey ------------------------------------------------------
item_cols <- function(df) {
  ord <- c(paste0("rating_USA"), paste0("perf_", blw_items$key), paste0("imp_", blw_items$key))
  intersect(ord, names(df))
}

finalize_common <- function(df) {
  wave_info <- df |> group_by(wave) |>
    summarise(field_start = if (all(is.na(start_time))) as.Date(NA) else as.Date(min(start_time, na.rm = TRUE)),
              field_end   = if (all(is.na(start_time))) as.Date(NA) else as.Date(max(start_time, na.rm = TRUE)), .groups = "drop")
  df |> left_join(wave_info, by = "wave")
}

# "Not sure" on the PERF battery -> NA with Stata/SPSS-style tag ("s"): is.na() is TRUE
# and means ignore it, but the response survives (haven::na_tag(x) == "s").
tag_not_sure <- function(x) { y <- as.numeric(x); ns <- !is.na(y) & y == 5; y[ns] <- NA; y[ns] <- tagged_na("s"); y }

public <- bind_rows(stacked$public) |> finalize_common()
expert <- bind_rows(stacked$expert) |> finalize_common()

# expert wave 30 file has no timestamps; BLW fielded it in October 2026 (instrument dated Oct 2026)
expert <- expert |> mutate(field_start = if_else(wave == 30 & is.na(field_start), as.Date("2026-10-01"), field_start))

public <- public |>
  mutate(
    field_date = coalesce(as.Date(start_time), field_start),
    age        = coalesce(year(field_date) - birthyr, age_src),
    age        = if_else(age >= 18 & age <= 100, age, NA_real_),
    age4       = cut(age, c(17, 29, 44, 64, Inf), labels = FALSE),
    pid3_lean  = case_when(pid7 %in% 1:3 ~ 1, pid7 %in% c(4, 8) ~ 2, pid7 %in% 5:7 ~ 3,
                           pid3 == 1 ~ 1, pid3 == 2 ~ 3, pid3 %in% 3:5 ~ 2),
    educ4      = case_when(educ7 %in% 1:2 | educ6 %in% 1:2 ~ 1, educ7 %in% 3:4 | educ6 %in% 3:4 ~ 2,
                           educ7 == 5 | educ6 == 5 ~ 3, educ7 %in% 6:7 | educ6 == 6 ~ 4),
    race5      = case_when(hispanic == 1 | race8 == 3 | ethnicity == 6 ~ 3,
                           race8 == 1 | (is.na(race8) & ethnicity == 1) ~ 1,
                           race8 == 2 | (is.na(race8) & ethnicity == 2) ~ 2,
                           race8 == 4 | (is.na(race8) & ethnicity == 4) ~ 4,
                           race8 %in% 5:8 | (is.na(race8) & ethnicity %in% c(3, 5, 7)) ~ 5),
    income5    = case_when(faminc %in% 1:3 ~ 1, faminc %in% 4:6 ~ 2, faminc %in% 7:9 ~ 3, faminc %in% 10:12 ~ 4, faminc %in% 13:16 ~ 5),
    state_abb  = states$abb[match(state_fips, states$fips)],
    region     = states$region[match(state_fips, states$fips)],
    approve_pres_who = case_when(wave <= 13 | wave >= 24 ~ "Donald Trump", TRUE ~ "Joe Biden"),
    approve_pres_who = if_else(is.na(approve_pres), NA_character_, approve_pres_who)
  ) |>
  select(-age_src)
expert <- expert |> mutate(field_date = coalesce(as.Date(start_time), field_start))

public <- public |> mutate(across(starts_with("perf_"), tag_not_sure))
expert <- expert |> mutate(across(starts_with("perf_"), tag_not_sure))

saveRDS(list(public = public, expert = expert, xwalk = xwalk,
             unmatched = qa_unmatched$log, coalesce = qa_unmatched$coalesce),
        "build/_intermediate.rds")
message("Built: public ", nrow(public), " rows; expert ", nrow(expert), " rows")
