# =============================================================================
# Bright Line Watch stacked files -- helper functions and value schemes
# =============================================================================
# Every source variable, whatever its storage (factor, haven_labelled, plain
# character, or bare numeric codes with no labels), is recoded through ONE
# scheme per harmonized variable:
#
#   * labelled / factor / character input  -> matched on its text label
#   * bare numeric input (no labels)       -> taken as the vendor's numeric code
#                                             (YouGov / Qualtrics codes, checked
#                                             against the questionnaires)
#
# Any non-missing text value that a scheme cannot place is logged to
# `qa_unmatched` so nothing is silently dropped.
# =============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(haven)
  library(lubridate)
})

qa_unmatched <- new.env()
qa_unmatched$log <- tibble(survey = character(), wave = integer(), target = character(),
                           source_var = character(), value = character(), n = integer())
.ctx <- new.env()   # current survey / wave / source var, for logging

# ---- text normalisation ----------------------------------------------------
norm_txt <- function(x) {
  x |>
    str_replace_all("[‘’‛`]", "'") |>
    str_replace_all("[“”]", "\"") |>
    str_replace_all("[–—−]", "-") |>
    str_replace_all("\\\\n|\n", " ") |>
    str_squish() |>
    str_to_lower()
}

# Is the vector bare numeric codes (numeric, no value labels, not a factor)?
is_bare_numeric <- function(x) is.numeric(x) && is.null(attr(x, "labels")) && !is.factor(x)

# Text view of any vector (labels where they exist)
as_text <- function(x) {
  if (is.factor(x)) return(as.character(x))
  if (!is.null(attr(x, "labels"))) {
    lab <- attr(x, "labels"); v <- as.vector(unclass(x))
    out <- names(lab)[match(v, lab)]
    out[is.na(out) & !is.na(v)] <- as.character(v[is.na(out) & !is.na(v)])
    return(out)
  }
  as.character(x)
}

# Values that mean "no answer" in every BLW file
nonresponse_rx <- "^(skipped|not asked|refused|prefer not to (say|answer)|-?99?|98|999|na|n/a|)$"

log_unmatched <- function(txt, target) {
  if (!length(txt)) return(invisible())
  t <- table(txt)
  qa_unmatched$log <- bind_rows(qa_unmatched$log, tibble(
    survey = .ctx$survey %||% NA_character_, wave = .ctx$wave %||% NA_integer_,
    target = target, source_var = .ctx$var %||% NA_character_,
    value = names(t), n = as.integer(t)))
}

# ---- generic scheme recoder --------------------------------------------------
# scheme: tibble(code, label, rx) ; rx is matched against normalised text.
# num_valid: numeric codes accepted as-is from bare numeric input.
# num_map:   optional named vector recoding bare numeric codes (names = source code).
recode_scheme <- function(x, scheme, target, num_valid = scheme$code, num_map = NULL) {
  if (is.null(x)) return(NULL)
  if (is_bare_numeric(x)) {
    v <- as.numeric(x)
    if (!is.null(num_map)) {
      out <- unname(num_map[as.character(v)])
      return(as.numeric(out))
    }
    v[!v %in% num_valid] <- NA
    return(v)
  }
  txt <- norm_txt(as_text(x))
  # character columns holding only numeric codes ("1".."5"; e.g. expert wave 28) -> numeric path
  if (is.character(x) && is.null(attr(x, "labels"))) {
    nz <- txt[!is.na(txt) & txt != ""]
    if (length(nz) && all(str_detect(nz, "^-?[0-9]+([.]0+)?$")))
      return(recode_scheme(as.numeric(if_else(txt == "", NA_character_, txt)), scheme, target, num_valid, num_map))
  }
  out <- rep(NA_real_, length(txt))
  for (i in seq_len(nrow(scheme))) {
    hit <- is.na(out) & !is.na(txt) & str_detect(txt, regex(scheme$rx[i]))
    out[hit] <- scheme$code[i]
  }
  bad <- is.na(out) & !is.na(txt) & !str_detect(txt, nonresponse_rx)
  log_unmatched(txt[bad], target)
  out
}

