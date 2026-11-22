# =============================================================================
# Bright Line Watch stacked files -- labels, metadata, codebooks, export
# Reads build/_intermediate.rds; writes the final data files and docs.
# Every output carries the wave range it covers, e.g. blw_public_stacked_w03-30.rds,
# so builds after new waves sit next to older versions instead of overwriting them.
# =============================================================================
source("syntax/00_item_dictionary.R")
source("syntax/01_helpers.R")
b <- readRDS("build/_intermediate.rds")
public <- b$public; expert <- b$expert; xwalk <- b$xwalk
build_date <- format(Sys.Date())

# ---- wave labels ------------------------------------------------------------
wave_lab <- function(df) {
  df |> group_by(wave) |> mutate(wave_label = sprintf("Wave %d (%s)", wave, format(min(field_start, na.rm = TRUE), "%b %Y"))) |> ungroup()
}
public <- wave_lab(public); expert <- wave_lab(expert)

# ---- value-label helpers ----------------------------------------------------
vl <- function(s) setNames(s$code, s$label)
lab_perf <- c(setNames(1:4 + 0, S$perf$label[1:4]), "Not sure" = tagged_na("s"))
lab_imp  <- vl(S$imp)

value_labels <- list(
  pid3 = vl(S$pid3), pid7 = vl(S$pid7), pid3_lean = vl(S$pid3_lean), ideo7 = vl(S$ideo7), ideo5 = vl(S$ideo5),
  gender = vl(S$gender), age4 = vl(S$age4), educ7 = vl(S$educ7), educ6 = vl(S$educ6), educ4 = vl(S$educ4),
  race8 = vl(S$race8), ethnicity = vl(S$ethnicity), race5 = vl(S$race5), hispanic = vl(S$yesno),
  faminc = vl(S$faminc), income5 = vl(S$income5), state_fips = setNames(as.numeric(states$fips), states$name),
  votereg = vl(S$votereg), newsint = vl(S$newsint), polinterest = vl(S$polinterest),
  presvote16 = vl(S$presvote16), presvote20 = vl(S$presvote20), presvote24 = vl(S$presvote24),
  approve_pres = vl(S$approve), religpew = vl(S$religpew), pew_churatd = vl(S$churatd), pew_bornagain = vl(S$yesno),
  pew_religimp = vl(S$religimp), pew_prayer = vl(S$prayer), marstat = vl(S$marstat), employ = vl(S$employ),
  child18 = vl(S$yesno), ownhome = vl(S$ownhome), field = vl(S$field), occupation = vl(S$occupation),
  finished = c("Not finished" = 0, "Finished" = 1)
)

var_labels <- c(
  survey = "Survey: public (YouGov national sample) or expert (political scientists)",
  wave = "BLW wave number (shared numbering across public and expert surveys)",
  wave_label = "BLW wave and month fielded",
  field_start = "Wave fieldwork: first response date",
  field_end = "Wave fieldwork: last response date",
  field_date = "Date respondent started the survey (wave start date if unknown)",
  resp_id = "Respondent ID within wave (YouGov caseid / Qualtrics ResponseId)",
  panel_id = "Expert panel ID (LuthID); links the same expert across waves",
  weight = "YouGov survey weight (within wave; mean 1)",
  start_time = "Survey start timestamp",
  end_time = "Survey end timestamp",
  duration_sec = "Survey duration (seconds)",
  progress = "Qualtrics progress (percent of survey completed)",
  finished = "Qualtrics: completed the survey",
  rating_USA = "How democratic is the U.S. today? (0 = least, 100 = most democratic)",
  pid3 = "Party ID (3 categories)", pid7 = "Party ID (7-point; higher = more Republican)",
  pid3_lean = "Party ID with leaners (from pid7)",
  ideo7 = "Ideology (7-point; higher = more conservative)", ideo5 = "Ideology (5-point; wave 9 and 25 only)",
  birthyr = "Birth year", age = "Age in years (field year - birth year)", age4 = "Age group",
  gender = "Gender", educ7 = "Education (7 categories)", educ6 = "Education (YouGov 6 categories)",
  educ4 = "Education (4 categories)", race8 = "Race (YouGov 8 categories)",
  ethnicity = "Race/ethnicity (BLW 7 categories)", race5 = "Race/ethnicity (5 categories; Hispanic of any race)",
  hispanic = "Hispanic or Latino origin", faminc = "Family income (16 categories)", income5 = "Family income (5 categories)",
  state_fips = "State of residence (FIPS code)", state_abb = "State of residence (postal abbreviation)",
  region = "Census region", votereg = "Registered to vote", newsint = "Follows government and public affairs",
  polinterest = "Interest in politics", presvote16 = "2016 presidential vote (recalled)",
  presvote20 = "2020 presidential vote (recalled)", presvote24 = "2024 presidential vote (recalled)",
  approve_pres = "Job approval of the sitting president", approve_pres_who = "President rated in approve_pres",
  approve_pres_src = "Source variable for approve_pres",
  religpew = "Religion (Pew)", pew_churatd = "Religious service attendance", pew_bornagain = "Born-again or evangelical Christian",
  pew_religimp = "Importance of religion", pew_prayer = "Frequency of prayer", marstat = "Marital status",
  employ = "Employment status", child18 = "Parent/guardian of child under 18", ownhome = "Home ownership",
  field = "Expert's primary field", occupation = "Expert's position",
  source_file = "Source file in ps7160/blw", source_row = "Row in source file"
)

