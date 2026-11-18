suppressPackageStartupMessages(library(haven))
src <- "C:/Users/thoma/AppData/Local/Temp/ps7160_dl/roper_nyt"; out <- "C:/Users/thoma/AppData/Local/Temp/ps7160_clone/nyt_siena"
dir.create(out, showWarnings = FALSE)
pors <- list.files(src, "[.]por$", full.names = TRUE); bad <- character(); n <- 0
for (p in pors) { id <- sub("[.]por$", "", basename(p))
  x <- tryCatch(read_por(p), error = function(e) NULL)
  if (is.null(x) || nrow(x) == 0) { bad <- c(bad, id); next }
  saveRDS(x, file.path(out, paste0(id, ".rds"))); n <- n + 1 }
file.copy(list.files(src, "[.](pdf|por|csv)$", full.names = TRUE), out, overwrite = TRUE)
cat("converted:", n, " failed:", length(bad), bad, "\n")
x <- readRDS(file.path(out, "31118624.rds")); cat("example dims:", dim(x), " weight col:", grep("WE", names(x), value = TRUE)[1], "\n")
