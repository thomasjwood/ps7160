library(plyr)
library(tidyverse)
library(magrittr)
library(haven)
library(lubridate)

# ---- Pew ATP "how much of a problem is X in the country today" (NATPROBS) ----
# 12 waves, 2016-2024. Source: github.com/thomasjwood/ps7160/atp
# Output: one row per respondent x item, labelled, with demographics.
# Income is left as Pew coded it (income_orig); brackets differ by wave.

atp_dir <- "C:/Users/thoma/Downloads/atp/"
out_dir <- "lectures/lecture 10/"

waves <- c(22, 38, 45, 53, 54, 59, 69, 87, 92, 107, 129, 148)

# field dates for waves whose microdata have no interview timestamps
# (from the ATP toplines)
fd_known <- tribble(
  ~wave, ~fstart,       ~fend,
  22,    "2016-10-25",  "2016-11-08",
  38,    "2018-09-24",  "2018-10-07",
  45,    "2019-02-19",  "2019-03-04",
  53,    "2019-09-03",  "2019-09-15",
  54,    "2019-09-16",  "2019-09-29") %>%
  mutate(fstart = fstart %>% ymd,
         fend = fend %>% ymd)

for (w in waves) {
  f <- str_c(atp_dir, "ATP W", w, ".sav")
  if (!file.exists(f)) {
    download.file(str_c("https://github.com/thomasjwood/ps7160/raw/HEAD/atp/ATP%20W",
                        w, ".sav"),
                  f,
                  mode = "wb")
  }
}


# ---- helpers ----

# value label as character; 'refused'-type codes to NA
lbl <- function(x) {
  x %>%
    as_factor %>%
    as.character %>%
    str_squish %>%
    ifelse(str_detect(., regex("^(\\(VOL\\.?\\) )?(refused|don.t know|DK)", T)),
           NA,
           .)
}

num <- function(x) x %>% as.numeric %>% ifelse(. %in% c(9, 99), NA, .)

# first column present among candidates, else NA
pick <- function(d, ...) {
  nm <- c(...) %>% extract(. %in% names(d))
  if (length(nm) == 0) rep(NA, nrow(d)) else d[[nm[1]]]
}


# old labels: '... country today? <issue>'; new labels: 'X. <issue> // How much...'
issue_text <- function(l) {
  if (str_detect(l, " // ")) {
    l %>% str_remove(" // .*$") %>% str_remove("^[^.]*\\. ")
  } else {
    l %>% str_remove("^.*country today\\?")
  }
}


# ---- one wave ----

