PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
LATE OCTOBER 2008 POLITICAL SURVEY
October 23-26, 2008
N=1,500

This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also contain a landline phone. 

The dataset contains three weight variables, which can be used to compare the combined landline and 
cell phone sample with the landline sample by itself and with the landline sample combined with the cell-only households.

Weight Name: WEIGHT
Description: This is the weight for the combined sample of all landline and
cell phone interviews. This weight is used for all analysis in the 9-18 and 9-24 reports.

Weight Name: LLWEIGHT
Description: This weight is applied to the landline RDD sample only. Interviews
conducted by cellphone are not given a weight and are excluded
from analysis when this weight is used.

Weight Name: COWEIGHT
Description: This is the weight for the Landline RDD sample and the 
cell-only cases combined. Cases from the Cell Phone RDD sample that 
reported having a landline phone are not given a weight and are excluded from
analysis when this weight is used.

Two additional weights related to likely voters (lvwt67 and unlvwt67) are described below.

*********************************************************************************************

Regfinal is the final voter registration variable for this survey. The regfinal variable was computed using the following syntax:
compute regfinal=1.
if (regist=9) regfinal=2.
if (regist=2 and sameday=2) regfinal=2.
if (regicert>1) regfinal=2.
if (planreg>1) regfinal=2.
var lab regfinal 'Final Registered Voter Variable'.
val lab regfinal 1 ‘Registered/Plan to/N.Dakota’ 2 ‘Not registered’.

*********************************************************************************************

The sameday variable indicates which respondents are in states that allow voters to register the day of the election. 
The sameday variable was computed using the following syntax:
recode state (16=1) (19=1) (23=1) (27=1) (30=1) (33=1) (55=1) (56=1) (38=3) (else=2) into sameday.
var lab sameday 'States which allow same day registration'.
val lab sameday 1 ‘Same day registration’ 2 ‘Pre-registration required’ 3 ‘North Dakota’.

*********************************************************************************************

The ballot variable indicates which candidates respondents were read as part of the horserace sequence based on who appears on the ballot in their state.
recode state (1,2,4,5,6,8,10,12,15,16,17,19,20,21,24,25,26,27,28,29,30,31,32,33,34,35,36,38,39,41,42,44,45,46,47,49,50,51,53,55,56=1) 
(40=2) (13,18,37,48=3) (9,11,22,23,54=4) into ballot.
var lab ballot 'Candidates on ballot for horserace'.
val lab ballot 1 'All candidates on ballot' 2 'No Nader or Barr on ballot' 3 'Barr on ballot, Nader not' 4 'Nader on ballot, Barr not'.
var lab ballot 'Candidates on ballot for horserace'.
val lab ballot 1 'All candidates on ballot'
               2 'No Nader or Barr on ballot'
 	       3 'Barr on ballot, Nader not'
	       4 'Nader on ballot, Barr not'.

*********************************************************************************************

The racecmb variable was computed using the following syntax:

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

*********************************************************************************************

The SWING variable was computed using the following syntax:
Swing Voter Syntax 

if (q3=1 or q3_1=1 or q3_2=1 or q3_3=1) and (q6>1) swing=1.
if (q3=2 or q3_1=2 or q3_2=2 or q3_3=2) and (q5>1) swing=2.
if (q3_1=3 or q3_2=3) and (q5>1 and q6>1) swing=3.
if (q3_1=4 or q3_3=4) and (q5>1 and q6>1) swing=4.
if (q3a=1 or q3a_1=1 or q3a_2=1 or q3a_3=1) or ((q3=1 or q3_1=1 or q3_2=1 or q3_3=1) and (q6=1)) swing=5.
if (q3a=2 or q3a_1=2 or q3a_2=2 or q3a_3=2) or ((q3=2 or q3_1=2 or q3_2=2 or q3_3=2) and (q5=1)) swing=6.
if (q3a_1=3 or q3a_2=3) or ((q3_1=3 or q3_2=3) and (q5=1 or q6=1)) swing=7. 
if (q3a_1=4 or q3a_3=4) or ((q3_1=4 or q3_3=4) and (q5=1 or q6=1)) swing=8. 
if (q3a>4 or q3a_1>4 or q3a_2>4 or q3a_3>4) swing=9. 
var lab swing '2008 Vote Preference'.
val lab swing 1 'MCCAIN –no chance Obama'
              2 'OBAMA - no chance McCain'
	      3 'Barr - no chance Other'
	      4 'Nader - no chance Other'
              5 'MCCAIN - Lean McCain Chance Obama'
              6 'OBAMA - Lean Obama Chance McCain'
	      7 'BARR - Lean Barr Chance Other'
	      8 'NADER - Lean Nader Chance Other'
	      9 'Other/Undecided'.

