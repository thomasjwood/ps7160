# polling error dataset 1998-2026.R
# poll-level dataset of polling error in u.s. elections, 538's method: every
# poll whose median field date falls in the final 21 days before a presidential
# primary or a presidential, senate, house (district or generic ballot) or
# governor general election, scored against the top two finishers.
#   error = |poll margin - actual margin| between the top two finishers
#   bias  = poll margin - actual margin, democrat minus republican, only where a
#           democrat and a republican finished first and second (positive =
#           polls overstated the democrat, i.e. republicans underrated)
# cycles pool the odd year with the following even year (2023-24 = "2024").
# weights: 1 / sqrt(polls by that pollster), counted within cycle x race type
# for the by-type averages and within cycle for the all-races average, which
# is what reproduces 538's published table (12 of 13 cycles to the decimal).
#
# sources
#   1998-2022  538's raw-polls.csv, 2023 release (github.com/fivethirtyeight/data,
#              pollster-ratings/2023), the data behind "The Polls Were
#              Historically Accurate In 2022" (N. Rakich, Mar. 10, 2023). already
#              filtered and scored by 538; used as is
#   2023-24    polls: 538's polls pages as archived in thomasjwood/ps7160
#              (538_polls/*_historical.csv). results: the nyt's 2024 results
#              scrape (general), nyt json feeds (2024 primaries), and
#              hand_results.csv (primaries and specials the nyt feeds lack,
#              2023 governors) from wikipedia
#   2025-26    polls: the nyt's polls files (newsgraphics/polls/*.csv).
#              results: the nyt's 2026 results scrape (still counting), the
#              nyt's 2025 json feeds (va, nj governor), hand_results.csv
# 538's primary rules are applied to the 2024 primaries: new hampshire polls
# before iowa and other states' polls before new hampshire are dropped, as are
# polls in which a candidate polling 15%+ (or several totalling 25%+) had
# dropped out by election day. not applied to 2023-26: 538's list of banned
# pollsters (it banned none active in 2024-26 that appear here, as far as we
# know). polls of individual congressional districts for president (me-2,
# ne-2) are dropped (no district results on file).
# output: data/polling error/polling_error_polls_1998_2026.(csv|rds) and
# polling_error_by_cycle_1998_2026.csv

source("polling error helpers.R")

pe <- "data/polling error/"
nyt24 <- "data/nyt_2024-11-05/nyt_2024-11-05_results.rds"
nyt26 <- getOption("nyt26_file", "data/nyt_2026-11-03/nyt_2026-11-03_results.rds")

# ---------------------------------------------------------------
# 1998-2022: 538, as published
# ---------------------------------------------------------------

p538 <- str_c(pe, "538/raw-polls_2023.csv") %>%
  read_csv(show_col_types = F) %>%
  transmute(
    source = "538 raw-polls (2023 release)",
    poll_id = as.character(poll_id), question_id = as.character(question_id),
    cycle = year + year %% 2, type_simple, race, location,
    pollster, pollster_rating_id = as.character(pollster_rating_id), partisan,
    polldate = mdy(polldate), electiondate = mdy(electiondate),
    days = as.numeric(electiondate - polldate), samplesize,
    cand1_name, cand1_party, cand1_pct, cand1_actual,
    cand2_name, cand2_party, cand2_pct, cand2_actual,
    margin_poll, margin_actual, error, bias
    )

# ---------------------------------------------------------------
# 2023-26 polls
# ---------------------------------------------------------------

type_of <- \(office_type, state) case_when(
  office_type == "U.S. President" ~ "Pres-G",
  office_type == "U.S. Senate" ~ "Sen-G",
  office_type == "U.S. House" & state == "US" ~ "House-G-US",
  office_type == "U.S. House" ~ "House-G",
  office_type == "Governor" ~ "Gov-G"
  )

general <- \(d) d %>%
  filter(!str_detect(stage, "primary|runoff")) %>%
  mutate(
    type_simple = type_of(office_type, state),
    location = if_else(type_simple == "House-G", str_c(state, "-", as.integer(seat_number)), state),
    party_primary = NA_character_
    ) %>%
  filter(!is.na(type_simple) & !(type_simple == "Pres-G" & !is.na(seat_number) & seat_number != "0"))

arch <- \(f) str_c(pe, "538 archive/", f, ".csv") %>%
  read_poll_page %>%
  filter(cycle %in% c("2023", "2024"))

# the generic ballot comes wide (dem, rep): make it one row per party
gb24 <- arch("generic_ballot_polls_historical") %>%
  pivot_longer(c(dem, rep), names_to = "party", values_to = "pct") %>%
  mutate(
    party = str_to_upper(party), candidate_name = party,
    office_type = "U.S. House", state = "US",
    election_date = coalesce(na_if(election_date, ""), "11/5/24"),
    stage = coalesce(na_if(stage, ""), "general"),
    hypothetical = "false", ranked_choice_reallocated = "false"
    )

