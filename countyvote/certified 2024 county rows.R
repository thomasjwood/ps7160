# Rebuilds countyvote/pres_vote_by_county_1868_2024.rds: the Nov 2024 version with its 2024 rows replaced by
# MIT Election Data + Science Lab's certified county returns (countypres_2000-2024, v20, Feb 2026; Harvard
# Dataverse doi:10.7910/DVN/VOQCHQ, downloaded by hand because of the guestbook). The ps7160 2024 rows came from
# the Nov 28, 2024 NYT scrape, which ran ~1.4M votes high per party (duplicate rows) and had a few counties off by
# 3-10 points.
# Run from the repo root. Output: countyvote/pres_vote_by_county_1868_2024.rds (overwrites; same columns)

library(tidyverse)
library(magrittr)

# the Nov 2024 (scrape) version of the file, pinned to its commit
old <- "https://github.com/thomasjwood/ps7160/raw/21e71b5/countyvote/pres_vote_by_county_1868_2024.rds" %>%
  url %>%
  gzcon %>%
  readRDS

mit <- "countyvote/countypres_2000-2024.csv" %>%
  read_csv(show_col_types = F, col_types = cols(county_fips = "c")) %>%
  filter(
    year == 2024,
    party %>% is_in(c("DEMOCRAT", "REPUBLICAN")),
    state_po != "AK"                                   # AK reports by legislative district; the ps7160 file has no 2024 AK rows
  ) %>%
  group_by(county_fips, state_po, county_name) %>%
  filter(if (any(mode %in% "TOTAL")) mode %in% "TOTAL" else TRUE) %>%   # states with mode breakdowns AND a TOTAL row
  ungroup %>%
  mutate(
    fips = county_fips %>%
      str_pad(5, pad = "0") %>%
      recode(
        "36000" = "29095",                             # Kansas City, MO reported apart from Jackson County
        "46113" = "46102"                              # Oglala Lakota, under the code the ps7160 file uses
      )
  )

prev <- old %>%
  filter(election_year == 2020) %>%
  select(fips, d_perc_prev = d_perc, r_perc_prev = r_perc)

new24 <- mit %>%
  group_by(fips, party) %>%
  summarise(v = candidatevotes %>% sum(na.rm = T), .groups = "drop") %>%
  pivot_wider(names_from = party, values_from = v) %>%
  transmute(fips, d_total = DEMOCRAT, r_total = REPUBLICAN) %>%
  left_join(
    old %>%
      filter(election_year %>% is_in(c(2020, 2024))) %>%
      distinct(fips, .keep_all = T) %>%
      select(fips, county_name, state),
    by = "fips"
  ) %>%
  left_join(
    mit %>%
      distinct(fips, state_po, county_name) %>%
      group_by(fips) %>%
      slice(1) %>%
      ungroup %>%
      rename(state_mit = state_po, county_mit = county_name),
    by = "fips"
  ) %>%
  mutate(
    county_name = county_name %>% coalesce(county_mit),
    state = state %>% coalesce(state_mit),
    election_year = 2024,
    d_perc = d_total / (d_total + r_total) * 100,
    r_perc = r_total / (d_total + r_total) * 100
  ) %>%
  left_join(prev, by = "fips") %>%
  mutate(
    d_change = d_perc - d_perc_prev,
    r_change = r_perc - r_perc_prev,
    r_minus_d = r_perc - d_perc
  ) %>%
  select(names(old))

out <- old %>%
  filter(election_year != 2024) %>%
  bind_rows(new24) %>%
  arrange(fips, election_year)

# national certified totals (Harris 75,017,613; Trump 77,302,580) less Alaska (140,026; 184,458)
stopifnot(
  new24$d_total %>% sum %>% between(74.86e6, 74.89e6),
  new24$r_total %>% sum %>% between(77.10e6, 77.13e6)
)

saveRDS(out, "countyvote/pres_vote_by_county_1868_2024.rds")
