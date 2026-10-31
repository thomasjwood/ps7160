PEW RESEARCH CENTER FOR SOCIAL& DEMOGRAPHIC TRENDS

April 2009 Fertility Survey (April 2-8, 2009)

Interviews were conducted in English.

National sample: N =1,003

***Note: The WEIGHT variable is weighting variable intended for use on all questions.

***Note: Questions about Luxury and Necessity were also asked in this survey.


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



*****************************************************************************.
*** Syntax for other created variables
******************************************************************************.

******************.
***nomore/nmore2. 
******************.

compute nomore=2.
if (SEX=2 AND range(AGE,18,49) AND range(Q7,1,11) AND Q11=2) nomore=1.
if (SEX=2 AND range(AGE,50,97) AND range(Q7,1,11)) nomore=1.
if (SEX=1 AND range(AGE,18,59) AND range(Q7,1,11) AND Q11=2) nomore=1. 
if (SEX=1 AND range(AGE,60,97) AND range(Q7,1,11)) nomore=1.
formats nomore (f1.0).
var label nomore "Doesn't plan to have any more children - based off of Q7, Q11, gender, and age".
value label nomore 1 "True" 2 "False".
fre nomore.


*****************.

compute nomore2=2.
if (SEX=2 AND range(AGE,18,49) AND Q13=2) nomore2=1.
if (SEX=2 AND range(AGE,50,97) AND Q5=2 AND Q6=2) nomore2=1.
if (SEX=1 AND range(AGE,18,59) AND Q13=2) nomore2=1. 
if (SEX=1 AND range(AGE,60,97) AND Q5=2 AND Q6=2) nomore2=1.
formats nomore2 (f1.0).
var label nomore2 "Doesn't plan to have any more children - based off of Q5, Q6, Q13, gender, and age".
value label nomore2 1 "True" 2 "False".
fre nomore2.
