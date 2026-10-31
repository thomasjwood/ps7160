PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
MARCH 2011 POLITICAL TYPOLOGY SURVEY
February 22-March 1, 2011 N=1,504
March 8-14, 2011 N=1,525
COMBINED N=3,029

This survey was conducted over two field periods. Survey A was conducted from February 22-March 1, 2011 and 
Survey B was conducted from March 8-14, 2011. Some questions ran only on Survey A, others only on Survey B, 
and others were on both and are reported based on the combined total. 
The questionnaire identifies whether each question was only on Survey A, Survey B, or on both.  
The SURVEY variable identifies whether a respondent is from Survey A or Survey B.

A re-contact survey with 1,432 of the original respondents was conducted April 7-10. Please see the separate dataset 
"2011 Typology Recontact Survey" for additional information about that survey.

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

POLITICAL TYPOLOGY SYNTAX

* WARNING: The following syntax shows the steps used to construct the Pew Research Center 2011 Political Typology. 
  If you are attempting to recreate the Typology using a dataset different from this 2011 survey, you will almost certainly 
  end up with different groups that may or may not fit the same descriptions. 
  The only way to replicate the same groups in the this typology is to use a different statistical procedure, which we can make available.  

**BASIC METHODOLOGY FOR 2011 PEW RESEARCH CENTER TYPOLOGY**.
* The typology methodology consists of two basic stages -- a factor analysis of items to identify underlying value dimensions, and a cluster analysis
  that uses value scales and party ID to group respondents.
* Each of these stages has a number of specific elements and methodological choices, which are outlined below.
* Throughout is some analytical syntax that is not essential to the final cluster solution -- most were exploratory methods or secondary ways
  to confirm results -- in most cases these lines of syntax are "starred" out so they will not run if you run the entire syntax to replicate the 
  final results.
* IMPORTANT: The following syntax will recode a number of items in the dataset without renaming them -- do not save over the original dataset if you wish to
  maintain the original coding of the variables.

*************************************.
********* STAGE ONE: FACTOR *********.
*************************************.
***COMPUTE NEW VARIABLES TO BE USED IN THE FACTOR ANALYSIS AND SUBSEQUENT SCALING***.
***NOTE, THIS APPROACH USES JUST THE TYPOLOGY STATEMENTS, WITHOUT STRENGTH. THROUGHOUT THE ANALYSIS
 (FACTOR, SCALING, AND CLUSTER ANALYSIS), WE COMPARED APPROACHES THAT INCLUDED STRENGTH TO THOSE WITHOUT
AND FOUND THE SAME DYNAMICS AT WORK, ULTIMATELY DECIDING TO USE A MODEL WITHOUT STRENGTH*.
compute GovWaste2 = q17a.
compute Regulate2 = q17b.
compute PoorEasy2 = q17c.
compute GovNeedy2 = q17d.
compute Discrimi2 = q17f.
compute ImmBurdn2 = q17g.
compute PeaceStr2 = q17i.
compute WorkHard2 = q17k.
compute Success2 = q17l.
compute BusPower2 = q17m.
compute BusProft2 = q17n.
compute LoseTch2 = q17o.
compute OffCare2 = q17p.
compute ProtEnv2 = q37q.
compute LawsCost2 = q37r.
compute Homosex2 = q37u.
compute ReligImp2=q37w.
compute SatFin2 = q37y.
compute MakeEnds2 = q37z.
compute NeccGod2=q37aa.
compute ForcTerr2=q37bb.
compute ImmCult2=q37dd.
compute BlackEq2=q37hh.

