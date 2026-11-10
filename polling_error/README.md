# Polling error in U.S. elections, 1998-2026

Poll-level accuracy data on FiveThirtyEight's method: every poll whose median
field date falls in the final 21 days before a presidential primary or a
presidential, Senate, House (district or generic ballot) or governor general
election, scored against the top two finishers.

- `polling_error_polls_1998_2026.csv` / `.rds`: one row per poll (12,756 polls). Columns in `codebook.csv`.
- `polling_error_by_cycle_1998_2026.csv`: weighted averages of error and bias by cycle, by race type and for all races.
- `hand_results.csv`: results entered by hand (from Wikipedia) for contests the NYT feeds lack: three 2024 primaries, four House specials, the 2023 Kentucky and Mississippi governor races.
- `polling error dataset 1998-2026.R` (with `polling error helpers.R`) builds the data; `polling error 1998-2026.R` draws the two-panel figure. Paths are those of the author's election analysis project.
- `raw/`: 538's 2023 raw-polls release and the NYT polls files as downloaded on Nov. 9, 2026.

## Method

- error = |poll margin - actual margin| between the top two finishers.
- bias = poll margin - actual margin, Democrat minus Republican, only where a Democrat and a Republican finished first and second. Positive = polls overstated the Democrat (Republicans underrated).
- Cycles pool the odd year with the following even year.
- Weights: 1 / sqrt(number of polls by that pollster), counted within cycle x race type for the by-type averages and within cycle for the all-races average. This reproduces 538's published table (Rakich, "The Polls Were Historically Accurate In 2022," Mar. 10, 2023) to the decimal in 12 of 13 cycles.
- 2024 primaries follow 538's rules: New Hampshire polls before Iowa and other states' polls before New Hampshire are dropped, as are polls in which a candidate polling 15%+ (or several totalling 25%+) had dropped out by election day.

## Sources

- 1998-2022: 538's `raw-polls.csv`, 2023 release (github.com/fivethirtyeight/data, `pollster-ratings/2023`), used as published.
- 2023-24 polls: 538's polls pages as archived in this repo (`538_polls/`). Results: NYT 2024 results (general), NYT results feeds (2024 primaries), `hand_results.csv`.
- 2025-26 polls: the NYT's polls files (nytimes.com/newsgraphics/polls). Results: NYT 2026 results as of Nov. 8, 2026 (still being counted, so 2026 is preliminary), NYT 2025 results feeds (Virginia, New Jersey governor), `hand_results.csv`.

## Not covered

- 11 primary polls from 2024 Super Tuesday states with no NYT results feed (CO, ME, MA, MN, TN, VA), and three single general-election polls, are unscored.
- 538's banned-pollster list is not applied to 2023-26.
- Presidential polls of single congressional districts (ME-2, NE-2) are dropped.