# Number embedded in text ("72", "0 - Not at all democratic") -> numeric
parse_num <- function(x, lo = 0, hi = 100) {
  v <- if (is_bare_numeric(x)) as.numeric(x) else suppressWarnings(as.numeric(str_extract(as_text(x), "-?[0-9]+(\\.[0-9]+)?")))
  v[!is.na(v) & (v < lo | v > hi)] <- NA
  v
}

parse_dt <- function(x) {
  if (inherits(x, "POSIXt")) return(as.POSIXct(format(x, "%Y-%m-%d %H:%M:%S"), tz = "UTC"))
  x <- as_text(x); x[x %in% c("", "NA")] <- NA
  suppressWarnings(as.POSIXct(parse_date_time(x, orders = c("Ymd HMS", "Ymd HM", "Ymd", "mdy HM", "mdy HMS", "mdy"),
                                             tz = "UTC", truncated = 1)))
}

# First column of `d` (by name, in order) that exists and is not entirely missing
pick <- function(d, ...) {
  for (nm in c(...)) if (nm %in% names(d) && any(!is.na(d[[nm]]) & as_text(d[[nm]]) != "")) {
    .ctx$var <- nm; return(d[[nm]])
  }
  .ctx$var <- NA_character_
  NULL
}
pick_name <- function(d, ...) { for (nm in c(...)) if (nm %in% names(d) && any(!is.na(d[[nm]]) & as_text(d[[nm]]) != "")) return(nm); NA_character_ }

# Column whose text values contain all of `must` (regexes); for variables whose
# Qualtrics name changes every wave (expert field / occupation).
find_by_values <- function(d, must, exclude_rx = "text|_TEXT|_t$") {
  for (nm in names(d)) {
    if (str_detect(nm, exclude_rx)) next
    x <- d[[nm]]; if (is.numeric(x) && is.null(attr(x, "labels"))) next
    vals <- norm_txt(unique(c(as_text(x), if (is.factor(x)) levels(x), names(attr(x, "labels")))))
    vals <- vals[!is.na(vals) & vals != ""]
    if (length(vals) > 12) next          # closed-ended items only (skips open-ended text)
    if (all(map_lgl(must, \(m) any(str_detect(vals, regex(m)), na.rm = TRUE)))) { .ctx$var <- nm; return(x) }
  }
  .ctx$var <- NA_character_
  NULL
}

