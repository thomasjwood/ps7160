# prepare midterm exit polls.R
# harmonizes the national midterm exit polls (roper center) into one
# respondent-level file and one table of house vote by group.
#   1998, 2002  voter news service (2002 is the year vns's system failed on
#               election night; the file was released later, treat with care)
#   2006-2018   national election pool (edison)
#   2018, 2022  ap votecast (2018 is the bridge year: both sources)
# raw files: data/exit_polls/raw/ (roper terms: don't redistribute)
# groups are cut to the categories every year shares: sex, age (4), race (5),
# education (4), white/nonwhite x college, family income (3, nominal dollars),
# party id (no leaners), ideology (3), community type (3; nep classifies by
# the precinct's place, votecast by the voter's own description).
# output: data/exit_polls/midterm_exits_harmonized.rds (respondents),
#         data/exit_polls/midterm_house_vote_by_group.csv (estimates)

library(tidyverse)
library(magrittr)
library(haven)

raw <- "data/exit_polls/raw/"

# recode a labelled numeric into a factor: rc(x, "Men" = 1, "Women" = 2)
rc <- function(x, ...) {
  m <- list(...)
  x <- as.numeric(x)
  out <- rep(NA_character_, length(x))
  for (k in names(m)) out[x %in% m[[k]]] <- k
  factor(out, levels = names(m))
}

# category maps shared across most files
vote3 <- \(x, o = 9) rc(x, "Democrat" = 1, "Republican" = 2, "Other" = o)
sex2 <- \(x) rc(x, "Men" = 1, "Women" = 2)
race5 <- \(x) rc(x, "White" = 1, "Black" = 2, "Hispanic" = 3, "Asian" = 4, "Other" = 5)
educ5 <- \(x) rc(x, "HS or less" = 1:2, "Some college" = 3, "College graduate" = 4, "Postgraduate" = 5)
party3 <- \(x) rc(x, "Democrat" = 1, "Republican" = 2, "Independent/other" = 3)
ideo3 <- \(x) rc(x, "Liberal" = 1, "Moderate" = 2, "Conservative" = 3)
place3 <- \(x) rc(x, "City" = 1, "Suburb" = 2, "Small town/rural" = 3)
age_lv <- c("18-29", "30-49", "50-64", "65+")
inc_lv <- c("Under $50K", "$50-100K", "$100K+")
age8 <- \(x) rc(x, "18-29" = 1:2, "30-49" = 3:5, "50-64" = 6:7, "65+" = 8)          # 18-24 ... 60-64, 65+
age9 <- \(x) rc(x, "18-29" = 1:2, "30-49" = 3:5, "50-64" = 6:7, "65+" = 8:9)        # ... 65-74, 75+

polls <- list(
  list(
    year = 1998, source = "VNS", f = "1998_vns_national.por",
    fn = \(d) transmute(d,
      weight = WEIGHT, house = vote3(QJW_QIY), sex = sex2(QA), race = race5(QB),
      age = age8(QIW_QHY), educ = educ5(QU_W),
      income = rc(QFFWQDDY, "Under $50K" = 1:3, "$50-100K" = 4:5, "$100K+" = 6),
      party = party3(PARTYID), ideo = ideo3(QZW_QBBY),
      place = rc(SIZE, "City" = 1:2, "Suburb" = 3, "Small town/rural" = 4:5)
      )
    ),
  list(
    year = 2002, source = "VNS", f = "2002_vns_national.por",
    fn = \(d) transmute(d,
      weight = WEIGHT, house = vote3(HOU), sex = sex2(SEX), race = race5(RACE),
      age = age9(AGE9), educ = educ5(EDUC),
      income = rc(INCOME, "Under $50K" = 1:3, "$50-100K" = 4:5, "$100K+" = 6),
      party = party3(PARTY), ideo = ideo3(PHIL3), place = place3(SIZEPLC3)
      )
    ),
  list(
    year = 2006, source = "NEP", f = "2006_nep_national.por",
    fn = \(d) transmute(d,
      weight = WGT, house = vote3(HOU), sex = sex2(SEX), race = race5(RACE),
      age = age9(AGE9), educ = educ5(EDUC),
      income = rc(INCOME05, "Under $50K" = 1:3, "$50-100K" = 4:5, "$100K+" = 6:8),
      party = party3(PARTY), ideo = ideo3(PHIL3), place = place3(SIZEPLC3)
      )
    ),
  list(
    year = 2010, source = "NEP", f = "2010_nep_national.por",
    fn = \(d) transmute(d,
      weight = WEIGHT, house = vote3(HOU), sex = sex2(SEX), race = race5(RACE),
      age = age8(AGE8), educ = educ5(EDUC10),
      income = rc(INCOME10, "Under $50K" = 1:2, "$50-100K" = 3:4, "$100K+" = 5:6),
      party = party3(PARTY), ideo = ideo3(PHIL3), place = place3(SIZEPLC3)
      )
    ),
  list(
    year = 2014, source = "NEP", f = "2014_nep_national.por",
    fn = \(d) transmute(d,
      weight = WEIGHT, house = vote3(HOU), sex = sex2(SEX), race = race5(RACE),
      age = age8(AGE8), educ = educ5(EDUC10),
      income = rc(INCOME14, "Under $50K" = 1:2, "$50-100K" = 3, "$100K+" = 4:5),
      party = party3(PARTY), ideo = ideo3(PHIL3), place = place3(SIZEPLC3)
      )
    ),
  list(
    year = 2018, source = "NEP", f = "2018_nep_national.por",
    fn = \(d) transmute(d,
      weight = WEIGHT, house = vote3(HOU), sex = sex2(SEX), race = race5(RACE),
      age = age8(AGE8),
      educ = rc(EDUC18, "HS or less" = 1, "Some college" = 2:3, "College graduate" = 4, "Postgraduate" = 5),
      income = rc(INCOME18, "Under $50K" = 1:2, "$50-100K" = 3, "$100K+" = 4:5),
      party = party3(PARTY), ideo = ideo3(PHIL3), place = place3(SIZEPLC3)
      )
    ),
  list(
    year = 2018, source = "VoteCast", f = "2018_ap_votecast.por",
    fn = \(d) transmute(d,
      weight = FINALV_1, house = vote3(RACE5_PA, o = 6), sex = sex2(SEX), race = race5(RACETH5),
      age = rc(AGE65, "18-29" = 1:2, "30-49" = 3:4, "50-64" = 5, "65+" = 6),
      educ = rc(EDUC, "HS or less" = 1, "Some college" = 2, "College graduate" = 3, "Postgraduate" = 4),
      income = rc(INCOME, "Under $50K" = 1:2, "$50-100K" = 3:4, "$100K+" = 5),
      party = party3(PARTY),
      ideo = rc(IDEO, "Liberal" = 1:2, "Moderate" = 3, "Conservative" = 4:5),
      place = rc(SIZEPLAC, "City" = 1, "Suburb" = 2, "Small town/rural" = 3:4)
      )
    ),
  list(
    year = 2022, source = "VoteCast", f = "2022_ap_votecast.por",
    fn = \(d) transmute(d,
      weight = FINALV_1, house = vote3(HOUSEVOT, o = 3), sex = sex2(GENDER), race = race5(RACETH5),
      age = rc(AGE65, "18-29" = 1:2, "30-49" = 3:4, "50-64" = 5, "65+" = 6),
      educ = rc(EDUC, "HS or less" = 1, "Some college" = 2, "College graduate" = 3, "Postgraduate" = 4),
      income = rc(INCOME, "Under $50K" = 1:2, "$50-100K" = 3:4, "$100K+" = 5),
      party = party3(PARTY),
      ideo = rc(IDEO, "Liberal" = 1:2, "Moderate" = 3, "Conservative" = 4:5),
      place = rc(SIZEPLAC, "City" = 1, "Suburb" = 2, "Small town/rural" = 3:4)
      )
    )
  )

