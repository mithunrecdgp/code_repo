%let brand=on; %let monthindex=20140701;

proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._&monthindex._ltv_scored.txt"
     out=&brand._&monthindex._ltv_scored
     dbms=dlm
     replace;
     getnames=yes;
	 delimiter="|";
run;

proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._&monthindex._ltv_valid.txt"
     out=&brand._&monthindex._ltv_valid
     dbms=dlm
     replace;
     getnames=yes;
	 delimiter="|";
run;


proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\attrition scores\&brand._&monthindex._attrition_scores.txt"
     out=&brand._&monthindex._attrition_scores
     dbms=dlm
     replace;
     getnames=yes;
	 delimiter=",";
run;


proc sort data=&brand._&monthindex._ltv_scored;
 by customer_key;
run;

proc sort data=&brand._&monthindex._ltv_valid;
 by customer_key;
run;

proc sort data=&brand._&monthindex._attrition_scores;
 by customer_key;
run;

data &brand._&monthindex._ltv_scored_file;
 merge &brand._&monthindex._ltv_scored (in=a)
 	   &brand._&monthindex._ltv_valid (in=b)
	   &brand._&monthindex._attrition_scores (in=c);
 by customer_key;
 if a=1 and c=1;
run;

data &brand._&monthindex._ltv_scored_file;
 set &brand._&monthindex._ltv_scored_file;
 forecasted_txn_12_poffset = uncond_txn_12 * (1 - poffset);
 exp_ltv_12_poffset = forecasted_txn_12_poffset * forecasted_avg_spend_12;
 forecasted_txn_12_palive = uncond_txn_12 * palive_12;
 exp_ltv_12_palive = forecasted_txn_12_palive * forecasted_avg_spend_12;
 eq_wtd_exp_ltv_12 = exp_ltv_12_palive*0.50 + exp_ltv_12_poffset*0.50;
 attr_flag = 0;
 if spend_12 = . then attr_flag = 1;
 if spend_12 = . then spend_12 = 0;
run;


%macro attrition_score(ds, scorevars);

    dm "output" clear;

	proc sort data = &brand._&monthindex._ltv_scored_file;
	by flag;
	run;

	%let scorevarcount = %sysfunc(countw(&scorevars));

	%do i=1 %to &scorevarcount;
		%let scorevar = %scan(&scorevars,&i," ");
		proc logistic data=&brand._&monthindex._ltv_scored_file;
		 model attr_flag (event='1') = &scorevar;
		 by flag;
		run;
	%end;

	%do i=1 %to &scorevarcount;
		%let scorevar = %scan(&scorevars,&i," ");
		proc logistic data=&brand._&monthindex._ltv_scored_file;
		 model attr_flag (event='1') = &scorevar;
		run;
	%end;

%mend;
%attrition_score(ds=&brand._&monthindex._ltv_scored_file, scorevars = modelmedian poffset palive_12);



data &brand._&monthindex._ltv_scored_file;
 keep customer_key spend_12 exp_ltv_12_poffset exp_ltv_12_palive eq_wtd_exp_ltv_12;
 set &brand._&monthindex._ltv_scored_file;
run;

proc univariate data = &brand._&monthindex._ltv_scored_file;
 var exp_ltv_12_poffset exp_ltv_12_palive;
quit;





%let brand=on; %let monthindex=20140701;

proc sql;
 select 
		 mean(abs(spend_12 - exp_ltv_12_poffset)) as mae_poffset,
		 mean(abs(spend_12 - exp_ltv_12_palive)) as mae_palive,
		 mean(abs(spend_12 - eq_wtd_exp_ltv_12)) as mae_eq_wtd
 from &brand._&monthindex._ltv_scored_file;
quit;


proc sql;
 select count(*) into: traincount from &brand._&monthindex._ltv_scored_file;
quit;

%let num_quantiles=100; 
%let trainintv = %eval(&traincount/&num_quantiles);

%let varname = eq_wtd_exp_ltv_12;

proc sort data=&brand._&monthindex._ltv_scored_file
		  out=&brand._&monthindex._ltv_scored_file;
 by descending &varname;
run;


data temp;
set &brand._&monthindex._ltv_scored_file;
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
									  sum(spend_12) as spend_12, 
									  sum(&varname) as &varname
	    from temp
		group by ltv_grp order by ltv_grp;
quit;




proc univariate data = temp;
 var exp_ltv_12_palive exp_ltv_12_poffset;
quit;

proc setinit; run;


%let varname = exp_ltv_12_poffset;

proc sort data=&brand._&monthindex._ltv_scored_file
		  out=&brand._&monthindex._ltv_scored_file;
 by descending &varname;
run;


data temp;
set &brand._&monthindex._ltv_scored_file;
do i = 1 to &num_quantiles;
 if _n_ ge 1 + (i-1) * round(&trainintv) then ltv_grp = i;
 else ltv_grp=ltv_grp;
end;
run;

proc sql;
 create table test as select distinct ltv_grp, 
									  count(customer_key) as customers,
									  sum(spend_12) as spend_12, 
									  sum(exp_ltv_12_poffset) as exp_ltv_12_poffset,
									  sum(exp_ltv_12_palive) as exp_ltv_12_palive,
									  sum(eq_wtd_exp_ltv_12) as eq_wtd_exp_ltv_12,
									  sum(op_wtd_exp_ltv_12) as op_wtd_exp_ltv_12
	    from temp
		group by ltv_grp order by ltv_grp;
quit;




