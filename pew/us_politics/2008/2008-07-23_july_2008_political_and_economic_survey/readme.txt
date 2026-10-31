PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
JULY 2008 POLITICAL AND ECONOMIC SURVEY
July 23-27, 2008
N=1,503


The racecmb variables were computed using the following syntax:

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

compute swing=99.
if q5=1 and q8>1 swing=1.
if q5=2 and q7>1 swing=2.
if q5a=1 or (q5=1 and q8=1) swing=3.
if q5a=2 or (q5=2 and q7=1) swing=4.
if q5a>2 swing=5.
if any(regicert,2,9) or any(regist,2,9) swing=999.
recode swing (999=sysmis).
var label swing "2008 Vote Preference".
value label swing 
1 "McCAIN - no chance Obama" 
2 "OBAMA - no chance McCain" 
3 "McCAIN - Lean McCain Chance Obama" 
4 "OBAMA - Lean Obama Chance McCain" 
5 "Undecided".
	 