na_vec <- function(n) rep(NA_real_, n)
`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a

# ---- value schemes -----------------------------------------------------------
sch <- function(...) {
  x <- tribble(~code, ~label, ~rx, ...)
  x$code <- as.numeric(x$code); x
}

S <- list()
S$perf <- sch(
  1, "Does not meet this standard",  "does not meet",
  2, "Partly meets this standard",   "partly meets",
  3, "Mostly meets this standard",   "mostly meets",
  4, "Fully meets this standard",    "fully meets",
  5, "Not sure",                     "not sure|don't know|dont know|^5$")   # early YouGov factors carry code 5 as the level text "5"
S$imp <- sch(
  1, "Not relevant (no impact on democracy)",           "^not relevant",
  2, "Beneficial (enhances democracy, not required)",   "^beneficial",
  3, "Important (democracy compromised if absent)",     "^important",
  4, "Essential (not a democracy without it)",          "^essential")
S$pid3 <- sch(1, "Democrat", "^democrat", 2, "Republican", "^republican", 3, "Independent", "^independent",
              4, "Other", "^other", 5, "Not sure", "not sure")
S$pid7 <- sch(1, "Strong Democrat", "^strong democrat", 2, "Not very strong Democrat", "not very strong democrat|weak democrat",
              3, "Lean Democrat", "lean democrat", 4, "Independent", "^independent", 5, "Lean Republican", "lean republican",
              6, "Not very strong Republican", "not very strong republican|weak republican", 7, "Strong Republican", "^strong republican",
              8, "Not sure / Don't know", "not sure|don't know")
S$ideo7 <- sch(1, "Very liberal", "^very liberal", 2, "Somewhat liberal", "^somewhat liberal", 3, "Slightly liberal", "^slightly liberal",
               4, "Moderate; middle of the road", "^moderate", 5, "Slightly conservative", "^slightly conservative",
               6, "Somewhat conservative", "^somewhat conservative", 7, "Very conservative", "^very conservative")
S$ideo5 <- sch(1, "Very liberal", "^very liberal", 2, "Liberal", "^liberal", 3, "Moderate", "^moderate",
               4, "Conservative", "^conservative", 5, "Very conservative", "^very conservative", 6, "Not sure", "not sure")
S$gender <- sch(1, "Male", "^male$|^man$", 2, "Female", "^female$|^woman$", 3, "Other / non-binary", "^other|non-?binary")
S$educ7 <- sch(1, "Did not graduate from high school", "did not graduate|^no hs", 2, "High school diploma or equivalent", "high school",
               3, "Some college", "^some college", 4, "Associate's degree", "associate|^2-year", 5, "Bachelor's degree", "bachelor|^4-year",
               6, "Master's degree", "master", 7, "Professional or doctorate degree", "professional|doctorate")
S$educ6 <- sch(1, "No high school diploma", "^no hs|did not graduate", 2, "High school graduate", "high school",
               3, "Some college", "^some college", 4, "2-year degree", "^2-year|associate", 5, "4-year degree", "^4-year|bachelor",
               6, "Post-graduate degree", "post-?grad")
S$educ4 <- sch(1, "High school or less", "x", 2, "Some college / 2-year", "x", 3, "Bachelor's degree", "x", 4, "Postgraduate degree", "x")
S$race8 <- sch(1, "White", "^white", 2, "Black", "^black", 3, "Hispanic", "^hispanic|latino", 4, "Asian", "^asian",
               5, "Native American", "native american", 6, "Two or more races", "^mixed|two or more", 7, "Other", "^other",
               8, "Middle Eastern", "middle eastern")
S$ethnicity <- sch(1, "White", "^white", 2, "Black or African American", "^black", 3, "American Indian or Alaska Native", "american indian",
                   4, "Asian/Pacific Islander", "^asian", 5, "Multi-racial", "multi-?racial", 6, "Hispanic/Latino/Chicano/a", "hispanic|latino",
                   7, "Other", "^other")
S$race5 <- sch(1, "White", "x", 2, "Black", "x", 3, "Hispanic", "x", 4, "Asian", "x", 5, "Other / multiple", "x")
S$yesno <- sch(1, "Yes", "^yes", 2, "No", "^no$|^no\\b")
S$votereg <- sch(1, "Yes", "^yes", 2, "No", "^no$|^no\\b", 3, "Don't know", "don't know|not sure")
S$newsint <- sch(1, "Most of the time", "^most of the time", 2, "Some of the time", "^some of the time", 3, "Only now and then", "now and then",
                 4, "Hardly at all", "hardly", 7, "Don't know", "don't know")
S$polinterest <- sch(1, "Extremely interested", "^extremely", 2, "Very interested", "^very", 3, "Somewhat interested", "^somewhat",
                     4, "Not very interested", "^not very", 5, "Not at all interested", "^not at all")
S$approve <- sch(1, "Strongly approve", "^strongly approve", 2, "Somewhat approve", "^somewhat approve",
                 3, "Somewhat disapprove", "^somewhat disapprove", 4, "Strongly disapprove", "^strongly disapprove")
S$presvote16 <- sch(1, "Hillary Clinton", "clinton", 2, "Donald Trump", "trump", 3, "Gary Johnson", "johnson", 4, "Jill Stein", "stein",
                    5, "Evan McMullin", "mcmullin", 6, "Other", "^other", 7, "Did not vote for President", "did not vote")
S$presvote20 <- sch(1, "Joe Biden", "biden", 2, "Donald Trump", "trump", 3, "Jo Jorgensen", "jorgensen", 4, "Howie Hawkins", "hawkins",
                    5, "Other", "^other", 6, "Did not vote for President", "did not vote")
S$presvote24 <- sch(1, "Kamala Harris", "harris", 2, "Donald Trump", "trump", 3, "Robert F. Kennedy, Jr.", "kennedy", 4, "Jill Stein", "stein",
                    5, "Cornel West", "west", 6, "Chase Oliver", "oliver", 8, "Other", "^other", 9, "Did not vote for President", "did not vote")
S$religpew <- sch(1, "Protestant", "^protestant", 2, "Roman Catholic", "catholic", 3, "Mormon", "mormon", 4, "Eastern or Greek Orthodox", "orthodox",
                  5, "Jewish", "jewish", 6, "Muslim", "muslim", 7, "Buddhist", "buddhist", 8, "Hindu", "hindu", 9, "Atheist", "atheist",
                  10, "Agnostic", "agnostic", 11, "Nothing in particular", "nothing in particular", 12, "Something else", "something else")
S$churatd <- sch(1, "More than once a week", "more than once a week", 2, "Once a week", "^once a week", 3, "Once or twice a month", "once or twice a month",
                 4, "A few times a year", "few times a year", 5, "Seldom", "^seldom", 6, "Never", "^never", 7, "Don't know", "don't know")
S$religimp <- sch(1, "Very important", "^very important", 2, "Somewhat important", "^somewhat important", 3, "Not too important", "^not too important",
                  4, "Not at all important", "^not at all important")
S$prayer <- sch(1, "Several times a day", "several times a day", 2, "Once a day", "^once a day", 3, "A few times a week", "few times a week",
                4, "Once a week", "^once a week", 5, "A few times a month", "few times a month", 6, "Seldom", "^seldom", 7, "Never", "^never",
                8, "Don't know", "don't know")
S$marstat <- sch(1, "Married", "^married", 2, "Separated", "^separated", 3, "Divorced", "^divorced", 4, "Widowed", "^widowed",
                 5, "Never married", "never married", 6, "Domestic / civil partnership", "domestic|civil partnership")
S$employ <- sch(1, "Full-time", "^full-time|^full time", 2, "Part-time", "^part-time|^part time", 3, "Temporarily laid off", "laid off",
                4, "Unemployed", "^unemployed", 5, "Retired", "^retired", 6, "Permanently disabled", "disabled", 7, "Homemaker", "homemaker",
                8, "Student", "^student", 9, "Other", "^other")
S$ownhome <- sch(1, "Own", "^own", 2, "Rent", "^rent", 3, "Other", "^other")
S$faminc <- sch(1, "Less than $10,000", "less than \\$?10,000", 2, "$10,000 - $19,999", "^\\$?10,000", 3, "$20,000 - $29,999", "^\\$?20,000",
                4, "$30,000 - $39,999", "^\\$?30,000", 5, "$40,000 - $49,999", "^\\$?40,000", 6, "$50,000 - $59,999", "^\\$?50,000",
                7, "$60,000 - $69,999", "^\\$?60,000", 8, "$70,000 - $79,999", "^\\$?70,000", 9, "$80,000 - $99,999", "^\\$?80,000",
                10, "$100,000 - $119,999", "^\\$?100,000", 11, "$120,000 - $149,999", "^\\$?120,000", 12, "$150,000 - $199,999", "^\\$?150,000",
                13, "$200,000 - $249,999", "^\\$?200,000", 14, "$250,000 - $349,999", "^\\$?250,000", 15, "$350,000 - $499,999", "^\\$?350,000",
                16, "$500,000 or more", "^\\$?500,000")
S$income5 <- sch(1, "Under $30,000", "x", 2, "$30,000 - $59,999", "x", 3, "$60,000 - $99,999", "x", 4, "$100,000 - $199,999", "x", 5, "$200,000 or more", "x")
S$pid3_lean <- sch(1, "Democrat (incl. leaners)", "x", 2, "Independent / not sure", "x", 3, "Republican (incl. leaners)", "x")
S$age4 <- sch(1, "18-29", "x", 2, "30-44", "x", 3, "45-64", "x", 4, "65+", "x")
S$field <- sch(1, "American politics", "^american", 2, "Comparative politics", "^comparative", 3, "International relations", "^ir$|^international",
               4, "Political theory", "theory", 5, "Another field of political science", "^another field|other \\(ps\\)",
               6, "Something other than political science", "^something other|not ps")
S$occupation <- sch(1, "Graduate student", "^grad", 2, "Post-doctoral fellow", "^post-?doc", 3, "Adjunct faculty", "^adjunct",
                    4, "Full-time faculty", "^full-time faculty|^faculty$", 5, "Emeritus faculty", "^emerit", 6, "Other", "^other")

# ---- state FIPS --------------------------------------------------------------
states <- tibble(
  fips = c(1, 2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33,
           34, 35, 36, 37, 38, 39, 40, 41, 42, 44, 45, 46, 47, 48, 49, 50, 51, 53, 54, 55, 56),
  name = c(state.name[1:8], "District of Columbia", state.name[9:50]),
  abb  = c(state.abb[1:8], "DC", state.abb[9:50])
) |> mutate(region = case_when(
  abb %in% c("CT", "ME", "MA", "NH", "RI", "VT", "NJ", "NY", "PA") ~ "Northeast",
  abb %in% c("IL", "IN", "MI", "OH", "WI", "IA", "KS", "MN", "MO", "NE", "ND", "SD") ~ "Midwest",
  abb %in% c("DE", "DC", "FL", "GA", "MD", "NC", "SC", "VA", "WV", "AL", "KY", "MS", "TN", "AR", "LA", "OK", "TX") ~ "South",
  TRUE ~ "West"))
stopifnot(nrow(states) == 51)

recode_state <- function(x) {
  if (is.null(x)) return(NULL)
  if (is_bare_numeric(x)) { v <- as.numeric(x); v[!v %in% states$fips] <- NA; return(v) }
  txt <- norm_txt(as_text(x))
  out <- states$fips[match(txt, norm_txt(states$name))]
  bad <- is.na(out) & !is.na(txt) & !str_detect(txt, nonresponse_rx)
  log_unmatched(txt[bad], "state_fips")
  out
}

# ---- item orders (from BLW questionnaires) -----------------------------------
# YouGov public grid order used 2021-2024 (public waves 16-23).
# Source: DART0049_W7_qx.pdf (wave 22), DART0049_W8-1.pdf (wave 23), and the
# variable labels of public waves 16-22.
ORDER_YG30 <- c("election_fraud", "candidates_disclose", "districts", "funds_transparent", "contributions",
                "foreign_influence", "concede_defeat", "voting_rights", "votes_impact", "participation",
                "equal_rights", "ban_ideology", "free_speech", "protest", "opinions", "equal_enforce",
                "journalists", "private_violence", "monitor_opponents", "misconduct", "private_gain",
                "investigations", "gov_stats", "expand_executive", "legislature_check", "judiciary_check",
                "judicial_ind", "common_und", "compromise", "patriotism")
# BLW base order (Qualtrics expert instruments throughout; YouGov public from wave 24).
# Items 31-35 were appended as they were introduced. Sources: BLW_wave_22/24/26/27_experts.pdf,
# expert_instrument_w25.pdf, blw_w17_expert_flow.pdf, DART0049_W9_qx2.pdf (public 24),
# DART0058_Qx.pdf (public 25), BLW_wave26_public.pdf, DART0057_W2_Qx.pdf (public 27).
ORDER_STD35 <- c("misconduct", "private_gain", "monitor_opponents", "equal_rights", "journalists",
                 "private_violence", "free_speech", "patriotism", "foreign_influence", "ban_ideology",
                 "voting_rights", "votes_impact", "election_fraud", "expand_executive", "legislature_check",
                 "judiciary_check", "judicial_ind", "participation", "funds_transparent", "contributions",
                 "opinions", "districts", "common_und", "compromise", "candidates_disclose", "protest",
                 "investigations", "gov_stats", "equal_enforce", "concede_defeat", "org_pressure",
                 "military_neutral", "use_military", "law_neutral", "use_law")
# Public wave 28 (DART0057_w3-1.pdf): item 1 is a piped court item (judiciary /
# Supreme Court / lower courts, assigned by limit_executive_power_text).
ORDER_P28 <- c("COURT", "misconduct", "private_gain", "monitor_opponents", "equal_rights", "journalists",
               "private_violence", "free_speech", "expand_executive", "legislature_check", "judicial_ind",
               "protest", "investigations", "equal_enforce", "org_pressure", "law_neutral", "use_law",
               "patriotism", "foreign_influence", "ban_ideology", "voting_rights", "votes_impact",
               "election_fraud", "participation", "funds_transparent", "contributions", "opinions",
               "districts", "common_und", "compromise", "candidates_disclose", "gov_stats",
               "concede_defeat", "military_neutral", "use_military")
# Public wave 30 (wave-30-public-survey-instrument-v10.pdf).
ORDER_P30 <- c("judiciary_check", "judiciary_check_scotus", "judiciary_check_lwr", "districts", "misconduct",
               "private_gain", "monitor_opponents", "equal_rights", "journalists", "private_violence",
               "free_speech", "expand_executive", "legislature_check", "judicial_ind", "protest",
               "investigations", "equal_enforce", "org_pressure", "law_neutral", "use_law", "patriotism",
               "foreign_influence", "ban_ideology", "voting_rights", "votes_impact", "election_fraud",
               "participation", "funds_transparent", "contributions", "opinions", "common_und",
               "compromise", "candidates_disclose", "gov_stats", "concede_defeat", "military_neutral",
               "use_military")
stopifnot(all(c(ORDER_YG30, ORDER_STD35, setdiff(ORDER_P28, "COURT"), ORDER_P30) %in% blw_items$key))

# Battery index specs: (survey, wave, battery, regex with one capture = position, order, provenance)
# `role = "map"` defines the mapping; `role = "check"` only verifies labelled waves.
battery_specs <- tribble(
  ~survey,  ~wave, ~battery, ~rx,                          ~order,              ~role,   ~source,
  "public",   4,  "imp",  "^IMPgrid_(\\d+)$",             list(ORDER_STD35),   "map",   "labels (truncated) + BLW base order",
  "public",   4,  "perf", "^statements_(\\d+)$",          list(ORDER_STD35),   "map",   "labels (truncated) + BLW base order",
  "public",   9,  "perf", "^Q1_(\\d+)$",                  list(ORDER_STD35),   "map",   "labels (truncated) + BLW base order",
  "public",  10,  "perf", "^statements_(\\d+)$",          list(ORDER_STD35),   "map",   "labels (truncated) + BLW base order",
  "public",  16,  "perf", "^statements_US_(\\d+)$",       list(ORDER_YG30),    "map",   "labels (truncated) + YouGov order",
  "public",  17,  "perf", "^statments_US_(\\d+)$",        list(ORDER_YG30),    "check", "labels",
  "public",  18,  "perf", "^statments_US_(\\d+)_post$",   list(ORDER_YG30),    "check", "labels",
  "public",  19,  "perf", "^statments_US_(\\d+)$",        list(ORDER_YG30),    "map",   "labels + YouGov order (item 7 piped wording)",
  "public",  20,  "perf", "^statments_US_(\\d+)$",        list(ORDER_YG30),    "map",   "labels + YouGov order (item 7 piped wording)",
  "public",  21,  "perf", "^statments_US_(\\d+)$",        list(ORDER_YG30),    "check", "labels",
  "public",  22,  "perf", "^statments_US_(\\d+)$",        list(ORDER_YG30),    "check", "labels; DART0049_W7_qx.pdf",
  "public",  23,  "perf", "^statments_US_(\\d+)$",        list(ORDER_YG30),    "map",   "DART0049_W8-1.pdf",
  "public",  23,  "imp",  "^IMP_US_(\\d+)$",              list(ORDER_YG30),    "map",   "DART0049_W8-1.pdf",
  "public",  24,  "perf", "^statments_US_(\\d+)$",        list(ORDER_STD35),   "map",   "DART0049_W9_qx2.pdf",
  "public",  25,  "perf", "^statments_US_(\\d+)$",        list(ORDER_STD35),   "map",   "DART0058_Qx.pdf",
  "public",  26,  "perf", "^statements_US_(\\d+)$",       list(ORDER_STD35),   "map",   "BLW_wave26_public.pdf",
  "public",  27,  "perf", "^statements_US_(\\d+)$",       list(ORDER_STD35),   "map",   "DART0057_W2_Qx.pdf",
  "public",  28,  "perf", "^statements_US_(\\d+)$",       list(ORDER_P28),     "map",   "DART0057_w3-1.pdf",
  "public",  28,  "imp",  "^imp_items_(\\d+)$",           list(ORDER_P28),     "map",   "DART0057_w3-1.pdf",
  "public",  30,  "perf", "^statements_US_(\\d+)$",       list(ORDER_P30),     "map",   "wave-30-public-survey-instrument-v10.pdf",
  "expert",   9,  "perf", "^Q158_(\\d+)$",                list(ORDER_STD35),   "map",   "labels (truncated) + BLW base order",
  "expert",  10,  "perf", "^Q158_(\\d+)$",                list(ORDER_STD35),   "map",   "labels (truncated) + BLW base order",
  "expert",  14,  "perf", "^Q2_6_(\\d+)$",                list(ORDER_STD35),   "map",   "labels (truncated) + BLW base order",
  "expert",  15,  "perf", "^_v(\\d+)$",                   list(c(rep(NA, 5), ORDER_STD35[1:30])), "map", "labels (truncated) + BLW base order (_v6.._v35)",
  "expert",  16,  "perf", "^Q2_6_(\\d+)$",                list(ORDER_STD35),   "check", "labels",
  "expert",  17,  "perf", "^Q2_6_(\\d+)$",                list(ORDER_STD35),   "map",   "blw_w17_expert_flow.pdf",
  "expert",  18,  "perf", "^Q2_6_(\\d+)$",                list(ORDER_STD35),   "check", "labels",
  "expert",  19,  "perf", "^Q2_6_(\\d+)$",                list(ORDER_STD35),   "check", "labels",
  "expert",  20,  "perf", "^Q2_6_[ab]_(\\d+)$",           list(ORDER_STD35),   "check", "labels (two random forms, a/b)",
  "expert",  21,  "perf", "^Q2_6_(\\d+)$",                list(ORDER_STD35),   "check", "labels",
  "expert",  22,  "perf", "^Q2_6_(\\d+)$",                list(ORDER_STD35),   "map",   "BLW_wave_22_experts.pdf",
  "expert",  23,  "perf", "^PERF_(\\d+)$",                list(ORDER_STD35),   "map",   "inferred: same names/length as waves 22 & 24 (wave-23 PDF is an image); checked against item means",
  "expert",  23,  "imp",  "^Imp_(\\d+)$",                 list(ORDER_STD35),   "map",   "inferred: BLW base order; checked against item means",
  "expert",  24,  "perf", "^PERF_(\\d+)$",                list(ORDER_STD35),   "map",   "BLW_wave_24_experts.pdf",
  "expert",  25,  "perf", "^PERF_(\\d+)$",                list(ORDER_STD35),   "map",   "expert_instrument_w25.pdf",
  "expert",  26,  "perf", "^PERF_(\\d+)$",                list(ORDER_STD35),   "map",   "BLW_wave_26_experts.pdf",
  "expert",  27,  "perf", "^PERF_now_(\\d+)$",            list(ORDER_STD35),   "map",   "BLW_wave_27_experts.pdf"
)
