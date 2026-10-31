PEW RESEARCH CENTER FOR SOCIAL& DEMOGRAPHIC TRENDS

December 2011 Youth and Economy Survey (December 6-19,2011)

Interviews were conducted in English and Spanish.

National sample: N=2,048

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

Please create RACECMB as follows and include variable in dataset:
recode race1_1 (1=1) (2=2) (3=3) (4=5) (9=9) into racecmb.
if race1_2>0 racecmb=4.
variable label racecmb "Combining Race".
value label RACEcmb
1 "White"
2 "Black or African-American"
3 "Asian or Asian-American"
4 "Mixed Race"
5 "Or some other race"
9 "Don't know/Refused (VOL.)".

Please create RACETHN as follows and include variable in dataset:
if racecmb=1 and hisp4 ge 2 racethn=1.
if racecmb=2 and hisp4 ge 2 racethn=2.
if (racecmb ge 3) and (racecmb le 5) and (hisp4 ge 2) racethn=4.
if racecmb=9 racethn=9.
if hisp4=1 racethn=3.
variable label racethn “Race-Ethnicity”.
value label racethn
1 “White non-Hispanic”
2 “Black non-Hispanic”
3 “Hispanic”
4 “Other”
9 “Don’t know/Refused (VOL.)”.
