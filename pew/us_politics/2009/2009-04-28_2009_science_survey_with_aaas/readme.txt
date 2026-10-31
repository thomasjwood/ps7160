The science project involved three surveys. One was an RDD telephone survey of the general public, conducted on cell phones 
and landlines with 2,001 adults from April 28 to May 12, 2009 in Spanish and English. Another was a web-based survey of scientists 
drawn from the membership of the American Association for the Advancement of science. This survey was conducted May 1 to 
June 14, 2009, with 2,533 respondents. A third telephone survey of the general public was conducted on an omnibus survey 
of cell phones and landlines with 1,005 adults June 18 to June 21, 2009. The latter was mostly devoted to knowledge questions about 
science. This document cocerns only the general public survey conducted April 28 to May 12, 2009.

***************************************************************************************************************************

The GP science dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 
The dataset contains three weight variables. 

WEIGHT is the weight for the combined sample of all landline and cell phone interviews. 
Data for all Pew Research Center reports are analyzed using this weight.

The other two weights can be used to compare the combined sample with the landline sample by itself 
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

Questions 45F1 and 46F2 had identical wording, but the answer options were randomized differently. For Q.44F1, the answer choice
"The earth is not getting warmer" was always offered LAST while "The earth is getting warmer mostly because of natural changes
in the atmospher" and "The earth is getting warmer mostly because of human activity such as burning fossil fuels" were 
offered first in random order. For Q.45F2, "The earth is not getting warmer" was always offered FIRST, and the other two options
were offered after in random order.

These can be combined for analysis as follows:
if (q44f1=1) or (q45f2=2) com4445=1.
if (q44f1=2) or (q45f2=3) com4445=2.
if (q44f1=3) or (q45f2=1) com4445=3.
if (q44f1=9) or (q45f2=9) com4445=9.
val lab com4445 1 'Warming--natural changes' 2 'Warming--human activity' 3 'Earth not warming' 9 'Don't know/Refused'.

***************************************************************************************************************************

There are two variables in the dataset that combine responses to multiple questions.

SCICON4 combines responses to three questions about whether people consume various science news sources.
count scicon4 = q18 q19 q20 (1).
var label scicon4 "Science Source Scale".
value label scicon4
0 "0 sources regularly"
1 "1 source regularly"
2 "2 sources regularly"
3 "3 sources regularly". 
	
SCIKNOW5 combines responses to four science knowledge questions.
count Sciknow5 = q63 q64 q65 (1) q66 (2).
variable label sciknow5 “Science knowledge scale”.
value label sciknow5
0 "0 correct answers"
1 "1 correct answer"
2 "2 correct answers"
3 "3 correct answers"
4 "4 correct answers". 

***************************************************************************************************************************

For more details, see the "About the surveys" section at the end of the scientists report released on Thursday, July 9, 2009, titled:
"Public Praises Science; Scientists Fault Public Media."


