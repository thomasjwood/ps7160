# =============================================================================
# Bright Line Watch (BLW) -- canonical democratic-principles item dictionary
# -----------------------------------------------------------------------------
# One row per democratic principle BLW has rated, in the performance battery
# ("PERF": how well does the U.S. meet this standard?) and/or the importance
# battery ("IMP": how important is this for democracy?).
#
#   key      canonical stem; harmonized columns are perf_<key> and imp_<key>
#   short    short label (used in value/variable labels and plots)
#   family   substantive grouping
#   rx       regular expression that recognises the statement in a variable
#            label or questionnaire PDF. Patterns use one or two distinctive
#            words so they survive PDF line-wrap and Qualtrics' word scrambling
#            inside grid rows.
#   wording  full statement text as fielded (modal wording across waves)
# =============================================================================

blw_items <- tibble::tribble(
  ~key,                     ~short,                                        ~family,                ~rx,
  "election_fraud",         "Fraud-free elections",                        "Elections",            "fraud",
  "candidates_disclose",    "Candidate information available",             "Elections",            "relevant to how|candidates disclose",
  "districts",              "District boundaries not biased",              "Elections",            "boundaries(?!.{0,60}your state)|districts not biased",
  "districts_state",        "District boundaries not biased (own state)",  "Elections",            "boundaries.{0,60}your state",
  "funds_transparent",      "Campaign funding transparent",                "Elections",            "funding|campaign funds transparent",
  "contributions",          "Policy not set by large contributions",       "Elections",            "contributions|contribs",
  "foreign_influence",      "Elections free from foreign influence",       "Elections",            "foreign",
  "concede_defeat",         "Losers concede defeat",                       "Elections",            "concede",
  "voting_rights",          "Equal opportunity to vote",                   "Elections",            "opportunity to vote|equal voting rights",
  "votes_impact",           "Votes have equal impact",                     "Elections",            "equal impact|impact on election|votes have equal",
  "participation",          "Voter participation high",                    "Elections",            "participation",
  "equal_rights",           "Equal legal and political rights",            "Rights",               "enjoy|equal political/legal",
  "ban_ideology",           "Parties not barred for beliefs",              "Rights",               "barred|all parties allowed",
  "free_speech",            "Unpopular speech protected",                  "Rights",               "unpopular|^free speech",
  "protest",                "Peaceful protest protected",                  "Rights",               "protest",
  "opinions",               "Open debate on policy",                       "Rights",               "open debate|opinions heard",
  "journalists",            "No interference with the press",              "Rights",               "journalists|interference with press",
  "private_violence",       "Political violence prevented",                "Rights",               "intimidation|motivated violence|no political violence",
  "equal_enforce",          "Law enforced equally",                        "Accountability",       "enforced equally",
  "monitor_opponents",      "Agencies not used against opponents",         "Accountability",       "punish",
  "misconduct",             "Officials sanctioned for misconduct",         "Accountability",       "misconduct",
  "private_gain",           "No private gain from office",                 "Accountability",       "private\\s+gains?",
  "investigations",         "Investigations free from interference",       "Accountability",       "investigations",
  "gov_stats",              "Government statistics nonpartisan",           "Accountability",       "statistics",
  "law_neutral",            "Law enforcement politically neutral",         "Accountability",       "law enforcement remains",
  "use_law",                "Law enforcement not used for agendas",        "Accountability",       "use law enforcement",
  "military_neutral",       "Military politically neutral",                "Accountability",       "military leadership",
  "use_military",           "Military not used for agendas",               "Accountability",       "use the military",
  "org_pressure",           "Civil society free of government pressure",   "Accountability",       "universities",
  "expand_executive",       "Executive within constitutional limits",      "Institutional checks", "expanded|constitution limits executive",
  "legislature_check",      "Legislature can limit executive",             "Institutional checks", "legislature",
  "judiciary_check",        "Judiciary can limit executive",               "Institutional checks", "judiciary (is able|can)",
  "judiciary_check_scotus", "Supreme Court can limit executive",           "Institutional checks", "supreme court is able",
  "judiciary_check_lwr",    "Lower courts can limit executive",            "Institutional checks", "lower courts",
  "judicial_ind",           "Judicial independence respected",             "Institutional checks", "judicial independence",
  "common_und",             "Shared understanding of facts",               "Norms",                "understanding",
  "compromise",             "Officials seek compromise",                   "Norms",                "compromise",
  "patriotism",             "Loyalty/patriotism not questioned",           "Norms",                "patriotism",
  "science",                "Expert/scientific consensus recognized",      "Norms",                "consensus",
  "restraint",              "Restraint and reciprocity",                   "Norms",                "restraint|reciprocity"
)

