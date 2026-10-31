Pew Research Center for the People & the Press
Biennial Media Consumption Survey 2008

April 30-June 1, 2008

N=3615
Form 1: 1797
Form 2: 1818
Form A: 1776
Form B:	1839

**********************************************************************************************

This dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers (N=813). Cell phone interviews include households that are cell-only as well as those that also contain a landline phone. 

The dataset contains three weight variables, which can be used to compare the combined landline and cell phone sample with the landline sample by itself and with the landline sample combined with the cell-only households.


Weight Name: WEIGHT
Description: This is the weight for the combined sample of all landline and
cell phone interviews. This weight is used for all analysis in the July 1 and July 10 reports.

Weight Name: LLWEIGHT
Description: This weight is applied to the landline RDD sample only. Interviews
conducted by cellphone are not given a weight and are excluded
from analysis when this weight is used.

Weight Name: COWEIGHT
Description: This is the weight for the Landline RDD sample and the 
cell-only cases combined. Cases from the Cell Phone RDD sample that 
reported having a landline phone are not given a weight and are excluded from
analysis when this weight is used.

*********************************************************************************************



BELOW IS THE SPSS SYNTAX USED TO CREATE SPECIAL VARIABLES FOR ANALYSES SHOWN IN THE REPORT.


*******************************.
********KNOWLEDGE INDEX********.
*******************************.
An index ranging from 0 to 3 counting the number of items answered correctly in Q.71-Q.73.
In write-ups (and banners) High=3; Medium=1-2, Low=0.

If (Q71>1) and (Q72>1) and (Q73>1) knowledg=0.

If (Q71=1) and (Q72>1) and (Q73>1) knowledg=1.
If (Q71>1) and (Q72=1) and (Q73>1) knowledg=1.
If (Q71>1) and (Q72>1) and (QQ73=1) knowledg=1.

If (Q71=1) and (Q72=1) and (Q73>1) knowledg=2.
If (Q71=1) and (Q72>1) and (Q73=1) knowledg=2.
If (Q71>1) and (Q72=1) and (Q73=1) knowledg=2.

If (Q71=1) and (Q72=1) and (Q73=1) knowledg=3.


*******************************************.
********HARD NEWS CONSUMPTION INDEX********.
*******************************************. 

compute hardnews=2.
IF ((Q.74a<3) and (Q.74b<3) and (Q.74c<3) and (Q.74d<3)) hardnews=1.
IF ((Q.74a>2) and (Q.74b>2) and (Q.74c>2) and (Q.74d>2)) hardnews=3.
var lab hardnews 'Attention to Hard News'.
val lab hardnews (1)High (2)Moderate (3)Low.



*************************************.
********AUDIENCE SEGMENTATION********.
*************************************.
A key feature of this survey is an audience segmentation analysis, spearheaded by Joceyln Kiley. Her syntax is below.

***segmentation***

***create measure of online for news 3+ days per week***
**and sweep search engine users 3+ into the variable***

recode q49 (1=1) (2=1) (3 thru 9=0) (sysmis=99) into onln3day.
if q48 ge 2 onln3day=0.
if q52 le 2 onln3day=1.
variable labels onln3day 'online for news 3+ days per week'.
value labels onln3day
1 '3 or more days per week'
0 'none or less than 3 days per week'.
missing values onln3day(99).
fre onln3day.

**create segments using main source measure, hardnews measure, and online 3+ days***

compute segments=5.
if q42 le 3 and hardnews le 2 and onln3day=0 segments=1.
if q42 le 3 and hardnews le 2 and onln3day=1 segments=2.
if q42=4 and hardnews le 2 and onln3day=1 segments=3.
if hardnews=3 segments=4.
var labels segments 'news consumption audience segmentation'.
val labels segments
1 'traditionalist: not online, trad main source'
2 'integrators: online, trad main source'
3 'net-newsers: online, internet main source'
4 'disengaged: low on hardnews'
5 'other: other dk main source, or net main source (but not online)--not reported'.



**********************************.
********TIME SPENT RECODES********.
**********************************.
These are a standard element of the media consumption survey. This synatax was written by Joceyln Kiley.

