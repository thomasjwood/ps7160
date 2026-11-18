# PS 7160 survey data

Data and syntax for PS 7160 (OSU). Files are read straight from GitHub, e.g.
`readRDS(url("https://github.com/thomasjwood/ps7160/raw/refs/heads/master/anes/anes_timeseries_cdf_spss_20251211.rds"))`.
Raw-URL reads only work for files under 100 MB.

## Election studies and panels

| folder | what | coverage |
|---|---|---|
| `anes` | ANES cumulative file, 2024 time series, 2016-2020-2024 panel merged file (May 2026 release, .sav and .rds), 2018 pilot, 2012 turnout extract | 1948-2024 |
| `cces` | CES common content 2018, 2020, 2022, 2024 (validated vote), older cumulative files, and the CES cumulative file 2006-2025 (`ces_cumulative_2006_2025.rds`) with guides | 2006-2025 |
| `cmps` | Collaborative Multiracial Post-election Survey | 2008-2020 |
| `vsg` | Democracy Fund VOTER Survey panel | 2011-2020 |
| `ns_19_21` | Nationscape weekly files | Jul 2019-Jan 2021 |
| `uas2020` | Understanding America Study 2020 election waves (Stata) | 2020 |
| `spae` | Survey of the Performance of American Elections | 2007-2024 |
| `cses` | Comparative Study of Electoral Systems modules 5-6 and IMD | 1996-2021 |
| `wev` | West European Voter file | 1961-2020 |
| `exit_polls` | Election-day polls: CBS/NYT, ABC, NBC, LAT, VNS, NEP, Edison 2020/2022 (national + states), AP VoteCast 2018-2024, harmonized midterm file, NORC Civic Health 2026 | 1972-2026 |
| `cast_vote_records` | County cast-vote-record files | 2020 |
| `cps_voting` | CPS November 2024 Voting and Registration Supplement: all basic and supplement items (`cps_nov2024_voting_supplement.rds`), fixed-width layout, Census documentation, prep script. Weights divided by 10,000; nonresponse coded -1/-2/-3/-9 as in the raw file | 2024 |

## Election returns and context

| folder | what | coverage |
|---|---|---|
| `countyvote` | MIT county presidential returns; long county file | 1868-2024 |
| `statevote` | MIT state presidential returns (1976-2020 and 1976-2024 files) and Senate statewide returns 1976-2024, with codebooks | 1976-2024 |
| `housevote` | MIT House returns | 1976-2024 |
| `election_analysis` | election-context files used in class | 2018-2026 |
| `cmag_pres` | Wesleyan/CMAG presidential advertising | 2000-2020 |

## Polls and poll aggregates

| folder | what | coverage |
|---|---|---|
| `538_polls` | FiveThirtyEight poll files as archived at shutdown | to Mar 2025 |
| `538_2022`, `538_2022_w7` | 538/Ipsos 2022 panel waves (Roper) | 2022 |
| `cleaned_polls` | cleaned presidential and state Senate polls | 2016-2026 |
| `polling_error` | poll-level accuracy data on 538's method | 1998-2026 |
| `nyt_siena` | NYT Upshot/Siena College microdata from Roper: 94 House-district polls (Oct-Nov 2018) and 25 state and national polls (Sep-Oct 2020), plus the 2019 Commonwealth Fund/NYT/Harvard health survey. One labelled rds per Roper ID, the original .por, the Roper codebook PDF, and `catalog.csv` (ID, field dates, title) | 2018-2020 |
| `nyt_sienna_xtab_2024` | NYT/Siena crosstabs | 2023-2024 |
| `monmouth` | Monmouth University polls (Roper) | |
| `yg_tracker` | YouGov tracker | Jan 2009-Jun 2023 |

## Media and university polls (microdata)

| folder | what | coverage |
|---|---|---|
| `abc_wapo` | ABC News / Washington Post | 1996-2016 |
| `cbs` | CBS News / NYT | 2014-2016 |
| `fnc` | Fox News | 2011-2012 |
| `ap_norc`, `apnorc_long` | AP-NORC polls and VoteCast; stacked 2014-2025 file | 2011-2026 |
| `reuters_dnr` | Reuters/Ipsos daily files | 2020-2026 |
| `ampol_pulse` | American Political Pulse (Bright Line Watch / Polarization Research Lab) | Sep 2022-Sep 2026 |
| `blw` | Bright Line Watch public and expert waves | 2017- |
| `calpoll_igs` | Berkeley IGS California poll | 2012-2024 |
| `ppic` | PPIC Statewide Survey | 1998-2026 |
| `texas_tribune` | UT/Texas Tribune poll | 2008-2026 |
| `msu_soss` | Michigan State of the State Survey | 1994-2025 |
| `rutgers_eagleton` | Rutgers-Eagleton New Jersey polls | 1971-2014 |
| `uarkansas` | Arkansas Poll | 1999-2023 |
| `slu_yg` | SLU/YouGov Missouri poll | 2020-2025 |
| `quest_peoples_voice` | People's Voice Survey (multi-country) | 2024 |

