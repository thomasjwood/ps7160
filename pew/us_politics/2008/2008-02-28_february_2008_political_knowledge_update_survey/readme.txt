PEW RESEARCH CENTER FOR THE PEOPLE & THE PRESS
FEBRUARY 2008 POLITICAL KNOWLEDGE UPDATE SURVEY
February 28-March 2, 2008
N=1,003

Note Differences Between Variable Labels in Questionnaire and Dataset

Questionaire	Dataset
Q.1		qp1
Q.2		qp2
Q.3		qp3
Q.4		qp4
Q.5		qp5
Q.6		qp6
Q.7		qp7
Q.8		qp8
Q.9		qp9
Q.10		qp10
Q.11		qp11
Q.12		qp12
Q.13		qp13


*********SYNTAX TO CREATE KNOWLEDGE SCALE*********.
compute rice = 0.
if  qp2= 1 rice = 1.

compute sunni= 0.
if qp3 = 1 sunni = 1.

compute USkilled = 0.
if qp4 = 3  USkilled = 1.

compute McCain = 0.
if qp5 = 1 McCain = 1.

compute Reid = 0.
if qp6 = 1 Reid = 1.

compute house = 0.
if qp7 = 1house = 1.

compute Oprah = 0.
if qp8 = 1 Oprah = 1.

compute Chavez = 0.
if  qp9= 1 Chavez = 1.

compute Dow = 0.
if qp10 = 4 Dow = 1.

compute Dean= 0.
if qp11 = 1 Dean = 1.

compute Bernanke = 0.
if qp12 = 1 bernanke = 1.

compute Kosovo = 0.
if qp13 = 1 kosovo = 1.
exe.

compute know12=sum(Rice to kosovo).



