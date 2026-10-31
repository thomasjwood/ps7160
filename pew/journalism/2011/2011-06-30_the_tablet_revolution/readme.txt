PEW RESEARCH CENTER
JOURNALISM & MEDIA

Tablet owner phone surveys (Survey 1)
5 surveys fielded over June 30-July 31, 2011
N= 5,014 adults ages 18 and older
N= 504 tablet users

Tablet news phone survey (Survey 2)
JULY 15-30, 2011
N= 1,159 tablet users
N= 894 tablet news users

Tablet news web survey (Survey 3)
SEPTEMBER 6-19, 2011
N= 300 tablet news users

***************************************************************************************************************************

Survey 1: 

This dataset includes landline and cell phone interviews conducted using an RDD sample of landline and cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 

WEIGHT is the weight for the combined sample of all landline and cell phone interviews in Survey 1. 
Data for all Pew Research Center reports are analyzed using this weight.


Survey 2: 

This dataset includes landline and cell phone interviews from a panel developed by recontacting people previously 
identified as having a tablet computer in a large-scale survey effort that interviewed more than 40,000 adults in 2011. 

WEIGHT is the weight for the combined sample of all landline and cell phone interviews in Survey 2. 
Data for all Pew Research Center reports are analyzed using this weight.


Survey 3:
This dataset includes follow-up web surveys from a panel developed by recontacting people previously identified as having
a tablet computer in a large-scale survey effort that interviewed more than 40,000 adults in 2011. A select group of
respondents indicated they would be willing to be re-contacted by email for another survey.

Data for this dataset are not weighted.

***************************************************************************************************************************

Beginning in the Fall of 2008, the Pew Research Center started using respondents’ self-reported zip code as  
the basis for geographic variables such as region, state and county. We do this because the error rate in the original 
geographic information associated with the sample is quite high, especially for respondents from the cell phone sample. 

For respondents who do not provide a zip code or for those we cannot match, we use the sample geographic information. 
We continue to include the original sample geographic variables in the datasets (these variables are preceded by an ‘s’) 
for archival purposes only.

To protect the privacy of respondents:
Telephone numbers, county of residence and zip code have been removed from the data file.
In Survey 1, the raw open end responses to PEJ.4a (pej4_1vb) have been removed from the data file.
In Survey 2, the raw open end responses to PEJ.24 (pej24vb) and PEJ.26 (pej26vb) have been removed from the data file.
In Survey 3, the raw open end responses to Q41 (q41vb) have been removed from the data file.

***************************************************************************************************************************

Releases from these surveys:

October 25, 2011 "The tablet revolution"
http://www.journalism.org/2011/10/25/tablet/


***************************************************************************************************************************


***The following syntax is for constructed demographic variables***.


SYNTAX - SURVEY 1

*The race-ethnicity variable (racethn) was computed using the following syntax:
compute racethn=0.
if race=1 and hisp ge 2 racethn=1.
if race=2 and hisp ge 2 racethn=2.
if (race ge 3 and race le 6) and (hisp ge 2) racethn=4.
if race=9 racethn=9.
if hisp=1 racethn=3.
variable label racethn “Race-Ethnicity”.
value label racethn
1 “White non-Hispanic”
2 “Black non-Hispanic”
3 “Hispanic”
4 “Other”
9 “Don’t know/Refused (VOL.)”.

*The tablet owner variable (tablet) was computed using the following syntax:
Compute tablet=0.
IF PEJ1=1 tablet=1.
IF ANY(PEJ1,2,9) tablet=2.
IF ANY(PEJ2a,2,9) tablet=2.
IF ANY(99,pej2m1,pej2m2,pej2m3) tablet=2.
Variable Labels tablet 'Tablet owner'.
formats tablet (f1.0).
VALUE LABELS tablet 1 'Yes' 2 'No'.


SYNTAX - SURVEY 2

*The combined race variable (racecmb) was computed using the following syntax:
recode race1m1 (1=1) (2=2) (3=3) (4 thru 7=5) (8 thru 9=9) into racecmb.
if race1m2>0 and race1m2 <8 racecmb=4.
variable label racecmb "Combining Race".
value label racecmb
1 "White"
2 "Black or African-American"
3 "Asian or Asian-American"
4 "Mixed Race"
5 "Some other race"
9 "Don't know/Refused (VOL.)".

*The race-ethnicity variable (racethn) was computed using the following syntax:
compute racethn=0.
if racecmb=1 and hisp4 ge 2 racethn=1.
if racecmb=2 and hisp4 ge 2 racethn=2.
if (racecmb ge 3 and racecmb le 5) and (hisp4 ge 2) racethn=4.
if racecmb=9 racethn=9.
if hisp4=1 racethn=3.
variable label racethn “Race-Ethnicity”.
value label racethn
1 “White non-Hispanic”
2 “Black non-Hispanic”
3 “Hispanic”
4 “Other”
9 “Don’t know/Refused (VOL.)”.


SYNTAX - SURVEY 3

*The combined race variable (racecmb) was computed using the following syntax:
recode race1m1 (1=1) (2=2) (3=3) (4 thru 7=5) (8 thru 9=9) into racecmb.
if race1m2>0 and race1m2 <8 racecmb=4.
variable label racecmb "Combining Race".
value label racecmb
1 "White"
2 "Black or African-American"
3 "Asian or Asian-American"
4 "Mixed Race"
5 "Some other race"
9 "Don't know/Refused (VOL.)".

*The race-ethnicity variable (racethn) was computed using the following syntax:
compute racethn=0.
if racecmb=1 and hisp4 ge 2 racethn=1.
if racecmb=2 and hisp4 ge 2 racethn=2.
if (racecmb ge 3 and racecmb le 5) and (hisp4 ge 2) racethn=4.
if racecmb=9 racethn=9.
if hisp4=1 racethn=3.
variable label racethn “Race-Ethnicity”.
value label racethn
1 “White non-Hispanic”
2 “Black non-Hispanic”
3 “Hispanic”
4 “Other”
9 “Don’t know/Refused (VOL.)”.