q24 <- c("president_polls_historical", "senate_polls_historical", "house_polls_historical", "governor_polls_historical") %>%
  map(arch) %>%
  bind_rows(gb24) %>%
  tidy_poll_page("538 polls pages (archived)") %>%
  general

q26 <- c("senate", "governor", "house") %>%
  map(\(f) read_poll_page(str_c(pe, "nyt polls/", f, ".csv"))) %>%
  bind_rows %>%
  filter(cycle %in% c("2025", "2026")) %>%
  tidy_poll_page("NYT polls files") %>%
  general

# 2024 presidential primaries, with 538's exclusions
dropouts <- tribble(
  ~who, ~out,
  "christie", "2024-01-10", "ramaswamy", "2024-01-15", "hutchinson", "2024-01-16",
  "desantis", "2024-01-21", "haley", "2024-03-06", "phillips", "2024-03-06"
  ) %>%
  mutate(out = as.Date(out))

qp24 <- arch("president_primary_polls_historical") %>%
  tidy_poll_page("538 polls pages (archived)") %>%
  filter(state != "US") %>%
  mutate(type_simple = "Pres-P", location = state) %>%
  group_by(poll_id, question_id) %>%
  mutate(
    party_primary = names(which.max(table(party))),
    gone = sum(pct[surname(candidate) %in% dropouts$who[dropouts$out < first(electiondate)]], na.rm = T),
    gone_max = max(c(0, pct[surname(candidate) %in% dropouts$who[dropouts$out < first(electiondate)]]), na.rm = T)
    ) %>%
  ungroup %>%
  filter(
    gone_max < 15 & gone < 25,
    case_when(
      location == "IA" ~ T,
      location == "NH" ~ polldate >= as.Date("2024-01-15"),
      T ~ polldate >= as.Date("2024-01-23")
      )
    ) %>%
  select(-gone, -gone_max)

q <- bind_rows(q24, q26, qp24) %>%
  filter(between(days, 0, 21) & !is.na(pct)) %>%
  mutate(match_key = str_c(type_simple, "|", coalesce(party_primary, ""), "|", location, "|", electiondate))

# ---------------------------------------------------------------
# 2023-26 results
# ---------------------------------------------------------------

nyt_rds <- \(f) {
  x <- read_rds(f)
  x$results_state %>%
    inner_join(x$races %>% select(race_id, race_type), by = "race_id") %>%
    filter(
      office %in% c("President", "U.S. Senate", "U.S. House", "Governor"),
      race_type %in% c("General", "Special General")
      ) %>%
    transmute(
      race_key = race_id,
      type_simple = recode(office, President = "Pres-G", "U.S. Senate" = "Sen-G", "U.S. House" = "House-G", Governor = "Gov-G"),
      location = if_else(type_simple == "House-G", str_c(state, "-", suppressWarnings(as.integer(district)) %>% replace_na(1L)), state),
      electiondate = as.Date(str_extract(race_id, "\\d{4}-\\d{2}-\\d{2}$")),
      candidate = name, party, votes
      ) %>%
    group_by(race_key) %>%
    mutate(total_votes = sum(votes)) %>%
    ungroup
}

r24 <- nyt_rds(nyt24)
r26 <- nyt_rds(nyt26)

# national popular vote for president (sum of the states) and the national
# house vote for the generic ballot (2024: house_national_vote.csv, the
# certified totals; 2026: the sum of every house race counted so far)
pres_us <- r24 %>%
  filter(type_simple == "Pres-G") %>%
  group_by(candidate, party) %>%
  summarise(votes = sum(votes), .groups = "drop") %>%
  mutate(race_key = "US-P-2024", type_simple = "Pres-G", location = "US", electiondate = as.Date("2024-11-05"), total_votes = sum(votes))

hv24 <- read_csv("data/house_national_vote.csv", show_col_types = F) %>%
  filter(year == 2024)

gen <- bind_rows(
  tibble(race_key = "US-H-2024", electiondate = as.Date("2024-11-05"), party = c("DEM", "REP"), votes = c(hv24$dem_pct, hv24$rep_pct) * 1e4, total_votes = 1e6),
  r26 %>%
    filter(type_simple == "House-G") %>%
    mutate(party = recode(party, GOP = "REP")) %>%
    group_by(party) %>%
    summarise(votes = sum(votes)) %>%
    mutate(race_key = "US-H-2026", electiondate = as.Date("2026-11-03"), total_votes = sum(votes)) %>%
    filter(party %in% c("DEM", "REP"))
  ) %>%
  mutate(type_simple = "House-G-US", location = "US", candidate = party)

