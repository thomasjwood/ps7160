# Link a CDC single-year national YRBS file to the SADC rows for that year.
# Rows are in a different order and record IDs differ, so link on a
# fingerprint: design variables, demographics, measured height/weight, and
# every q item whose label matches and whose response distribution is
# identical in both files.
source("R/peryear_layout.R")
library(purrr); library(tidyr)

peryear_labels <- function(prog) {
  x <- readLines(prog, warn = FALSE) %>% str_trim()
  m <- str_match(x, '^(Q\\w+)\\s*=\\s*"(.*)"')
  m <- m[!is.na(m[, 1]), , drop = FALSE]
  tibble(var = tolower(m[, 2]), label = str_squish(tolower(m[, 3]))) %>%
    distinct(var, .keep_all = TRUE)
}

link_peryear <- function(sadc_year, dat, prog, extra, sadc_labels) {
  key0 <- c("weight", "stratum", "psu", "age", "sex", "grade", "stheight", "stweight")
  hw <- if (any(peryear_layout(prog)$var == "q7") &&
            str_detect(peryear_labels(prog)$label[peryear_labels(prog)$var == "q7"], "weigh"))
    c("q6", "q7") else c("q5", "q6")
  pl <- peryear_labels(prog) %>% filter(str_detect(var, "^q\\d+$"), !var %in% c("q1", "q2", "q3", hw))
  sl <- tibble(svar = names(sadc_labels), label = str_squish(tolower(sadc_labels))) %>%
    filter(str_detect(svar, "^q\\d+$"))
  cand <- inner_join(pl, sl, by = "label") %>% distinct(var, .keep_all = TRUE) %>% distinct(svar, .keep_all = TRUE)

  s <- read_peryear(dat, prog, unique(c("weight", "stratum", "psu", "q1", "q2", "q3", hw, cand$var, extra)))
  names(s)[match(c("q1", "q2", "q3", hw), names(s))] <- c("age", "sex", "grade", "stheight", "stweight")
  z <- sadc_year

  ok <- cand %>% filter(map2_lgl(var, svar, ~ identical(
    as.vector(table(s[[.x]], useNA = "always")), as.vector(table(z[[.y]], useNA = "always")))))
  # rebuild per-year columns under SADC names (avoids q-number collisions)
  s <- bind_cols(s[key0], set_names(s[ok$var], ok$svar), set_names(s[extra], paste0("x_", extra)))
  key <- c(key0, ok$svar)
  extra <- paste0("x_", extra)

  rnd <- function(d) d %>% mutate(weight = round(weight, 4),
                                  stheight = round(stheight, 2), stweight = round(stweight, 2))
  s <- rnd(s)
  z <- rnd(z) %>% select(record, all_of(key))

  m <- inner_join(z, s, by = key, relationship = "many-to-many", na_matches = "na")
  # unresolved duplicates: identical fingerprints with differing `extra` values
  # cannot be assigned; ties with identical `extra` values are harmless
  amb <- m %>% group_by(record) %>% filter(n() > 1) %>%
    summarise(same = n_distinct(pick(all_of(extra))) == 1, .groups = "drop")
  res <- m %>% group_by(record) %>% slice(1) %>% ungroup() %>%
    filter(!record %in% amb$record[!amb$same]) %>% select(record, all_of(extra))
  attr(res, "diag") <- c(n_sadc = nrow(z), n_items_in_key = length(ok$svar),
                         linked = nrow(res), unlinked = nrow(z) - nrow(res))
  res
}
