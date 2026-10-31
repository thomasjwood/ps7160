2010 Biennial Media Consumption Study
June 8-28, 2010
N=3,006 (2,005 landline interviews, 1,001 cell phone interviews)

Questions about media believability were asked on a separate omnibus survey conducted July 8-11, 2010.
N=1,001 (670 landline interviews, 331 cell phone interviews)
Data from this survey are available separately.

Both surveys were conducted in English.

**************************************************************************************************************************

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

To protect the privacy of respondents, telephone numbers, county of residence and zip code have been removed 
from the public data file.

***************************************************************************************************************************

***"Digital" versus "online" news***.
"Throughout this report, the phrase "online news" refers to news from newspaper websites or from online
news sources generally. "Digital news" is a broader category that includes news from newspaper websites
and other online sources, as well as news consumed through specific technologies, such as cell phones,
email, RSS, Twitter, social networking and podcasts." --Footnote on page 2 of the lede.

***************************************************************************************************************************

***Using traditional and/or digital platforms yesterday***.
This syntax determines which respondents consumed traditional news, digital news or both. 
It is discussed in the lede and section 1 of the report.

*"TRADITIONAL SOURCES USED YESTERDAY COMPARED WITH ANY SOURCE USED YESTERDAY*.
compute print=0.
if q11=1 or q11=3 print=1.
var label print "News from print newspaper yesterday".
count yestrad= print q13 (1) q17 (1 thru 4).
recode yestrad (1 thru 3=1) (0=0).
variable label yestrad "Any traditional news yesterday from TV, radio, print newspaper".

compute podcast=0.
if q71=1 and q40d=1 podcast=1.
count yesdigital= q18 q49a q52a q55a q57a q61a podcast (1).
recode yesdigital (1 thru 7=1) (0=0).
if q11=2 or q11=3 yesdigital=1.
variable label yesdigital "Any digital news yesterday: online including online newspapers, cell, 
email, RSS, Twitter, SNS, podcast (if has iPod)".

count yescomplete= q9 q13 q18 q49a q52a q55a q57a q61a podcast (1) q17 (1 thru 4).
recode yescomplete (1 thru 10=1) (0=0).
variable label yescomplete "Any news yesterday from TV, radio, newspapers any online or technology source".

if yesdigital=1 and yestrad=1 yescombined=3.
if yesdigital=1 and yestrad=0 yescombined=2.
if yesdigital=0 and yestrad=1 yescombined=1.
if yesdigital=0 and yestrad=0 yescombined=0.
var lab yescombined "Summary of news from traditional and digital sources yesterday".
val lab yescombined 0 'No news yesterday' 1 'Traditional only' 2 'Digital only' 3 'Both'.

***************************************************************************************************************************

***Minutes of news consumed yesterday***.
Minutes of news consumption are covered in the report's introduction and Section 1.
Syntax to compute the number of minutes of news consumed yesterday was run on a file that combines 
data from media consumption surveys across multiple years. 
Please contact the Pew Research Center for the People & the Press for questions about these calculations
at 202-419-4350 or info@people-press.org

***************************************************************************************************************************

***Defining internet users***
This survey used two questions to determine whether a respondent was an internet user, INT1 and INT2.
Respondents who answered yes to EITHER INT1 or INT2 were considered internet users. This differs from
2008 and earlier.

INT1: "Do you use the internet, at least occasionally?"
INT2: "Do you send or receive email, at least occasionally?"

The i_user variable combines these into a single internet user variable.

***************************************************************************************************************************

***This syntax computs net net regular consumption for online/digital sources is covered in section 2.***
compute online_netreg =0.
if q41 le 2 or q43 le 2 or q46=1 or q49=1 or q50=1 or q51=1 or q55=1 or q57=1 or q61=1 or (q70=1 and q40d=1) 
online_netreg=1.

***************************************************************************************************************************

***Knowledge index***
An index ranging from 0 to 4 counting the number of items answered correctly in Q.85-88. Correct answer is punch 1 in all cases.
count knowindex= q85 q86 q87 q88 (1).
var lab knowindex 'Knowledge index'.

***************************************************************************************************************************

The media consumption survey has routinely asked about how often respondents watch the NewsHour. 
Prior iterations of the question included mentions of "Jim Lehrer" and of "MacNeil-Lehrer" in the item 
wording. However, PBS has rebranded the show without the name of a host. Hence, we asked about "The 
PBS NewsHour," the show's current name, throughout the survey and in the believability survey. 
The demographic profile of the respondents who said they regularly watched the NewsHour differed 
substantially from the profile in 2008, leading us to conclude that the new name that did not mention any hosts 
may have caused some confusion. We included a footnote about this in the topline (Footnote #18) and did not 
discuss the NewsHour in the report because of this concern. The footnote was expanded upon on September 23,
2010 and the topline was reposted on the website.

***************************************************************************************************************************

HISP3 and HISP4 were each asked of half of the sample.  HISPCMB combines these variables and is the full sample Hispanicity variable.

***************************************************************************************************************************


