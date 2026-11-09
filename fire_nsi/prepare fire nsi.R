# prepare fire nsi.R
# cleans FIRE's National Speech Index megafile (12 quarterly waves, Jan 2024 -
# Oct 2026, 1,000 respondents each) into a labelled R data frame.
# raw files (raw/, as received 2026-11-06): NSI Megafile.csv, NSI Megafile Codebook.csv
# what this does
#   - every coded variable becomes a factor, levels in code order, labels from
#     FIRE's codebook (typos and broken characters fixed).
#   - 98 "Not in survey" and 99 "Skipped/Missing" become NA. the codebook counts
#     each (n_skipped vs n_not_asked).
#   - six columns that are 98 for every respondent (never fielded in these
#     waves) are dropped: ps_prevent*book (4), trk_socimediareg, trk_other.
#   - fixes to FIRE's codebook, checked against FIRE's published toplines:
#       * Oct 2026: the value labels for aimedical_harm, ailegal_harm and crit*
#         are shifted down one item. aimedical_harm/ailegal_harm get the
#         helpful/harmful scale; crit* lost their own labels, see crit_lab below.
#       * airestrictuse_law repeats parody_ai's wording; the July 2026 topline
#         gives the real item (overly restrict your AI usage ...).
#       * encindecent says "diturbing"; it is the "indecent" item.
#       * mojibake (вЂќ, вЂ“, Х), dropped apostrophes and quote marks, misspellings.
#   - adds age (surveyyear - birthyr) and a wave table with field dates.
#   - each column's "label" attribute is the question wording; the data frame
#     carries study metadata as attributes and the codebook in attr(d, "codebook").
# output: fire_nsi_24_26.rds, codebook.csv
# usage: Rscript "prepare fire nsi.R" <folder with raw csvs> <output folder>

library(magrittr)
library(dplyr)
library(tidyr)
library(stringr)

raw <- commandArgs(TRUE)[1]
out <- commandArgs(TRUE)[2]

d0 <- raw %>%
  file.path("NSI Megafile.csv") %>%
  read.csv(
    check.names = F,
    na.strings = ""
    )

fix_text <- \(x)
x %>%
  str_replace_all(
    c(
      "вЂќ" = "\"",
      "вЂњ" = "\"",
      "вЂ“" = "-",
      "вЂ™" = "'",
      "Х" = "'",
      "’" = "'",
      "descrbes" = "describes",
      "Seperated" = "Separated",
      "ethinicity" = "ethnicity",
      "Emploment" = "Employment",
      "speaing" = "speaking",
      "metnal" = "mental",
      "Somthing" = "Something",
      "Kirks" = "Kirk's",
      "persons book" = "person's book",
      "peoples everyday" = "people's everyday",
      "governments role" = "government's role",
      "this persons" = "this person's",
      "Its O\\.K\\." = "It's O.K.",
      "\\s+" = " "
      )
    ) %>%
  str_trim

cb0 <- raw %>%
  file.path("NSI Megafile Codebook.csv") %>%
  read.csv(
    fileEncoding = "UTF-8",
    colClasses = "character"
    ) %>%
  mutate(
    Variable = Variable %>%
      na_if("")
    ) %>%
  fill(Variable, VariableLabel) %>%
  mutate(
    VariableLabel = VariableLabel %>%
      fix_text,
    ValueLabel = ValueLabel %>%
      fix_text
    )

stopifnot(
  setequal(cb0$Variable, names(d0))
  )

# question wording: FIRE's label, with hand fixes where it's wrong or garbled
q_fix <- c(
  firstamend = "The First Amendment became part of the U.S. Constitution more than 225 years ago. This is what it says: \"Congress shall make no law respecting an establishment of religion or prohibiting the free exercise thereof, or abridging the freedom of speech or of the press, or the right of the people peaceably to assemble, and to petition the government for a redress of grievances.\" Based on your own thoughts about the First Amendment, can you tell us what you think about the following statement: \"The First Amendment goes too far in the rights it guarantees.\"",
  wordsviolence = "How much, if at all, does the following statement describe your thoughts: \"Words can be violence.\"",
  encdisturbing = "How often, if at all, do you encounter speech online that is intended to be disturbing?",
  encindecent = "How often, if at all, do you encounter speech online that is intended to be indecent?",
  airestrictuse_law = "How concerned, if at all, are you about laws that would overly restrict your AI usage instead of holding individuals accountable for harmful actions they commit?",
  punchnazi = "If a professor on a college campus said any of the following statements on social media after Charlie Kirk's assassination, SHOULD THEY or SHOULD THEY NOT be fired from their job?: \"It's O.K. to punch a Nazi.\"",
  biblethumpers = "If a professor on a college campus said any of the following statements on social media after Charlie Kirk's assassination, SHOULD THEY or SHOULD THEY NOT be fired from their job?: \"These fascist Bible-thumpers want to drag us back to the Dark Ages.\"",
  maga_prof = "If a professor on a college campus said any of the following statements on social media after Charlie Kirk's assassination, SHOULD THEY or SHOULD THEY NOT be fired from their job?: \"We are going to make America great again.\"",
  indoctrinate = "If a professor on a college campus said any of the following statements on social media after Charlie Kirk's assassination, SHOULD THEY or SHOULD THEY NOT be fired from their job?: \"Our colleges and universities are progressive indoctrination centers.\"",
  survey = "NSI survey wave",
  surveymonth = "Survey month (quarter)",
  urbancity2 = "Type of residential area"
  )

