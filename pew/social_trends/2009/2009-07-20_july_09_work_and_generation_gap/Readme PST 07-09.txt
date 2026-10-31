PEW RESEARCH CENTER FOR SOCIAL& DEMOGRAPHIC TRENDS

July 2009 Work/Generation Gap Survey (July 20- August 2, 2009)

Interviews were conducted in English and Spanish.

National sample: N =1,815

***Note: The WEIGHT variable is weighting variable intended for use on all questions.

***Note: Questions about Woodstock were also asked in this survey.


***Race/ethnicity recode:

Created RACECMB as follows and included the variable in dataset:
recode race_1 (1=1) (2=2) (3=3) (4=5) (9=9) into racecmb.
if race_2>0 racecmb=4.
variable label racecmb "Combining Race".
value label RACEcmb
1 "White"
2 "Black or African-American"
3 "Asian or Asian-American"
4 "Mixed Race"
5 "Or some other race"
9 "Don't know/Refused (VOL.)".

Created RACETHN for a combined Race/Ethnicity variable:

variable label racethn “Race-Ethnicity”.

1 “White non-Hispanic”
2 “Black non-Hispanic”
3 “Hispanic”
4 “Other non-Hispanic”
9 “Don’t know/Refused (VOL.)”.