# item labels and per-item metadata
items_meta <- blw_items |> mutate(perf_label = str_trunc(paste0("PERF: ", short), 80), imp_label = str_trunc(paste0("IMP: ", short), 80))

apply_labels <- function(df) {
  for (v in names(df)) {
    if (str_detect(v, "^perf_")) {
      k <- str_remove(v, "^perf_"); m <- items_meta[items_meta$key == k, ]
      df[[v]] <- labelled(as.numeric(df[[v]]), lab_perf, label = m$perf_label)
      attr(df[[v]], "wording") <- paste0("How well does this statement describe the United States as of today? -- ", m$wording)
    } else if (str_detect(v, "^imp_")) {
      k <- str_remove(v, "^imp_"); m <- items_meta[items_meta$key == k, ]
      df[[v]] <- labelled(as.numeric(df[[v]]), lab_imp, label = m$imp_label)
      attr(df[[v]], "wording") <- paste0("How important is this characteristic for democratic government? -- ", m$wording)
    } else if (v %in% names(value_labels)) {
      df[[v]] <- labelled(as.integer(df[[v]]), setNames(as.integer(value_labels[[v]]), names(value_labels[[v]])), label = var_labels[[v]])
    } else if (v %in% c("wave", "birthyr", "age", "source_row")) {
      df[[v]] <- structure(as.integer(df[[v]]), label = var_labels[[v]])
    } else if (v %in% names(var_labels)) {
      attr(df[[v]], "label") <- var_labels[[v]]
    }
  }
  df
}

order_cols <- function(df, demo) {
  items <- c(paste0("perf_", blw_items$key), paste0("imp_", blw_items$key))
  front <- c("survey", "wave", "wave_label", "field_start", "field_end", "field_date", "resp_id", "panel_id", "weight",
             "start_time", "end_time", "duration_sec", "progress", "finished", "rating_USA")
  df |> select(any_of(front), any_of(items), any_of(demo), everything(), any_of(c("source_file", "source_row")))
}
demo_pub <- c("pid3", "pid7", "pid3_lean", "ideo7", "ideo5", "birthyr", "age", "age4", "gender", "educ7", "educ6", "educ4",
              "race8", "ethnicity", "hispanic", "race5", "faminc", "income5", "state_fips", "state_abb", "region", "votereg",
              "newsint", "polinterest", "presvote16", "presvote20", "presvote24", "approve_pres", "approve_pres_who",
              "approve_pres_src", "religpew", "pew_churatd", "pew_bornagain", "pew_religimp", "pew_prayer", "marstat",
              "employ", "child18", "ownhome")

# drop columns that are entirely missing in a survey (e.g. items never asked of experts)
drop_empty <- function(df) df[, map_lgl(df, \(x) any(!is.na(x)) || (is.double(x) && any(!is.na(na_tag(x)))))]

