PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
AND PEW FORUM ON RELIGION & PUBLIC LIFE

AUGUST 2009 RELIGION AND PUBLIC LIFE SURVEY
August 11-17, 2009 N=2,010
August 20-27, 2009 N=2,003
COMBINED N=4,013

AUGUST 2009 OMNIBUS
August 27-30, 2009
N=1,005


The 2009 Religion study involved two surveys. The first was carried out over two waves. Survey A was conducted from August 11 - 17, 2009 and 
Survey B was conducted from August 20-27, 2009. Both waves were conducted on cell phones and landlines in Spanish and English.  A second survey was 
an omnibus poll conducted on cell phones and landlines and was mostly devoted to opinions about Congress.  This document concerns only the first survey 
conducted over two waves between August 11-27, 2009.

**********************************************************************************************************************************************

This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also contain a landline phone. 

The dataset contains three weight variables, which can be used to compare the combined landline and 
cell phone sample with the landline sample by itself and with the landline sample combined with the cell-only households.

Weight Name: WEIGHT
Description: This is the weight for the combined sample of all landline and
cell phone interviews. This weight is used for analysis of all Pew Research Center reports.

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

Beginning in the Fall of 2008, the Pew Research Center started using respondents’ self-reported zip code as  
the basis for geographic variables such as region, state and county. We do this because the error rate in the original 
geographic information associated with the sample is quite high, especially for respondents from the cell phone sample. 

For respondents who do not provide a zip code or for those we cannot match, we use the sample geographic information. 
We continue to include the original sample geographic variables in the datasets (these variables are preceded by an ‘s’) 
for archival purposes only.

*********************************************************************************************

HISP1 and HISP3 were each asked of half of the sample.  HISPX combines these variables and is the full sample Hispanicity variable.

***************************************************************************************************************************

Most questions ran only on Survey A, or only on Survey B, and a few substantive items ran on both. 
The following questions common to both surveys A & B were reported based on the combined total:
Q.125/240 - Abortion should be legal/illegal?
Q.145a/249 - Favor/oppose faith based funding?
Q.188/288 - How often do you pray?
(SYNTAX FOR COMBINING THESE VARS SHOWN BELOW).

The following questions common to both surveys A & B were reported separately:
Q.101/201 - Obama's Job Approval. 
Q.102/202 - Satisfaction with country.
Q.140a/212a - Favorability of the Republican party.
Q.140b/212b - Favorability of the Democratic party.

Demographics, including the standard series about ones religious practice, were asked on both Surveys A & B and reported together.
Data from Surveys A & B for these variables are combined in the dataset. Three Demographic questions about the religious practice of ones spouse were asked on Survey B only.

The questionnaire for survey A is organized with numbering between 101-191 and Survey B with numbering between 201-292. The combined topline 
identifies the questions asked only on Survey A, only on Survey B, or asked of all at the top of each item.
The SURVEY variable identifies whether a respondent is from Survey A or Survey B.

***************************************************************************************************************************

DATA COMBINED FOR ANALYSIS:

Q.125 and 240 have identical wording on Surveys A & B: 
They were combined for analysis as follows:
if (q125=1) or (q240=1) Q125_240=1.
if (q125=2) or (q240=2) Q125_240=2.
if (q125=3) or (q240=3) Q125_240=3.
if (q125=4) or (q240=4) Q125_240=4.
if (q125=9) or (q240=9) Q125_240=9.
val lab Q125_Q240 'Legal in all cases' 2 'Legal in most cases' 3 'Illegal in most cases' 4 'Illegal in all cases' 9 'Don't know/Refused'.

Q.145a and 249 have identical wording on Surveys A & B:
They were combined for analysis as follows:
if (q145a=1) or (q249=1) Q145a_249=1.
if (q145a=2) or (q249=2) Q145a_249=2.
if (q145a=3) or (q249=3) Q145a_249=3.
if (q145a=4) or (q249=4) Q145a_249=4.
if (q145a=9) or (q249=9) Q145a_249=9.
val lab Q145a_Q249 'Strongly favor' 2 'favor' 3 'oppose' 4 'Strongly oppose' 9 'Don't know/Refused'.

Q.188 and 288 have identical wording on Surveys A & B: 
They were combined for analysis as follows:
if (q188=1) or (q288=1) Q188_288=1.
if (q188=2) or (q288=2) Q188_288=2.
if (q188=3) or (q288=3) Q188_288=3.
if (q188=4) or (q288=4) Q188_288=4.
if (q188=5) or (q288=5) Q188_288=5.
if (q188=6) or (q288=6) Q188_288=6.
if (q188=7) or (q288=7) Q188_288=7.
if (q188=9) or (q288=9) Q188_288=9.
val lab Q188_Q288 1 'Several times a day' 2 'Once a day' 3 'A few times a week' 4 'Once a week' 5 'A few times a month' 6 'Seldom' 7 'Never' 9 'Don't know/Refused'.

***************************************************************************************************************************

Q.129 was used for qualitiative purposes only. These open ended responses were not coded.

***************************************************************************************************************************

NOTE: Due to unusually high item nonresponse in Q.141a-h on Survey A (August 11-17, 2009), results for these questions cannot be compared with previous trends.
Current data are used for analytical purposes only and are shown in grey in the topline. 

***************************************************************************************************************************

The generic ballot horse race variable (cheat) was computed using the following syntax:

if (q210=1 or q211=1) cheat=1.
if (q210=2 or q211=2) cheat=2.
if (q210=3 and (q211=3 or q211=9)) cheat=3.
if (q210=9 and (q211=3 or q211=9)) cheat=9.
if (regist>1) or (regicert>1) cheat=999.
recode cheat (999=sysmis).
var lab cheat 'Congressional trial heat combined with leaners'.
val lab cheat  1 'Rep/lean Rep' 2 'Dem/lean Dem' 3 'Other-lean other' 9 'DK-no lean'.
