PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
DECEMBER 2008 POLITICAL KNOWLEDGE UPDATE SURVEY
DECEMBER 4-7, 2008
N=1,000


Note Differences Between Variable Labels in Questionnaire and Dataset

Questionaire	Dataset
Q.1		qr1
Q.2		qr2
Q.3		qr3
Q.4		qr4
Q.5		qr5
Q.6		qr6
Q.7		qr7
Q.8		qr8
Q.9		qr9
Q.10		qr10
Q.11		qr11 (VOTER REGISTRATION - NOT A KNOWLEDGE QUE)


*********SYNTAX TO CREATE KNOWLEDGE SCALE*********.
recode qr1 qr4 qr6 qr9 (1=1)(else=0).
recode qr2 qr5 qr7 (2=1)(else=0).
recode qr3 qr8 qr10 (3=1)(else=0).
count know = qr1 to qr10 (1).