**INITIAL FACTOR ANALYSIS AND SCALING ANALYSIS WAS RUN ON THE FULL SET OF TYPOLOGY ITEMS--Q17 AND Q37--AFTER THE COMPLETION OF SURVEY A.
***THROUGH THIS ANALYSIS, WE DETERMINED SEVERAL ITEMS COULD BE CUT, BECAUSE THEY WOULD NOT BE A COMPONENT OF A FINAL 
SCALE. SOME ITEMS WERE CUT BECAUSE THEY WERE UNNECCESARY ADDTIONS TO EXISTING SCALES (E.G., BOOKS2 AND GOVMORAL2 FIT WITH THE 
RELIGION SCALE, BUT WERE NOT NECESSARY TO CONSTRUCT THAT SCALE), OR BECAUSE THEY DID NOT FIT WELL WITH OTHER TYPOLOGY ITEMS (E.G., NOLIMITS2).**.
*do if survey=1.
*compute PosBlack2 = q17e.
*compute WilFight2 = q17j.
*compute NoLimits2 = q37s.
*compute USAsolve2 = q37t.
*compute Books2 = q37v.
*compute Allies2 =q37cc.
*compute Active2 =q37ee.
*compute CivLib2 =q37ff.
*compute GovMoral2 =q37gg.
*end if.
***NOTE: AN ADDITIONAL ITEM q37ii WAS ADDED IN SURVEY B, BUT BECAUSE IT IS NOT FULL FORM, IN THIS ANALYSIS IT WAS SOLELY USED AS A DEPENDENT 
VARIABLE**.
*do if survey=2.
*compute wallst2=q37ii.
*end if.

***RECODE WITHOUT STRENGTH***.
recode GovWaste2 to BlackEq2 (1,2=-1) (5,9=0) (3,4=1).
value labels GovWaste2 to BlackEq2 -1 'statement 1' 0 "Both/DK/Refused" 1 'statement 2'.


****CREATE BYSTANDER GROUP*****.
**DEFINITION OF BYSTANDERS - NOT REGISTERED TO VOTE, SELDOM OR NEVER VOTE AND DO NOT FOLLOW GOVERNMENT AND PUBLIC AFFIARS MOST OF THE TIME**. 
compute bys=0.
if ((regist>1) and (oftvote=4 or oftvote=5) and (folgov2>1)) bys=1.
format bys (F1.0).

***SEVERAL APPROACHES TO PARTY WERE ALSO EXPLORED. THE FINAL MODEL INCLUDES VARIABLES FOR REPUBLICAN AND DEMOCRAT.
***THIS IS THE APPROACH THAT HISTORICALLY HAS BEEN USED IN THIS PROJECT**.
***THE 2004 MODEL ALSO INCLUDED IDEOLOGY, WHICH WAS ALSO EXPLORED, BUT NOT USED TO CREATE THE FINAL TYPOLOGY***.
compute party7=0.
if party=1 & partystr=1 party7=1.
if party=1 & partystr>1 party7=2.
if partyln=1 party7=3.
if party=2 & partystr=1 party7=7.
if party=2 & partystr>1 party7=6.
if partyln=2 party7=5.
if partyln>2 party7=4.

recode party7 (1=3) (2=2) (3=1) (else=0) into rep.
recode party7 (7=3) (6=2) (5=1) (else=0) into dem.
val lab party7 1 'Strong Rep' 2 'Not strong R' 3 'Lean Rep' 4 'No leaning' 5 'Lean Dem' 6 'Not strong D' 7 'Strong Dem'.
val lab rep 3 'Str Rep' 2 'Not str Rep' 1 'Lean Rep' 0 'All else'.
val lab dem 3 'Str Dem' 2 'Not str Dem' 1 'Lean Dem' 0 'All else'.
format party7 rep dem (f1.0).


****FINAL FACTOR ANALYSIS****.
weight by weight.
temp.
SELECT IF (bys NE 1).
factor variables=
  BlackEq2 Discrimi2 PoorEasy2 GovNeedy2 PeaceStr2 ForcTerr2 ProtEnv2 LawsCost2 BusPower2 BusProft2
  GovWaste2 Regulate2 LoseTch2 OffCare2 Homosex2 ReligImp2  NeccGod2  SatFin2 MakeEnds2
  ImmBurdn2  ImmCult2 WorkHard2 Success2
  /CRITERIA ITERATE(100)
  /FORMAT=SORT BLANK (.0)
  /ROTATION VARIMAX
  /WIDTH=80.


***FACTOR STAGE METHODOLOGICAL NOTES***.
* The above Factor analysis is used to identify core value dimensions, but is not the sole determinant of the scales used in the final typology analysis. 
* The dimensions identified by this analysis are then subjected to Scale Reliability Analysis (syntax not archived because it includes a lot of 
  replication), and items which are not contributing to scale reliability (items which do not increase the scale's Alpha score -- pay attention to the 
  "Alpha if item removed" column) are removed.