*********************************************************************************************

The horserace variable (Q3horse) was computed using the following syntax:

if ((q3=1 or q3_1=1 or q3_2=1 or q3_3=1) or (q3a=1 or q3a_1=1 or q3a_2=1 or q3a_3=1)) q3horse=1.
if ((q3=2 or q3_1=2 or q3_2=2 or q3_3=2) or (q3a=2 or q3a_1=2 or q3a_2=2 or q3a_3=2)) q3horse=2.
if ((q3_1=3 or q3_2=3) or (q3a_1=3 or q3a_2=3)) q3horse=3.
if ((q3_1=4 or q3_3=4) or (q3a_1=4 or q3a_3=4)) q3horse=4.
if (q3a=5 or q3a_1=5 or q3a_2=5 or q3a_3=5) q3horse=5.
if (q3a=9 or q3a_1=9 or q3a_2=9 or q3a_3=9) q3horse=9.
Val lab q3horse ‘Horserace’
	      1 'McCain/lean McCain'
              2 'Obama/lean Obama'
              3 'Barr/lean Barr'
              4 'Nader/lean Nader'
              5 'Other-refused to lean'
              9 'DK-refused to lean’.

*********************************************************************************************

The BATTLE variable was computed using the following syntax:


recode zstate (1,2,4,5,13,16,20,21,22,28,30,31,38,40,45,46,47,48,49,54,56=1)
(6,9,10,11,15,17,23,24,25,34,36,41,44,50,53=2) (8,12,18,19,26,27,29,32,33,35,37,39,42,51,55=3) into battle.
var label battle 'Red, Blue & Battle'.
val label battle 1'Republican states' 2 'Democratic states' 3 'Battleground states'.

*********************************************************************************************

The likely voter scale is computed using the following variables:

****** LVS variables ***

recode thought (1 thru 2=1) (else=0) into lvs1. 
recode oftvote (1 thru 2=1) (else=0) into lvs2.
recode pvote04a (1=1) (else=0) into lvs3.
recode precinct (1=1) (else=0) into lvs4.
recode scale10 (9 thru 10=1) (else=0) into lvs5.
recode q1 (1 thru 2=1) (else=0) into lvs6.
recode plan3 (1=1) (else=0) into lvs7.
recode where (1=1) (else=0) into lvs9.
if plan2=1 lvs9=1.
recode q2 (1=1) (else=0) into lvs10.
compute lvstemp=lvs1+lvs2+lvs3+lvs4+lvs5+lvs6+lvs7lvs9+lvs10.

LVS is then adjusted, as follows:

COMPUTE lvs=lvstemp.
if racecmb=2 lvs=lvstemp+.5.
if age<20 lvs=lvstemp+1.5.
if age ge 20 and age le 25 lvs=lvstemp+1.
if age ge 26 and age < 30 lvs=lvstemp+.5.
if regfinal > 1 lvs=0.
if plan1=3 lvs=0.
if plan1=2 lvs=9.
if lvs > 9 lvs=9.
var label lvs '9-point likely voter scale'.
exe.

*LIKELY VOTER WEIGHT*

A weight for likely Voters is computed based on the likely voter scale 
(predicting 62% turnout--using a 67% cutoff for the scale).

**This weight (lvswt67) should be used when analyzing likely voters**.

if (lvs<6) lvswt67=0.
if (lvs=6) lvswt67=weight*.0536.
if (lvs>6) lvswt67=weight.
weight by lvswt67.
var label lvswt67 'weight for likely voter analysis'.

*UNLIKELY VOTER WEIGHT*

This unlikely voter weight (unlvwt67) is only used in comparison with likely voters.
(this includes all those not considered likely voters--including non registered).

if (lvs>6) unlvwt67=0.
if (lvs=6) unlvwt67=weight*.9464.
if (lvs<6) unlvwt67=weight.
weight by unlvwt67.
var label unlvwt67 'weight for unlikely voters'.


For additional information on Pew's likely voter scale, see:

http://people-press.org/methodology/election/#1



