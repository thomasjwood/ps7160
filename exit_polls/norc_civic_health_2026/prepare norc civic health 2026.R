# prepare norc civic health 2026.R
# cleans NORC's Civic Health & Elections Project (2026 midterm voter survey)
# into a labelled R data frame.
# raw files (NORC download, 2026-11-04): civichealth_datafile.zip (.sav/.dta/.csv)
#   and civichealth_codebook.zip (variable_list.csv, response_options.csv,
#   final questionnaire 10.16.2026, README.txt)
# what this does
#   - every coded variable becomes a factor, levels in code order. level text is
#     the .sav value label minus its "(code)" prefix; where SPSS cut a label off
#     at 60 characters the full text comes from response_options.csv.
#   - RACEn_RACEID / BALLOT1_RACEID are contest IDs, kept as integers.
#   - nonresponse codes become NA: 99 "DON'T KNOW/SKIPPED/REFUSED",
#     "SKIPPED/REFUSED", "UNKNOWN" (county context), 777777/999998/999999 on the
#     candidate-choice variables, 88 "REMOVED FOR DISCLOSURE RISK", and blank
#     strings. substantive "Not sure" options are kept.
#   - NA otherwise means the item wasn't asked (skip patterns, state-specific races).
#   - each column's "label" attribute is the question wording from variable_list.csv.
#   - the data frame carries study metadata as attributes (see attr(d, "notes"))
#     and a full codebook in attr(d, "codebook"), also written as codebook.csv.
# output: norc_civic_health_2026.rds, codebook.csv

library(haven)
library(dplyr)

raw <- commandArgs(TRUE)[1]   # folder holding the unzipped NORC files
out <- commandArgs(TRUE)[2]   # this folder

d0 <- read_sav(file.path(raw, "civichealth_datafile.sav"))

strip_q <- \(x) trimws(gsub('^"+|"+$', "", x))
vlist <- read.csv(file.path(raw, "variable_list.csv"), fileEncoding = "UTF-8-BOM", colClasses = "character") |>
  mutate(label = strip_q(label))
ropt <- read.csv(file.path(raw, "response_options.csv"), fileEncoding = "UTF-8-BOM", colClasses = "character") |>
  mutate(value_label = strip_q(value_label))
stopifnot(setequal(vlist$variable, names(d0)))

miss_lab <- "DON'T KNOW|SKIPPED|REFUSED|^UNKNOWN$|^DONT KNOW$|Skipped on web|^Refused$|REMOVED FOR DISCLOSURE"

to_factor <- function(x, v) {
  lb <- attr(x, "labels")
  codes <- if (is.numeric(lb)) format(unname(lb), scientific = FALSE, trim = TRUE, drop0trailing = TRUE) else unname(lb)
  sav_txt <- sub("^\\([^)]*\\) ", "", names(lb))
  r <- ropt[ropt$variable == v, ]
  # the .sav label wins unless SPSS cut it off (60 characters with the prefix).
  # where the two disagree the .sav is right: the CSV has TURNOUT_2024 high/low
  # reversed, calls the no-race code on COMPETITIVE_SEN/GOV "UNKNOWN", and has typos.
  cut_off <- nchar(names(lb)) >= 60 & codes %in% r$value
  txt <- ifelse(cut_off, r$value_label[match(codes, r$value)], sav_txt)
  txt <- recode(txt, "NO SENATE RACE" = "No Senate race in state", "NO GOVERNOR'S RACE" = "No Governor's race in state")
  keep <- !grepl(miss_lab, txt)
  vals <- vctrs::vec_data(x)
  vals <- if (is.numeric(vals)) format(vals, scientific = FALSE, trim = TRUE, drop0trailing = TRUE) else trimws(vals)
  vals[vals %in% c("", "NA")] <- NA
  stopifnot(all(is.na(vals) | vals %in% codes))
  ord <- if (is.numeric(lb)) order(unname(lb)) else order(codes)
  keep_codes <- codes[ord][keep[ord]]
  # levels: only codes in the codebook CSV or present in the data (the .sav also
  # lists every candidate in every state, which would give 216-level factors)
  keep_codes <- keep_codes[keep_codes %in% c(r$value, vals)]
  # contest-level vars carry every state's codes: keep only those used in this column
  if (grepl(race_vars, v)) keep_codes <- keep_codes[keep_codes %in% vals]
  lab <- txt[match(keep_codes, codes)]
  stopifnot(!anyDuplicated(lab))
  f <- factor(vals, levels = keep_codes, labels = lab)
  list(f = f, codes = keep_codes, n_na_coded = sum(vals %in% codes[!keep]))
}
race_vars <- "^(RACE|BALLOT)[0-9](M2)?_(VOTE|PARTY|OFFICEID)$"
id_vars <- "^(RACE|BALLOT)[0-9]_RACEID$"   # contest IDs: integers; the codebook gives each one's office