* The reliability analysis also reveals relevant divisions among items that the Factor analysis may not.
* Historically, the Typology analysis has used additive scales rather than the  actual factor loadings in constructing the final thematic value dimensions.
* There are three reasons for using additive scales:
   -- first, it is a simpler method to explain to the report's consumers
   -- second, the cluster analysis simply works better (i.e. it results in cleaner and more distinct groupings) when additive scales are used
   -- third, we have no conceptual reason to believe certain index items should have more weight than others in the final scale -- our default is
      therefore to weight all items equally (additive index).
* In short, there is no single mathematical process that determines the underlying value dimensions -- Numerous factor models were run with different
  items included and removed to verify the robustness of different value  dimensions -- Alpha testing is used to further validate the additive scales
  used -- And judgments based the conceptual validity of results and on the historical legacy of past typology studies play a role in defining the
  final scales.


***SCALING***.
**SCALING IS AN ITERATIVE PROCESS, DOCUMENTED HERE ARE THE FINAL SCALES, INFORMED BY FACTOR ANALYSIS AS WELL AS THE SCALES OF PAST YEARS.
* IN SEVERAL CASES, ADDITIONAL SCALES WERE EVALUATED. IN PARTICULAR, ALTERNATIVE MODELS OF THE GOVERNMENT PERFORMANCE SCALE AND THE RACE 
SCALE WERE CONSIDERED**.
weight by weight.
recode Discrimi2 (1=-1) (-1=1).
compute ADDrace2=Discrimi2+BlackEq2.

recode GovNeedy2 (1=-1) (-1=1).
compute ADDpoor2=PoorEasy2+GovNeedy2.

recode ForcTerr2 PeaceStr2 (1=-1) (-1=1).
compute ADDFor2=ForcTerr2+PeaceStr2.

recode ProtEnv2 (1=-1) (-1=1).
compute ADDenvir2=LawsCost2+ProtEnv2.

compute ADDbus2=BusPower2+BusProft2.

recode GovWaste2 (1=-1) (-1=1).
compute ADDgovperf2=GovWaste2+Regulate2.

recode ReligImp2 (1=-1) (-1=1).
compute ADDRelig2=NeccGod2+ReligImp2+Homosex2.

recode SatFin2 (1=-1) (-1=1).
compute ADDfinan2=SatFin2+MakeEnds2.

recode ImmCult2 (1=-1) (-1=1).
compute ADDimmig2=ImmCult2+ImmBurdn2.

**THIS SCALE NOT USED IN THE FINAL CLUSTER SOLUTION*
*recode WorkHard2 (1=-1) (-1=1).
*compute ADDindivid2=Success2+WorkHard2.

**THIS SCALE WAS NOT IN THE FINAL CLUSTER SOLUTION. MANY GROUPS HAVE HIGHLY NEGATIVE VIEWS OF GOVERNMENT 
RESPONSIVNESS, AND ITS ADDITION APPEARED TO FORCE THE CREATION OF GROUPS THAT HELD HIGHLY POSITIVE VIEWS OF GOVERNMENT 
RESPONSIVENESS**
*recode LoseTch2 (1=-1) (-1=1).
*compute ADDgovresp2=LoseTch2+OffCare2 .

****standardize weight for cluster analysis****.
weight off.
compute stweight=weight/3.25026305170872.

***standardized SCALES here***.
WEIGHT BY WEIGHT.
desc ADDRelig2 ADDFor2 ADDfinan2 ADDimmig2 ADDgovperf2 ADDenvir2 ADDbus2 ADDpoor2 ADDrace2 rep dem /save.

******REGRESSION ANALYSIS********.
* As a preliminary step before creating typology groups, we investigate whether these basic value dimensions "predict" specific policy or political
  attitudes effectively and in the expected directions.
* Note that for the regression analysis, all value indices are used as independent variables "predicting" attitudes, and all are "normalized" using
  the desc /save command to creat z-scores.
