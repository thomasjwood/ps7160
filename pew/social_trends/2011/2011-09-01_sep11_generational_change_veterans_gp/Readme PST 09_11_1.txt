PEW RESEARCH CENTER SOCIAL & DEMOGRAPHIC TRENDS

Generational Change & Veteran GP Survey (Sep.1-Sep.15, 2011) 

Interviews were conducted by landline and cell phone.

Interviews were conducted in English and Spanish.

Form A/Form B: each a random 1/2 of sample

National Sample: N=2,003

***Note: The WEIGHT variable is weighting variable intended for use on all questions.

***Note for variables: Race of the respondent "Race1" allows multiple responses, 
and "racecmb" in the dataset combines different responses to the race questions.
The combined variable “racethn” identifies the respondent’s race and ethnicity. 


******************************************************************************************************************************************

The Pew Research Center uses respondents’ self-reported zip code as the basis for geographic variables such as region,state and county. 
We continue to include the original sample geographic variables in the datasets (these variables are preceded by an ‘s’)
for archival purposes only.

To protect the privacy of respondents, telephone numbers, zip code and other identifying variables have been removed from
the public data file.

Some special technical variables were also removed, but are available upon request.

******************************************************************************************************************************************

SYNTAX FOR ADDITIONAL VARIABLES:

RACECMB:

recode race1_1 (1=1) (2=2) (3=3) (4=5) (9=9) into racecmb.
if race2_2>0 racecmb=4.
variable label racecmb "Combining Race".
value label RACEcmb
1 "White"
2 "Black or African-American"
3 "Asian or Asian-American"
4 "Mixed Race"
5 "Or some other race"
9 "Don't know/Refused (VOL.)".

RACETHN:

if racecmb=1 and hisp4 ge 2 racethn=1.
if racecmb=2 and hisp4 ge 2 racethn=2.
if (racecmb ge 2) and (racecmb le 5) and (hisp4 ge 2) racethn=4.
if racecmb=9 racethn=9.
if hisp4=1 racethn=3.
variable label racethn “Race-Ethnicity”.
value label racethn
1 “White non-Hispanic”
2 “Black non-Hispanic”
3 “Hispanic”
4 “Other”
9 “Don’t know/Refused (VOL.)”.


SACRIFICE:

compute sacrifice=0.
if q41>q40 and q41 ne 9 sacrifice=1.
if q41=q40 sacrifice=2.
if q41<q40 sacrifice=3.
if q41=9  or q40=9 sacrifice=9.
variable label sacrifice "Sacrifices Summary (Q40 and Q41)".
value labels sacrifice 1 "Service people/families have made more sacrifices than American people" 2 "Both have made same amount of sacrifices" 3 "American people have made more sacrifices than service people/familes" 9 "DK/Ref.".

