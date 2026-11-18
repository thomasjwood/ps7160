# Build a labelled, multiyear (1991-2025) national YRBS file from CDC's
# combined high school dataset (SADC 2025, national file).
# One row per student-survey; question numbers harmonized by CDC to 2025.
#
# Input:  raw/sadc_2025/{sadc_2025_national.dat, 2025-SADC-SAS-*.sas}
#         raw/sadc_2023/2023-SADC-SAS-*.sas, raw/2025/2025XXH-Formats-Program.sas
#         (used only to restore labels CDC blanked in the 2025 programs)
# Output: output/yrbs_national_1991_2025.{rds,dta,sav}, output/codebook.csv

library(magrittr)
library(dplyr)
library(stringr)
library(purrr)
library(readr)
library(haven)
library(labelled)

dir.create("output", showWarnings = FALSE)

# ---- parse SAS programs -------------------------------------------------------

sas_lines <- function(f) {
  readLines(f, warn = FALSE, encoding = "latin1") %>%
    iconv("latin1", "UTF-8") %>%
    str_replace_all("\t", " ") %>%
    str_trim()
}

# column layout: "name [$] start-end"
parse_layout <- function(f) {
  x <- sas_lines(f)
  i0 <- which(str_detect(x, regex("^input$", ignore_case = TRUE)))[1]
  i1 <- which(x == ";" & seq_along(x) > i0)[1]
  x[(i0 + 1):(i1 - 1)] %>%
    str_match("^(\\w+)\\s+(\\$?)\\s*(\\d+)-(\\d+)$") %>%
    as.data.frame() %>%
    transmute(var = tolower(V2), char = V3 == "$",
              start = as.integer(V4), end = as.integer(V5)) %>%
    filter(!is.na(var))
}

# variable labels: var="label"
parse_varlabels <- function(f) {
  x <- sas_lines(f)
  i0 <- which(str_detect(x, regex("^label$", ignore_case = TRUE)))[1]
  m <- str_match(x[i0:length(x)], '^(\\w+)\\s*=\\s*"(.*)"\\s*;?$')
  m <- m[!is.na(m[, 1]), , drop = FALSE]
  set_names(m[, 3], tolower(m[, 2]))
}

# variable -> format name
parse_formatmap <- function(f) {
  x <- sas_lines(f)
  i0 <- which(str_detect(x, regex("^format$", ignore_case = TRUE)))[1]
  i1 <- which(str_detect(x, regex("^label$", ignore_case = TRUE)))[1]
  m <- str_match_all(paste(x[i0:i1], collapse = " "), "(\\w+)\\s+(\\$?[A-Za-z]\\w*)\\.")[[1]]
  set_names(toupper(str_remove(m[, 3], "^\\$")), tolower(m[, 2]))
}

# value labels: list(FMT = c(label = code, ...)); drops Missing / other rows
parse_formats <- function(f) {
  x <- sas_lines(f) %>% paste(collapse = "\n")
  blocks <- str_split(x, regex("\\bvalue\\s+", ignore_case = TRUE))[[1]][-1]
  map(blocks, function(b) {
    nm <- str_match(b, "^\\$?(\\w+)")[, 2] %>% toupper()
    m <- str_match_all(b, "[\"']?([^\"'=\\n]*)[\"']?\\s*=\\s*[\"']([^\"']*)[\"']")[[1]]
    codes <- str_trim(m[, 2]); labs <- str_squish(m[, 3])
    keep <- str_detect(codes, "^-?\\d+$")
    list(name = nm, labels = set_names(as.numeric(codes[keep]), labs[keep]))
  }) %>%
    { set_names(map(., "labels"), map_chr(., "name")) }
}

lay    <- parse_layout("raw/sadc_2025/2025-SADC-SAS-Input-Program.sas")
vlab   <- parse_varlabels("raw/sadc_2025/2025-SADC-SAS-Input-Program.sas")
fmap   <- parse_formatmap("raw/sadc_2025/2025-SADC-SAS-Input-Program.sas")
fmts   <- parse_formats("raw/sadc_2025/2025-SADC-SAS-Formats-Program.sas")
fmts23 <- parse_formats("raw/sadc_2023/2023-SADC-SAS-Formats-Program.sas")
fmtsyr <- parse_formats("raw/2025/2025XXH-Formats-Program.sas")

