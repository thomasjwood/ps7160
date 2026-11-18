# Parse a CDC single-year YRBS SAS input program into a column layout.
# Handles both "Q1 $ 1-1" and "@17 Q1 $1." / "@389 WEIGHT 10.4" styles.
library(magrittr); library(stringr); library(dplyr)

peryear_layout <- function(f) {
  x <- readLines(f, warn = FALSE) %>% str_replace_all("\t", " ") %>% str_trim()
  i0 <- which(str_detect(x, regex("^input\\b", ignore_case = TRUE)))[1]
  i1 <- which(str_detect(x, "^;") & seq_along(x) > i0)[1]
  x <- x[(i0 + 1):(i1 - 1)]
  a <- str_match(x, "^(\\w+)\\s+\\$?\\s*(\\d+)-(\\d+)$")
  b <- str_match(x, "^@(\\d+)\\s+(\\w+)\\s+\\$?(\\d+)\\.(\\d*)")
  bind_rows(
    tibble(var = a[, 2], start = as.integer(a[, 3]), end = as.integer(a[, 4])),
    tibble(var = b[, 3], start = as.integer(b[, 2]),
           end = as.integer(b[, 2]) + as.integer(b[, 4]) - 1L)
  ) %>%
    filter(!is.na(var)) %>%
    mutate(var = tolower(var)) %>%
    distinct(var, .keep_all = TRUE)
}

# Read selected variables from a single-year file as numeric
read_peryear <- function(dat, prog, vars) {
  l <- peryear_layout(prog) %>% filter(var %in% vars)
  stopifnot(setequal(l$var, vars))
  readr::read_fwf(dat, readr::fwf_positions(l$start, l$end, l$var),
                  col_types = readr::cols(.default = "c"), trim_ws = TRUE,
                  na = c("", ".")) %>%
    filter(if_any(everything(), ~ !is.na(.x))) %>%   # drop blank lines (1997)
    mutate(across(everything(), as.numeric))
}
