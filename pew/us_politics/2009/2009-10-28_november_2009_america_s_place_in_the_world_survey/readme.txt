PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
NOVEMBER 2009 AMERICA'S PLACE IN THE WORLD SURVEY

America's Place in the World V is the fifth quadrennial survey of the public and foreign policy experts. 
The general public survey was an RDD telephone survey conducted on cell phones and landlines with 2,000 adults from 
October 28 to November 8, 2009 in Spanish and English. In addition, a survey of foreign policy experts was conducted 
from October 2 to November 16, 2009 using a random sample of members of the Council on Foreign Relations.
A total of 642 members responded (506 by web and 136 by phone). A third telephone survey of the general public was conducted 
on an omnibus survey of cell phones and landlines with 1,003 adults November 12-15, 2009. 
This readme files cocerns only the general public survey conducted October 28 to November 8, 2009.

***************************************************************************************************************************

This GP dataset includes cell phone interviews conducted using an RDD sample of cell phone numbers. 
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

To protect the privacy of respondents, telephone numbers, county of residence and zip code have been removed from the data file.

***************************************************************************************************************************

HISP2 and HISP3 were each asked of half of the sample.  HISPX combines these variables and is the full sample Hispanicity variable.

***************************************************************************************************************************

The generic ballot horse race variable (cheat) was computed using the following syntax:

do if regicert=1.
compute cheat=0.
if (q3=1 or q3a=1) cheat=1.
if (q3=2 or q3a =2) cheat=2.
if (q3=3 and (q3a=3 or q3a=9)) cheat=3.
if (q3=9 and (q3a=3 or q3a=9)) cheat=9.
end if.
var lab cheat 'Congressional trial heat combined with leaners'.
val lab cheat  1 “Rep/lean Rep” 2 “Dem/lean Dem' 3 'Other-lean other (VOL.)’ 9 'DK-no lean (VOL.)'.

***************************************************************************************************************************

