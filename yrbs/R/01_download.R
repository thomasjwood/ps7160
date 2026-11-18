# Download national YRBS ASCII data + SAS input/format programs, 1991-2025
library(magrittr)
base <- "https://www.cdc.gov/yrbs/files/"
files <- c(
  "2025/XXH2025_YRBS_Data.dat", "2025/2025XXH-Formats-Program.sas", "2025/2025XXH-SAS-Input-Program.sas",
  "2023/XXH2023_YRBS_Data.dat", "2023/2023XXH-Formats-Program.sas", "2023/2023XXH-SAS-Input-Program.sas",
  "2021/XXH2021_YRBS_Data.dat", "2021/2021XXH-Formats-Program.sas", "2021/2021XXH-SAS-Input-Program.sas",
  "2019/XXH2019_YRBS_Data.dat", "2019/2019XXH-Formats-Program.sas", "2019/2019XXH-SAS-Input-Program.sas",
  "2017/XXH2017_YRBS_Data.dat", "2017/2017XXH_Formats_Program.sas", "2017/2017XXH_SAS_Input_Program.sas",
  unlist(lapply(seq(1991, 2015, 2), function(y)
    c(sprintf("%d/yrbs%d.dat", y, y),
      sprintf("%d/YRBS_%d_SAS_Format_Program.sas", y, y),
      sprintf("%d/YRBS_%d_SAS_Input_Program.sas", y, y))))
)
options(timeout = 1200)
for (f in files) {
  dest <- file.path("raw", f)
  dir.create(dirname(dest), showWarnings = FALSE, recursive = TRUE)
  if (file.exists(dest) && file.size(dest) > 0) next
  ok <- tryCatch({download.file(paste0(base, f), dest, mode = "wb", quiet = TRUE); TRUE},
                 error = function(e) {message("FAIL ", f, ": ", conditionMessage(e)); FALSE})
}
fs <- file.path("raw", files)
print(data.frame(f = files, mb = round(file.size(fs) / 1e6, 2)))
