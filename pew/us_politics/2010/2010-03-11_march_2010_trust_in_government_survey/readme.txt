PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
MARCH 2010 TRUST IN GOVERNMENT SURVEY
MARCH 11-21, 2010 
N=2,505

The March 2010 Trust in Government Survey was an update and an expansion of the 1998 Deconstructing Distrust report.
The main survey was conducted on cell phones and landlines with 2,505 adults from March 11-21, 2010.
In addition to the main survey, the report draws from three other omnibus surveys conducted March 18-21, April 1-5, and April 8-11.
This readme file concerns only the main survey conducted March 11-21, 2010. The data for the three omnibus surveys are released separately.

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

HISP2 and HISP3 were each asked of half of the sample.  HISPCMB combines these variables and is the full sample Hispanicity variable.

***************************************************************************************************************************

The generic ballot horse race variable (cheat) was computed using the following syntax:

do if regicert=1.
compute cheat=0.
if (q10=1 or q11=1) cheat=1.
if (q10=2 or q11 =2) cheat=2.
if ((q10=3 and q11 ge 3) or q11=3) cheat=3.
if (q10=9 and q11=9) cheat=9.
end if.
var lab cheat 'Congressional trial heat combined with leaners'.
val lab cheat  1 'Rep-lean Rep' 2 'Dem-lean Dem' 3 'Other-lean other (VOL)’ 9 'DK-no lean (VOL)'.

***************************************************************************************************************************

BELOW IS THE SPSS SYNTAX USED TO CREATE VARIABLES FOR THE "10-POINT SATISFACTION WITH THE FEDERAL GOVERNMENT" SCALE.
THIS SCALE WAS USED TO ANALYZE RESPONDENTS LEVEL OF SATISFACTION WITH GOVERNMENT USING MORE THAN 20 DIFFERENT QUESTIONS.
SEE QUESTIONNAIRE AND TOPLINE FILES FOR ITEM WORDING AND MARGINAL RESULTS.
A BINARY VERSION OF THE SCALE COMPARES THOSE WHO ARE HIGHLY DISATISFIED WITH GOVERNMENT WITH THOSE WHO ARE LESS SO.

****THESE ARE RECODES OF ALL OF THE INDIVIDUAL ITEMS THAT MAKE IT INTO THE SCALE**.

RECODE Q18AF1 Q18HF2 (1=0) (2=1) (ELSE=.5) INTO Q18ASCL Q18HSCL.
IF FORM=1 Q18SCL=Q18ASCL.
IF FORM=2 Q18SCL=Q18HSCL.
var lab q18scl 'effect of fed govt/congress scl'.
RECODE Q20 (3=2) (2=1) (1=0) (9=.5) INTO Q20SCL.
var lab q20scl 'content angry scl--2 points--dks at .5'.
RECODE Q21 (1 THRU 2=0) (3=1) (4=1) (9=.5) INTO Q21SCL.
var lab q21scl 'trust scl dichotomous'.
RECODE Q23 (1=1) (2=.8) (3=.6) (4=.4) (5=.2) (6=0) (9=.5) INTO Q23SCL.
var lab q23scl 'scale 6 scl'.

RECODE Q25 (1=1) (2=0) (9=.5) INTO Q25SCL.
var lab q25scl 'criticism justified scl'.
RECODE Q26 (1=1) (2 THRU 9=0) INTO Q26SCL.
var lab q26scl 'major reform dichotomous'.

compute effectfedgovt=99.
if q27a=1 and q28a=1 effectfedgovt=0.
if q27a=2 and q28a=1 effectfedgovt=0.
if q27a ge 3 effectfedgovt=0.
if q28a ge 2 effectfedgovt=.5.
if q27a=2 and q28a=2 effectfedgovt=.75.
if q27a=1 and q28a=2 effectfedgovt=1.
var lab effectfedgovt 'effect of the federal govt, includes size and valence for neg'.


***create ratings for congress, obama admin, agencies***.

