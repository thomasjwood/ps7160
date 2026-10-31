PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
OCTOBER 2011 GENERATIONS SURVEY
SEPTEMBER 22-OCTOBER 4, 2011 
TOTAL N=2,410

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

**To create the generational breaks used throughout the report***.
do if (age<99).
compute yob=2011-age.
end if.
recode yob (1913 thru 1927=1)(1928 thru 1945=2)(1946 thru 1964=3) (1965 thru 1980=4) (1981 thru hi=5) into cohort5.
var lab cohort5 'Generational cohorts--5 groups'.
value lab cohort5 1 'Greatest (-1928)' 2 'Silent (1928-45)' 3 'Boomer (1946-64)' 4 'Xer (1965-1980)' 5 'Millennial (1981-)'.


***************************************************************************************************************************

THis report also includes analysis of data from a survey condcuted September 1-15, 2011 by the Pew Social and Demographic Trends project; 
the dataset for that survey will be released on their website http://www.pewsocialtrends.org/category/datasets/.
