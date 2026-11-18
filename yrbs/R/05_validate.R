# Validate the long file against CDC single-year files and published estimates
library(magrittr); library(dplyr); library(readr); library(haven); library(survey)
source("R/peryear_layout.R")
y <- read_rds("output/yrbs_national_1991_2025.rds")
z <- zap_labels(y)

# 1. Row counts vs each single-year file (blank lines dropped)
progs <- list.files("raw", "SAS[-_]Input[-_]Program\\.sas$", recursive = TRUE, full.names = TRUE) %>%
  grep("sadc", ., value = TRUE, invert = TRUE)
dats <- list.files("raw", "\\.dat$", recursive = TRUE, full.names = TRUE) %>% grep("sadc", ., value = TRUE, invert = TRUE)
n_py <- sapply(dats, function(d) sum(nchar(trimws(read_lines(d))) > 0))
names(n_py) <- basename(dirname(dats))
cmp <- count(z, year) %>% mutate(single_year_file = n_py[as.character(year)], same = n == single_year_file)
print(cmp, n = 20)

# 2. 2025 values identical to the 2025 single-year file (multiset of rows)
s25 <- read_peryear("raw/2025/XXH2025_YRBS_Data.dat", "raw/2025/2025XXH-SAS-Input-Program.sas",
                    c("weight", "q1", "q2", "q3", "q26", "q41", "q61", "q62")) %>%
  rename(age = q1, sex = q2, grade = q3) %>%
  mutate(grade = if_else(grade == 5, NA_real_, grade))   # SADC sets "Ungraded or other" to missing
a <- s25 %>% arrange(across(everything())) %>% as.data.frame()
b <- z %>% filter(year == 2025) %>% select(all_of(names(s25))) %>% arrange(across(everything())) %>%
  mutate(across(everything(), as.numeric)) %>% as.data.frame()
cat("2025 SADC rows identical to single-year file:", isTRUE(all.equal(a, b, check.attributes = FALSE)), "\n")

# 3. Weighted prevalences, design-based
options(survey.lonely.psu = "adjust")
des <- svydesign(ids = ~psu, strata = ~interaction(year, stratum), weights = ~weight,
                 nest = TRUE, data = z)
est <- function(f, sub) {
  r <- svyby(f, ~year, subset(des, eval(sub)), svymean, na.rm = TRUE)
  round(100 * r[[grep("TRUE$", names(r))[1]]], 1) %>% setNames(r$year)
}
cat("\nPersistent sadness (qn26): CDC reports 36.7 / 42.3 / 39.7 for 2019 / 2021 / 2023\n")
print(est(~I(qn26 == 1), quote(!is.na(qn26))))
cat("\nCurrent alcohol (qn41): CDC reports 50.8 for 1991, 22.1 for 2023\n")
print(est(~I(qn41 == 1), quote(!is.na(qn41))))
cat("\nSexual minority, sexid2 == 2 (2015-2019 restored)\n")
print(est(~I(sexid2 == 2), quote(!is.na(sexid2))))
cat("\nTransgender, q63 == 2 (2023 restored)\n")
print(est(~I(q63 == 2), quote(!is.na(q63))))

# 4. Round-trip labels through Stata and SPSS
for (f in c("output/yrbs_national_1991_2025.dta", "output/yrbs_national_1991_2025.sav")) {
  r <- if (grepl("dta$", f)) read_dta(f, n_max = 50) else read_sav(f, n_max = 50)
  same_vl <- all(mapply(function(u, v) identical(attr(u, "label"), attr(v, "label")), r, y[1:50, ]))
  same_val <- all(mapply(function(u, v) identical(attr(u, "labels") %>% as.numeric(), attr(v, "labels") %>% as.numeric()), r, y[1:50, ]))
  long <- sum(nchar(sapply(y, function(v) attr(v, "label") %||% "")) > 80)
  cat(basename(f), "| variable labels identical:", same_vl, "| value labels identical:", same_val,
      "| labels > 80 chars:", long, "\n")
}
