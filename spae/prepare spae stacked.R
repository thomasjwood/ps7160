# SPAE (Survey of the Performance of American Elections): stacked file of every wave in this folder
# Left out: spae_2022_bystate.rds, the CSV read of the 2022 survey (same respondents and weights as
# spae_2022_national.rds). spae_2014_tenstate.rds is a separate sample (1,000 each in ten states);
# it is stacked with sample = "tenstate", so filter on `sample` before pooling national estimates.
#
# Variable names are lowercased (2016+ files use Q1, earlier ones q1). SPAE renumbers items across
# years, so a column is shared only when its label is the same in every wave it appears in
# (ignoring years); otherwise it gets a wave suffix (q1_2016, q1_2014_tenstate). spae_stacked_vars.rds maps every
# stacked column to its waves, original name and label. Weights are left as each wave has them:
# `weight` 2007-2020; `weight_stacked` (state RV) and `weight_final` (national RV) 2022-2024.
suppressPackageStartupMessages({library(dplyr); library(purrr)})
dir <- "C:/Users/thoma/Documents/GitHub/ps7160/spae"

files <- setdiff(list.files(dir, "^spae_\\d{4}_.*[.]rds$"), c("spae_2022_bystate.rds", "spae_stacked.rds", "spae_stacked_vars.rds"))
waves <- tibble(file = files, wave = gsub("^spae_|[.]rds$", "", files),
                year = as.integer(substr(wave, 1, 4)), sample = sub("^\\d{4}_", "", wave)) |> arrange(year, sample)

L <- map(set_names(waves$file, waves$wave), \(f) {
  x <- readRDS(file.path(dir, f)); n <- tolower(names(x))
  stopifnot(!anyDuplicated(n)); names(x) <- n; x })

lab  <- \(v) { a <- attr(v, "label"); if (is.null(a)) "" else a }
norm <- \(s) gsub("\\s+", " ", tolower(trimws(gsub("\\b(19|20)[0-9]{2}\\b", "YYYY", s))))
type <- \(v) if (is.factor(v)) "factor" else if (inherits(v, "POSIXt")) "POSIXct" else class(v)[1]

meta <- imap_dfr(L, \(x, w) tibble(wave = w, var = names(x), label = map_chr(x, lab), type = map_chr(x, type)))
# standard YouGov profile items: same question, label wording varies by year
force_shared <- c("caseid", "weight", "weight_stacked", "weight_final", "birthyr", "gender", "race", "race_other",
  "hispanic", "pid3", "pid3_t", "pid7", "inputstate", "inputzip", "lookupzip", "countyfips", "countyname",
  "income", "employ_t", "child18", "numadults", "landline", "newsint", "time_1", "time_2", "starttime", "endtime")
shared <- meta |> group_by(var) |>
  summarise(shared = n_distinct(norm(label)) == 1 | var[1] %in% force_shared,
            mixed = n_distinct(type) > 1, has_time = any(type %in% c("Date", "POSIXct")), .groups = "drop")
meta <- meta |> left_join(shared, by = "var") |>
  mutate(stacked_name = ifelse(shared, var, paste0(var, "_", sub("_national$", "", wave))))

# shared columns whose storage differs across waves: times -> POSIXct; otherwise numeric if every
# value parses as a number, else character
mixed <- shared |> filter(shared, mixed)
to_num <- map_lgl(set_names(mixed$var), \(v) all(map_lgl(L, \(x) is.null(x[[v]]) ||
  !anyNA(suppressWarnings(as.numeric(as.character(na.omit(x[[v]]))))))))
stk <- imap_dfr(L, \(x, w) {
  for (v in intersect(mixed$var, names(x))) {
    l <- attr(x[[v]], "label")
    x[[v]] <- if (mixed$has_time[mixed$var == v]) as.POSIXct(x[[v]])
              else if (to_num[[v]]) as.numeric(as.character(x[[v]])) else as.character(x[[v]])
    attr(x[[v]], "label") <- l
  }
  m <- filter(meta, wave == w)
  x <- set_names(x, m$stacked_name[match(names(x), m$var)])
  mutate(x, wave = w, year = waves$year[waves$wave == w], sample = waves$sample[waves$wave == w], .before = 1)
})

# shared factors: early waves use lower-case levels ("democrat", "skipped"), later ones title case.
# Merge levels that differ only in case/spacing, using the newest wave's spelling and order
key <- \(l) gsub("\\s+", " ", tolower(trimws(l)))
for (v in unique(meta$stacked_name[meta$shared])) {
  if (!is.factor(stk[[v]])) next
  lv <- unlist(map(rev(L), \(x) levels(x[[v]])))            # newest wave first
  canon <- lv[!duplicated(key(lv))]; names(canon) <- key(canon)
  l <- attr(stk[[v]], "label")
  stk[[v]] <- factor(unname(canon[key(as.character(stk[[v]]))]), levels = unname(canon))
  attr(stk[[v]], "label") <- l
}

vars <- meta |> group_by(stacked_name) |>
  summarise(var = first(var), label = first(label), waves = paste(wave, collapse = ", "),
            n_waves = n(), .groups = "drop") |>
  arrange(match(stacked_name, names(stk)))

saveRDS(stk,  file.path(dir, "spae_stacked.rds"))
saveRDS(vars, file.path(dir, "spae_stacked_vars.rds"))
cat("stacked:", dim(stk), "| shared cols:", sum(vars$n_waves > 1), "\n")