# 2025 governors and the 2024 primaries, from the nyt's json feeds
feeds <- bind_rows(
  nyt_feed("2025-11-04", "results-virginia"),
  nyt_feed("2025-11-04", "results-new-jersey"),
  nyt_feed("2024-01-15", "results-iowa-caucus"),
  nyt_feed("2024-02-27", "results-michigan-republican-presidential-primary"),
  nyt_feed("2024-02-27", "results-michigan-democratic-presidential-primary"),
  c("alabama", "california", "colorado", "maine", "massachusetts", "minnesota", "north-carolina", "tennessee", "texas", "vermont", "virginia") %>%
    map(\(s) nyt_feed("2024-03-05", str_c("results-", s, "-primary"))) %>%
    bind_rows,
  nyt_feed("2024-03-19", "results-ohio-primary")
  ) %>%
  filter(
    (office == "Governor" & race_type == "General") |
      (office == "President" & str_detect(race_type, "Primary|Caucus"))
    ) %>%
  transmute(
    race_key = nyt_race,
    type_simple = if_else(office == "Governor", "Gov-G", "Pres-P"),
    party_primary = if_else(type_simple == "Pres-P", recode(party_primary, D = "DEM", R = "REP"), NA_character_),
    location = state, electiondate, candidate, party, votes, total_votes
    )

hand <- read_csv(str_c(pe, "hand_results.csv"), show_col_types = F) %>%
  mutate(party_primary = na_if(party_primary, ""), race_key = str_c(type_simple, coalesce(party_primary, ""), location, electiondate, sep = "|"))

res <- bind_rows(r24, r26, pres_us, gen, feeds, hand) %>%
  mutate(match_key = str_c(type_simple, "|", coalesce(party_primary, ""), "|", location, "|", electiondate))

tt <- top_two(res)

# ---------------------------------------------------------------
# score, and put the eras together
# ---------------------------------------------------------------

p_new <- q %>%
  pick_question %>%
  score(tt) %>%
  transmute(
    source, poll_id, question_id,
    cycle = year(electiondate) + year(electiondate) %% 2,
    type_simple, race = race_key, location, pollster, pollster_rating_id, partisan,
    polldate, electiondate, days, samplesize,
    cand1_name, cand1_party, cand1_pct, cand1_actual,
    cand2_name, cand2_party, cand2_pct, cand2_actual,
    margin_poll, margin_actual, error, bias
    )

# what didn't score: races polled with no result on file, or polls missing one
# of the top two
miss <- q %>%
  distinct(source, poll_id, match_key, type_simple) %>%
  anti_join(p_new %>% distinct(poll_id), by = "poll_id")
message("polls not scored: ", nrow(miss))
print(miss %>% count(type_simple, match_key, sort = T), n = 30)

polls <- bind_rows(p538, p_new) %>%
  mutate(pollster_rating_id = as.character(pollster_rating_id)) %>%
  arrange(cycle, type_simple, location, polldate)

# ---------------------------------------------------------------
# averages by cycle: by race type and all races
# ---------------------------------------------------------------

wmean <- \(x, w) if (all(is.na(x))) NA_real_ else weighted.mean(x, w, na.rm = T)

# pollsters 538 never rated have no rating id: weight those by name
polls %<>% mutate(wkey = coalesce(pollster_rating_id, pollster))

by_type <- polls %>%
  mutate(type = if_else(type_simple == "House-G-US", "House-G", type_simple)) %>%
  group_by(cycle, type, wkey) %>%
  mutate(w = 1 / sqrt(n())) %>%
  group_by(cycle, type) %>%
  summarise(n_polls = n(), n_races = n_distinct(race), error = wmean(error, w), bias = wmean(bias, w), .groups = "drop")

all_races <- polls %>%
  group_by(cycle, wkey) %>%
  mutate(w = 1 / sqrt(n())) %>%
  group_by(cycle) %>%
  summarise(n_polls = n(), n_races = n_distinct(race), error = wmean(error, w), bias = wmean(bias, w), .groups = "drop") %>%
  mutate(type = "All")

by_cycle <- bind_rows(by_type, all_races) %>%
  arrange(cycle, type)

print(all_races %>% mutate(across(c(error, bias), \(x) round(x, 1))), n = 20)

polls %<>% select(-wkey)

write_rds(polls, str_c(pe, "polling_error_polls_1998_2026.rds"), compress = "gz")
write_csv(polls, str_c(pe, "polling_error_polls_1998_2026.csv"))
write_csv(by_cycle, str_c(pe, "polling_error_by_cycle_1998_2026.csv"))
