
PEW RESEARCH CENTER NEWS INTEREST INDEX
JANUARY 6-9, 2011 OMNIBUS
N=1,018

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

NOTE: Data collection was interrupted midfield period to ask about the Arizona shooting in the News Interest Index series.  
Item newpew3d and a modified Pew4 were added for Saturday and Sunday interviewing (Jan 8-9, 2011). In the dataset, NewPew3d/Oldpew3d and 
Newpew4/Oldpew4 were created when this change was made using the Version variable.



In the people-press release we decided to report both new pew3d/Pew4 from Sunday only (Jan 9, 2011) 
showing the new question and old pew3d/Pew4 for Thursday-Saturday interviewing (Jan 6-8, 2011) showing the old question.

To reproduce the published results of Question Pew.4, run the following syntax:

***SUNDAY ONLY INCLUDING GIFFORDS***.
weight by weight.
Temp.
select if  (int_date=10911).
fre newpew4.

weight off.
Temp.
select if  (int_date=10911).
fre newpew4.

***THURSDAY-SATURDAY INCLUDING PAKISTANI GOVERNOR***.
weight by weight.
Temp.
select if  (int_date LE 10811).
fre oldpew4.

weight off.
Temp.
select if  (int_date LE 10811).
fre oldpew4.