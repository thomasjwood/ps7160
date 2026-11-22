# SLU/YouGov Missouri poll: per-wave .rds files and a stacked file
# source: https://www.slu.edu/research/research-institute/big-ideas/slu-poll/data-archive/index.php
# Per-wave files are haven::read_sav() |> as_factor(). Files already in the repo are left alone:
# they match SLU's current releases but also keep birthyr/inputzip/agenum, which SLU has since
# dropped from its public files.
suppressPackageStartupMessages({library(haven); library(dplyr); library(purrr)})
out <- "C:/Users/thoma/Documents/GitHub/ps7160/slu_yg"
dl  <- file.path(tempdir(), "slu_dl"); dir.create(dl, showWarnings = FALSE)
base <- "https://www.slu.edu/research/research-institute/big-ideas/slu-poll/public-data/"

waves <- tribble(
  ~wave,               ~date,        ~path,
  "slu_2020_june",     "2020-06-01", "june-2020-poll/slu-poll-june-2020-spss.sav",
  "slu_2020_october",  "2020-10-01", "october-2020-poll/slu-poll-october-2020-spss.sav",
  "slu_2021_july",     "2021-07-01", "july-2021-poll/slu-poll-july-2021-spss.sav",
  "slu_2022_august",   "2022-08-01", "august-2022-poll/stlu0006-output.sav",
  "slu_2023_february", "2023-02-01", "february-2023-poll/february-2023.sav",
  "slu_2023_august",   "2023-08-01", "august-2023-poll/stlu0009-output.sav",
  "slu_2024_february", "2024-02-01", "february-2024-poll/stlu0011-output.sav",
  "slu_2024_august",   "2024-08-01", "august-2024-poll/stlu0012-output.sav",
  "slu_2025_february", "2025-02-01", "february-2025-poll/stlu0013-output.sav",
  "slu_2026_february", "2026-02-01", "february-2026-poll/stlu0015-output.sav",       # Sept 2026 revision (new weights)
  "slu_2026_august",   "2026-08-01", "august-2026-poll/stlu0016-output.sav"
) |> mutate(date = as.Date(date))

get_sav <- function(path) {
  f <- file.path(dl, basename(path))
  if (!file.exists(f)) download.file(paste0(base, path), f, mode = "wb", quiet = TRUE)
  as_factor(read_sav(f))
}

# new waves -----------------------------------------------------------------
for (i in seq_len(nrow(waves))) {
  f <- file.path(out, paste0(waves$wave[i], ".rds"))
  if (file.exists(f)) next
  x <- get_sav(waves$path[i])
  if (waves$wave[i] == "slu_2026_february") {
    # the Sept revision only reweights (weight = new, weight_old = March weight) but drops agenum/birthyr;
    # bring those back from the original March release
    orig <- get_sav("february-2026-poll/stlu0015-output-march.sav")
    stopifnot(isTRUE(all.equal(as.numeric(x$weight_old), as.numeric(orig$weight))))
    x <- left_join(x, select(orig, caseid, agenum, birthyr), by = "caseid")
  }
  saveRDS(x, f); cat("wrote", basename(f), dim(x), "\n")
}

# stacked file ---------------------------------------------------------------
# SLU reuses item names (POLS001 ...) for different questions across waves. A column is shared
# across waves only when its label is the same in every wave it appears in (ignoring years, e.g.
# "2020 Vote likelihood" vs "2024 Vote likelihood") and its type is the same; otherwise it gets a
# wave suffix (POLS001_2026aug). slu_stacked_vars.rds maps every stacked column to its wave(s),
# original name and label.
L <- map(set_names(waves$wave), \(w) readRDS(file.path(out, paste0(w, ".rds"))))
tag <- \(w) { p <- strsplit(sub("^slu_", "", w), "_")[[1]]; paste0(p[1], substr(p[2], 1, 3)) }
lab <- \(v) { a <- attr(v, "label"); if (is.null(a)) "" else a }
norm <- \(s) gsub("\\s+", " ", tolower(trimws(gsub("\\b(19|20)[0-9]{2}\\b", "YYYY", s))))

meta <- imap_dfr(L, \(x, w) tibble(wave = w, var = names(x), label = map_chr(x, lab),
                                   type = map_chr(x, \(v) if (is.factor(v)) "factor" else class(v)[1])))
# same concept, label wording varies across waves (2026 files call gender "Sex")
force_shared <- c("caseid", "weight", "gender", "hispanic", "inputzip", "sample_treat")
shared <- meta |> group_by(var) |>
  summarise(shared = n_distinct(norm(label)) == 1 | var[1] %in% force_shared,
            mixed  = n_distinct(type) > 1, .groups = "drop")
meta <- meta |> left_join(shared, by = "var") |>
  mutate(stacked_name = ifelse(shared, var, paste0(var, "_", map_chr(wave, tag))))

# shared columns stored as factor in some waves and character/numeric in others (MO_Region,
# county_fips ...): numeric if every value parses as a number, otherwise character
mixed <- unique(meta$var[meta$shared & meta$mixed])
to_num <- map_lgl(set_names(mixed), \(v) all(map_lgl(L, \(x) is.null(x[[v]]) ||
  !anyNA(suppressWarnings(as.numeric(as.character(na.omit(x[[v]]))))))))
stk <- imap_dfr(L, \(x, w) {
  for (v in intersect(mixed, names(x))) {
    l <- attr(x[[v]], "label"); x[[v]] <- as.character(x[[v]])
    if (to_num[[v]]) x[[v]] <- as.numeric(x[[v]])
    attr(x[[v]], "label") <- l
  }
  m <- filter(meta, wave == w)
  x <- set_names(x, m$stacked_name[match(names(x), m$var)])
  mutate(x, wave = w, wave_date = waves$date[waves$wave == w], .before = 1)
}) |> arrange(wave_date)
vars <- meta |> group_by(stacked_name) |>
  summarise(var = first(var), label = first(label), waves = paste(wave, collapse = ", "),
            n_waves = n(), .groups = "drop") |>
  arrange(match(stacked_name, names(stk)))

saveRDS(stk,  file.path(out, "slu_stacked.rds"))
saveRDS(vars, file.path(out, "slu_stacked_vars.rds"))
cat("stacked:", dim(stk), "| shared cols:", sum(vars$n_waves > 1), "\n")
