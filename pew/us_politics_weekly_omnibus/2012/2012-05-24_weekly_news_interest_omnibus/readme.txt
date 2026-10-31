PEW RESEARCH CENTER NEWS INTEREST INDEX
May 24-27, 2012 OMNIBUS
N=1012


**************************************************************************************************************************

This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 
WEIGHT is the weight for the combined sample of all landline and cell phone interviews and should be used for analysis of this data.
 
***************************************************************************************************************************

Beginning in the Fall of 2008, the Pew Research Center started using respondents’ self-reported zip code as  
the basis for geographic variables such as region, state and county. We do this because the error rate in the original 
geographic information associated with the sample is quite high, especially for respondents from the cell phone sample. 

For respondents who do not provide a zip code or for those we cannot match, we use the sample geographic information. 

To protect the privacy of respondents, telephone numbers, county of residence and zip code have been removed from the public data file.

***************************************************************************************************************************

In this and other weekly omnibus surveys beginning in May 2010, demographic variable names match those in the questionnaire, but the 
order of demographics in the survey may vary.

***************************************************************************************************************************

Some of the analysis of PEWWP1 was based on non-standard geographic regions. These are the U.S. Energy Information Administration's
Petroleum Administration for Defense District (PADD) regions. 

For more information, see: http://www.eia.gov/tools/glossary/index.cfm?id=Petroleum%20Administration%20for%20Defense%20District

Syntax to create these regional variables is below:
recode state (9,23,25,33,44,50=1)(10,11,24,34,36,42=2)(12,13,37,45,51,54=3)(17,18,19,20,21,26,27,29,31,38,39,40,46,47,55=4)						
(1,5,22,28,35,48=5)(8,16,30,49,56=6)(4,6,32,41,53=7) into paddfull. 						
val lab paddfull 1 "New England" 2 "Central Atlantic" 3 "Lower Atlantic" 4 "Midwest" 5 "Gulf Coast" 6 "Rocky Mountain" 7 "West Coast". 						
recode paddfull (1,2,3=1)(4=2)(5=3)(6=4)(7=5) into padd. 						
value labels padd 1 "East coast" 2 "Midwest" 3 "Gulf coast" 4 "Rocky mountain" 5 "West coast".						

***************************************************************************************************************************

Releases from this survey:

MAY 31, 2012 "Public Sees Gas Prices Down A Little Across Much of Nation"
http://www.people-press.org/2012/05/31/public-sees-gas-prices-down-a-little-across-much-of-nation/

MAY 31, 2012 "Presidential Campaign Public's Top Story"
http://www.people-press.org/2012/05/31/presidential-campaign-publics-top-story/