# value labels FIRE's codebook gets wrong (Oct 2026 block shifted by one item)
harm_lab <- c(
  "1" = "Very harmful",
  "2" = "Somewhat harmful",
  "3" = "Neither helpful nor harmful",
  "4" = "Somewhat helpful",
  "5" = "Very helpful"
  )
# crit*: FIRE's codebook dropped this item's response options and the Oct 2026
# topline isn't published yet. the scale runs low -> high importance: 5 is the
# modal answer for every target (e.g. 34% for the police, 5% at 1), and the
# reverse would mean almost nobody thinks criticizing politicians matters.
crit_lab <- c(
  "1" = "1 (least important)",
  "2" = "2",
  "3" = "3",
  "4" = "4",
  "5" = "5 (most important)"
  )
crit_vars <- c("critpolice", "critpoliticians", "critgovtoff", "critjudges", "critpubfig", "critreliglead")

wave_lab <- c("Jan 2024", "Apr 2024", "Jul 2024", "Oct 2024", "Jan 2025", "Apr 2025", "Jul 2025", "Oct 2025", "Jan 2026", "Apr 2026", "Jul 2026", "Oct 2026")

# field dates from FIRE's wave pages (NA where FIRE doesn't give them)
waves <- tibble(
  survey = 1:12,
  wave = wave_lab,
  field_start = c("2024-01-12", NA, NA, "2024-10-04", "2025-01-03", "2025-04-04", NA, "2025-10-20", "2026-01-20", "2026-04-09", "2026-07-07", NA) %>%
    as.Date,
  field_end = c("2024-01-19", NA, NA, "2024-10-11", "2025-01-09", "2025-04-11", NA, "2025-10-28", "2026-01-27", "2026-04-17", "2026-07-20", NA) %>%
    as.Date,
  fire_page = c(
    "https://www.fire.org/research-learn/national-speech-index-january-2024-topline-results",
    NA, NA,
    "https://www.fire.org/research-learn/national-speech-index-october-2024",
    "https://www.fire.org/research-learn/national-speech-index-january-2025",
    "https://www.fire.org/research-learn/national-speech-index-april-2025",
    "https://www.fire.org/research-learn/national-speech-index-july-2025",
    "https://www.fire.org/research-learn/national-speech-index-october-2025",
    "https://www.fire.org/research-learn/national-speech-index-january-2026",
    "https://www.fire.org/research-learn/national-speech-index-april-2026",
    "https://www.fire.org/research-learn/national-speech-index-august-2026",
    NA
    )
  )

drop_vars <- d0 %>%
  select(where(\(x) is.numeric(x) && all(x == 98))) %>%
  names

var_note <- c(
  survey = "Wave labels recoded from FIRE's Jn/Ap/Jl/Oc codes; Jn = January (surveymonth). FIRE published the Jul 2026 wave as 'August 2026' (fielded July 7-20).",
  caseid = "YouGov case ID. Missing (98) for every respondent in Jan 2024 and Oct 2025, so it is not a unique key there. No respondent appears in more than one wave.",
  weight = "Mean 1 within each wave. Weighted counts reproduce FIRE's toplines exactly (e.g. mostoffensive, Jan 2024).",
  urbancity2 = "Asked Jan and Apr 2024 only; stored as text in the raw file. FIRE's codebook says 'Small city', the data say 'Smaller city'.",
  inputstate = "FIPS code; factor labels are state names.",
  mostoffensive = "Respondent's pick feeds the [insert] text in comspeech, tchcollege, keeplib and fired.",
  wordsviolence = "Scale runs 1 = Describes my thoughts completely ... 5 = Does not describe; wordsviolence_matrix (Oct 2025) runs the other way.",
  wordsviolence_matrix = "Scale runs 1 = Does not describe ... 5 = Describes completely; the opposite of wordsviolence.",
  losejob = "1 = Very worried ... 5 = Not at all worried.",
  aimedical_harm = "Asked only of respondents who have used AI for a medical issue (aimedical not Never); FIRE's 99 = not asked. FIRE's codebook shows aimedical's labels here (shifted one item); the helpful/harmful scale is restored.",
  ailegal_harm = "Asked only of respondents who have used AI for a legal issue (ailegal not Never); FIRE's 99 = not asked. Labels restored as for aimedical_harm.",
  airestrictuse_law = "FIRE's codebook repeats parody_ai's question here; wording from FIRE's July 2026 topline.",
  encindecent = "FIRE's codebook says 'disturbing'; it is the 'indecent' item.",
  jawbone_socmedia = "Same wording as govtpressure_socmediacensor (Apr 2026).",
  jawbone_video = "Same wording as govtpressure_videocensor (Apr 2026).",
  jawbone_tech = "Same wording as govtpressure_techcensor (Apr 2026).",
  comspeech = "[insert] = respondent's mostoffensive pick.",
  tchcollege = "[insert] = respondent's mostoffensive pick.",
  keeplib = "[insert] = respondent's mostoffensive pick.",
  fired = "[insert] = respondent's mostoffensive pick.",
  pardoyimpt = "Variable name typo is FIRE's (parody); kept so code written against FIRE's file still runs.",
  age = "Derived: surveyyear - birthyr."
  ) %>%
  c(
    crit_vars %>%
      set_names(crit_vars) %>%
      lapply(\(i) "FIRE's codebook gives the next-door item's labels (shifted one item) and omits this item's response options; the Oct 2026 topline isn't out yet. Levels keep the codes, low to high importance (inferred from the distribution).") %>%
      unlist
    )