read_wave <- function(w) {

  d <- str_c(atp_dir, "ATP W", w, ".sav") %>%
    read_sav(encoding = "latin1")

  # strip the _FINAL and _W## decorations so names line up across waves
  names(d) %<>%
    str_replace("^(F_.*)_FINAL$", "\\1") %>%
    str_replace("^(F_.*?)_W\\d+(\\.\\d+)?$", "\\1")

  # NATPROBS agree/problem items only (W92 also has a 'biggest problem' item)
  iv <- names(d) %>%
    extract(str_detect(., "^NATPROBS") &
              sapply(names(d), function(n)
                str_detect(attr(d[[n]], "label") %||% "", "How much of a problem")))

  # field dates
  ts <- names(d) %>% extract(str_detect(., "^INTERVIEW_START"))
  te <- names(d) %>% extract(str_detect(., "^INTERVIEW_END"))

  if (length(ts) > 0) {
    fs <- d[[ts[1]]] %>% as.character %>% ymd_hms %>% as.Date %>% min(na.rm = T)
    fe <- d[[te[1]]] %>% as.character %>% ymd_hms %>% as.Date %>% max(na.rm = T)
  } else {
    fs <- fd_known %>% filter(wave == w) %>% use_series(fstart)
    fe <- fd_known %>% filter(wave == w) %>% use_series(fend)
  }

  # party: Pew summary where present; W59 only has raw party + leaner
  psum <- pick(d, "F_PARTYSUM") %>% num
  if (all(is.na(psum))) {
    p <- d$PARTY_W59 %>% num
    pl <- d$PARTYLN_W59 %>% num
    psum <- ifelse(p == 1 | (p %in% 3:4 & pl == 1), 1,
                   ifelse(p == 2 | (p %in% 3:4 & pl == 2), 2, 3))
  }

  race <- pick(d, "F_RACECMB", "F_RACECMB_RECRUITMENT") %>% num
  hisp <- pick(d, "F_HISP", "F_HISP_RECRUITMENT") %>% num

  inc_src <- c("F_INCOME", "F_INC_SDT1") %>%
    extract(. %in% names(d)) %>%
    c(NA) %>%
    extract(1)

  relig <- pick(d, "F_RELIG") %>% num

  demos <- tibble(
    wave = w,
    qkey = d$QKEY,
    weight = d[[str_c("WEIGHT_W", w)]] %>% as.numeric,
    field_start = fs,
    field_end = fe,

    pid3 = psum %>%
      mapvalues(c(1, 2, 3, 9),
                c("Rep/lean Rep", "Dem/lean Dem", "Other/no lean", "Other/no lean"),
                warn_missing = F) %>%
      ifelse(psum %>% is.na, NA, .),
    pid_orig = pick(d, "F_PARTY") %>% lbl,

    ideol = pick(d, "F_IDEO") %>% lbl,
    ideol3 = pick(d, "F_IDEO") %>% num %>%
      mapvalues(1:5,
                c("Conservative", "Conservative", "Moderate", "Liberal", "Liberal"),
                warn_missing = F) %>%
      ifelse(pick(d, "F_IDEO") %>% num %>% is.na, NA, .),

    race = ifelse(hisp == 1, "Hispanic",
                  race %>%
                    mapvalues(1:5,
                              c("White", "Black", "Asian", "Mixed/other", "Mixed/other"),
                              warn_missing = F)),
    racethn_orig = pick(d, "F_RACETHNMOD", "F_RACETHN", "F_RACETHN_RECRUITMENT") %>% lbl,

    educ3 = pick(d, "F_EDUCCAT") %>% lbl %>% str_replace("Some College", "Some college"),
    educ6 = pick(d, "F_EDUCCAT2") %>% num %>%
      mapvalues(1:6,
                c("Less than HS", "HS grad", "Some college", "Associate",
                  "College grad", "Postgrad"),
                warn_missing = F) %>%
      ifelse(pick(d, "F_EDUCCAT2") %>% num %>% is.na, NA, .),

    income_orig = if (is.na(inc_src)) NA_character_ else d[[inc_src]] %>% lbl,
    income_src = inc_src,
    income_tier = pick(d, "F_INC_TIER2") %>% lbl,

    gender = pick(d, "F_GENDER", "F_SEX") %>% num %>%
      mapvalues(1:3, c("Man", "Woman", "Other"), warn_missing = F) %>%
      ifelse(pick(d, "F_GENDER", "F_SEX") %>% num %>% is.na, NA, .),
    age4 = pick(d, "F_AGECAT") %>% lbl,

    region = pick(d, "F_CREGION") %>% lbl,
    division = pick(d, "F_CDIVISION") %>% lbl,
    metro = pick(d, "F_METRO") %>% lbl,

    relig = ifelse(relig %in% c(9, 10, 12), "Unaffiliated",
                   ifelse(relig == 1, "Protestant",
                          ifelse(relig == 2, "Catholic",
                                 ifelse(relig %in% c(3:8, 11), "Other", NA)))),
    relig_orig = pick(d, "F_RELIG") %>% lbl %>%
      str_remove(" \\(.*$") %>%
      str_remove("^\\(VOL\\) ") %>%
      str_replace("^Something else.*$", "Something else"),
    attend = pick(d, "F_ATTEND", "F_ATTENDPER") %>% lbl,
    evangelical = pick(d, "F_BORN") %>% num %>%
      mapvalues(1:2, c("Yes", "No"), warn_missing = F) %>%
      ifelse(pick(d, "F_BORN") %>% num %>% is.na, NA, .))

  # item stack
  items <- tibble(item_var = iv,
                  item_wording = iv %>%
                    sapply(function(n) attr(d[[n]], "label")) %>%
                    str_squish %>%
                    sapply(issue_text) %>%
                    unname %>%
                    str_squish)

  d[, c("QKEY", iv)] %>%
    gather(item_var, resp_num, -QKEY) %>%
    mutate(resp_num = resp_num %>% num) %>%
    filter(resp_num %>% is.na %>% not) %>%
    left_join(items, by = "item_var") %>%
    rename(qkey = QKEY) %>%
    left_join(demos, by = "qkey")
}

