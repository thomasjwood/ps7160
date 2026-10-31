PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
SEPTEMBER 2010 POLITICAL-INDEPENDENTS SURVEY
AUGUST 25-SEPTEMBER 6, 2010 
TOTAL N=3,509

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
recode PLANTO1 (1=1) (else=0) into XPLANTO1.
recode SCALE10 (9 thru 10=1) (else=0) into XSCALE10.
recode PVOTE08A (1=1) (else=0) into XPVOTE08.
if form=1 FOLGOV=q6f1.
if form=2 FOLGOV=q7f2.
recode FOLGOV (1 thru 2=1) (else=0) into XFOLGOV.

if age ge 20 lvs=XTHOUGHT+XOFTVOTE+XPRECINCT+XPLANTO1+XSCALE10+XFOLGOV+XPVOTE08.
if age le 19 lvs=XTHOUGHT+XOFTVOTE+XPRECINCT+XPLANTO1+XSCALE10+XFOLGOV+1.
if age le 21 lvs=lvs+1.
recode lvs (8=7).
if regicert>1 lvs=0.
if regist>1 lvs=0.
if planto1>1 lvs=0.

weight by weight.
freq lvs.
cros cheat by lvs /cel col.

if lvs=7 lvs50weight=weight.
if lvs=6 lvs50weight=weight*.8374384.
weight by lvs50weight.
freq cheat.
weight off.

var lab lvs "7-point likely voter scale".
var lab lvs50weight "Likely voter weight at 50% cutoff".

***************************************************************************************************************************

SYNTAX FOR TYPOLOGY OF INDEPENDENT VOTERS

weight off.
sort cases by psraid (a).

*Compute and run filter for independent registered voters*.
compute filter_indRV=(party>2 and regicert=1).
var lab filter_indRV 'Independent/Other Registered Voters'.
val lab filter_indRV  0 'Not Selected' 1 'Selected'.
filter by filter_indRV.

*Recodes and scale construction*.
*Views of government scale*.
recode q31 (1=1) (2=0) (3,9=.5) into GovSize.
var lab GovSize "Smaller vs. bigger government - depends,dk at .5".
recode q30a (1=1) (2=0) (3,9=.5) into GovWaste.
var lab GovWaste "Government wasteful vs. does a better job than given credit for - neither,both,dk at .5".
recode q29 (1,2=0) (3,4=1) (9=.5) into GovTrust.
var lab GovTrust "Always, most vs. some, never - dk at .5".
compute gov3=GovSize+GovWaste+GovTrust.
var lab gov3 "3-item views of govt scale - govt size, wasteful, trust".

*Disaffected scale*.
recode q30c (1=0) (2=1) (3,9=.5) into PolCare.
var lab PolCare "Elected officials don't care vs. care - neither,both,dk at .5".
recode q69a (1=1) (2,3=0) (9=.5) into DontTrust.
var lab DontTrust "Don't trust either party - major vs. minor,not - dk at .5".
recode q69f (1=1) (2,3=0) (9=.5) into SpecInt.
var lab SpecInt "Both parties care more about special interests - major vs. minor,not - dk at .5".
compute disaff3=PolCare+DontTrust+SpecInt.
var lab disaff3 "3-item disaffected scale - elected officials don't care, dont' trust either party, parties care more about special interests".

*Upbeat scale*.
recode q30b (1=1) (2=0) (3,9=.5) into AmerSolve.
var lab AmerSolve "Americans can solve problems vs. can't solve - neither,both,dk at .5".
recode q30d (1=1) (2=0) (3,9=.5) into HardWork.
var lab HardWork "Hard work get ahead vs. no guarantee - neither,both,dk at .5".
recode q54 (1,2=1) (3=0) (9=.5) into EconRec.
var lab EconRec "Economy recovering already, soon vs. long time - dk at .5".
compute upbeat3=AmerSolve+HardWork+EconRec.
var lab upbeat3 "3-item upbeat scale - americans solve problems, work hard get ahead, econ recovery soon".

*Financial stress scale*.
recode q55 (1,2=0) (3,4=1) (9=.5) into PersFin.
var lab PersFin "Personal financial situation excellent, good vs. fair, poor  - dk at .5".
recode q100 (1=1) (2=0) (9=.5) into HHunemp.
var lab HHunemp "Someone in household unemployed in last 12 mos or not - dk at .5".
compute FinStress2=PersFin+HHunemp.
var lab FinStress2 "2-item financial stress scale - personal finances, household unemployment".

*Engagement scale*.
compute q6q7comb=0.
if form=1 q6q7comb=q6f1.
if form=2 q6q7comb=q7f2.
recode q6q7comb (1=1) (2=.5) (3,4=0) (9=.5) into FolGov.
var lab FolGov "Follow govt and public affairs most of the time vs. some vs. less often  - dk at .5".
recode oftvote (1=1) (2=.5) (3 thru 6=0) (9=.5) into FreqVote.
var lab FreqVote "Vote always vs. nearly always vs. less often  - dk at .5".
compute engage2=FolGov+FreqVote.
var lab engage2 "2-item engagement scale - folgov, oftvote".

*Immigrants*.
weight off.
recode q30e (1=1) (2=0) (3,9=.5) into ImmigStr.
var lab ImmigStr "Immigrants strengthen vs. burden - neither,both,dk at .5".
compute immig1=ImmigStr.
var lab immig1 "1-item immigrant measure - strengthen vs. burden".

*Business*.
recode q30g (1=0) (2=1) (3,9=.5) into BusProf.
var lab BusProf "Businesses fair profit vs. too much - neither,both,dk at .5".
compute business1=BusProf.
var lab business1 "1-item business measure - fair vs. too much profit".

**Standardize scales for cluster analysis**.
weight by weight.
desc vars=gov3 disaff3 upbeat3 FinStress2 engage2 immig1 business1 /save.
*desc vars=zgov3 zdisaff3 zupbeat3 zFinStress2 zengage2 zimmig1 zbusiness1.

**Cluster analysis**.
*5 clusters*.
weight by weight.
QUICK CLUSTER zgov3 zdisaff3 zupbeat3 zFinStress2 zengage2 zimmig1 zbusiness1
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(5) MXITER(100) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /PRINT INITIAL ANOVA DISTANCE
  /SAVE CLUSTER (indRV_typology).

recode indRV_typology (3=1) (5=2) (4=3) (1=4) (2=5).
var lab indRV_typology "Independent RV typology groups".
val lab indRV_typology
  1 'Shadow Republicans'
  2 'Disaffected Republicans'
  3 'Doubting Democrats'
  4 'Shadow Democrats'
  5 'Disengaged'.

***************************************************************************************************************************