to_factor <- function(x, v) {
  r <- cb0 %>%
    filter(
      Variable == v,
      Value != "",
      !Value %in% c("98", "99"),
      ValueLabel != "Not asked"
      )
  codes <- r$Value
  lab <- r$ValueLabel %>%
    set_names(codes)
  if (v %in% c("aimedical_harm", "ailegal_harm")) lab <- harm_lab
  if (v %in% crit_vars) lab <- crit_lab
  if (v == "survey") lab <- wave_lab %>% set_names(1:12)
  if (v == "pid7") lab <- lab[names(lab) != "9"]   # "Don't know" listed but never used
  codes <- names(lab) %>%
    as.numeric %>%
    sort %>%
    as.character
  vals <- x %>%
    as.character
  n_skip <- sum(vals == "99", na.rm = T)
  n_98 <- sum(vals == "98", na.rm = T)
  vals[vals %in% c("98", "99")] <- NA
  stopifnot(
    all(is.na(vals) | vals %in% codes),
    !anyDuplicated(lab)
    )
  list(
    f = factor(
      vals,
      levels = codes,
      labels = lab[codes]
      ),
    codes = codes,
    n_skip = n_skip,
    n_98 = n_98
    )
}

keep <- names(d0) %>%
  setdiff(drop_vars)
d <- d0[, 0, drop = F]   # 12,000 rows, no columns yet
cb <- list()
for (v in keep) {
  x <- d0[[v]]
  lab <- if (v %in% names(q_fix)) q_fix[[v]] else cb0$VariableLabel[cb0$Variable == v][1]
  n_skip <- 0L
  n_98 <- 0L
  levs <- NA_character_
  if (v == "urbancity2") {
    n_98 <- sum(x == "98")
    col <- x %>%
      na_if("98") %>%
      factor(levels = c("Big city", "Smaller city", "Suburban area", "Small town", "Rural area"))
    stopifnot(sum(is.na(col)) == n_98)
    levs <- paste0(1:5, " = ", levels(col), collapse = "; ")
  } else if (v == "surveymonth") {
    col <- x %>%
      factor(levels = c("January", "April", "July", "October"))
    levs <- levels(col) %>%
      paste(collapse = "; ")
  } else if (v %in% c("caseid", "birthyr")) {
    n_98 <- sum(x == 98)
    n_skip <- sum(x == 99)
    col <- x %>%
      replace(x %in% c(98, 99), NA) %>%
      as.numeric
    if (v == "birthyr") col <- col %>% as.integer
  } else if (v %in% c("weight", "surveyyear")) {
    col <- x
  } else {
    r <- to_factor(x, v)
    col <- r$f
    n_skip <- r$n_skip
    n_98 <- r$n_98
    levs <- paste0(r$codes, " = ", levels(col), collapse = "; ")
  }
  attr(col, "label") <- lab
  d[[v]] <- col
  asked <- d0$survey[!is.na(col) | (x %in% 99)] %>%
    unique %>%
    sort
  cb[[v]] <- tibble(
    variable = v,
    label = lab,
    class = class(col)[1],
    waves = wave_lab[asked] %>%
      paste(collapse = ", "),
    n_valid = sum(!is.na(col)),
    n_skipped = n_skip,
    n_not_asked = sum(is.na(col)) - n_skip,
    levels = levs,
    note = if (v %in% names(var_note)) var_note[[v]] else NA_character_
    )
}

