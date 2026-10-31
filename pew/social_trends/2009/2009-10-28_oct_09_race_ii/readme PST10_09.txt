PEW SOCIAL AND DEMOGRAPHIC TRENDS AND PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
OCTOBER 2009 RACIAL ATTITUDES POLL
OCTOBER 28-NOVEMBER 30, 2009 
N=2,884
(BLACK NON-HISPANIC N=812, WHITE NON-HISPANIC N=1447, HISPANIC N=376)


This dataset includes landline interviews conducted using a disporoportionately-stratified RDD landline sample and 
cell phone interviews conducted using an disproportionately-stratified RDD sample of cell phone numbers. 
It also includes both cell phone and landline interviews using a callback sample of African Americans.

Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 

Interviews were conducted in English or Spanish.

***Note: WEIGHT is the weight for the combined sample of all landline and cell phone interviews and should be used for all analysis of this data. 

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
