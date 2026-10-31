PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
APRIL 2009 VALUES SURVEY
March 31 - April 6, 2009 N=1,506
April 14-21, 2009 N=1,507
COMBINED N=3,013


This survey was conducted over two field periods. Survey A was conducted from March 31 - April 6, 2009 and 
Survey B was conducted from April 14-21, 2009. Some questions ran only on Survey A, others only on Survey B, 
and others were on both and are reported based on the combined total (with the exception of Q.1 - Obama's Job Approval). 
The questionnaire identifies whether each question was only on Survey A, Survey B, or on both.  
The VALUES variable identifies whether a respondent is from Survey A or Survey B.

***************************************************************************************************************************

This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 
The dataset contains three weight variables. 

WEIGHT is the weight for the combined sample of all landline and cell phone interviews. 
Data for all Pew Research Center reports are analyzed using this weight.

The other two weights can be used to compared the combined sample with the landline sample by itself 
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

***************************************************************************************************************************

HISP1 and HISP2 were each asked of half of the sample.  HISPX combines these variables and is the full sample Hispanicity variable.

***************************************************************************************************************************

Q.A18 and Q.A19 were asked on separate forms so the order of the response categories could be rotated. 
To combine the variables (as they are shown in the topline), use the following syntax.

if form=2 qa18af1=qa19af2.
if form=2 qa18bf1=qa19bf2.
if form=2 qa18cf1=qa19cf2.

***************************************************************************************************************************

Four values questions were asked of both forms but in different places. 
To combine the results (as they are shown in the topline), use the following syntax.

if form=2 q30ccf1=q20eef2.
if form=2 q30cF1=q20aaF2.
if form=2 q30jF1=q20bbF2.
if form=2 q30mF1=q20ccF2.
