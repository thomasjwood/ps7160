PEW RESEARCH CENTER/NATIONAL JOURNAL 
CONGRESSIONAL CONNECTION POLL
PEW RESEARCH CENTER NEWS INTEREST INDEX
October 21-24, 2010 OMNIBUS
N=1,006

***************************************************************************************************************************************** 

This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 
WEIGHT is the weight for the combined sample of all landline and cell phone interviews and should be used for analysis of this data.
 
***************************************************************************************************************************************** 

Beginning in the Fall of 2008, the Pew Research Center started using respondents’ self-reported zip code as  
the basis for geographic variables such as region, state and county. We do this because the error rate in the original 
geographic information associated with the sample is quite high, especially for respondents from the cell phone sample. 

For respondents who do not provide a zip code or for those we cannot match, we use the sample geographic information. 

To protect the privacy of respondents, telephone numbers, county of residence and zip code have been removed from the public data file.

***************************************************************************************************************************************** 

In this and other weekly omnibus surveys beginning in May 2010, demographic variable names match those in the questionnaire, but the 
order of demographics in the survey may vary.

***************************************************************************************************************************************** 

SYNTAX FOR THREE QUESTION LIKELY VOTER SCALE

recode PEW1b (1 thru 2=1) (else=0) into Xcampnii.
recode PEWSCALE10 (9 thru 10=1) (else=0) into XSCALE10.
recode PEWPVOTE08A (1=1) (else=0) into XPVOTE08.
if age ge 20 lvs=XCAMPNII+XSCALE10+XPVOTE08.
if age le 19 lvs=XCAMPNII+XSCALE10+1.
if PEWREGA>1 lvs=0.

weight by weight.
freq lvs.
cros PEW7 by lvs /cel col.
cros lvs by party /cel col.
if lvs=3 lvs50weight=weight.
if lvs=2 lvs50weight=weight*.2961129.
weight by lvs50weight.
var lab lvs "Likely voter scale, short".
var lab lvs50weight "Likely voter weight at 50% cutoff".

(N FOR LIKELY VOTERS: 588)