recode q52a (1=0) (2=0) (3=.5) (4=1) (else=sysmis) into congperfrate.
recode q52b (1=0) (2=0) (3=.5) (4=1) (else=sysmis) into obadminperfrate.
recode q52d (1=0) (2=0) (3=.5) (4=1) (else=sysmis)  into eparate.
recode q52f (1=0) (2=0) (3=.5) (4=1) (else=sysmis) into ssarate.
recode q52g (1=0) (2=0) (3=.5) (4=1)  (else=sysmis) into varate.
recode q52i (1=0) (2=0) (3=.5) (4=1) (else=sysmis) into nasarate.
recode q52l (1=0) (2=0) (3=.5) (4=1)  (else=sysmis) into irsrate.
recode q52m (1=0) (2=0) (3=.5) (4=1)  (else=sysmis) into deptofedrate.
recode q52n (1=0) (2=0) (3=.5) (4=1) (else=sysmis) into fdarate.
recode q52p (1=0) (2=0) (3=.5) (4=1) (else=sysmis) into justicerate.
recode q52r (1=0) (2=0) (3=.5) (4=1) (else=sysmis) into cdcrate.

***DONT KNOW RESPONSES TO PERFORMANCE RATINGS RECODED TO THEIR MEAN***. 
recode congperfrate (0 thru 1=copy) (else=0) into congrate.
if q52a=9 congrate=.6225.

recode obadminperfrate (0 thru 1=copy) (else=0) into obamadminrate.
if q52b=9 obadminrate=.4495.

recode eparate (0 thru 1=copy) (else=0) into eparatemean.
if q52d=9 eparatemean=.3562.

recode ssarate (0 thru 1=copy) (else=0) into ssaratemean.
if q52f=9 ssaratemean=.4388.

recode varate (0 thru 1=copy) (else=0) into varatemean.
if q52g=9 varatemean=.3554.

recode nasarate (0 thru 1=copy) (else=0) into nasaratemean.
if q52i=9 nasaratemean=.2031.

recode irsrate (0 thru 1=copy) (else=0) into irsratemean.
if q52l=9 irsratemean=.3743.

recode deptofedrate (0 thru 1=copy) (else=0) into deptofedratemean.
if q52m=9 deptofedratemean=.4764.

recode fdarate (0 thru 1=copy) (else=0) into fdaratemean.
if q52n=9 fdaratemean=.3635.

recode justicerate (0 thru 1=copy) (else=0) into justiceratemean.
if q52p=9 justiceratemean=.4046.

recode cdcrate (0 thru 1=copy) (else=0) into cdcratemean.
if q52r=9 cdcratemean=.2031.

count agencyrate2= q52d q52f q52g q52i q52l q52m q52n q52p q52r (1,2,3,4,9).

***MEAN SCORE FOR AGENCY RATINGS***.
compute agenciesidxmean=(eparatemean+ssaratemean+varatemean+nasaratemean+irsratemean+deptofedratemean+fdaratemean+justiceratemean+cdcratemean)/agencyrate2.

weight by weight.
RECODE Q73 (1=1) (2=.5) (3 THRU 9=0) INTO Q73SCL.
var lab q73scl 'threat scl'.

COMPUTE FINDEX2=congrate+obamadminrate+agenciesidxmean+Q18SCL+Q20SCL+Q21SCL+Q23SCL+Q25SCL+Q26SCL+effectfedgovt+Q73SCL.

recode findex2 (0 thru 8.251=0)  (8.252 thru 12=1) into frustgov.
var lab frustgov 'Attitudes and evaluations of government'.
val lab frustgov 0 'low-med frustration' 1 'high frustration'.

***this is re-scaling to run 0 to 10****.
COMPUTE FIDX0to10=findex2/1.1.
COMPUTE frustidx10=TRUNC(FIDX0to10).

**THIS IS REVERSING THE VARIABLE TO REFLECT THAT IT IS A INDEX OF SATISFACTION**.
compute satisidx10=10-frustidx10.
var lab satisidx10 '11-point index of satisfaction with government'.
val lab satisidx10 0 "0-Most dissatisfied with government" 10 "10-Most satisfied with government".
compute satisgov=1-frustgov.
var lab satisgov '2-point satisfaction with the federal government--highly dissatisfied vs.others'.
val lab satisgov  0 'Highly dissatisfied with government' 1 'Satisfied with federal government'.
