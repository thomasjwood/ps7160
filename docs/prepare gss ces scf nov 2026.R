suppressPackageStartupMessages({library(haven); library(data.table); library(dplyr)})
dl <- "C:/Users/thoma/AppData/Local/Temp/ps7160_dl"; repo <- "C:/Users/thoma/AppData/Local/Temp/ps7160_clone"
mb <- function(f) round(file.size(f)/1e6, 1)
dir.create(file.path(repo, "gss"), showWarnings = FALSE); dir.create(file.path(repo, "cps_voting"), showWarnings = FALSE)

# SCF 2025: full public data (5 implicates), same shape as scf2022_labelled.rds, plus the summary extract
scf <- read_dta(file.path(dl, "scf/p25i6.dta")); cat("scf", dim(scf), "\n")
saveRDS(scf, file.path(repo, "fedres_scf/scf2025_labelled.rds")); rm(scf)
scfp <- read_dta(file.path(dl, "scf/rscfp2025.dta")); cat("scfp", dim(scfp), "\n")
saveRDS(scfp, file.path(repo, "fedres_scf/scfp2025_summary_extract.rds")); rm(scfp)

# CES 2022, 2024 (csv releases) and the cumulative 2006-2025 file
for (y in c("2022", "2024")) {
  f <- if (y == "2022") "CCES22_Common_OUTPUT_vv_topost.csv" else "CCES24_Common_OUTPUT_vv_topost_final.csv"
  x <- fread(file.path(dl, f), showProgress = FALSE); cat("ces", y, dim(x), "\n")
  saveRDS(as_tibble(x), file.path(repo, sprintf("cces/ces_%s_common_vv.rds", y))); rm(x)
}
file.copy(file.path(dl, "cumulative_2006-2025.rds"), file.path(repo, "cces/ces_cumulative_2006_2025.rds"), overwrite = TRUE)
file.copy(file.path(dl, c("CES_2024_GUIDE_vv.pdf", "CES Guide 2022.pdf", "guide_cumulative_2006-2025.pdf")), file.path(repo, "cces"), overwrite = TRUE)

# GSS 1972-2024 cumulative, release 3a
g <- read_dta(file.path(dl, "gss/GSS_stata/gss7224_r3a.dta")); cat("gss", dim(g), "\n")
out <- file.path(repo, "gss/gss_cumulative_1972_2024_r3a.rds")
saveRDS(g, out, compress = "xz"); cat("gss xz rds MB:", mb(out), "\n")
if (mb(out) > 95) {
  file.remove(out)
  saveRDS(g[g$year <= 1998, ], file.path(repo, "gss/gss_cumulative_1972_1998_r3a.rds"), compress = "xz")
  saveRDS(g[g$year >= 2000, ], file.path(repo, "gss/gss_cumulative_2000_2024_r3a.rds"), compress = "xz")
  cat("split:", mb(file.path(repo, "gss/gss_cumulative_1972_1998_r3a.rds")), mb(file.path(repo, "gss/gss_cumulative_2000_2024_r3a.rds")), "\n")
}
file.copy(list.files(file.path(dl, "gss/GSS_stata"), "[.](pdf|txt)$", full.names = TRUE), file.path(repo, "gss"), overwrite = TRUE)
cat("done\n")
