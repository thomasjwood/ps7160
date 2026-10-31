PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
LATE OCTOBER POLITICAL SURVEY
October 24-28, 2012
N=2,008

***************************************************************************************************************************

This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 
The dataset contains several weight variables. 

WEIGHT is the weight for the combined sample of all landline and cell phone interviews. 
Data for all Pew Research Center reports are analyzed using this weight.

Two other weights can be used to compare the combined sample with the landline sample by itself 
and with the landline sample combined with the cell-only households.

LLWEIGHT is for analysis of the landline RDD sample only. Interviews conducted by cellphone are not 
given a weight and are excluded from analysis when this weight is used.

COWEIGHT is for analysis of the combined landline RDD sample and the cell-only cases. 
Cases from the cell phone RDD sample that reported having a landline phone are not given 
a weight and are excluded from analysis when this weight is used.

Two additional weights related to likely voters lvs9wt64 and unlvs9wt64 are described below with the likely voter syntax.

***************************************************************************************************************************

Beginning in the Fall of 2008, the Pew Research Center started using respondents’ self-reported zip code as  
the basis for geographic variables such as region, state and county. We do this because the error rate in the original 
geographic information associated with the sample is quite high, especially for respondents from the cell phone sample. 

For respondents who do not provide a zip code or for those we cannot match, we use the sample geographic information. 
We continue to include the original sample geographic variables in the datasets (these variables are preceded by an ‘s’) 
for archival purposes only.

To protect the privacy of respondents, telephone numbers, county of residence and zip code have been removed from the data file.

***************************************************************************************************************************

Releases from this survey:

October 29, 2012 "Presidential Race Dead Even; Romney Maintains Turnout Edge"
http://www.people-press.org/2012/10/29/presidential-race-dead-even-romney-maintains-turnout-edge/

October 31, 2012 "In Deadlocked Race, Neither Side Has Ground Game Advantage"
http://www.people-press.org/2012/10/31/in-deadlocked-race-neither-side-has-ground-game-advantage/

November 1, 2012 "Nonvoters: Who They Are,What They Think"
http://www.people-press.org/2012/11/01/nonvoters-who-they-are-what-they-think/
***************************************************************************************************************************

Please note, REGFINAL is the final variable used in all analysis of registered  voters.

SYNTAX

**********SYNTAX FOR LIKELY VOTER SCALE**********.
**RECODE LVS MEASURES**.
recode THOUGHT (1 thru 2=1) (else=0) into XTHOUGHT.
recode CAMPNII (1 thru 2=1) (else=0) into XCAMPNII.
recode FOLGOV (1 thru 2=1) (else=0) into XFOLGOV.
recode OFTVOTE (1 thru 2=1) (else=0) into XOFTVOTE.
recode PRECINCT (1=1) (else=0) into XPRECINCT.
recode PVOTE08A (1=1) (else=0) into XPVOTE08.
*Note: kept XPLANTO2 name so did not have to change in syntax below.
recode PLAN3 (1=1) (else=0) into XPLANTO2.
recode SCALE10 (9 thru 10=1) (else=0) into XSCALE10.
recode WHERE (1,3,4=1) (else=0) into XWHERE.

weight by weight.
cro XTHOUGHT XOFTVOTE XPVOTE08 XPRECINCT XSCALE10 XCAMPNII XPLANTO2 XFOLGOV PLAN1 XWHERE by q5horse/cell row.
weight by weight.
cro XTHOUGHT XOFTVOTE XPLANTO2 XPVOTE08 XPRECINCT XSCALE10 XCAMPNII XFOLGOV XWHERE PLAN1 by q5horse /cell col.

fre XTHOUGHT XOFTVOTE XPVOTE08 XPRECINCT XSCALE10 XCAMPNII XPLANTO2 XFOLGOV PLAN1 XWHERE.


**COMPUTE 9-POINT SCALE**.
*18-21 one point instead of pvote; additional .5 for 18-24. 
*Those who are not registered or don't plan to vote are coded to the bottom. 
*Those who already voted are coded to the top.
if age ge 22 lvs9=XTHOUGHT+XCAMPNII+XOFTVOTE+XPRECINCT+XPLANTO2+XSCALE10+XPVOTE08+XFOLGOV+XWHERE.
if age le 21 lvs9=XTHOUGHT+XCAMPNII+XOFTVOTE+XPRECINCT+XPLANTO2+XSCALE10+XFOLGOV+XWHERE+1.
if age le 24 lvs9=lvs9+.5.
if lvs9>9 lvs9=9.
if plan1=3 lvs9=0.
if regfinal=2 lvs9=0.
if (plan1=2 and early1<4) lvs9=9.
var lab lvs9 "9-point likely voter scale, replacement point for < 21. additional .5 for <24".

weight by weight.
fre lvs9.

*Likely/Unlikely voter weights - using a 64% cutpoint based on turnout estimate of 59%*.
weight off.
if lvs9 ge 6.5 lvs9wt64=weight.
if lvs9=6 lvs9wt64=weight*0.104335718.
if lvs9<6 lvs9wt64=0.

**unlikely voter weight**.
weight off.
if lvs9 ge 6.5 unlvs9wt64=0.
if lvs9=6 unlvs9wt64=weight*0.895664282.
if lvs9<6 unlvs9wt64=weight.


******** SYNTAX FOR HORSE RACE BASED ON REGISTERED VOTERS*************.
do if regfinal=1.
compute Q5horse=0.
if (q5=2 or q5a=2) q5horse=1.
if (q5=1 or q5a=1) q5horse=2.
If (q5=3 or q5a=3) q5horse=3.
If (q5=4 or q5a=4) q5horse=4.
if ((q5=5 and q5a ge 5) or q5a=5) q5horse=5.
if (q5 ge 8 and q5a ge 8) q5horse=9.
end if.
var lab q5horse ‘Presidential Horserace’.
val lab q5horse 1 'Obama/lean Obama' 2 'Romney/lean Romney' 3 'Johnson/lean Johnson'
4 'Stein/lean Stein’ 5 'Other-refused to lean' 9 'DK-refused to lean’.

******** SYNTAX FOR HORSE RACE BASED ON GENERAL PUBLIC*************.
compute horsegp=0.
if (q5=2 or q5a=2 or q8=2 or q8a=2) horsegp=1.
if (q5=1 or q5a=1 or q8=1 or q8a=1) horsegp=2.
if (q5horse=3 or q5horse=4 or q5horse=5) or ((q8=3) and q8a ge 3) or (q8a=3) horsegp=3.
if (q8a=9 or q5horse=9) horsegp=9.
end if.
var lab horsegp ‘Obama-Romney Horserace general public’.
val lab horsegp 1 'Obama/lean Obama' 2 'Romney/lean Romney' 3 'Other'
9 'DK-refused to lean’.



****SYNTAX FOR BATTLE GROUND STATES**********************.
recode state 
(1,2,4,5,13,16,18,20,21,22,28,29,30,31,38,40,45,46,47,48,49,54,56=1)
(6,9,10,11,15,17,23,24,25,26,27,34,35,36,41,42,44,50,53=2) 
(8,12,19,32,33,37,39,51,55=3) into battle.
var label battle 'Red, Blue & Battle'.
val label battle 1'Republican states' 2 'Democratic states' 3 'Battleground states'








