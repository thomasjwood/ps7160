PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
MARCH 2009 POLITICAL KNOWLEDGE UPDATE SURVEY
MARCH 26-29, 2009
N=1,003


Note Differences Between Variable Labels in Questionnaire and Dataset

Questionaire	Dataset
Q.1a		qm1a
Q.1		qm1
Q.2		qm2
Q.3		qm3
Q.4		qm4
Q.5		qm5
Q.6		qm6
Q.7		qm7
Q.8		qm8
Q.9		qm9
Q.10		qm10
Q.11		qm11 


*********SYNTAX TO CREATE KNOWLEDGE SCALE*********.
compute house = 0.
if  qm1= 1 house = 1.
compute border= 0.
if qm2 = 1 border = 1.
compute dow = 0.
if qm3 = 3  dow = 1.
compute afghan = 0.
if qm4 = 1 afghan= 1.
compute autos= 0.
if qm5 = 1 autos = 1.
compute geithner = 0.
if qm6 =1 geithner = 1.
compute hillary = 0.
if qm7 = 1 hillary = 1.
compute killed = 0.
if  qm8= 3 killed = 1.
compute unemployment = 0.
if qm9 = 2 unemployment = 1.
compute bernanke= 0.
if qm10 = 1 bernanke = 1.
compute china = 0.
if qm11 = 1 china = 1.
compute lend = 0.
if qm12 = 1 lend= 1.
compute know12=sum(house to lend).