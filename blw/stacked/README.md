# Bright Line Watch: stacked public and expert files

Every Bright Line Watch (BLW) wave in `ps7160/blw`, harmonized into one file per survey:

| File | Rows | Columns | Waves |
|---|---|---|---|
| `data/blw_public_stacked_w03-30.rds` / `.dta` | 69,277 | 127 | 3–10, 12–30 (YouGov national samples) |
| `data/blw_expert_stacked_w01-30.rds` / `.dta` | 21,889 | 96 | 1–30 (political scientists) |
| `data/blw_battery_long_w01-30.rds` | 1,015,124 | 17 | PERF and IMP answers, one row per respondent × item, both surveys |

Each file name carries the waves it covers (`_w03-30`), so a rebuild after new waves writes new files next to the old ones. BLW numbers waves the same way in both surveys. Waves 1, 2 and 11 were expert-only.

Source: brightlinewatch.org/survey-data-and-replication-material/, mirrored at github.com/thomasjwood/ps7160/tree/master/blw.

## Loading

```r
library(haven); library(dplyr)
pub <- readRDS("data/blw_public_stacked_w03-30.rds")
exp <- readRDS("data/blw_expert_stacked_w01-30.rds")

pub |> group_by(wave_label) |> summarise(fraud = weighted.mean(perf_election_fraud, weight, na.rm = TRUE))
attr(pub$perf_election_fraud, "wording")      # full statement text
as_factor(pub$pid7)                            # labelled -> factor
na_tag(pub$perf_misconduct) %in% "s"           # who answered "Not sure"
```

In Stata, `use data/blw_public_stacked_w03-30.dta`. Value labels are attached, and "Not sure" is stored as `.s`.

## What's in each file

**Both surveys**
- `survey`, `wave`, `wave_label` ("Wave 23 (Nov 2024)"), `field_start`, `field_end`, `field_date`
- `resp_id`: respondent ID, complete and unique within every wave
- `rating_USA`: how democratic the U.S. is today, 0–100
- `perf_<key>`: performance battery ("How well do the following statements describe the United States as of today?"). 1 = does not meet the standard, 2 = partly meets, 3 = mostly meets, 4 = fully meets. "Not sure" is `NA`, tagged `"s"`. It drops out of means but stays recoverable.
- `imp_<key>`: importance battery ("How important are these characteristics for democratic government?"). 1 = not relevant, 2 = beneficial, 3 = important, 4 = essential.
- `source_file`, `source_row`: the exact row each record came from

