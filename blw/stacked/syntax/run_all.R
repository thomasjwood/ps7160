# =============================================================================
# Bright Line Watch stacked files -- run everything
# Run from the project root (the folder holding raw/, syntax/, data/, docs/):
#   Rscript syntax/run_all.R > build/build_log.txt 2>&1
# Outputs are suffixed with the waves they cover (e.g. _w03-30); build/ holds
# intermediates and QA output and is overwritten on every run.
# Needs: tidyverse, haven, lubridate. raw/ must hold the ps7160/blw .rds files
# (syntax/05_download_raw.R fetches them).
# =============================================================================
t0 <- Sys.time()
if (!file.exists("raw/public_wave30.rds") && !file.exists("../public_wave30.rds")) source("syntax/05_download_raw.R")
source("syntax/02_build_stacked.R")   # harmonize every wave, build crosswalk
source("syntax/03_checks.R")          # QA: crosswalk vs labels, unmatched values, item profiles
source("syntax/04_label_and_save.R")  # labels, codebooks, .rds/.dta export
message("Done in ", round(difftime(Sys.time(), t0, units = "mins"), 1), " min")
