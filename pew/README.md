# Pew Research Center datasets, 1999-2013

232 public-release studies, each in `pew/<unit>/<year>/<field start>_<title>/` with Pew's own files (SPSS data, questionnaire, topline, methodology, readme). `catalog.csv` lists every study: field dates, title, sample size (`n`), variables, data files and weight variables; `source_folder` is the name of Pew's download.

| unit | studies | years | what |
|---|---|---|---|
| `us_politics` | 54 | 1999-2012 | People & the Press political surveys: monthly political, knowledge, typology, values, media and post-election surveys |
| `us_politics_weekly_omnibus` | 119 | 2009-2013 | News Interest Index weekly omnibus surveys (about 1,000 adults, Thursday-Sunday) |
| `internet` | 21 | 2008-2011 | Internet & American Life Project |
| `social_trends` | 13 | 2009-2011 | Social & Demographic Trends |
| `religion` | 8 | 2008-2011 | Forum on Religion & Public Life (U.S. surveys) |
| `journalism` | 7 | 2007-2011 | Project for Excellence in Journalism: News Coverage Index content data and media surveys |
| `hispanic` | 5 | 2008-2011 | Pew Hispanic Center National Surveys of Latinos |
| `global_attitudes` | 5 | 2008-2011 | Global Attitudes Project (multi-country; each includes a U.S. sample of about 1,000) |

Notes:
- Read with `haven::read_sav()`; most surveys use `weight` (multi-part studies have several weights; see `catalog.csv`).
- Weekly omnibus surveys run from June 2009 to June 2013, with nearly every week of 2010-2012.
- News Coverage Index folders are content-analysis data (one row per story), not surveys.
- Studies without U.S. respondents were left out (the 2008-09 sub-Saharan Africa religion survey).
- Field dates come from each study's readme or questionnaire; Internet Project releases give only the month.
