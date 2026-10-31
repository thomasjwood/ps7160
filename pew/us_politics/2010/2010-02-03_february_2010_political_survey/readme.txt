PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
FEBRUARY 2010 POLITICAL SURVEY
FEBRUARY 3-9, 2010 
N=1,383


This poll was interrupted by a major snow storm on the east coast resulting in a lower than intended sample size. 
Due to the storm, interviewing was unable to be conducted February 6-7, 2010.

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

Congressional Heat Variable was created using the following syntax:

do if regicert=1.
compute cheat=0.
if (q8=1 or q9=1) cheat=1.
if (q8=2 or q9 =2) cheat=2.
if ((q8=3 and q9 ge 3) or q9=3) cheat=3.
if (q8=9 and q9=9) cheat=9.
end if.
var lab cheat 'Congressional trial heat combined with leaners'.
val lab cheat  1 “Rep/lean Rep” 2 “Dem/lean Dem' 3 'Other-lean other (VOL.)’ 9 'DK-no lean (VOL.)'.

***************************************************************************************************************************