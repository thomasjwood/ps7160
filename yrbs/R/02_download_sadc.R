# CDC combined (SADC) national high school file, 1991-2025, plus programs and guide
options(timeout = 1200)
dir.create("raw/sadc_2025", showWarnings = FALSE)
for (f in c("sadc_2025/sadc_2025_national.dat",
            "sadc_2025/2025-SADC-SAS-Formats-Program.sas",
            "sadc_2025/2025-SADC-SAS-Input-Program.sas")) {
  dest <- file.path("raw", f)
  if (!file.exists(dest)) download.file(paste0("https://www.cdc.gov/yrbs/files/", f), dest, mode = "wb", quiet = TRUE)
  cat(f, round(file.size(dest) / 1e6, 2), "MB\n")
}
