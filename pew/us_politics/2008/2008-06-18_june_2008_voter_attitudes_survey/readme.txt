PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
JUNE 2008 VOTER ATTITUDES SURVEY
June 18-29, 2008
N=2,004

As part of an experiment, respondents who said they planned to register to vote (Q4=1) were asked questions that are typically asked of registered voters only. Published results are based on registered voters and exclude those who plan to register. This dataset has been modified to reflect the published results. Please contact the center to obtain the complete dataset.  

**********************************************************************************************

This dataset includes an oversample of 200 respondents age 18-29 for a total of 473 respondents in this age range. The 200 oversample respondents can be identified by qs1a.

**********************************************************************************************

This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. Cell phone interviews include households that are cell-only as well as those that also contain a landline phone. 

The dataset contains three weight variables, which can be used to compare the combined landline and cell phone sample with the landline sample by itself and with the landline sample combined with the cell-only households.


Weight Name: WEIGHT
Description: This is the weight for the combined sample of all landline and
cell phone interviews. This weight is used for all analysis in the July 1 and July 10 reports.

Weight Name: LLWEIGHT
Description: This weight is applied to the landline RDD sample only. Interviews
conducted by cellphone are not given a weight and are excluded
from analysis when this weight is used.

Weight Name: COWEIGHT
Description: This is the weight for the Landline RDD sample and the 
cell-only cases combined. Cases from the Cell Phone RDD sample that 
reported having a landline phone are not given a weight and are excluded from
analysis when this weight is used.

*********************************************************************************************

The racecmb and racethn variables were computed using the following syntax:

recode race1 (1=1) (2=2) (3=3) (4=5) (9=9) into racecmb.
if race2>0 racecmb=4.
var label racecmb "Combining Race".
value label RACEcmb
1 "White"
2 "Black or African-American"
3 "Asian or Asian-American"
4 "Mixed Race"
5 "Or some other race"
9 "Don't know/Refused (VOL.)".

 
recode race1 (1=1) (2=2) (3 thru 4=4) (9=9) into racethn.
if race2>0 racethn=4.
if hisp1=1 racethn=3.
var label racethn "Race/Ethnicity".
value label RACEthn
1 "White, non-Hisp"
2 "Black, non-Hisp"
3 "Hispanic"
4 "Other"
9 "Don't know/Refused (VOL.)".

*********************************************************************************************

The SWING variable was computed using the following syntax:

if (q5=1) and (q7>1) swing=1.
if (q5=2) and (q6>1) swing=2.
if (q5a=1 or (q5=1 and q7=1)) swing=3.
if (q5a=2 or (q5=2 and q6=1)) swing=4.
if (q5a>2) swing=5.
var lab swing '2008 Vote Preference'.
val lab swing 
1 'MCCAIN –no chance Obama'
2 'OBAMA - no chance McCain'
3 'MCCAIN - Lean McCain Chance Obama'
4 'OBAMA - Lean Obama Chance McCain'
5 'UNDECIDED'.
	 
