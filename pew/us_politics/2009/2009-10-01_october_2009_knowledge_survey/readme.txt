PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
OCTOBER 2009 KNOWLEDGE SURVEY
October 1-4, 2009
N=1,002


This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 
WEIGHT is the weight for the combined sample of all landline and cell phone interviews and should be used for all analysis of this data. 

***************************************************************************************************************************

Beginning in the Fall of 2008, the Pew Research Center started using respondents’ self-reported zip code as  
the basis for geographic variables such as region, state and county. We do this because the error rate in the original 
geographic information associated with the sample is quite high, especially for respondents from the cell phone sample. 

For respondents who do not provide a zip code or for those we cannot match, we use the sample geographic information. 
We continue to include the original sample geographic variables in the datasets (these variables are preceded by an ‘s’) 
for archival purposes only.

To protect the privacy of respondents, telephone numbers, county of residence and zip code have been removed from the data file.

***************************************************************************************************************************

Because this was an omnibus, the question numbering in the questionnaire and topline do not match the question
numbers and the variable names in the SPSS file. They can be matched as follows:

DATASET/QUESTIONNAIRE		TOPLINE
pew1				Q.1	
pew2				Q.2
pew3				Q.3
pew4				Q.4	
pew5				Q.5
pew6				Q.6
pew7				Q.7
pew8				Q.8
pew9				Q.9
pew10				Q.10
pew11				Q.11
pew12				Q.12


***************************************************************************************************************************

This is the syntax used to create the knowledge scale:

compute house= 0.
if pew1=1 house=1.
compute border = 0.
if  pew2= 2 border = 1.
compute dow= 0.
if pew3 = 3 dow = 1.
compute capandtrade = 0.
if pew4 = 1  capandtrade= 1.
compute publicoption= 0.
if pew5 = 2 publicoption= 1.
compute afghan= 0.
if pew6 = 2 afghan = 1.
compute unemployment = 0.
if pew7 =2 unemployment = 1.
compute bernanke= 0.
if pew8 = 1 bernanke= 1.
compute beck=0.
if pew9=1 beck=1.
compute sotomayor=0.
if pew10=1 sotomayor=1.
compute baucus=0.
if pew11=1 baucus=1.
compute spending=0.
if pew12=1 spending=1.
compute know12=sum(house to spending).