d <- d0[0]
cb <- vector("list", ncol(d0))
for (i in seq_along(d0)) {
  v <- names(d0)[i]; x <- d0[[v]]
  if (grepl(id_vars, v)) {
    lb <- attr(x, "labels"); vals <- zap_labels(x)
    col <- as.integer(vals)
    used <- sort(unique(col))
    cb_codes <- paste0(used, " = ", sub("^\\([^)]*\\) ", "", names(lb))[match(used, lb)], collapse = "; ")
    n_coded_na <- 0L
  } else if (!is.null(attr(x, "labels"))) {
    r <- to_factor(x, v)
    col <- r$f
    cb_codes <- paste0(r$codes, " = ", levels(col), collapse = "; ")
    n_coded_na <- r$n_na_coded
  } else {
    col <- if (v == "SU_ID") as.integer(trimws(x)) else if (is.character(x)) trimws(x) else as.numeric(x)
    cb_codes <- NA_character_
    n_coded_na <- 0L
  }
  attr(col, "label") <- vlist$label[vlist$variable == v]
  d[[v]] <- col
  cb[[i]] <- tibble(
    variable = v, label = vlist$label[vlist$variable == v], class = class(col)[1],
    n_valid = sum(!is.na(col)), n_coded_missing = n_coded_na,
    n_not_asked = sum(is.na(col)) - n_coded_na, levels = cb_codes
    )
}
cb <- bind_rows(cb)

# hand checks against the raw file
stopifnot(
  nrow(d) == nrow(d0), ncol(d) == ncol(d0), !anyDuplicated(d$SU_ID),
  isTRUE(all.equal(as.vector(d$CHEP_WEIGHT), as.vector(zap_labels(d0$CHEP_WEIGHT)), check.attributes = FALSE)),
  sum(d$LVB == "Already voted", na.rm = TRUE) == sum(d0$LVB == 5),
  sum(is.na(d$LVB)) == sum(d0$LVB == 99, na.rm = TRUE) + sum(is.na(d0$LVB))
  )

attr(d, "title") <- "NORC Civic Health & Elections Project, 2026 midterm election (respondent-level)"
attr(d, "producer") <- "NORC at the University of Chicago"
attr(d, "election_date") <- as.Date("2026-11-03")
attr(d, "questionnaire") <- "Civic Health & Elections Project_Final_Questionnaire.docx (final, 10.16.2026)"
attr(d, "n") <- nrow(d)
attr(d, "modes") <- table(d$MODE)
attr(d, "weight") <- "CHEP_WEIGHT (mean 1). Use it for every estimate."
attr(d, "unit") <- "One row per respondent (SU_ID); 50 states (P_STATE, STATENUM)."
attr(d, "notes") <- c(
  "Coded variables are factors with NORC's value labels; levels are in code order. Contest IDs (*_RACEID) are integers; the codebook gives each one's office.",
  "NA = item not asked, or coded missing: 99 DON'T KNOW/SKIPPED/REFUSED, SKIPPED/REFUSED, UNKNOWN, 777777/999998/999999, 88 REMOVED FOR DISCLOSURE RISK. The codebook counts each (n_coded_missing vs n_not_asked).",
  "NORC suppressed detailed identity items for disclosure risk (88): RACETH is missing for about 71,000 cases, DETAILEDHISP for 75,000. The collapsed versions are fuller: RACETH2/4/5 about 98% complete, DETAILEDHISP4 about 75%.",
  "COMPETITIVE_SEN/GOV keep 'No Senate/Governor's race in state' as a level (code 99).",
  "Substantive 'Not sure' answers are kept as levels.",
  "RACEn_VOTE gives the candidate; RACEn_PARTY the candidate's party; RACEn_OFFICEID and RACEn_RACEID the contest. RACE1 = Senate, RACE3 = Governor, RACE4 = at-large House (Los Angeles mayor for LA respondents), RACE5 = House in multi-district states, BALLOT1 = state ballot measure; RACEnM2_VOTE = second choice in the ranked-choice states (AK, ME).",
  "County and state context variables (ACS, AHRF, EPA, KFF, American Communities Project) are binned by NORC; the source is in each variable's label.",
  "NORC README: state-level analysis needs software that handles subpopulation weights (R survey/srvyr, Stata svy, SAS); base SPSS without Complex Samples doesn't."
  )
attr(d, "source_files") <- "civichealth_datafile.sav, civichealth_codebook.zip (downloaded from NORC 2026-11-04)"
attr(d, "built") <- paste("prepare norc civic health 2026.R,", Sys.Date())
attr(d, "codebook") <- cb

saveRDS(d, file.path(out, "norc_civic_health_2026.rds"), compress = "xz")
write.csv(cb, file.path(out, "codebook.csv"), row.names = FALSE, na = "", fileEncoding = "UTF-8")
