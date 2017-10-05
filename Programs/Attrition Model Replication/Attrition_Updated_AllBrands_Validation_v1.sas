%let brand=at; 

proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._retained_ensemble_testing.csv"
     out=&brand._retained_ensemble_testing
     dbms=csv
     replace;
     getnames=yes;
run;

proc export data=&brand._retained_ensemble_testing
   outfile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._retained_ensemble_testing.csv"
   dbms=dlm replace; 
   delimiter=',';
run;


proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._recent_ensemble_testing.csv"
     out=&brand._recent_ensemble_testing
     dbms=csv
     replace;
     getnames=yes;
run;

proc export data=&brand._recent_ensemble_testing
   outfile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._recent_ensemble_testing.csv"
   dbms=dlm replace; 
   delimiter=',';
run;


proc freq data  = &brand._retained_ensemble_testing;
tables actual_response;
run;


%let prior = 0.3730;

data &brand._retained_ensemble_testing;
 set &brand._retained_ensemble_testing;
 flag = "retained";
 logit = log((modelmedian)/(1-modelmedian));
 offset = -log(%sysevalf(&prior)/(1-%sysevalf(&prior)));
 poffset = logistic(logit - offset);
run;

data &brand._retained_ensemble_testing;
 keep customer_key flag actual_response modelmedian votesinfavour poffset;
 set &brand._retained_ensemble_testing;
run;





proc freq data  = &brand._recent_ensemble_testing;
tables actual_response;
run;


%let prior = 0.6233;

data &brand._recent_ensemble_testing;
 set &brand._recent_ensemble_testing;
 flag = "recent";
 logit = log((modelmedian)/(1-modelmedian));
 offset = -log(%sysevalf(&prior)/(1-%sysevalf(&prior)));
 poffset = logistic(logit - offset);
run;

data &brand._recent_ensemble_testing;
 keep customer_key flag actual_response modelmedian votesinfavour poffset;
 set &brand._recent_ensemble_testing;
run;

 




data &brand._combined_ensemble_testing;
 set &brand._retained_ensemble_testing
	 &brand._recent_ensemble_testing;
run;

proc export data=&brand._combined_ensemble_testing
   outfile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._combined_ensemble_testing.txt"
   dbms=dlm replace; 
   delimiter=',';
 run;




%let groups = 100;

proc sql;
 select count(*) into: testcount from &brand._combined_ensemble_testing where flag='recent';
quit;
 
%let testintv = %eval(&testcount/&groups);

data test;
 set &brand._combined_ensemble_testing;
 where flag = 'recent';
run;

proc sort data=test
		  out=test;
 by descending poffset votesinfavour;
run;


data test;
 set test;
 do i = 1 to &groups;
  if _n_ ge 1 + (i-1) * round(&testintv) then attrgrp=i;
 end;
 drop i;
run;

proc freq data=test;
tables attrgrp*actual_response / nocol;
run;

proc sql undo_policy=none;
create table temp as select 
attrgrp, count(customer_key) as customers, sum(actual_response) as attritors, sum(poffset) as exp_attritors
from test
group by attrgrp;
quit;




proc sql;
 select count(*) into: testcount from &brand._combined_ensemble_testing where flag='retained';
quit;
 
%let testintv = %eval(&testcount/&groups);

data test;
 set &brand._combined_ensemble_testing;
 where flag = 'retained';
run;

proc sort data=test
		  out=test;
 by descending poffset votesinfavour;
run;


data test;
 set test;
 do i = 1 to &groups;
  if _n_ ge 1 + (i-1) * round(&testintv) then attrgrp=i;
 end;
 drop i;
run;

proc freq data=test;
tables attrgrp*actual_response / nocol;
run;

proc sql undo_policy=none;
create table temp as select 
attrgrp, count(customer_key) as customers, sum(actual_response) as attritors, sum(poffset) as exp_attritors
from test
group by attrgrp;
quit;





%let groups = 10;

proc sql;
 select count(*) into: testcount from &brand._combined_ensemble_testing;
quit;
 
%let testintv = %eval(&testcount/&groups);

data test;
 set &brand._combined_ensemble_testing;
run;

proc sort data=test
		  out=test;
 by descending poffset votesinfavour;
run;


data test;
 set test;
 do i = 1 to &groups;
  if _n_ ge 1 + (i-1) * round(&testintv) then attrgrp=i;
 end;
 drop i;
run;

proc freq data=test;
tables attrgrp*actual_response / nocol;
run;

proc sql undo_policy=none;
create table temp as select 
attrgrp, count(customer_key) as customers, sum(actual_response) as attritors, sum(poffset) as exp_attritors
from test
group by attrgrp;
quit;