***2008 RECODES FOR TIME SPENT WITH NEWS SOURCES YESTERDAY***

**time on internet (includes newspaper online)**
** First add time spent reading newspaper websites from q10.

IF (q9>1) q10time=0.
IF (q10=1) q10time=8.
IF (q10=2) q10time=23.
IF (q10=3) q10time=45.
IF (q10=4) q10time=70.
IF (q10=9) q10time=0.
COMPUTE q10_net=q10time.

** Zero out q10time if respondent did not spend any time reading the newspaper online.

DO IF (q11=1 | q11=9).
RECODE q10_net (else=0).
END IF.

** Count 75% of the value of q10time for those reading online version of newspaper more.

DO IF (q12=2).
RECODE q10_net (0=0) (8=6) (23=17) (45=34) (70=53).
END IF.

** Count 50% of the value of q10time for those reading print and online newspaper equally.

DO IF (q12=3).
RECODE q10_net (0=0) (8=4) (23=12) (45=23) (70=35).
END IF.

** Count 25% of the value of q10time for those who read print version of newspaper more.

DO IF (q12=1).
RECODE q10_net (0=0) (8=2) (23=6) (45=11) (70=18). 
END IF.
	
** Count 50% of the value of q10time for those who Dk'ed on q11a..

DO IF (q12=9).
RECODE q10_net (0=0) (8=4) (23=12) (45=23) (70=35).
END IF.

**** Add Online News Time from q19 ****.

IF (q18>1 or q18a>1) q19time=0.
IF (q19=1) q19time=8.
IF (q19=2) q19time=8.
IF (q19=3) q19time=8.
IF (q19=4) q19time=23.
IF (q19=5) q19time=23.
IF (q19=6) q19time=45.
IF (q19=7) q19time=70.
IF (q19=9) q19time=0.

COMPUTE net_time = q10_net + q19time.
RECODE net_time (0=0) (1 thru 14=8) (15 thru 29=23) (30 thru 59=45) (60 thru hi=70).

****  Account for DK/Refused ****.
** Identify those who DK'ed overall with respect to getting news online yesterday.
	
DO IF (q18=9).
RECODE net_time (else=99).
END IF.
	
** Identify those who read the newspaper online but DK'ed on the time in q10.
	
DO IF ((q10=9)   and   (q11=2 | q11=3)).
RECODE net_time (else=98).
END IF.

** Identify those who DK'ed on time in q19.

DO IF (q19=9).
RECODE net_time (else=98).
END IF.

VAL LAB net_time (0) No news online yest (8) 1-15 min (23) 15-29 min (45) 30-59 min 
                         (70) 60 min + (98) Yes but DK time (99) DK if yesterday .


**time reading newspaper (including newspaper online)**
*************** Create PP_TIME *****************.

	COMPUTE pp_time = q10time.

** Delete q10time q10_net and q19time - these were used for computational purposes only.

**time watching tv news--as in all prior surveys**
********* Create Television Time (TVX) *********.

IF (q13>1) tvx=0.
IF (q14=1) tvx=8.
IF (q14=2) tvx=23.
IF (q14=3) tvx=45.
IF (q14=4) tvx=70.
IF (q14=9) tvx=0.

**time listening to radio--as in prior surveys**
********** Create Radio Time (RADIOX) **********.

IF (q17=1) radiox=8.
IF (q17=2) radiox=23.
IF (q17=3) radiox=45.
IF (q17=4) radiox=70.
IF (q17=5) radiox=0.
IF (q17=9) radiox=0.

****************** Analysis for minutes spent with individual media types ********************.


	WEIGHT BY weight.
** Television.

	TEMP.
	SELECT IF (q13=1).
	DESCRIPTIVES  VARIABLES= tvx /STATISTICS=MEAN SEMEAN .

** Newspaper.

	TEMP.
	SELECT IF (pp_time>0).
	DESCRIPTIVES  VARIABLES= pp_time /STATISTICS=MEAN SEMEAN .

** Radio.

	TEMP.
	SELECT IF (q17<5).
	DESCRIPTIVES  VARIABLES= radiox /STATISTICS=MEAN SEMEAN .