public <- public |> drop_empty() |> order_cols(demo_pub) |> select(-any_of("panel_id")) |> apply_labels()
expert <- expert |> drop_empty() |> order_cols(c("field", "occupation")) |> apply_labels()

ds_note <- function(sv) paste0(
  "Bright Line Watch ", sv, " survey, all waves stacked and harmonized. Source: brightlinewatch.org survey data, ",
  "as mirrored in github.com/thomasjwood/ps7160/tree/master/blw. Built ", build_date, " by syntax/run_all.R. ",
  "PERF items: 1 = does not meet ... 4 = fully meets the standard; 'Not sure' is NA tagged 's' (haven::na_tag). ",
  "IMP items: 1 = not relevant ... 4 = essential. Item wording varies slightly across waves; see docs/codebook_<survey>_<waves>.csv ",
  "and docs/blw_battery_crosswalk_<waves>.csv for the source variable behind every value.")
attr(public, "label") <- "Bright Line Watch public surveys (YouGov), stacked waves 3-30"
attr(expert, "label") <- "Bright Line Watch expert surveys (political scientists), stacked waves 1-30"
attr(public, "notes") <- ds_note("public"); attr(expert, "notes") <- ds_note("expert")

# ---- long (respondent x item) file -------------------------------------------
to_long <- function(df) {
  keep <- intersect(c("survey", "wave", "wave_label", "field_date", "resp_id", "panel_id", "weight", "pid3_lean", "pid7", "field"), names(df))
  df |> mutate(.row = row_number()) |>
    select(all_of(keep), .row, starts_with("perf_"), starts_with("imp_")) |>
    mutate(across(c(starts_with("perf_"), starts_with("imp_")), \(x) { y <- as.numeric(x); y[!is.na(na_tag(x)) & na_tag(x) == "s"] <- 5; zap_labels(y) })) |>
    mutate(across(any_of(c("pid3_lean", "pid7", "field")), as_factor)) |>
    pivot_longer(c(starts_with("perf_"), starts_with("imp_")), names_to = c("battery", "key"), names_pattern = "^(perf|imp)_(.+)$",
                 values_to = "response", values_drop_na = TRUE) |>
    mutate(not_sure = response == 5, response = if_else(not_sure, NA_real_, response))
}
long <- bind_rows(to_long(public), to_long(expert)) |>
  left_join(blw_items |> select(key, item_short = short, item_family = family), by = "key") |>
  relocate(battery, key, item_short, item_family, response, not_sure, .after = .row) |>
  rename(resp_row = .row)
attr(long$response, "label") <- "PERF: 1 does not meet ... 4 fully meets; IMP: 1 not relevant ... 4 essential"
attr(long$not_sure, "label") <- "PERF answer was 'Not sure' (response is NA)"
attr(long$resp_row, "label") <- "Row of the respondent in the matching stacked file (within survey)"
attr(long, "label") <- "Bright Line Watch PERF and IMP batteries, long format (one row per respondent x item), public and expert"

# ---- wave table ---------------------------------------------------------------
wave_tab <- function(df, sv) {
  df |> group_by(wave, wave_label) |>
    summarise(survey = sv, field_start = first(field_start), field_end = first(field_end), n = n(),
              n_perf_items = sum(map_lgl(pick(starts_with("perf_")), \(x) any(!is.na(x) | !is.na(na_tag(x))))),
              n_imp_items  = sum(map_lgl(pick(starts_with("imp_")), \(x) any(!is.na(x)))),
              rating_USA_mean = round(mean(rating_USA, na.rm = TRUE), 1), source_file = first(source_file), .groups = "drop")
}
waves <- bind_rows(wave_tab(public, "public"), wave_tab(expert, "expert")) |> relocate(survey) |>
  mutate(rating_USA_mean = if_else(is.nan(rating_USA_mean), NA_real_, rating_USA_mean))
