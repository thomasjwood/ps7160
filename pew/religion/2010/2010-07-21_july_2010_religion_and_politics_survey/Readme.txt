PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS AND THE PEW FORUM ON RELIGION AND PUBLIC LIFE
JULY 2010 RELIGION AND POLITICS SURVEY
July 21-August 5, 2010
N=3,003

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

To protect the privacy of respondents, telephone numbers, county of residence and zip code have been removed from the public data file.

***************************************************************************************************************************

HISP3 and HISP4 were each asked of half of the sample.  HISPCMB combines these variables and is the full sample Hispanicity variable.

***************************************************************************************************************************

The generic ballot horse race variable (cheat) was computed using the following syntax:

do if regicert=1.
compute cheat=0.
if (q2=1 or q2a=1) cheat=1.
if (q2=2 or q2a =2) cheat=2.
if ((q2=3 and q2a ge 3) or q2a=3) cheat=3.
if (q2=9 and q2a=9) cheat=9.
end if.
var lab cheat 'Congressional trial heat combined with leaners'.
val lab cheat  1 'Rep-lean Rep' 2 'Dem-lean Dem' 3 'Other-lean other (VOL)’ 9 'DK-no lean (VOL)'.

***************************************************************************************************************************

In a wording experiment, the survey asked how important gay marriage (q8bf1) and how important same sex marriage (q8bf2) are to your vote.
The results were presented separately and combined in the topline.

SPSS Syntax for combining q8bf1 and Q8bf2). This variable is saved to the dataset as q8bf1f2.

compute q8bf1f2=q8bf1.
if q8bf2=1 q8bf1f2=1.
if q8bf2=2 q8bf1f2=2.
if q8bf2=3 q8bf1f2=3.
if q8bf2=4 q8bf1f2=4.
if q8bf2=9 q8bf1f2=9.
val lab q8bf1f2 1 "Very important" 2 "Somewhat important" 3 "Not too important" 4 "Not at all important" 9 "Don't know/Refused (VOL)".
var lab q8bf1f2 "Q.8bf1 The issue of - Gay marriage/Same sex marriage."

***************************************************************************************************************************.

Creates engagement scale for horserace release, "Republicans Faring Better with Men, Whites, Independents and Seniors" 
August 8, 2010, page 4****.
weight off.
count engagement = thought planto2 (1).
val lab engagement (0)Low engagement (1)Medium engagement (2)High engagement.	
var lab engagement 'Engagement in the campaign based on THOUGHT and PLANTO2'.

*************************************************************************************************.