PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
JANUARY 2010 POLITICAL SURVEY
JANUARY 6-10, 2010 
N=1,504

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
if (q9=1 or q10=1) cheat=1.
if (q9=2 or q10 =2) cheat=2.
if (q9=3 and (q10=3 or q10=9)) cheat=3.
if (q9=9 and (q10=3 or q10=9)) cheat=9.
end if.
var lab cheat 'Congressional trial heat combined with leaners'.
val lab cheat  1 “Rep/lean Rep” 2 “Dem/lean Dem' 3 'Other-lean other (VOL.)’ 9 'DK-no lean (VOL.)'.

***************************************************************************************************************************

The question numbering in the questionnaire and topline do not match the question
numbers and the variable names in the SPSS file for the Census questions. They can be matched as follows:

DATASET				TOPLINE/QUESTIONNAIRE
qcen1				QC.1	
qcen2				QC.2
qcen3				QC.3
qcen4				QC.4	
qcen4a				QC.4a
qcen5				QC.5
qcen6				QC.6
qcen7				QC.7
qcen8				QC.8
qcen9				QC.9
qcen10				QC.10

***************************************************************************************************************************