d <- d %>%
  as_tibble %>%
  mutate(
    age = surveyyear %>%
      subtract(birthyr) %>%
      as.integer,
    .after = birthyr
    )
attr(d$age, "label") <- "Age at survey (surveyyear - birthyr)"
cb <- cb %>%
  bind_rows %>%
  add_row(
    variable = "age",
    label = "Age at survey (surveyyear - birthyr)",
    class = "integer",
    waves = wave_lab %>% paste(collapse = ", "),
    n_valid = sum(!is.na(d$age)),
    n_skipped = 0L,
    n_not_asked = sum(is.na(d$age)),
    note = var_note[["age"]],
    .after = which(.$variable == "birthyr")
    )

# hand checks against the raw file and FIRE's published toplines
wt_n <- \(v, w) tapply(d$weight[d$survey == w], d[[v]][d$survey == w], sum) %>% round %>% as.vector
stopifnot(
  nrow(d) == 12000,
  ncol(d) == ncol(d0) - length(drop_vars) + 1,
  all(table(d$survey) == 1000),
  !anyDuplicated(na.omit(d$caseid)),
  isTRUE(all.equal(as.vector(d$weight), d0$weight, check.attributes = F)),
  # Jan 2024 topline: most offensive statement (weighted counts)
  identical(wt_n("mostoffensive", "Jan 2024"), c(112, 79, 64, 121, 42, 188, 57, 28, 46, 36, 47, 180)),
  # July 2026 topline: comfort discussing race
  identical(wt_n("comfort_race", "Jul 2026"), c(129, 218, 375, 279)),
  # AI-harm items: FIRE's 99 = never used AI for that issue
  sum(d0$aimedical_harm == 99) == sum(d0$aimedical == 1),
  all(d0$aimedical_harm[d0$aimedical == 1] == 99),
  all(d0$ailegal_harm[d0$ailegal == 1] == 99),
  sum(d$gender == "Female") == sum(d0$gender == 2),
  sum(is.na(d$turnout24post)) == sum(d0$turnout24post %in% 98:99)
  )

attr(d, "title") <- "FIRE National Speech Index, January 2024 - October 2026 (stacked respondent-level megafile)"
attr(d, "producer") <- "Foundation for Individual Rights and Expression (FIRE); fielded by the Dartmouth Polarization Research Lab as part of America's Political Pulse, YouGov panel"
attr(d, "url") <- "https://www.fire.org/research-learn/national-speech-index"
attr(d, "n") <- nrow(d)
attr(d, "waves") <- waves
attr(d, "weight") <- "weight (mean 1 within each wave; weighted to nationally representative demographic targets). Use it for every estimate. Weighted counts reproduce FIRE's toplines."
attr(d, "unit") <- "One row per respondent; 1,000 per wave, 12 quarterly waves (survey). Separate cross-sections, not a panel."
attr(d, "notes") <- c(
  "Each wave: five permanent tracker items (tracker, firstamend, secure, losejob, scmonth) plus rotating items. The codebook's 'waves' column lists when each was asked.",
  "Coded variables are factors with FIRE's labels, levels in code order. Scales don't all run the same way (e.g. losejob 1 = Very worried; wordsviolence vs wordsviolence_matrix run opposite ways); check levels() before averaging codes.",
  "NA = not asked that wave (98 'Not in survey') or skipped (99). The codebook counts each (n_not_asked vs n_skipped).",
  "Dropped, 98 for everyone: ps_preventbook, ps_preventsexidbook, ps_preventgenderidbook, ps_preventraceidbook, trk_socimediareg, trk_other.",
  "Oct 2026 fixes: aimedical_harm / ailegal_harm labels restored (helpful/harmful); crit* response wording missing from FIRE's codebook, levels are 1 (least important) - 5 (most important).",
  "airestrictuse_law and encindecent question wording corrected (FIRE's codebook repeats a neighbouring item).",
  "caseid is missing for the Jan 2024 and Oct 2025 waves.",
  "Party ID, vote recall and demographics are YouGov profile variables (pid3, pid7, presvote20post, presvote24post, turnout24post, ideo5, religion items, etc.)."
  )
attr(d, "source_files") <- "NSI Megafile.csv, NSI Megafile Codebook.csv (from FIRE, received 2026-11-06); question wording checked against FIRE's Jan 2024 and Jul 2026 topline PDFs"
attr(d, "built") <- paste("prepare fire nsi.R,", Sys.Date())
attr(d, "codebook") <- cb

saveRDS(d, file.path(out, "fire_nsi_24_26.rds"), compress = "xz")
write.csv(cb, file.path(out, "codebook.csv"), row.names = F, na = "", fileEncoding = "UTF-8")
write.csv(waves, file.path(out, "waves.csv"), row.names = F, na = "")
