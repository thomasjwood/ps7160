PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
JUNE 2009 OMNIBUS SURVEY
June 18-21, 2009 
N=1,005


Most of this survey was analyzed as part of the science project, which involved two other surveys, an RDD telephone survey of the 
general public, conducted on cell phones and landlines with 2,001 adults from April 28 to May 12, 2009 in Spanish and 
English, and a web-based survey of scientists drawn from the membership of the American Association for the Advancement 
of Science. That survey was conducted May 1 to June 14, 2009, with 2,533 respondents. This document concerns only the 
omnibus survey conducted June 18-21, 2009. For more details, see the "About the surveys" section at the end of the scientists report 
released on Thursday, July 9, 2009, titled: "Public Praises Science; Scientists Fault Public Media."

***************************************************************************************************************************

This dataset includes cell phone interviews conducted using an RDD sample of landline and cell phone numbers. 
Cell phone interviews include households that are cell-only as well as those that also have a landline phone. 
WEIGHT is the weight for the combined sample of all landline and cell phone interviews and should be used for all analysis of this data. 

***************************************************************************************************************************

Beginning in the Fall of 2008, the Pew Research Center started using respondents’ self-reported zip code as  
the basis for geographic variables such as region, state and county. We do this because the error rate in the original 
geographic information associated with the sample is quite high, especially for respondents from the cell phone sample. 

For respondents who do not provide a zip code or for those we cannot match, we use the sample geographic information. 
We continue to include the original sample geographic variables in the datasets (these variables are preceded by an ‘s’) 
for archival purposes only.

***************************************************************************************************************************

Because this was an omnibus, the question numbering in the topline does not match the question
numbers embedded in the variable names in the SPSS file. They can be matched as follows:

DATASET			QUESTIONNAIRE/TOPLINE
pew1a			2a	(spending for scientific research)
pew1bf1			2bf1	(spending for health care)
pew1cf1			2cf1	(spending for energy)
pew1df1			2df1	(spending for anti-terrorism defenses in the U.S.)
pew1ef1			2ef1	(spending for education)
pew1ff1			2ff1	(spending for veterans benefits and services)	
pew1gf1			2gf1	(spending for economic assistance to needing people around the world)
pew1hf2			2hf2	(spending for military defense)
pew1if2			2if2	(spending for the State Department and American embassies)
pew1jf2			2jf2	(spending for government assistance for the unemployed)
pew1kf2			2kf2	(spending for agriculture)
pew1lf2			2lf2	(spending for Medicare)
pew1mf2			2mf2	(spending for combating crime)
pew1nf2			2nf2	(spending for environmental protection)
pew2			11	(Pluto no longer a planet)			
pew3			12	(Earthquake under ocean can cause a tsunami)
pew4			13	(GPS systems rely on satellites)
pew5			14	(Carbon dioxide believed to cause atmoshperic temps to rise)
pew6			15	(Water recently discovered on Mars)
pew7			16	(Aspirin prevents heart attacks)
pew8			17	(Stem cells can develop into many types of cells)
pew9			18 	(democrats have majority in House)	
pew10			19	(Susan Boyle was surprise on Britain's Got Talent)	
pew11a			20a	(All radioactivity NOT man-made)
pew11b			20b	(Electrons are smaller than atoms)
pew11c			20c	(Lasers do NOT work by focusing sound waves)
pwe11d			20d	(Antibotics will NOT kill viruses as well as bacteria)
pew11e			20e	(Continental drift is happening)
pew12			21	(spend more to help economy recover or reduce deficit)
sex			d1	(sex)
age			d2	(age)
educ			d4	(education)
hisp			d5	(hispanic ethnicity)
race			d6	(race)

***************************************************************************************************************************


The following syntax can be used to recreate the science knowledge scale used in the report.

compute pluto = 0.
if  pew2= 1 pluto = 1.

compute tsunami= 0.
if pew3 = 1 tsunami = 1.

compute GPS = 0.
if pew4 = 1  GPS= 1.

compute Carbon= 0.
if pew5 = 1 Carbon= 1.

compute Mars= 0.
if pew6 = 1 Mars = 1.

compute Aspirin = 0.
if pew7 =1 Aspirin = 1.

compute stemcell = 0.
if pew8 = 2 stemcell= 1.

compute radioactive=0.
if pew11a=2 radioactive=1.

compute electrons=0.
if pew11b=1 electrons=1.

compute lasers=0.
if pew11c=2 lasers=1.

compute antibiotics=0.
if pew11d=2 antibiotics=1.

compute tectonics=0.
if pew11e=1 tectonics=1.

compute know12=sum(pluto to tectonics).
recode know12 (0 thru 6=1) (7 thru 9=2) (10 thru 12=3) into know3.
val lab know3 (1)Low (2)Mid (3)High. 




