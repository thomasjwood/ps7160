# Stack the free LAPOP AmericasBarometer Grand Merge (2004-2023) with the
# 2026 regional merged file.
#
# Data: download both from
# https://www.vanderbilt.edu/center-for-global-democracy/data/directory/
# into raw/ (each user must accept LAPOP's agreement and download themselves;
# the data may not be shared or posted).
#   raw/Grand_Merge_2004-2023_LAPOP_AmericasBarometer_v1.0_FREE.dta
#   raw/ab2026_merged.dta
#
# Output: ab_2004_2026.rds. Keeps every Grand Merge variable plus the
# 2026-only ones; a variable missing in one file is NA for those rows.
# Value labels come from whichever file has them; where the two files label a
# variable differently, the Grand Merge labels win and the 2026 codes are kept
# as-is (listed in label_conflicts.csv so you can check them).
#
# Acknowledgment required in any output: "These data were supplied by LAPOP Lab
# at Vanderbilt University, which takes no responsibility for any
# interpretation of the data."

library(haven)
library(dplyr)

setwd("C:/Users/thoma/Documents/GitHub/ps7160/lapop")

gm  <- read_dta("raw/Grand_Merge_2004-2023_LAPOP_AmericasBarometer_v1.0_FREE.dta")
a26 <- read_dta("raw/ab2026_merged.dta")

# The 2026 file codes wave as the round number (11); the Grand Merge uses the
# wave's start year. Recode so wave sorts as 2026 (fieldwork ran 2025-26; see `year`).
stopifnot(all(zap_labels(a26$wave) == 11))
a26$wave <- labelled(rep(2026, nrow(a26)), labels = c(attr(gm$wave, "labels"), "2026" = 2026),
                     label = attr(gm$wave, "label"))
gm$wave  <- labelled(as.numeric(zap_labels(gm$wave)), labels = attr(a26$wave, "labels"),
                     label = attr(gm$wave, "label"))

conflicts <- character()
for (v in intersect(names(gm), names(a26))) {
  x <- gm[[v]]; y <- a26[[v]]
  ok <- tryCatch({ vctrs::vec_ptype2(x, y); TRUE }, error = function(e) FALSE)
  if (ok) next
  conflicts <- c(conflicts, v)
  if (is.character(x) || is.character(y)) {
    gm[[v]] <- as.character(zap_labels(x)); a26[[v]] <- as.character(zap_labels(y))
  } else {
    # keep the Grand Merge labels on both
    a26[[v]] <- labelled(as.numeric(zap_labels(y)), labels = attr(x, "labels"),
                         label = attr(x, "label"))
    gm[[v]]  <- labelled(as.numeric(zap_labels(x)), labels = attr(x, "labels"),
                         label = attr(x, "label"))
  }
}

gm$source  <- "grand_merge_free"
a26$source <- "merged_2026"

# ---- single-year country files the free Grand Merge leaves out -------------
# singles_added.csv lists them (name, year, LAPOP download id); the files are
# in raw/singles/<name>_<year>_<id>. Only variables that also exist in the
# Grand Merge are kept, coerced to the Grand Merge's type and value labels.
match_to <- function(y, x) {
  if (is.character(x)) return(as.character(zap_labels(y)))
  num <- suppressWarnings(as.numeric(zap_labels(y)))
  if (inherits(x, "haven_labelled")) labelled(num, labels = attr(x, "labels"), label = attr(x, "label"))
  else num
}
added <- read.csv("singles_added.csv")
singles <- lapply(seq_len(nrow(added)), function(i) {
  f <- list.files("raw/singles", pattern = paste0("_", added$year[i], "_", added$id[i], "$"), full.names = TRUE)
  d <- read_dta(f)
  names(d) <- tolower(names(d))
  keep <- intersect(names(d), names(gm))
  out <- as_tibble(lapply(setNames(keep, keep), function(v) match_to(d[[v]], gm[[v]])))
  out$pais   <- match_to(rep(added$pais[i], nrow(out)), gm$pais)
  out$wave   <- match_to(rep(added$year[i], nrow(out)), gm$wave)
  out$source <- paste0("single_", added$year[i])
  out$n_vars_in_file <- ncol(d)
  out
})
single_vars <- vapply(singles, ncol, 1)

ab <- bind_rows(gm, a26, singles)
rm(gm, a26, singles); gc()

# English country names (pais codes are LAPOP's standard ones)
pais_en <- c(`1` = "Mexico", `2` = "Guatemala", `3` = "El Salvador", `4` = "Honduras", `5` = "Nicaragua",
  `6` = "Costa Rica", `7` = "Panama", `8` = "Colombia", `9` = "Ecuador", `10` = "Bolivia", `11` = "Peru",
  `12` = "Paraguay", `13` = "Chile", `14` = "Uruguay", `15` = "Brazil", `16` = "Venezuela", `17` = "Argentina",
  `21` = "Dominican Republic", `22` = "Haiti", `23` = "Jamaica", `24` = "Guyana", `25` = "Trinidad and Tobago",
  `26` = "Belize", `27` = "Suriname", `28` = "Bahamas", `29` = "Barbados", `30` = "Grenada", `31` = "St. Lucia",
  `32` = "Dominica", `33` = "Antigua and Barbuda", `34` = "St. Vincent and the Grenadines",
  `35` = "St. Kitts and Nevis", `36` = "Cuba", `40` = "United States", `41` = "Canada")
ab$country <- unname(pais_en[as.character(as.numeric(zap_labels(ab$pais)))])
stopifnot(!anyNA(ab$country))

write.csv(data.frame(variable = conflicts), "label_conflicts.csv", row.names = FALSE)
saveRDS(ab, "ab_2004_2026.rds", compress = "xz")
# (no .dta copy: written out, it's about 4.5 GB)
cat("rows:", nrow(ab), " vars:", ncol(ab), " label conflicts:", length(conflicts),
    " | single-year files added:", length(single_vars),
    " (vars kept per file: min", min(single_vars), "median", median(single_vars), ")\n")
