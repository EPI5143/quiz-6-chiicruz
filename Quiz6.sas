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

*retrieve dataset, based on the hint - Use EncStartDtm to identify encounters occurring in 2003;
*my understanding based on the hint that the data will only include encounters from 2003;
data enc;
set source.nencounter (keep=EncWID EncPatWID EncStartDtm EncVisitTypeCd);
if year(datepart(EncStartDtm))=2003;
run;
*n=3327;

*remove duplicates;
proc sort data=enc out=encnodup nodupkey;
by EncWID;
run;
*no duplicates;

*a) How many patients had at least 1 inpatient encounter that started in 2003?;
proc sort data=enc out=inpt;
by EncPatWID;
run;

data inpt;
set inpt;
by EncPatWID;
if first.EncPatWID then do;
inpt=0; count1=0;
end;
if EncVisitTypeCd="INPT" then do;
inpt=1;*inpatient flag;count1=count1+1;
end;
if last.EncPatWID then output;
retain inpt count1;
run;
*n=2891;

ods listing;
options formchar="|----|+|---+=|-/\<>*"; 
proc freq data=inpt;
tables inpt count1;
title 'Admissions from 2003 with Inpatient Visits';
run;

/*
                              Admissions from 2003 with Inpatient Visits                           258
                                                                         15:53 Tuesday, March 31, 2020

                                          The FREQ Procedure

                                                       Cumulative    Cumulative
                      inpt    Frequency     Percent     Frequency      Percent
                      ---------------------------------------------------------
                         0        1817       62.85          1817        62.85
                         1        1074       37.15          2891       100.00


*/
/* ANSWER: There are 1074 patients had at least 1 inpatient encounter in 2003*/

*b) How many patients had at least 1 emergency room encounter that started in 2003?; 
proc sort data=enc out=emerg;
by EncPatWID;
run;

data emerg;
set emerg;
by EncPatWID;
if first.EncPatWID then do;
emerg=0; count2=0;
end;
if EncVisitTypeCd="EMERG" then do;
emerg=1;*inpatient flag;count2=count2+1;
end;
if last.EncPatWID then output;
retain emerg count2;
run;
*n=2891;

ods listing;
options formchar="|----|+|---+=|-/\<>*"; 
proc freq data=emerg;
tables emerg count2;
title 'Admissions from 2003 with Emergency Visits';
run;

/*
                              Admissions from 2003 with Emergency Visits                           259
                                                                         15:53 Tuesday, March 31, 2020

                                          The FREQ Procedure

                                                        Cumulative    Cumulative
                      emerg    Frequency     Percent     Frequency      Percent
                      ----------------------------------------------------------
                          0         913       31.58           913        31.58
                          1        1978       68.42          2891       100.00




*/
/* ANSWER: There are 1978 patients had at least 1 emergency encounter in 2003*/


*c) How many patients had at least 1 visit of either type (inpatient or emergency room 
encounter) that started in 2003?;

*link inpatient and emerg datasets;
proc sql;
create table sql_table as
select emerg.*,inpt.*
from emerg as emerg
	 left join
     inpt as inpt
	 on emerg.encPatWID = inpt.encPatWID
;
quit;
*n=2891;

/*ANSWER: There are 2891 patients had at least 1 visit of either type (inpatient or emergency room 
encounter) that started in 2003*/


*d) In patients from c) who had at least 1 visit of either type, create a variable that 
counts the total number encounters (of either type)-for example, a patient with one inpatient 
encounter and one emergency room encounter would have a total encounter count of 2. 
Generate a frequency table of total encounter number for this data set, and paste the (text) 
table into your assignment- use the SAS tip from class to make the table output text-friendly;

*create var for total number of encounters;
data sql_table;
set sql_table;
totalenc=count1 + count2;
run;

ods listing;
options formchar="|----|+|---+=|-/\<>*";
proc freq data=sql_table;
table totalenc;
title 'Total Number of Emergency or Inpatient Visits';
run;

/*
                            Total Number of Emergency or Inpatient Visits                            7
                                                                         17:56 Tuesday, March 31, 2020

                                          The FREQ Procedure

                                                         Cumulative    Cumulative
                    totalenc    Frequency     Percent     Frequency      Percent
                    -------------------------------------------------------------
                           1        2556       88.41          2556        88.41
                           2         270        9.34          2826        97.75
                           3          45        1.56          2871        99.31
                           4          14        0.48          2885        99.79
                           5           3        0.10          2888        99.90
                           6           1        0.03          2889        99.93
                           7           1        0.03          2890        99.97
                          12           1        0.03          2891       100.00


*/
