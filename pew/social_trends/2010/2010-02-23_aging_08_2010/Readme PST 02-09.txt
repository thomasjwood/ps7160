PEW RESEARCH CENTER FOR SOCIAL& DEMOGRAPHIC TRENDS

Feb 2009 Aging Survey (Feb23 - March23, 2009)

Interviews were conducted in English and Spanish.

National sample: N =2,969

***Note: The WEIGHT variable is weighting variable intended for use on all questions.


***Race/ethnicity recode:

Ceated RACECMB as follows and included the variable in dataset:
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

Created HISPX as follows and included the variable in dataset:
if hisp2=1 or hisp3=1 hispx=1.
if hisp2=2 or hisp3=2 hispx=2.
if hisp2=9 or hisp3=9 hispx=9.
variable label hispx “Hispanic”.
value label hispx
1 “Hispanic”
2 “Not Hispanic”
9 “Don’t know/Refused (VOL.)”.

Created RACETHN as follows and included variable in dataset:
if racecmb=1 and hispx ge 2 racethn=1.
if racecmb=2 and hispx ge 2 racethn=2.
if (racecmb ge 2) and (racecmb le 5) and (hispx ge 2) racethn=4.
if racecmb=9 racethn=9.
if hispx=1 racethn=3.
variable label racethn “Race-Ethnicity”.
value label racethn
1 “White non-Hispanic”
2 “Black non-Hispanic”
3 “Hispanic”
4 “Other”
9 “Don’t know/Refused (VOL.)”.



*****************************************************************************.
*** Syntax for other Created Variables
******************************************************************************.

******************.
***AGEGRP.
******************.

compute agegrp=0.
if range(q8,18,64) or q8a=1 agegrp=1.
if range(q8,65,97) or q8a=2 agegrp=2.
if q8a=9 agegrp=9.
formats agegrp (f1.0).
var label agegrp "Age Groups".
value labe agegrp
1 "18 to 64"
2 "65+"
9 "Undesignated".
fre agegrp.


*****************************.
***AGEDIF / AGEDIF2.
*****************************.

compute agedif=9999.
if q9=3 agedif=0.
if any(q9,1,2) agedif=q10-q8.
if q8=99 or q10=99 or q9=9 agedif=999.
var labels agedif "AgeDif. Difference in years between FELT AGE (Q10) and ACTUAL AGE (Q8)".
value labels agedif
	0 "Feel about your actual age"
	999 "Don't know/Refused".
formats agedif (f8.0).
fre agedif.

recode agedif (0=0) (999=9) (-998 thru -20=1) (-19 thru -10=2) (-9 thru -1=3) (1 thru 9=4) (10 thru 19=5) (20 thru 998=6) into agedif2.
var labels agedif2 "AgeDif2. Collapsed AGEDIF variable".
value labels agedif2
	0 "Feel about your actual age"
	1 "20 or more years younger"
	2 "10-19 years younger"
	3 "1-9 years younger"
	4 "1-9 years older"
	5 "10-19 years older"
	6 "20 or more years older"
	9 "Don't know/Refused".
formats agedif2 (f2.0).
fre agedif2.
cro agedif by agedif2.