**Public only**
- `weight` (YouGov, within wave)
- Party: `pid3`, `pid7` (higher = more Republican), `pid3_lean`
- Ideology: `ideo7` (higher = more conservative; recoded from BLW's reversed coding), `ideo5`
- Demographics: `birthyr`, `age`, `age4`, `gender`, `educ7`, `educ6`, `educ4`, `race8`, `ethnicity`, `hispanic`, `race5`, `faminc`, `income5`, `state_fips`, `state_abb`, `region`
- Politics: `votereg`, `newsint`, `polinterest`, `presvote16`, `presvote20`, `presvote24`
- `approve_pres`: job approval of the sitting president (Trump in waves 3–13 and 24–30, Biden in waves 14–23), with `approve_pres_who`
- Religion and household: `religpew`, `pew_churatd`, `pew_bornagain`, `pew_religimp`, `pew_prayer`, `marstat`, `employ`, `child18`, `ownhome`

**Expert only**
- `panel_id` (LuthID; links the same expert across waves 4–30), `field`, `occupation`, `duration_sec`, `progress`, `finished`

Every column has a variable label. Every coded column has value labels. Every item column carries its full wording in `attr(x, "wording")`.

## Items

There are 40 democratic principles, listed in `docs/blw_item_dictionary_w01-30.csv` with key, short label, family and full wording. Twenty-eight PERF items appear in 20 or more waves of each survey. Newer items start later:
- `gov_stats`: Oct 2019
- `equal_enforce`, `concede_defeat`: Oct 2020
- `org_pressure`: 2025
- `military_neutral`, `use_military`, `law_neutral`, `use_law`: Sep 2025
- the Supreme Court and lower-court splits of `judiciary_check`: 2026

`science` and `restraint` were asked only of experts, in 2017.

The public IMP battery was fielded in waves 3, 8, 14, 23 and 28. Wave 4's IMP grid is empty in BLW's release. The expert IMP battery was fielded in waves 1, 3, 8, 11, 23 and 28.

Wording drifted a little over the years. For example, "Incumbent politicians who lose elections…" became "Politicians who lose free and fair elections…". Each variant is mapped to the same key. The crosswalk records which source variable fed every value.

## How items were matched across waves

Item order and naming change from wave to wave. Some examples: `perf_misconduct`, `statements_13`, `Q1_13`, `statments_US_20`, `Q158_1`, `_v6`, `PERF_1`. In 14 files (public waves 23–28 and 30; expert waves 17 and 22–27) the variables carry no labels at all. Matching therefore uses three sources, in order:

1. **Variable names** that are already `perf_*` / `imp_*`.
2. **Grid position**, read from BLW's questionnaires (kept in `questionnaires/`). Three orders are in use:
   - a YouGov order for public waves 16–23
   - a base order used by every Qualtrics expert instrument and by public waves 24–27
   - wave-specific orders for public waves 28 and 30

   They are coded in `syntax/01_helpers.R`, with the PDF each one came from.
3. **Variable labels**, matched to the dictionary by keyword, or by prefix where Stata cut the label at 80 characters.

Checks, all reproduced by `syntax/03_checks.R`:
- All 1,058 labelled source variables that were also mapped by position agree with their labels. There are 0 disagreements.
- Every non-missing source value was placed on a code. There are 0 unmatched values.
- Each wave's item-mean profile correlates .88–.99 with the previous wave's.
- As a substantive check, Republicans' rating of election integrity drops from 2.2 to 1.8 after the 2020 election and recovers after the 2024 election. Democrats' rating of press freedom falls in 2025, including in waves mapped only from questionnaires.

## Problems found in the source files

- **`expert_wave7.rds` is a second copy of wave 6**: the same 679 response IDs and July 2018 dates. The real wave 7 (n = 747, Oct–Nov 2018) is taken from `expert_waves1_to_7.rds`.
- `public_wave_unk.rds` = wave 9, `unknown_wave_unk.rds` = public wave 10, and `expert_wave_unk.rds` = expert wave 9 stored as factors. All three are ignored.
- Expert wave 23's questionnaire PDF is a scanned image. Its item order is inferred from waves 22 and 24, which use the same variable names and length. Its item means line up with both neighbours (r = .96 and .88).
- Public waves 18, 24 and 28 have no `caseid`. Their own-wave YouGov IDs (`caseid_DART0049_W3`, `caseid_w9`, `caseid_DART0057_W3`) are used instead.
- Expert waves 29–30 have no response ID, so `resp_id` = `luthid`. Expert wave 30 has no timestamps, so `field_start` is set to 2026-10-01 from the instrument date.
- Public wave 28's first grid row was piped: "The judiciary / The Supreme Court / Lower courts is able to…". Answers are split across the three judiciary items using `limit_executive_power_text`.
- Expert wave 20 asked the battery in two random half-forms (`Q2_6_a_*`, `Q2_6_b_*`); these are combined. Expert wave 17 asked `rating_USA` under two slider defaults (`rusa_d50_now_1`, `rusa_dblank_now_1`); these are combined too.

## Docs

- `docs/codebook_public_w03-30.csv`, `docs/codebook_expert_w01-30.csv`: every variable with its label, wording, value codes, n, the waves it appears in, and the source variable in each wave
- `docs/blw_battery_crosswalk_w01-30.csv`: one row per source battery variable, giving its target, method (name / grid position / label), provenance, and label check
- `docs/blw_waves_w01-30.csv`: one row per survey × wave, with field dates, n, item counts, mean `rating_USA` and notes
- `build/qa_*.csv`, `build/build_log.txt`: check output from the last build (overwritten each run)
- `docs/source_variable_inventory/`: every variable in every source file, with storage type, n, label and values. Start here to add wave-specific items.

## Syntax

```
Rscript syntax/run_all.R > build/build_log.txt 2>&1   # about 1 minute; needs tidyverse, haven, lubridate
```

Run it from `blw/stacked/`. It reads the per-wave `.rds` files from the parent `blw/` folder, or from `raw/` in a standalone copy.

| Script | Does |
|---|---|
| `00_item_dictionary.R` | The 40 principles: keys, labels, wording, matching patterns |
| `01_helpers.R` | Recoders, value schemes (codes and labels for every variable), state table, questionnaire item orders |
| `02_build_stacked.R` | Reads each wave, builds the crosswalk, harmonizes core variables and batteries; writes `build/_intermediate.rds` |
| `03_checks.R` | Checks listed above |
| `04_label_and_save.R` | Labels, codebooks, wave table, crosswalk, long file; wave-suffixed `.rds`/`.dta` export |
| `05_download_raw.R` | Re-downloads the `.rds` files into `raw/` |
| `06_source_inventory.R` | Writes `docs/source_variable_inventory/` |

Adding a new wave:
1. Add it to `wave_files` in `02_build_stacked.R`.
2. If its battery variables are named by position, add a row to `battery_specs` in `01_helpers.R` with the order from its questionnaire.
3. Rerun `run_all.R` and read `build/qa_unmatched_values.csv`. New files appear with the new wave range; older versions stay put.

`build/` holds the intermediate file and QA output; it is safe to delete and is rewritten on every run.
