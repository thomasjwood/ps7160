# Fetch the per-wave Bright Line Watch .rds files from github.com/thomasjwood/ps7160/tree/master/blw into raw/
dir.create("raw", showWarnings = FALSE)
files <- c(paste0("public_wave", c(3:10, 12:30), ".rds"), paste0("expert_wave", 1:30, ".rds"),
           "expert_waves1_to_7.rds", "source_url")
base <- "https://raw.githubusercontent.com/thomasjwood/ps7160/master/blw/"
for (f in files) if (!file.exists(file.path("raw", f)))
  download.file(paste0(base, f), file.path("raw", f), mode = "wb", quiet = TRUE)
