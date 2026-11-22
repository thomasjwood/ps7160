# =============================================================================
# Inventory of every source variable in every wave file (name, storage class,
# n non-missing, variable label, value labels / example values).
# Writes docs/source_variable_inventory/<file>.tsv. Useful when extending the
# stacked files with wave-specific items that are not harmonized yet.
# =============================================================================
suppressPackageStartupMessages(library(tidyverse))
out <- "docs/source_variable_inventory"; dir.create(out, showWarnings = FALSE, recursive = TRUE)
raw_dir <- if (file.exists("raw/public_wave30.rds")) "raw" else ".."
fs <- list.files(raw_dir, "^(public|expert)_wave[0-9]+[.]rds$|^expert_waves1_to_7[.]rds$")
for (f in fs) {
  d <- readRDS(file.path(raw_dir, f))
  m <- imap_dfr(d, \(x, v) {
    xc <- if (is.factor(x)) as.character(x) else as.character(as.vector(unclass(x)))
    lab <- attr(x, "label"); lab <- if (is.null(lab)) "" else paste(lab, collapse = " ")
    vl <- attr(x, "labels")
    vals <- if (is.factor(x)) paste(levels(x), collapse = " | ")
            else if (!is.null(vl)) paste(paste0(vl, "=", names(vl)), collapse = " | ")
            else { u <- unique(na.omit(xc)); paste0(if (length(u) > 8) paste0("[", length(u), " uniq] ") else "", paste(head(u, 8), collapse = " | ")) }
    tibble(var = v, class = class(x)[1], n = sum(!is.na(xc) & xc != ""),
           label = str_squish(str_trunc(lab, 300)), values = str_squish(str_trunc(vals, 300)))
  })
  write_tsv(m, file.path(out, sub("[.]rds$", ".tsv", f)))
}
