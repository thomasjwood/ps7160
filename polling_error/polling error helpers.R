# polling error helpers.R
# helpers for "polling error dataset 1998-2026.R": reading the nyt results json
# feeds, turning poll-page csvs (538's archived polls pages, the nyt's polls
# files) into one row per poll question, and matching questions to results

library(tidyverse)
library(magrittr)

st_abb <- c(set_names(state.abb, state.name), "District of Columbia" = "DC")

# a candidate's surname, for matching poll answers to results: lower case, no
# accents, suffixes dropped ("Earle-Sears", "Van Epps" -> "epps" both sides)
surname <- \(x) x %>%
  stringi::stri_trans_general("Latin-ASCII") %>%
  str_to_lower %>%
  str_remove_all("[.,]") %>%
  str_remove("\\s+(jr|sr|ii|iii|iv)$") %>%
  str_squish %>%
  word(-1)

# ---------------------------------------------------------------
# nyt results json feeds (static01, 2024 on): one row per candidate
# ---------------------------------------------------------------

nyt_feed <- \(date, slug, dir = "data/polling error/nyt results feeds") {
  dir.create(dir, showWarnings = F, recursive = T)
  f <- file.path(dir, str_c(date, "_", slug, ".json"))
  if (!file.exists(f)) {
    ok <- try(download.file(str_c("https://static01.nyt.com/elections-assets/pages/data/", date, "/", slug, ".json"), f, quiet = T, mode = "wb"), silent = T)
    if (inherits(ok, "try-error")) {
      unlink(f)
      message("no nyt feed: ", date, "/", slug)
      return(NULL)
    }
  }
  j <- jsonlite::fromJSON(f, simplifyVector = F)
  map_dfr(j$races, \(r) {
    tru <- r$top_reporting_unit
    if (is.null(tru) || length(tru$candidates) == 0) return(NULL)
    meta <- r$candidate_metadata
    map_dfr(tru$candidates, \(k) {
      m <- meta[[k$nyt_id]]
      tibble(
        office = r$office %||% NA_character_,
        race_type = r$type %||% NA_character_,
        # the primary's party from the race id ("IA-R-P-2024-01-15"); the
        # race_type_id field reads "S" for the iowa caucus
        party_primary = str_match(r$nyt_id %||% "", "^[A-Z]{2}-([DR])-")[, 2],
        nyt_race = r$nyt_id %||% NA_character_,
        state = tru$state_postal %||% NA_character_,
        electiondate = as.Date(r$election_date %||% date),
        candidate = str_squish(str_c(m$first_name %||% "", " ", m$last_name %||% k$nyt_id)),
        party = (m$party$abbreviation %||% m$party$nyt_abbrev %||% NA_character_) %>%
          str_remove("[.]$") %>%
          recode(Dem = "DEM", Rep = "REP", GOP = "REP", Ind = "IND"),
        votes = k$votes$total %||% NA_integer_,
        total_votes = tru$total_votes %||% NA_integer_
        )
    })
  })
}

# ---------------------------------------------------------------
# poll pages (538's polls-page csvs, the nyt's polls files): one row per
# question and candidate, with the fields the scoring needs
# ---------------------------------------------------------------

read_poll_page <- \(f) {
  read_csv(f, col_types = cols(.default = "c"), show_col_types = F) %>%
    mutate(across(any_of(c("hypothetical", "ranked_choice_reallocated")), \(x) replace_na(x, "false")))
}

tidy_poll_page <- \(d, source) {
  d %>%
    filter(
      !(hypothetical %in% c("true", "TRUE")),
      !(ranked_choice_reallocated %in% c("true", "TRUE"))
      ) %>%
    transmute(
      source = .env$source,
      poll_id, question_id, pollster,
      pollster_rating_id = na_if(pollster_rating_id, ""),
      partisan = na_if(partisan, ""), internal,
      population = str_to_lower(population),
      start = mdy(start_date), end = mdy(end_date),
      polldate = start + floor((end - start) / 2),
      electiondate = as.Date(parse_date_time(election_date, c("mdy", "ymd"))),
      days = as.numeric(electiondate - polldate),
      office_type, stage,
      state = case_when(
        state %in% c("", "US") | is.na(state) ~ "US",
        state %in% st_abb ~ state,
        T ~ unname(st_abb[state])
        ),
      seat_number,
      samplesize = as.numeric(sample_size),
      candidate = candidate_name, party,
      pct = as.numeric(pct)
      ) %>%
    filter(!is.na(state))
}

# one question per poll and race: likely voters over registered voters over
# all adults, then the fullest ballot (most candidates), then the first question
pick_question <- \(d) {
  d %>%
    group_by(poll_id, question_id, match_key) %>%
    mutate(n_cand = n()) %>%
    group_by(poll_id, match_key) %>%
    mutate(pop_rank = match(population, c("lv", "rv", "v", "a"), nomatch = 5L)) %>%
    filter(pop_rank == min(pop_rank)) %>%
    filter(n_cand == max(n_cand)) %>%
    filter(question_id == min(question_id)) %>%
    ungroup
}

# ---------------------------------------------------------------
# results: top two finishers per race, in 538's order (the democrat first when
# a democrat and a republican finished first and second, else the winner).
# race_key is unique per race; match_key (type, place, date) is what a poll
# knows, so a state with two senate races has two races on one match_key and a
# poll is scored against whichever one its candidates belong to
# ---------------------------------------------------------------

top_two <- \(res) {
  res %>%
    mutate(party = recode(party, GOP = "REP", Dem = "DEM", Rep = "REP"), pct = 100 * votes / total_votes) %>%
    group_by(race_key, match_key) %>%
    arrange(desc(votes), .by_group = T) %>%
    slice_head(n = 2) %>%
    mutate(dr = all(sort(party) == c("DEM", "REP")), ord = if_else(dr, if_else(party == "DEM", 1L, 2L), row_number())) %>%
    arrange(ord, .by_group = T) %>%
    summarise(
      dr = first(dr),
      cand1_name = candidate[1], cand1_party = party[1], cand1_actual = pct[1], cand1_key = surname(candidate[1]),
      cand2_name = candidate[2], cand2_party = party[2], cand2_actual = pct[2], cand2_key = surname(candidate[2]),
      .groups = "drop"
      ) %>%
    mutate(margin_actual = cand1_actual - cand2_actual)
}

# score poll questions against the top two: the poll's share for each of the
# two finishers, matched on surname (and, for the generic ballot, on party)
score <- \(q, tt) {
  q %>%
    mutate(key = if_else(type_simple == "House-G-US", party, surname(candidate))) %>%
    inner_join(tt, by = "match_key", relationship = "many-to-many") %>%
    mutate(
      k1 = if_else(type_simple == "House-G-US", cand1_party, cand1_key),
      k2 = if_else(type_simple == "House-G-US", cand2_party, cand2_key)
      ) %>%
    group_by(across(-c(candidate, party, pct, key))) %>%
    summarise(
      cand1_pct = sum(pct[key == k1]) %>% na_if(0),
      cand2_pct = sum(pct[key == k2]) %>% na_if(0),
      .groups = "drop"
      ) %>%
    filter(!is.na(cand1_pct) & !is.na(cand2_pct)) %>%
    mutate(
      margin_poll = cand1_pct - cand2_pct,
      error = abs(margin_poll - margin_actual),
      bias = if_else(dr, margin_poll - margin_actual, NA_real_)
      ) %>%
    select(-k1, -k2, -cand1_key, -cand2_key)
}