** Internet.

	TEMP.
	SELECT IF (net_time>0 and net_time<98).
	DESCRIPTIVES  VARIABLES= net_time /STATISTICS=MEAN SEMEAN .

****analysis for time spent with news sources yesterday TOTAL**
****USE SAME VARIABLES FOR RADIO AND TV USED ABOVE TVX AND RADIOX***

**** Time reading NEWSPAPER, FOR TOTAL TIME SPENT ANALYSIS ****.
* EXCLUDES online newspaper time reported in q19 and q20.*

	IF (q9>1) paperx=0.
	IF (q10=1) paperx=8.
	IF (q10=2) paperx=23.
	IF (q10=3) paperx=45.
	IF (q10=4) paperx=70.
	IF (q10=9) paperx=0.	

**** Time getting news ONLINE ****.
* EXCLUDES online newspaper time reported in q10.

	IF (q18>1 or q18a>1) netx=0.
	IF (q19=1) netx=3.
	IF (q19=2) netx=8.
	IF (q19=3) netx=13.
	IF (q19=4) netx=18.
	IF (q19=5) netx=25.
	IF (q19=6) netx=45.
	IF (q19=7) netx=70.
	IF (q19=9) netx=0.

**** TOTAL Time ****.

COMPUTE totalx = tvx + paperx + radiox + netx.

***ANALYSIS BASED ON TOTALS**

WEIGHT BY weight.

	DESCRIPTIVES  VARIABLES= tvx paperx radiox netx totalx /STATISTICS=MEAN SEMEAN .


***ANALYSIS of TOTAL TIME SPENT BY AGE, SEGMENTS**

recode age (18 thru 29=1) (30 thru 39=2) (40 thru 49=3) (50 thru 64=4) (65 thru 97=5) (99=99) into age5cat.
val labels age5cat
1 '18-29'
2 '30-39'
3 '40-49'
4 '50-64'
5 '65+'.
fre age5cat.

WEIGHT BY weight.

mean totalx by age5cat
  /cel mean count stddev.

mean tvx paperx radiox netx totalx by segments
  /cel mean count stddev.


***adding online newspaper time to 30mins+ internet time for individual media time spent graph***

weight by weight.
compute inttim=0.
if Q19 ge 6 and q19 le 7 inttim=1.
if q11=2 and q10 ge 3 and q10 le 4 inttim=1.
if q12=2 and q10 ge 3 and q10 le 4 inttim=1.
var labels inttim 'Time spent on internet yesterday 30+ mins'.
val labels inttim
0 'less than 30 mins'
1 '30+ mins'.

compute onltime=q19.
recode onltime (1 thru 5=0) (6 thru 7=1) (else=0).
fre onltime inttim.

***Compute 4 media type variables for yesterday usage***.

compute tv=0.
if q13=1 tv=1.
compute radio=0.
if q17 le 4 radio=1.
compute paper=0.
if (q9=1) and (q11 ne 2) paper=1.
compute net=0.
if (q18=1) or (q11=2) or (q11=3) net=1.

***Create yesterday tally***.
compute yesterday=(TV +radio +paper +net).
val lab yesterday 0 'None' 1 'One' 2 'Two' 3 'Three' 4 'Four'.
recode yesterday (0=0) (1=1) (2 thru 4=2) into yestcol.
val label yestcol 0 'none' 1 'one' 2 'two or more'.

cros yestcol by segments /cel=col.

weight by weight.
temp.
select if yesterday ge 1.
MEANS
  TABLES=totalx tvx paperx radiox netx  BY age5cat
  /CELLS MEAN COUNT STDDEV SEMEAN  .



*******************************************************************************************.
********"TRADITIONAL SOURCES USED YESTERDAY COMPARED WITH ANY SOURCE USED YESTERDAY********.
*******************************************************************************************.
This syntax was prepared by Michael Dimock.

This syntax measures the net use of "traditional" sources "yesterday" as compared with the use of "any" source "yesterday".