# ---- restore labels CDC blanked in the 2025 SADC programs ---------------------
# 2025 SADC q61 = 2025 Q61 (sex of sexual contacts), q62 = 2025 Q62 (sexual
# identity), q63 = 2023 SADC q65 (transgender identity; not asked in 2025).
vlab[c("q61", "q62", "q63", "sexid", "sexid2")] <-
  c("Sex of sexual contacts", "Sexual identity", "Transgender identity",
    "Sexual identity (5 categories)", "Sexual identity (3 categories)")
fmts[["H61S"]] <- fmtsyr[["H61S"]]
fmts[["H62S"]] <- fmtsyr[["H62S"]]
fmts[["H63S"]] <- fmts23[["H65S"]]

# ---- read data ----------------------------------------------------------------

raw <- read_fwf(
  "raw/sadc_2025/sadc_2025_national.dat",
  col_positions = fwf_positions(lay$start, lay$end, lay$var),
  col_types = cols(.default = col_character()),
  na = c("", ".", " "), trim_ws = TRUE, progress = FALSE
)
stopifnot(nrow(raw) > 0, all(lay$var %in% names(raw)))

site_vars <- c("sitecode", "sitename", "sitetype", "sitetypenum")
stopifnot(map_lgl(raw[site_vars], ~ n_distinct(.x) == 1))  # national file only

cont_vars <- c("weight", "stheight", "stweight", "bmi", "bmipct")
yrbs <- raw %>%
  select(-all_of(site_vars), -survyear) %>%
  mutate(across(all_of(cont_vars), as.numeric),
         across(-all_of(cont_vars), as.integer))

# ---- value labels -------------------------------------------------------------

yn <- c(Yes = 1, No = 2)
qn_vars <- str_subset(names(yrbs), "^qn")

for (v in names(yrbs)) {
  labs <- if (v %in% qn_vars) yn else if (!is.na(fmap[v])) fmts[[fmap[v]]] else NULL
  if (is.null(labs) || v == "sitecode") next
  stopifnot(length(labs) > 0, !anyNA(labs))
  bad <- setdiff(na.omit(unique(yrbs[[v]])), labs)
  if (length(bad)) stop(v, ": unlabelled codes ", paste(bad, collapse = ","))
  yrbs[[v]] <- labelled(yrbs[[v]], labels = labs)
}

# ---- variable labels ----------------------------------------------------------

tidy_label <- function(x) {
  x %>%
    str_squish() %>%
    str_replace("sexually transmitted transmitted infection \\(STI\\) other than HIV, such as chlamydia or gonorrhea\\)",
                "sexually transmitted infection (STI) other than HIV, such as chlamydia or gonorrhea") %>%
    str_replace("Currently smoked electronic vapor", "Currently used electronic vapor") %>%
    str_replace("^Used birth control pills; an IUD.*",
                "Used birth control pills; an IUD or implant; or a shot, patch, or birth control ring before last sexual intercourse with an opposite-sex partner") %>%
    str_replace("^Experience unstable", "Experienced unstable") %>%
    str_replace("^(\\w)", toupper)
}

vlab[] <- tidy_label(vlab)
vlab[c("year", "weight", "stratum", "psu", "record", "age", "sex", "grade",
       "race4", "race7")] <-
  c("Survey year", "Analysis weight", "Analysis stratum",
    "Analysis primary sampling unit", "Record ID (unique within year)",
    "Age", "Sex", "Grade", "Race/ethnicity (4 categories)",
    "Race/ethnicity (7 categories)")
vlab["stheight"] <- "Height in meters"
vlab["stweight"] <- "Weight in kilograms"
vlab["bmi"] <- "Body mass index"

missing_lab <- setdiff(names(yrbs), names(vlab))
if (length(missing_lab)) stop("no label: ", paste(missing_lab, collapse = " "))
var_label(yrbs) <- as.list(vlab[names(yrbs)])

# fix CDC typos in value labels
fix_vallab <- function(x) {
  if (!is.labelled(x)) return(x)
  l <- val_labels(x)
  names(l) <- names(l) %>% str_replace("gaurdian", "guardian") %>% str_squish()
  val_labels(x) <- l
  x
}
yrbs <- yrbs %>%
  mutate(across(everything(), fix_vallab)) %>%
  relocate(year, record, weight, stratum, psu) %>%
  arrange(year, record)

