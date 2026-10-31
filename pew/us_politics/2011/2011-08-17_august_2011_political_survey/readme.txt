PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
AUGUST 2011 POLITICAL SURVEY
AUGUST 17-21, 2011 
TOTAL N=1,509

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

Items Q9d-j reported in the topline and report were recoded to assign those who had not been born to a "not born yet" category, based on 
their reported age. These questions were also reported based on those who were eight years old or older at the time of the event. 
Syntax for both is below:

****To recode those who had not been born yet*****

compute berlinwall=q9d.
if missing (q9d) berlinwall=3.
if age le 21 berlinwall=4.
value labels berlinwall 1 'remember' 2 'dont remember' 3 'not old enough' 4 'not born' 9 'dk'.

compute challenger=q9e.
if missing(q9e) challenger=3.
if age le 24 challenger=4.
value labels challenger 1 'remember' 2 'dont remember' 3 'not old enough' 4 'not born' 9 'dk'.

compute nixon=q9g.
if missing (q9g) nixon=3.
if age le 36 nixon=4.
value labels nixon 1 'remember' 2 'dont remember' 3 'not old enough' 4 'not born' 9 'dk'.

compute moon=q9h.
if missing (q9h) moon=3.
if age le 41 moon=4.
value labels moon 1 'remember' 2 'dont remember' 3 'not old enough' 4 'not born' 9 'dk'.

compute mlk=q9i.
if missing (q9i) mlk=3.
if age le 42 mlk=4.
value labels mlk 1 'remember' 2 'dont remember' 3 'not old enough' 4 'not born' 9 'dk'.

compute jfk=q9j.
if missing (q9j) jfk=3.
if age le 47 jfk=4.
value labels jfk 1 'remember' 2 'dont remember' 3 'not old enough' 4 'not born' 9 'dk'.


****Analysis based on those who were eight or older*****

weight by weight.
TEMPORARY .
select if age ge 56 and (jfk le 2 or jfk=9).
freq jfk.

weight by weight.
TEMPORARY .
select if age ge 51 and (mlk le 2 or mlk=9).
freq mlk.

weight by weight.
TEMPORARY .
select if age ge 50 and (moon le 2 or moon=9).
freq moon.

weight by weight.
TEMPORARY .
select if age ge 45 and (nixon le 2 or nixon=9).
freq nixon.

weight by weight.
TEMPORARY .
select if age ge 33 and (challenger le 2 or challenger=9).
freq challenger.

weight by weight.
TEMPORARY .
select if age ge 30 and (berlinwall le 2 or berlinwall=9).
freq berlinwall.

weight by weight.
TEMPORARY .
select if age ge 24 and (q9c le 2 or q9c=9).
freq q9c.