natprobs <- waves %>%
  lapply(read_wave) %>%
  bind_rows


# ---- harmonize item wording (32 raw wordings -> 31 items) ----

item_map <- tribble(
  ~item_wording, ~item,
  "Climate change", "Climate change",
  "Condition of roads, bridges and other infrastructure", "Infrastructure",
  "Crime", "Crime",
  "Domestic terrorism", "Domestic terrorism",
  "Drug addiction", "Drug addiction",
  "Economic inequality", "Economic inequality",
  "Ethics in government", "Ethics in government",
  "Gun violence", "Gun violence",
  "Illegal immigration", "Illegal immigration",
  "Inflation", "Inflation",
  "International terrorism", "International terrorism",
  "Job opportunities for all Americans", "Job opportunities",
  "Job opportunities for working-class Americans", "Job opportunities (working class)",
  "Made-up news and information", "Made-up news",
  "Racism", "Racism",
  "Sexism", "Sexism",
  "Terrorism", "Terrorism",
  "The ability of Democrats and Republicans to work together in Washington", "Partisan cooperation",
  "The affordability of a college education", "College affordability",
  "The affordability of health care", "Health care affordability",
  "The affordability of healthcare", "Health care affordability",
  "The coronavirus outbreak", "Coronavirus",
  "The federal budget deficit", "Budget deficit",
  "The gap between the rich and poor", "Rich-poor gap",
  "The quality of public K-12 schools", "K-12 schools",
  "The state of moral values in the country", "Moral values",
  "The way immigrants who are in the country illegally are treated", "Treatment of illegal immigrants",
  "The way racial and ethnic minorities are treated by the criminal justice system", "Criminal justice treatment of minorities",
  "The way the U.S. political system operates", "Political system",
  "Unemployment", "Unemployment",
  "Violent crime", "Violent crime",
  "Wages and the cost of living", "Wages and cost of living")

natprobs %<>%
  left_join(item_map, by = "item_wording") %>%
  mutate(resp = resp_num %>%
           mapvalues(1:4,
                     c("A very big problem", "A moderately big problem",
                       "A small problem", "Not a problem at all"),
                     warn_missing = F) %>%
           factor(c("A very big problem", "A moderately big problem",
                    "A small problem", "Not a problem at all")),
         big = (resp_num == 1) %>% as.numeric,
         field_mid = field_start + (field_end - field_start) / 2,
         year = field_mid %>% year) %>%
  select(wave, year, field_start, field_end, field_mid,
         qkey, weight,
         item, item_wording, item_var, resp, resp_num, big,
         pid3, pid_orig, ideol, ideol3, race, racethn_orig,
         educ3, educ6, income_orig, income_src, income_tier,
         gender, age4, region, division, metro,
         relig, relig_orig, attend, evangelical)

stopifnot(natprobs$item %>% is.na %>% any %>% not)

saveRDS(natprobs, str_c(out_dir, "natprobs_stacked.rds"))
write_csv(natprobs, str_c(out_dir, "natprobs_stacked.csv.gz"))


# ---- checks ----

natprobs %>%
  group_by(wave, field_start, field_end) %>%
  summarize(resp = qkey %>% n_distinct,
            items = item %>% n_distinct,
            rows = n(),
            .groups = "drop") %>%
  print(n = 20)

# should reproduce Pew's May 2024 topline: inflation very big problem
natprobs %>%
  filter(wave == 148, item == "Inflation") %>%
  group_by(pid3) %>%
  summarize(very_big = 100 * weighted.mean(big, weight),
            n = n(),
            .groups = "drop") %>%
  print

natprobs %>%
  filter(wave == 148, item == "Inflation") %>%
  summarize(very_big = 100 * weighted.mean(big, weight)) %>%
  print

natprobs %>%
  group_by(wave) %>%
  summarize(across(c(pid3, ideol, race, educ6, income_orig, income_tier,
                     gender, region, relig, attend),
                   ~ mean(is.na(.x)) %>% round(2)),
            .groups = "drop") %>%
  print(n = 20, width = 200)
