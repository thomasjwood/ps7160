# 2023 SADC programs (labels CDC blanked in 2025) and SADC user's guide
options(timeout = 600)
dir.create("raw/sadc_2023", showWarnings = FALSE)
u <- c("https://www.cdc.gov/yrbs/files/sadc_2023/HS/2023-SADC-SAS-Formats-Program.sas",
       "https://www.cdc.gov/yrbs/files/sadc_2023/HS/2023-SADC-SAS-Input-Program.sas",
       "https://www.cdc.gov/yrbs/media/pdf/2023/2023-YRBS-SADC-Documentation.pdf",
       "https://www.cdc.gov/yrbs/files/2025/2025-YRBS-Data-Users-Guide-Final.pdf")
for (x in u) { d <- file.path("raw/sadc_2023", basename(x)); if (!file.exists(d)) download.file(x, d, mode = "wb", quiet = TRUE); cat(basename(x), file.size(d), "\n") }
