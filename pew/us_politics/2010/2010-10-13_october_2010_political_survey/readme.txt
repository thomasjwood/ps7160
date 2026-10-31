PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
OCTOBER 2010 POLITICAL SURVEY
OCTOBER 13-18, 2010 
TOTAL N=2,251

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

***************************************************************************************************************************

Beginning in the Fall of 2008, the Pew Research Center started using respondents’ self-reported zip code as  
the basis for geographic variables such as region, state and county. We do this because the error rate in the original 
geographic information associated with the sample is quite high, especially for respondents from the cell phone sample. 

For respondents who do not provide a zip code or for those we cannot match, we use the sample geographic information. 
We continue to include the original sample geographic variables in the datasets (these variables are preceded by an ‘s’) 
for archival purposes only.

To protect the privacy of respondents, telephone numbers, county of residence and zip code have been removed from the data file.

***************************************************************************************************************************

HISP3 and HISP4 were each asked of half of the sample.  HISPCMB combines these variables and is the full sample Hispanicity variable.

***************************************************************************************************************************

The generic ballot horse race variable (cheat) was computed using the following syntax:

do if regicert=1.
compute cheat=0.
if (q10=1 or q10a=1) cheat=1.
if (q10=2 or q10a =2) cheat=2.
if ((q10=3 and q10a ge 3) or q10a=3) cheat=3.
if (q10=9 and q10a=9) cheat=9.
end if.
var lab cheat 'Congressional trial heat combined with leaners'.
val lab cheat  1 “Rep/lean Rep” 2 “Dem/lean Dem' 3 'Other-lean other (VOL.)’ 9 'DK-no lean (VOL.)'.

***************************************************************************************************************************

SYNTAX FOR LIKELY VOTER SCALE

**FULL SEVEN-POINT LVS SCALE**.
recode THOUGHT (1 thru 2=1) (else=0) into XTHOUGHT.
recode OFTVOTE (1 thru 2=1) (else=0) into XOFTVOTE.
recode PRECINCT (1=1) (else=0) into XPRECINCT.
recode PLAN1 (1=1) (else=0) into XPLAN1.
recode SCALE10 (9 thru 10=1) (else=0) into XSCALE10.
recode PVOTE08A (1=1) (else=0) into XPVOTE08.
recode q6 (1 thru 2=1) (else=0) into XFOLGOV.

if age ge 20 lvs=XTHOUGHT+XOFTVOTE+XPRECINCT+XPLAN1+XSCALE10+XFOLGOV+XPVOTE08.
if age le 19 lvs=XTHOUGHT+XOFTVOTE+XPRECINCT+XPLAN1+XSCALE10+XFOLGOV+1.
if age le 21 lvs=lvs+1.
recode lvs (8=7).
if regicert>1 lvs=0.
if regist>1 lvs=0.
if plan1=2 lvs=7.
if plan1=3 lvs=0.

weight by weight.
freq lvs.
cros cheat by lvs /cel col.

if lvs=7 lvs50weight=weight.
if lvs=6 lvs50weight=weight*.8531014.
weight by lvs50weight.
freq cheat.
weight off.

var lab lvs "7-point likely voter scale".
var lab lvs50weight "Likely voter weight at 50% cutoff".


***************************************************************************************************************************

Competitive house districts were identified using ratings for each district from early October by Congressional Quarterly, 
The Cook Political Report, NBC News, The New York Times, and Real Clear Politics. 
Averaging the ratings by these different groups yields 77 competitive districts (rated as tossup or lean Republican or Democrat) 
and 358 safe districts (rated as likely or solid Republican or Democrat). 
A complete list of competitive districts is available upon request.
The variable SAFE indicates whether each respondent lives in a safe Republican, safe Democratic or tossup district.

***************************************************************************************************************************