waves$notes <- case_when(
  waves$survey == "expert" & waves$wave == 7 ~ "Taken from expert_waves1_to_7.rds: the repo's expert_wave7.rds duplicates wave 6",
  waves$survey == "expert" & waves$wave == 23 ~ "Item order inferred (instrument PDF is a scanned image); matches waves 22/24 and item means",
  waves$survey == "expert" & waves$wave == 30 ~ "No timestamps in source file; field_start set to 2026-10-01 (instrument dated Oct 2026)",
  waves$survey == "expert" & waves$wave %in% 29:30 ~ "No response ID in source file; resp_id = panel ID (luthid)",
  waves$survey == "public" & waves$wave == 28 ~ "First grid row piped judiciary / Supreme Court / lower courts (limit_executive_power_text)",
  waves$survey == "public" & waves$wave == 18 ~ "Post-election wave: battery and profile items carry _post suffix in source",
  TRUE ~ "")

# ---- codebooks -----------------------------------------------------------------
codebook <- function(df, sv) {
  map_dfr(names(df), \(v) {
    x <- df[[v]]; labs <- attr(x, "labels")
    valid <- !is.na(x); if (is.double(x)) valid <- valid | !is.na(na_tag(x))
    present <- sort(unique(df$wave[valid]))
    tibble(survey = sv, variable = v, label = attr(x, "label") %||% "", wording = attr(x, "wording") %||% "",
           type = class(x)[1],
           values = if (!is.null(labs)) paste(paste0(ifelse(is.na(labs), paste0("NA(", na_tag(labs), ")"), labs), " = ", names(labs)), collapse = "; ")
                    else if (is.numeric(x)) sprintf("range %s to %s", format(min(x, na.rm = TRUE)), format(max(x, na.rm = TRUE))) else "",
           n_valid = sum(!is.na(x)),
           n_waves = length(present),
           waves = paste(present, collapse = ","))
  })
}
cb_pub <- codebook(public, "public"); cb_exp <- codebook(expert, "expert")
src <- xwalk |> group_by(survey, target) |> summarise(source_vars = paste0("w", wave, ":", source_var, collapse = "; "), .groups = "drop") |> rename(variable = target)
cb_pub <- cb_pub |> left_join(src |> filter(survey == "public") |> select(-survey), by = "variable")
cb_exp <- cb_exp |> left_join(src |> filter(survey == "expert") |> select(-survey), by = "variable")

# ---- write -----------------------------------------------------------------------
# ---- wave-range suffixes ----------------------------------------------------------
wtag <- function(w) sprintf("w%02d-%02d", min(w), max(w))
tag <- list(public = wtag(public$wave), expert = wtag(expert$wave), all = wtag(c(public$wave, expert$wave)))
out_file <- function(dir, stem, which, ext) file.path(dir, sprintf("%s_%s.%s", stem, tag[[which]], ext))

saveRDS(public, out_file("data", "blw_public_stacked", "public", "rds"), compress = "xz")
saveRDS(expert, out_file("data", "blw_expert_stacked", "expert", "rds"), compress = "xz")
saveRDS(long, out_file("data", "blw_battery_long", "all", "rds"), compress = "xz")
for (nm in c("public", "expert")) {
  df <- get(nm)
  df <- df |> mutate(across(where(is.character), \(x) str_trunc(x, 2000)))
  # Stata needs variable labels <= 80 chars
  for (v in names(df)) if (!is.null(attr(df[[v]], "label"))) attr(df[[v]], "label") <- str_trunc(attr(df[[v]], "label"), 80)
  write_dta(df, out_file("data", sprintf("blw_%s_stacked", nm), nm, "dta"), version = 15, label = str_trunc(attr(df, "label"), 80))
}
write_csv(waves, out_file("docs", "blw_waves", "all", "csv"), na = "")
write_csv(cb_pub, out_file("docs", "codebook_public", "public", "csv"), na = "")
write_csv(cb_exp, out_file("docs", "codebook_expert", "expert", "csv"), na = "")
write_csv(xwalk, out_file("docs", "blw_battery_crosswalk", "all", "csv"), na = "")
write_csv(blw_items |> select(key, short, family, wording), out_file("docs", "blw_item_dictionary", "all", "csv"))
message("Saved: public ", nrow(public), " x ", ncol(public), "; expert ", nrow(expert), " x ", ncol(expert), "; long ", nrow(long))