weight by weight.
recode q9 (1=1) (2 thru 9=0).
recode q13f1 (1=1) (2 thru 9=0).
recode q17f1 (1 thru 4=1) (5 thru 9=0).
recode q18 (1=1) (2 thru 9=0).
if form=1 yestrad=q9+q13f1+q17f1.
if form=1 yestot=q9+q13f1+q17f1+q18.
freq yestrad yestot.
recode yestrad yestot (1 thru 4=1).
freq yestrad yestot.
recode age (18 thru 24=18) (25 thru 34=25) (35 thru 49=35) (50 thru 64=50) (65 thru 98=65) into age2.
cros age2 by yestrad yestot /cel row.

weight by weight.
recode q7 (1=1) (2 thru 9=0).
recode q9 (1=1) (2 thru 9=0).
recode q13 (1 thru 4=1) (5 thru 9=0).
recode q18 (1=1) (2 thru 9=0).
if form=1 yestrad=q7+q9+q13.
if form=1 yestot=q7+q9+q13+q18.
freq yestrad yestot.
recode yestrad yestot (1 thru 4=1).
freq yestrad yestot.
recode age (18 thru 24=18) (25 thru 34=25) (35 thru 49=35) (50 thru 64=50) (65 thru 98=65) into age2.
cros age2 by yestrad yestot /cel row.


****************************************************************************************.
********YESTERDAY SOURCES-SINGLE SOURCE, DUAL-SOURCE AND TRIPLE-SOURCE VARIABLES********.
****************************************************************************************.

This syntax was written by Shawn Neidorf.

***recreates table from bottom of page 11 in 2006 report***.


weight by weight.

***Compute 4 media type variables for yesterday usage***.

compute tv=0.
if q13=1 tv=1.
compute radio=0.
if q17 le 4 radio=1.
compute paper=0.
if (q9=1) and (q11 ne 2) paper=1.
compute net=0.
if (q18=1) or (q11=2) or (q11=3) net=1.


***Create yesterday tally***.
compute yesterday=(TV +radio +paper +net).
val lab yesterday 0 'None' 1 'One' 2 'Two' 3 'Three' 4 'Four'.
freq yesterday.



***THREE-SOURCE COMBOS***.

***TV, Paper, Radio***.
compute tpr=0.
if (tv=1) and (paper=1) and (radio=1) and (net ne 1) tpr=1.
freq tpr.

***Net and two others***.
compute n2others=0.
if (net=1) and (paper=1) and (radio=1) and (tv ne 1) n2others=1.
if  (net=1) and (paper=1) and (tv=1) and (radio ne 1) n2others=1.
if (net=1) and (radio=1) and (tv=1)  and (paper ne 1) n2others=1.
freq n2others.


***TWO-SOUCE COMBOS***.

***TV and paper***.
compute tvp=0.
if (net ne 1) and (radio ne 1) and (tv=1) and (paper=1) tvp=1.
freq tvp.

***Radio and TV***.
compute rtv=0.
if (net ne 1) and (paper ne 1) and (radio=1) and (tv=1) rtv=1.
freq rtv.

***radio & newspaper***.
compute rp=0.
if (net ne 1) and (tv ne 1) and (radio=1) and (paper=1) rp=1.
freq rp.

***Net and one other***.
compute net1=0.
if (net=1) and (paper=1) and (tv ne 1) and (radio ne 1) net1=1.
if (net=1) and (tv=1) and (paper ne 1) and (radio ne 1) net1=1.
if (net=1) and (radio=1) and (tv ne 1) and (paper ne 1) net1=1.
freq net1.

***ONE SOURCE***.

***TV***.
compute tvonly=0.
if (tv=1) and (radio ne 1) and (paper ne 1) and (net ne 1) tvonly=1.
freq tvonly.

***RADIO***.
compute radioonly=0.
if (radio=1) and (tv ne 1) and (paper ne 1) and (net ne 1) radioonly=1.
freq radioonly.

***PAPER***.
compute paperonly=0.
if (paper=1) and (tv ne 1) and (radio ne 1) and (net ne 1) paperonly=1.
freq paperonly.

***NET***.
compute netonly=0.
if (net=1) and (paper ne 1) and (tv ne 1) and (radio ne 1) netonly=1.
freq netonly.

