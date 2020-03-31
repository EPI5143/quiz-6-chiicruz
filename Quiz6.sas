/*
EPI5143 Winter 2020 Quiz 6.
Due Tuesday March 31st at 11:59PM via Github (link will be provided)

Using the Nencounter table from the class data:
a) How many patients had at least 1 inpatient encounter that started in 2003?
b) How many patients had at least 1 emergency room encounter that started in 2003? 
c) How many patients had at least 1 visit of either type (inpatient or emergency room encounter) that started in 2003?
d) In patients from c) who had at least 1 visit of either type, create a variable that counts the total number encounters (of either type)-for example, a patient with one inpatient encounter and one emergency room encounter would have a total encounter count of 2. Generate a frequency table of total encounter number for this data set, and paste the (text) table into your assignment- use the SAS tip from class to make the table output text-friendly
ie: 
options formchar="|----|+|---+=|-/\<>*"; 
Additional Info/hints
-you only need to use the NENCOUNTER table for this question 
-EncWID uniquely identifies encounters
-EncPatWID uniquely identifies patients
-Use EncStartDtm to identify encounters occurring in 2003
-EncVisitTypeCd identifies encounter types (EMERG/INPT)

-You will need to flatfile to end up 1 row per patient id, and decide on a strategy to count inpatient, emerg and total encounters for each patient to answer each part of the assignment. 
-There are many ways to accomplish these tasks. You could create one final dataset that can be used to answer all of a) through d), or you may wish to create different datasets/use different approaches to answer different parts. Choose an approach you are most comfortable with, and include lots of comments with your SAS code to describe what your code is doing (makes part marks easier to award and a good practice regardless).

Please submit your solutions through Github as a plain text .sas or .txt file. 
*/

libname source "D:\uOttawa\4 EPI 5143-large data\class data\ntables";

*retrieve dataset;
data enc;
set source.nencounter (keep=EncWID EncPatWID EncStartDtm EncVisitTypeCd);
admindate=datepart(EncStartDtm);
format admindate date9.;
if admindate<'01JAN2003'd then delete;
run;
*n=13389;

*remove duplicates;
proc sort data=enc out=encnodup nodupkey;
by EncWID;
run;
*no duplicates;

*a) How many patients had at least 1 inpatient encounter that started in 2003?;
data enc;
set enc;
inpt=0;
if EncVisitTypeCd="INPT" then inpt=1;*inpatient flag;
run;

proc means data=enc;
class encPatWID;
types encPatWID;
var inpt;
output out=inpt max(inpt)=inpt n(inpt)=count1;
run;

ods listing;
options formchar="|----|+|---+=|-/\<>*"; 
proc freq data=inpt;
tables inpt count1;
title 'Admissions from 01JAN2003 with Inpatient Visits';
run;

/*
                           Admissions from 01JAN2003 with Inpatient Visits                           2
                                                                         12:58 Tuesday, March 31, 2020

                                          The FREQ Procedure

                                                       Cumulative    Cumulative
                      inpt    Frequency     Percent     Frequency      Percent
                      ---------------------------------------------------------
                         0        6338       61.50          6338        61.50
                         1        3967       38.50         10305       100.00
*/
/* ANSWER: There are 3967 patients had at least 1 inpatient encounter that started in 2003*/

*b) How many patients had at least 1 emergency room encounter that started in 2003?; 
data enc;
set enc;
emerg=0;
if EncVisitTypeCd="EMERG" then emerg=1;*emerg flag;
run;

proc means data=enc;
class encPatWID;
types encPatWID;
var emerg;
output out=emerg max(emerg)=emerg n(emerg)=count2;
run;

ods listing;
options formchar="|----|+|---+=|-/\<>*";
proc freq data=emerg;
tables emerg count2;
title 'Admissions from 01JAN2003 with Emergency Visits';
run;

/*
                           Admissions from 01JAN2003 with Emergency Visits                         452
                                                                         12:58 Tuesday, March 31, 2020

                                          The FREQ Procedure

                                                        Cumulative    Cumulative
                      emerg    Frequency     Percent     Frequency      Percent
                      ----------------------------------------------------------
                          0        3064       29.73          3064        29.73
                          1        7241       70.27         10305       100.00


*/
/* ANSWER: There are 7241 patients had at least 1 emergency encounter that started in 2003*/


*c) How many patients had at least 1 visit of either type (inpatient or emergency room 
encounter) that started in 2003?;

*link inpatient and emerg datasets;
proc sql;
create table sql_final as
select em.*,in.*
from emerg as em
	 left join
     inpt as in
	 on em.encPatWID = in.encPatWID
;
quit;
*n=10305;

*delete with both emerg and inpatient data;
data eithertype;
set sql_final;
if (emerg=1 and inpt=1) then delete;
run;
*n=9402;

/*ANSWER: There are 9402 patients had at least 1 visit of either type (inpatient or emergency room 
encounter) that started in 2003*/


*d) In patients from c) who had at least 1 visit of either type, create a variable that 
counts the total number encounters (of either type)-for example, a patient with one inpatient 
encounter and one emergency room encounter would have a total encounter count of 2. 
Generate a frequency table of total encounter number for this data set, and paste the (text) 
table into your assignment- use the SAS tip from class to make the table output text-friendly;

*create var for total number of encounters;
data eithertype;
set eithertype;
totalenc=count1 + count2;
run;

ods listing;
options formchar="|----|+|---+=|-/\<>*";
proc freq data=eithertype;
table totalenc;
title 'Total Number of Emergency or Inpatient Visits';
run;
*n=9402;

/*
                     Total Number of Emergency or Inpatient Visits per Patient ID                 4246
                                                                         12:58 Tuesday, March 31, 2020

                                          The FREQ Procedure

                                                         Cumulative    Cumulative
                    totalenc    Frequency     Percent     Frequency      Percent
                    -------------------------------------------------------------
                           2        8314       88.43          8314        88.43
                           4         880        9.36          9194        97.79
                           6         143        1.52          9337        99.31
                           8          37        0.39          9374        99.70
                          10          13        0.14          9387        99.84
                          12           4        0.04          9391        99.88
                          14           3        0.03          9394        99.91
                          16           4        0.04          9398        99.96
                          18           3        0.03          9401        99.99
                          26           1        0.01          9402       100.00

*/
