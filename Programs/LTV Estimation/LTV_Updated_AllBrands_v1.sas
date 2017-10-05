proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\on_20160801_ltv_scored.txt"
     out=on_20160801_ltv_scored
     dbms=dlm
     replace;
     getnames=yes;
	 delimiter="|";
run;

proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\on_20160801_ltv_valid.txt"
     out=on_20160801_ltv_valid
     dbms=dlm
     replace;
     getnames=yes;
	 delimiter="|";
run;


proc sort data=on_20160801_ltv_scored;
 by customer_key;
run;

proc sort data=on_20160801_ltv_valid;
 by customer_key;
run;

data on_20160801_ltv_scored_file;
 merge on_20160801_ltv_scored (in=a)
 	   on_20160801_ltv_valid (in=b);
 by customer_key;
 if a=1; *and b=1;
run;


proc sql;
 select count(*) into: traincount from on_20160801_ltv_scored_file;
quit;

%let num_quantiles=100; 
%let trainintv = %eval(&traincount/&num_quantiles);

proc sort data=on_20160801_ltv_scored_file
		  out=on_20160801_ltv_scored_file;
 by descending exp_ltv_12 descending forecasted_txn_12;
run;


data temp;
set on_20160801_ltv_scored_file;
run;


data temp;
set temp;
do i = 1 to &num_quantiles;
 if _n_ ge 1 + (i-1) * round(&trainintv) then ltv_grp = i;
 else ltv_grp=ltv_grp;
end;
run;


proc sql;
 create table test as select distinct ltv_grp, 
									  count(customer_key) as customers, 
									  sum(exp_ltv_12) as exp_ltv_12,
									  sum(spend_12) as spend_12
	    from temp
		group by ltv_grp order by ltv_grp;
quit;


proc sql;
 select max(spend_12) from temp where ltv_grp <= 30;
 select max(spend_12) from temp where ltv_grp > 30 and ltv_grp <= 60;
 select max(spend_12) from temp where ltv_grp > 61 and ltv_grp <= 100;
quit;

proc univariate data=temp;
 var spend_12 exp_ltv_12;
 output out = test pctlpre = spend_12_ exp_ltv_12_ pctlpts=30 75;
quit;


proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\all_20160801_ltv_scored.txt"
     out=all_20160801_ltv_scored
     dbms=dlm
     replace;
     getnames=yes;
	 delimiter="|";
run;

proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\all_20160801_ltv_valid.txt"
     out=all_20160801_ltv_valid
     dbms=dlm
     replace;
     getnames=yes;
	 delimiter="|";
run;


proc sort data=all_20160801_ltv_scored;
 by customer_key;
run;

proc sort data=all_20160801_ltv_valid;
 by customer_key;
run;

data all_20160801_ltv_scored_file;
 merge all_20160801_ltv_scored (in=a)
 	   all_20160801_ltv_valid (in=b);
 by customer_key;
 if a=1; *and b=1;
run;


proc sql;
 select count(*) into: traincount from all_20160801_ltv_scored_file;
quit;

%let num_quantiles=100; 
%let trainintv = %eval(&traincount/&num_quantiles);

proc sort data=all_20160801_ltv_scored_file
		  out=all_20160801_ltv_scored_file;
 by descending exp_ltv_12 descending forecasted_txn_12;
run;


data temp;
set all_20160801_ltv_scored_file;
run;


data temp;
set temp;
do i = 1 to &num_quantiles;
 if _n_ ge 1 + (i-1) * round(&trainintv) then ltv_grp = i;
 else ltv_grp=ltv_grp;
end;
run;


proc sql;
 create table test as select distinct ltv_grp, 
									  count(customer_key) as customers, 
									  sum(exp_ltv_12) as exp_ltv_12,
									  sum(spend_12) as spend_12
	    from temp
		group by ltv_grp order by ltv_grp;
quit;



proc sql;
select distinct avg(abs(spend_12 - exp_ltv_12)/spend_12)									  
from temp;
quit;