exits <- polls %>%
  map(\(p) {
    str_c(raw, p$f) %>%
      read_por %>%
      p$fn() %>%
      mutate(year = p$year, source = p$source, .before = 1) %>%
      # weights rescaled to mean 1 within each poll (votecast 2018's sum to the electorate)
      mutate(weight = as.numeric(weight) / mean(as.numeric(weight), na.rm = T))
  }) %>%
  bind_rows %>%
  mutate(
    race_educ = case_when(
      is.na(race) | is.na(educ) ~ NA_character_,
      race == "White" & educ %in% c("College graduate", "Postgraduate") ~ "White college graduate",
      race == "White" ~ "White non-college",
      educ %in% c("College graduate", "Postgraduate") ~ "Nonwhite college graduate",
      T ~ "Nonwhite non-college"
      ) %>%
      factor(levels = c("White college graduate", "White non-college", "Nonwhite college graduate", "Nonwhite non-college")),
    poll = str_c(year, " ", source)
    ) %>%
  filter(!is.na(weight) & weight > 0)

dir.create("data/exit_polls", showWarnings = F)
exits %>% write_rds("data/exit_polls/midterm_exits_harmonized.rds")

# ---------------------------------------------------------------
# house vote by group: weighted shares among house voters
# ---------------------------------------------------------------

groups <- c(
  sex = "Sex", age = "Age", race = "Race", educ = "Education",
  race_educ = "Race and education", income = "Family income",
  party = "Party identification", ideo = "Ideology", place = "Community type"
  )

est <- exits %>%
  filter(!is.na(house)) %>%
  mutate(all = factor("All voters")) %>%
  pivot_longer(c(all, names(groups)), names_to = "group", values_to = "category", values_transform = as.character) %>%
  filter(!is.na(category)) %>%
  group_by(year, source, group, category) %>%
  summarise(
    n = n(),
    dem = 100 * sum(weight * (house == "Democrat")) / sum(weight),
    rep = 100 * sum(weight * (house == "Republican")) / sum(weight),
    oth = 100 * sum(weight * (house == "Other")) / sum(weight),
    wt = sum(weight),
    .groups = "drop_last"
    ) %>%
  # each category's share of that poll's house voters
  mutate(share = 100 * wt / sum(wt)) %>%
  ungroup %>%
  select(-wt) %>%
  mutate(
    margin = dem - rep,
    # among two-party voters: votecast's "other" runs high (uncontested seats)
    margin2 = 100 * (dem - rep) / (dem + rep),
    group_label = c(all = "All voters", groups)[group],
    # category order as harmonized, not alphabetical
    k = map2_int(group, category, \(g, x) if (g == "all") 1L else match(x, levels(exits[[g]])))
    ) %>%
  arrange(group, k, year, source)

est %>% write_csv("data/exit_polls/midterm_house_vote_by_group.csv")

est %>%
  filter(group == "all") %>%
  mutate(across(c(dem, rep, oth, margin), ~ round(.x, 1))) %>%
  print

exits %>%
  group_by(poll) %>%
  summarise(across(c(house, sex, age, race, educ, income, party, ideo, place), ~ mean(!is.na(.x)) %>% round(2)), n = n()) %>%
  print(width = 200)