## Pew Research Center

| folder | what | coverage |
|---|---|---|
| `pew` | 232 phone-era studies by unit and year; `pew/catalog.csv` | 1999-2013 |
| `atp` | American Trends Panel waves (SPSS, toplines) | W1-W169 |
| `atp_long` | stacked ATP file in three parts plus metadata | W1-W155 |
| `atp_theme` | national-problems items stacked | |
| `gpss` | Gallup Poll Social Series files | 1973-2026 |

## Gallup

| folder | what | coverage |
|---|---|---|
| `gallup_daily_08_19` | Gallup US Daily | 2008-2019 |
| `gallup_wellbeing` | Gallup Panel wellbeing monthlies | 2020-2025 |
| `gallup_wp` | Gallup World Poll by country; `wp_items.csv`; high-income stacked file (`.qs`) | 2006-2021 |

## Social, religion, economics, international

| folder | what | coverage |
|---|---|---|
| `prri` | PRRI surveys | 2010-2024 |
| `baylor_religion` | Baylor Religion Survey waves I-VI | 2005-2021 |
| `relig_freed_ind` | Religious Freedom Index | 2019-2024 |
| `springtide` | Springtide young people surveys | 2022-2024 |
| `byu_afs` | American Family Survey | 2015-2025 |
| `scoal` | Survey Center on American Life / AEI American Perspectives Survey | 2019-2024 |
| `chapman_soaf` | Chapman Survey of American Fears | 2014-2024 |
| `gen_forward` | GenForward | 2016-2022 |
| `knight_foundation` | Knight/Gallup trust in media and panels | 2017-2024 |
| `more_in_common`, `nche`, `reagan_institute`, `making_meaning`, `cms` | single studies | |
| `kff_stacked` | KFF tracking polls stacked by series | |
| `ccam` | Climate Change in the American Mind | 2008-2025 |
| `fire_nsi`, `fire_student` | FIRE National Speech Index; college student surveys | 2020-2026 |
| `sca` | Michigan Surveys of Consumers microdata | 1978-2026 |
| `fedres_scf` | Survey of Consumer Finances full public data (five implicates, labelled) for 2022 and 2025; 2025 summary extract | 2022-2025 |
| `fanniemae_hspi` | Fannie Mae National Housing Survey | 2016-2017 |
| `atus` | American Time Use Survey multi-year respondent, activity summary, roster and activity (episode-level, `atusact_0325.rds`) files (2003-2024 and 2003-2025 releases) | 2003-2025 |
| `oecd_trust` | OECD Trust Survey | 2021-2025 |
| `wvs` | World Values Survey wave 7 and time series | 1981-2022 |
| `ispp` | ISSP module ZA4747 | |
| `gss` | General Social Survey cumulative file, release 3a (July 2026), with codebook and release notes; recommended weight `wtssps` | 1972-2024 |

## Course materials

| folder | what |
|---|---|
| `class_examples` | small datasets used in lectures and problem sets (polls_16, polls_20, MRP inputs, Lucid 2016, football table, Butler et al. replication, DFP COVID economy, GSS framing extract) |
| `pdf_pen` | readings |
| `docs` | CV |

## Files moved from the repo root (Nov 2026)

| old root path | new path |
|---|---|
| `anes_*` (6 files) | `anes/` |
| `cces18_common_vv.RDS`, `cces_06_17.RDS`, `cces_08_12_16_20.rds`, `ces_20_1.rds` | `cces/` |
| `abc1980/82/84`, `cbs1972/76/78`, `cbsnyt1980/82`, `c1984natelec`, `lat1984090`, `nbc1984`, `nbcap1982` (.por + Roper .pdf) | `exit_polls/` |
| `ATP W162/W163 Questionnaire.pdf` | `atp/` (the `.sav` files were duplicates of `atp/` copies and were removed) |
| `campus_self_exp_(fire_2020)*` | `fire_student/` |
| `gallup_world_hiinc_06_21.qs` | `gallup_wp/` |
| `oecd_trust_in_ovt_21_23.rds` | `oecd_trust/` |
| `polls_16.RDS`, `polls_20.rds`, `mrp_*`, `lucid_pres_16.rds`, `state_analysis_data.csv`, `football_table.rds`, `five_hundred_k.qs`, `real_solutions_fake_news.rds`, `gss_framing_data.rds`, `butler et al*.RDS`, `cleaned_dfp_covid_econ_2021-02-24.rds`, `roper_31120363_long.rds` | `class_examples/` |
| `econ and presidential vote.pdf` | `pdf_pen/` |
| `thomas_wood__cv.pdf` | `docs/` |
| `reuters_dnr_2022.rds`, `president_primary_polls_historical.csv` | removed (identical to `reuters_dnr/` and `538_polls/` copies) |
