libname source "D:\uOttawa\4 EPI 5143-large data\class data\ntables";*folder with source data;
libname out "D:\uOttawa\4 EPI 5143-large data\out folder for SAS";*folder for permanent tables;

*create new var with date9. format;
data out.abstract;
set source.NhrAbstracts;
admindate=datepart(hraAdmDtm);
format admindate date9.;
run;
*n=24531;

*select date range;
data out.abstract;
set out.abstract;
where admindate between "01JAN2003"d and "31DEC2004"d;
run;
*n=2230;

*remove duplicates;
proc sort data=out.abstract out=out.abstractnodup nodupkey;
by hraEncWID;
run;
*no duplicates;

*create dataset with diabetes flag;
data out.diabetes;
set source.NhrDiagnosis;
length hdgCd_char$3;
hdgCd_char=left(hdgCd);
if hdgCd_char in('250','E11','E10') then DM=1;*diabetes flag; else DM=0;
run;
*the codes from slides did not work for me so I needed to trim hdgcd;

proc means data=out.diabetes;
class hdgHraEncWID;
types hdgHraEncWID;
var DM;
output out=out.diabetes2 max(DM)=DM n(DM)=count;
run;

proc freq data=out.diabetes2;
tables DM count;
run;

*link databases;
*rename encounter IDs;
proc sort data=out.abstract;
by hraEncWID;
run;

proc sort data=out.diabetes2 out=out.diabetes3 (rename=hdgHraEncWID=hraEncWID);
by hdgHraEncWID;
run;

proc sql;
create table out.sql_final as
select abs.*,dm.*
from out.abstract as abs
	 inner join
     out.diabetes2 as dm
	 on abs.hraEncWID = dm.hdgHraEncWID
;
quit;
*n=1981;

proc freq data=out.sql_final;
table DM;
run;
*83/1898 is the proportion of admissions which recorded a diagnosis of diabetes for admissions between  January 1st 2003 and December 31st, 2004;
