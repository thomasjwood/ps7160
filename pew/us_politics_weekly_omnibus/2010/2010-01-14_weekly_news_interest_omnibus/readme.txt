PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
JANUARY 2010 OMNIBUS SURVEY
JANUARY 14-17, 2010 
N=1,003

***************************************************************************************************************************

This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 
WEIGHT is the weight for the combined sample of all landline and cell phone interviews and should be used for analysis of this data. 

***************************************************************************************************************************

Beginning in the Fall of 2008, the Pew Research Center started using respondents’ self-reported zip code as  
the basis for geographic variables such as region, state and county. We do this because the error rate in the original 
geographic information associated with the sample is quite high, especially for respondents from the cell phone sample. 

For respondents who do not provide a zip code or for those we cannot match, we use the sample geographic information. 
We continue to include the original sample geographic variables in the datasets (these variables are preceded by an ‘s’) 
for archival purposes only.

To protect the privacy of respondents, telephone numbers, county of residence and zip code have been removed from the data file.

***************************************************************************************************************************

This is the syntax used to create the knowledge scale:
compute dow= 0.
if pew1=3 dow=1.
compute yemen=0.
if pew2=1 yemen=1.
compute afghan=0.
if pew3=1 afghan=1.
compute jobs=0.
if pew4=2 jobs=1.
compute gopvotes=0.
if pew5=1 gopvotes=1.
compute filibuster=0.
if pew6=2 filibuster=1.
compute china= 0.
if  pew7=1 china= 1.
compute oil= 0.
if pew8=3 oil = 1.
compute reid = 0.
if pew9=1  reid= 1.
compute steele= 0.
if pew10=1 steele= 1.
compute colbert= 0.
if pew11=1 colbert=1.
compute court= 0.
if pew12=3 court=1.
compute know12=sum(dow to court).

***************************************************************************************************************************