*An example is shown here, but several dependent variables were tested***.
*WEIGHT BY WEIGHT.
*do if survey=1.
*compute obamastr=.5.
*if qa1a=1 and qa1=1 obamastr=1.
*if qa1a>1 and qa1=1 obamastr=.75.
*if qa1a=1 and qa1=2 obamastr=0.
*if qa1a>1 and qa1=2 obamastr=.25.
*end if.
*TEMP.
*select if survey=1.
*reg dep obamastr  /method=enter addreligst addindivst addforst addfinst addimmigst addgovperfst addgovrespst 
addenvirst addbusst addpoorst addracest party7st/select = bys ne 1.


****CLUSTER ANALYSIS**.
**FINAL CLUSTER SOLUTION. YOU MUST RUN THIS CLUSTER SOLUTION TO PRODUCE THESE EXACT GROUPS. IT IS SORTED BY A RANDOMLY 
GENERATED NUMBER, BUT EVEN SLIGHTLY DIFFERENT RANDOMIZATIONS MAY PRODUCE DIFFERENCES
MANY DIFFERENT MODELS WERE RUN, WITH DIFFERENT SPECIFICATIONS, AND USING DIFFERENT RANDOMIZATIONS. THE TYPOLOGY HERE INCLUDES 
GROUPS AND CHARACTERISTICS THAT EMERGED IN MANY MODELS**

******DO THIS TO GET RANDOM #S. NOTE: IF YOU RE-RUN THE RANDOMIZATION, YOU WILL GET A DIFFERENT ORDER. TO REPLICATE THE RESULTS IN THE 2011 POLITICAL TYPOLOGYS, 
USE THE SAVED RANDOMIZATION CALLED RANDOMTYPO***.* .
*compute randomtypo = uniform(3029).
*variable label randomtypo 'Case Randomization--sort for typology cluster groups'.

* WARNING: Groups come out of the cluster analysis in a virtually random order.
  The final recode statement before the value labels will not apply to all cluster solutions. Even a slight modification to the syntax will result in 
  assigning different numerical values to the typology groups, requiring modifications to this recode command before applying the value labels.

* NOTE: In the process of determining the final cluster solution for the 2011 typology a number of different models were tested, the basic variations being:
   -- changing the number of groups (7,8,9,10) this is done using the clust(x) subcommand
   -- Using different cluster analysis approaches available in SPSS (two-step cluster, quick cluster)
   -- Entering party in different ways (historically, party has been entered as it is here, two measures)
   -- including/excluding scales (in this case, neither the individualism scale nor the government responsiveness scale were included. models that excluded 
      the race scale, or the financial satisfaction scale were also tested.
* The effectiveness of various cluster solutions was evaluated by the following criteria:
   -- first and foremost, the substantive differences between groups -- did overall group profiles differ from each other in meaningful and important
      ways that make sense in the current political climate
   -- are the differences between groups along politically relevant value dimensions -- for example, if a cluster solution created groups that
      differed ONLY in their attitude about financial satisfaction, that is inferior to a solution that discriminates groups along more politically salient 
      dimensions (such as foreign assertiveness or religion and morality) or ideally that discriminates along multiple dimensions simultaneously.
  -- whether the solution creates groups of large enough size that we had enough cases to analyze their views on other survey questions.

weight by stweight.
sort cases by randomtypo.
temp.
select if bys ne 1.
quick cluster 
    ZADDRelig2 ZADDFor2 ZADDfinan2 ZADDimmig2  ZADDgovperf2 ZADDenvir2 ZADDbus2 ZADDpoor2 zaddrace2 Zrep Zdem 
    /method=kmeans(noupdate)   /print initial anova cluster distance
    /missing=listwise  /criteria=  mxiter(50) clust(8) 
    /save clust (typoinitial) distance (typodis8).
*means typodis8 by typoinitial.
recode typoinitial (5=1) (7=2) (3=3) (2=4) (8=5) (6=6) (1=7) (4=8) (sysmis=11) into finaltypo.

var lab finaltypo 'Typology Groups' .
VAL LAB finaltypo 1 "Solid Liberals" 2 "Hard-Pressed Dems" 3 "New Coalition Dems" 4 "Post-Moderns" 5 "Disaffecteds" 6 "Libertarians" 7 "Main St. Republicans" 8 "Staunch Conservatives" 11 "Bystanders".