# ---- restore values CDC dropped from the 2025 combined file -------------------
# The 2025 SADC file omits sexual identity (sexid, sexid2) for 2015-2019 and
# transgender identity (q63) for 2023. Both are in CDC's single-year files.
# Rows are linked by fingerprint (R/link_peryear.R); the linkage reproduces
# SADC q62 exactly in 2021. The sexid/sexid2 recode reproduces CDC's own
# coding of q62 in 2021-2025.
source("R/link_peryear.R")

src <- tribble(
  ~yr,  ~dat,                               ~prog,                                        ~var,
  2015, "raw/2015/yrbs2015.dat",            "raw/2015/YRBS_2015_SAS_Input_Program.sas",   "q68",
  2017, "raw/2017/XXH2017_YRBS_Data.dat",   "raw/2017/2017XXH_SAS_Input_Program.sas",     "q67",
  2019, "raw/2019/XXH2019_YRBS_Data.dat",   "raw/2019/2019XXH-SAS-Input-Program.sas",     "q66",
  2023, "raw/2023/XXH2023_YRBS_Data.dat",   "raw/2023/2023XXH-SAS-Input-Program.sas",     "q65"
)
plain <- zap_labels(yrbs)
stopifnot(!anyDuplicated(plain[c("year", "record")]))
restored <- pmap_dfr(src, function(yr, dat, prog, var) {
  r <- link_peryear(filter(plain, year == yr), dat, prog, var, vlab)
  message(yr, ": ", paste(names(attr(r, "diag")), attr(r, "diag"), collapse = ", "))
  transmute(r, year = as.integer(yr), record, x = .data[[paste0("x_", var)]])
})

idx <- match(paste(restored$year, restored$record), paste(yrbs$year, yrbs$record))
stopifnot(!anyNA(idx))
sid <- restored$year <= 2019
stopifnot(all(is.na(yrbs$sexid[idx[sid]])), all(is.na(yrbs$q63[idx[!sid]])))
yrbs$sexid[idx[sid]]  <- c(1L, 2L, 3L, 5L)[restored$x[sid]]   # 4 "Not sure" -> 5 Questioning
yrbs$sexid2[idx[sid]] <- c(1L, 2L, 2L, 3L)[restored$x[sid]]
yrbs$q63[idx[!sid]]   <- as.integer(restored$x[!sid])

# ---- codebook: years each variable is non-missing -----------------------------

cov <- yrbs %>%
  group_by(year) %>%
  summarise(across(-c(record, weight, stratum, psu), ~ sum(!is.na(.x)))) %>%
  tidyr::pivot_longer(-year, names_to = "variable", values_to = "n")

codebook <- tibble(
  variable = names(yrbs),
  label = map_chr(names(yrbs), ~ var_label(yrbs[[.x]]) %||% ""),
  type = map_chr(yrbs, ~ if (is.labelled(.x)) "labelled integer" else class(.x)[1]),
  values = map_chr(yrbs, ~ if (is.labelled(.x))
    paste0(val_labels(.x), " = ", names(val_labels(.x)), collapse = "; ") else "")
) %>%
  left_join(
    cov %>% filter(n > 0) %>% group_by(variable) %>%
      summarise(years = paste(year, collapse = " "), n_years = n(), n_nonmissing = sum(n)),
    by = "variable"
  ) %>%
  mutate(years = if_else(variable %in% c("year", "record", "weight", "stratum", "psu"),
                         paste(sort(unique(yrbs$year)), collapse = " "), years),
         note = case_when(
           variable %in% c("sexid", "sexid2") ~ "2015-2019 restored from CDC single-year files (dropped from 2025 SADC); 2015-2019 'Not sure' coded Questioning",
           variable == "q63" ~ "Labels from 2023 SADC (blank in 2025 SADC); 2023 restored from CDC 2023 single-year file (dropped from 2025 SADC); 2025 values are in SADC but not in CDC's 2025 single-year file",
           variable %in% c("q61", "q62") ~ "Labels restored from CDC 2025 single-year format program (blank in 2025 SADC)",
           TRUE ~ ""))

# ---- write --------------------------------------------------------------------

write_rds(yrbs, "output/yrbs_national_1991_2025.rds", compress = "xz")
write_dta(yrbs, "output/yrbs_national_1991_2025.dta", version = 15,
          label = "National YRBS 1991-2025 (CDC combined high school file)")
write_sav(yrbs, "output/yrbs_national_1991_2025.sav", compress = "zsav")
write_csv(codebook, "output/codebook.csv", na = "")

cat("rows:", nrow(yrbs), " cols:", ncol(yrbs), "\n")
print(count(yrbs, year), n = 30)