blw_wording <- c(
  election_fraud         = "Elections are conducted, ballots counted, and winners determined without pervasive fraud or manipulation",
  candidates_disclose    = "Citizens have access to information about candidates that is relevant to how they would govern",
  districts              = "The geographic boundaries of electoral districts do not systematically advantage any particular political party",
  districts_state        = "The geographic boundaries of electoral districts in your state do not systematically advantage any particular political party",
  funds_transparent      = "Information about the sources of campaign funding is available to the public",
  contributions          = "Public policy is not determined by large campaign contributions",
  foreign_influence      = "Elections are free from foreign influence",
  concede_defeat         = "Politicians who lose free and fair elections publicly concede defeat",
  voting_rights          = "All adult citizens have equal opportunity to vote",
  votes_impact           = "All votes have equal impact on election outcomes",
  participation          = "Voter participation in elections is generally high",
  equal_rights           = "All adult citizens enjoy the same legal and political rights",
  ban_ideology           = "Parties and candidates are not barred due to their political beliefs and ideologies",
  free_speech            = "Government protects individuals' right to engage in unpopular speech or expression",
  protest                = "Government protects individuals' right to engage in peaceful protest",
  opinions               = "Citizens can make their opinions heard in open debate about policies that are under consideration",
  journalists            = "Government does not interfere with journalists or news organizations",
  private_violence       = "Government effectively prevents private actors from engaging in politically-motivated violence or intimidation",
  equal_enforce          = "The law is enforced equally for all persons",
  monitor_opponents      = "Government agencies are not used to monitor, attack, or punish political opponents",
  misconduct             = "Government officials are legally sanctioned for misconduct",
  private_gain           = "Government officials do not use public office for private gain",
  investigations         = "Law enforcement investigations of public officials or their associates are free from political influence or interference",
  gov_stats              = "Government statistics and data are produced by experts who are not influenced by political considerations",
  law_neutral            = "Law enforcement remains politically neutral and does not favor or target individuals or groups based on political affiliation",
  use_law                = "Officeholders do not use law enforcement to advance political agendas",
  military_neutral       = "Military leadership remains politically neutral and does not favor or target individuals or groups based on political affiliation",
  use_military           = "Officeholders do not use the military to advance political agendas",
  org_pressure           = "Universities, businesses, and professional organizations operate independently, without government pressure",
  expand_executive       = "Executive authority cannot be expanded beyond constitutional limits",
  legislature_check      = "The legislature is able to effectively limit executive power",
  judiciary_check        = "The judiciary is able to effectively limit executive power",
  judiciary_check_scotus = "The Supreme Court is able to effectively limit executive power",
  judiciary_check_lwr    = "Lower courts are able to effectively limit executive power",
  judicial_ind           = "The elected branches respect judicial independence",
  common_und             = "Even when there are disagreements about ideology or policy, political leaders generally share a common understanding of relevant facts",
  compromise             = "Elected officials seek compromise with political opponents",
  patriotism             = "Political competition occurs without criticism of opponents' loyalty or patriotism",
  science                = "Government leaders recognize the validity of bureaucratic or scientific consensus about matters of public policy",
  restraint              = "In the elected branches, majorities act with restraint and reciprocity"
)
blw_items$wording <- unname(blw_wording[blw_items$key])
stopifnot(!anyNA(blw_items$wording))

# Ordered canonical keys found in a block of text (questionnaire grid section).
blw_match_order <- function(txt) {
  txt <- stringr::str_squish(paste(txt, collapse = " "))
  hits <- purrr::map_dfr(seq_len(nrow(blw_items)), \(i) {
    loc <- stringr::str_locate_all(txt, stringr::regex(blw_items$rx[i], ignore_case = TRUE))[[1]]
    if (nrow(loc)) tibble::tibble(key = blw_items$key[i], pos = loc[, 1]) else NULL
  })
  hits <- dplyr::arrange(hits, pos)
  # one statement can trip two alternatives of the same pattern; keep the first
  hits[c(TRUE, hits$key[-1] != hits$key[-nrow(hits)]), ]
}

# Map variable labels to one canonical key each (NA if none or ambiguous).
blw_match_label <- function(lab) {
  purrr::map_chr(lab, \(l) {
    if (is.na(l) || !nzchar(l)) return(NA_character_)
    # strip the question preamble: "How well do ... today? - ", "PERF items -- ", "Statements - " ...
    stem <- stringr::str_remove(l, "^.*(\\?\\s*-+|--|^Statements\\s*-|^Importance\\s*-|^Democracy\\s*-|^Description\\s*-)\\s*")
    k <- blw_items$key[stringr::str_detect(stem, stringr::regex(blw_items$rx, ignore_case = TRUE))]
    if (all(c("districts", "districts_state") %in% k)) k <- "districts_state"
    if (length(k) == 0) {
      # labels cut at 80 characters (Stata/Qualtrics exports): use the stem as a
      # prefix of the full wording, if it is long enough to be unambiguous
      nz <- function(s) stringr::str_squish(tolower(gsub("[^A-Za-z ]", " ", s)))
      s <- nz(stem)
      if (nchar(s) >= 25) k <- blw_items$key[startsWith(nz(blw_items$wording), s)]
    }
    if (length(k) == 1) k else NA_character_
  })
}
