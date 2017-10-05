options mlogic macrogen symbolgen mprint;

libname loc "\\10.8.8.51\lv0\\Saumya\Datasets\";

%let brand = on; %let monthindex = 20140501; %let ltvfileindex = may;



%macro split_group_create(data,no_of_group,scorevar, create_var); 

proc sort data = &data;
by descending &scorevar;
run;

data &data;
set &data nobs=N_Record;
format &create_var best32.;
%do i = 1 %to &no_of_group;
if _N_/N_Record <= %sysevalf(&i /&no_of_group) then &create_var= &i ; else
%end;   &create_var=999;
run;


proc sql;
 create table test_&monthindex._&scorevar as select distinct
	 &create_var, 
	 count(customer_key) as customers,
	 sum(spend_12) as spend_12, 
	 sum(&scorevar) as &scorevar	 
 from &data
 group by &create_var order by &create_var;
quit;

%mend split_group_create;


proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._&monthindex._ltv_scored.txt"
     out=&brand._&monthindex._ltv_scored
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

data &brand._aq_a2_&ltvfileindex._score_valid;
 set loc.&brand._aq_a2_&ltvfileindex._score_valid;
run;
%split_group_create(&brand._aq_a2_&ltvfileindex._score_valid, 100, exp_ltv_12, Percentile_Bin);


proc sql;
create table &brand._&monthindex._ensemble as 
select 
T1.customer_key,
T1.spend_12,
T1.exp_ltv_12 as ltv_palive,
T1.exp_ltv_12/T1.palive * (1-T2.poffset) as ltv_poffset,
(T1.exp_ltv_12/T1.palive *(1-T2.poffset)+ T1.exp_ltv_12)/2 as ltv_eq_wt,
T1.forecasted_txn_12/T1.palive as unconditional_txn_12,
T1.palive,
1-T2.poffset as pnonattr
from 
&brand._aq_a2_&ltvfileindex._score_valid T1
inner join 
&brand._&monthindex._attrition_scores T2
on 
T1.customer_key=T2.customer_key;
quit;


%macro split_group_create(data,no_of_group,scorevar, create_var); 

proc sort data = &data;
by descending &scorevar;
run;

data &data;
set &data nobs=N_Record;
format &create_var best32.;
%do i = 1 %to &no_of_group;
if _N_/N_Record <= %sysevalf(&i /&no_of_group) then &create_var= &i ; else
%end;   &create_var=999;
run;


proc sql;
 create table test_&monthindex._&scorevar as select distinct
	 &create_var, 
	 count(customer_key) as customers,
	 sum(spend_12) as spend_12, 
	 sum(&scorevar) as &scorevar	 
 from &data
 group by &create_var order by &create_var;
quit;

%mend split_group_create;

%split_group_create(&brand._&monthindex._ensemble, 100, ltv_palive, Percentile_Bin);
%split_group_create(&brand._&monthindex._ensemble, 100, ltv_poffset, Percentile_Bin);
%split_group_create(&brand._&monthindex._ensemble, 100, ltv_eq_wt, Percentile_Bin);






%macro summary(ifimportdata, brand, monthindex, ltvfileindex);
    
    libname loc "\\10.8.8.51\lv0\\Saumya\Datasets\";
	
	%if &ifimportdata = 1 %then %do;

		proc import datafile="\\10.8.8.51\lv0\Tanumoy\Datasets\model replication\&brand._&monthindex._ltv_scored.txt"
		     out=&brand._&monthindex._ltv_scored
		     dbms=dlm
		     replace;
		     getnames=yes;
		     delimiter="|";
		run;


		proc import datafile="\\10.8.8.51\lv0\Tanumoy\Datasets\attrition scores\&brand._&monthindex._attrition_scores.txt"
		     out=&brand._&monthindex._attrition_scores
		     dbms=dlm
		     replace;
		     getnames=yes;
			 delimiter=",";
		run;

		data &brand._aq_a2_&ltvfileindex._score_valid;
		 set loc.&brand._aq_a2_&ltvfileindex._score_valid;
		run;

	%end;

	proc sql;
	create table &brand._&monthindex._app2 as 
	select 
	T1.customer_key,
	T1.spend_12,
	T1.exp_ltv_12 as ltv_palive_chall,
	T1.exp_ltv_12/T1.palive * (1-T2.poffset) as ltv_poffset_chall,
	T1.forecasted_txn_12/T1.palive as unconditional_txn_12,
	T1.palive,
	1-T2.poffset as pnonattr
	from 
	&brand._aq_a2_&ltvfileindex._score_valid T1
	inner join 
	&brand._&monthindex._attrition_scores T2
	on 
	T1.customer_key=T2.customer_key;
	quit;

	data &brand._&monthindex._app2;
	 keep customer_key spend_12 ltv_palive_chall ltv_poffset_chall;
	 set &brand._&monthindex._app2;
	run;

	proc sort data=&brand._&monthindex._ltv_scored;
	by customer_key;
	run;

	proc sort data=&brand._&monthindex._attrition_scores;
	by customer_key;
	run;


	data &brand._&monthindex._ltv_scored_file;
	merge &brand._&monthindex._ltv_scored (in=a)
	      &brand._&monthindex._attrition_scores (in=b);
	by customer_key;
	if a=1 and  b=1;
	run;

	data &brand._&monthindex._ltv_scored_file;
	set &brand._&monthindex._ltv_scored_file;
	forecasted_txn_12_poffset = uncond_txn_12 * (1 - poffset);
	exp_ltv_12_poffset = forecasted_txn_12_poffset * forecasted_avg_spend_12;
	forecasted_txn_12_palive = uncond_txn_12 * palive_12;
	exp_ltv_12_palive = forecasted_txn_12_palive * forecasted_avg_spend_12;
	rename exp_ltv_12_poffset = ltv_poffset_champ;
	rename exp_ltv_12_palive = ltv_palive_champ;
	run;

	data &brand._&monthindex._ltv_scored_file;
	keep customer_key ltv_palive_champ ltv_poffset_champ;
	set &brand._&monthindex._ltv_scored_file;
	run;


	proc sql;
	 create table &brand._&monthindex._all_comb 
	 as select t1.*, t2.ltv_palive_champ, ltv_poffset_champ
	 from
	 &brand._&monthindex._ltv_scored_file t2
	 inner join
	 &brand._&monthindex._app2 t1
	 on t1.customer_key = t2.customer_key;
	quit;


	data &brand._&monthindex._all_comb;
	set &brand._&monthindex._all_comb;
	ltv_eq_wt = (ltv_palive_champ + ltv_poffset_champ + ltv_palive_chall + ltv_poffset_chall) * 0.25;
	run;

	proc sql;
	 drop table &brand._&monthindex._ltv_scored_file;
	 drop table &brand._&monthindex._ltv_scored;
	 drop table &brand._&monthindex._attrition_scores;
	 drop table &brand._&monthindex._app2;
	 drop table &brand._aq_a2_&ltvfileindex._score_valid;
	quit;



	%macro quantiles(ds, scorevars, num_quantiles);

		proc sql;
		 select count(*) into : traincount from &ds;
		quit;

		%let trainintv = %eval(&traincount/&num_quantiles);

		%let scorevarcount = %sysfunc(countw(&scorevars));

		%do i = 1 %to &scorevarcount;

		    %let varname = %scan(&scorevars, &i, " ");

			proc sort data=&ds
					  out=&ds;
			 by descending &varname;
			run;


			data &ds;
			 set &ds;
			 do i = 1 to &num_quantiles;
			  if _n_ ge 1 + (i-1) * round(&trainintv) then ltv_grp = i;
			  else ltv_grp=ltv_grp;
			 end;
			 drop i;
			run;

			proc sql;
			 create table &brand._&monthindex._&varname as select distinct ltv_grp, 
												  count(customer_key) as customers,
												  sum(spend_12) as spend_12, 
												  sum(&varname) as &varname,
												  mean(abs(spend_12-&varname)) as mae,
												  std(abs(spend_12-&varname)) as sdae
				    from &ds
					group by ltv_grp order by ltv_grp;
			quit;

		%end;

	%mend;
	%quantiles(ds=&brand._&monthindex._all_comb, num_quantiles = 100,
			   scorevars = ltv_palive_champ ltv_poffset_champ ltv_palive_chall ltv_poffset_chall ltv_eq_wt);

%mend;
%summary(brand=on, monthindex=20140501, ifimportdata=1, ltvfileindex=may);
%summary(brand=on, monthindex=20140601, ifimportdata=1, ltvfileindex=june);
%summary(brand=on, monthindex=20140701, ifimportdata=1, ltvfileindex=july);
%summary(brand=br, monthindex=20140501, ifimportdata=1, ltvfileindex=may);
%summary(brand=br, monthindex=20140601, ifimportdata=1, ltvfileindex=june);
%summary(brand=br, monthindex=20140701, ifimportdata=1, ltvfileindex=july);
%summary(brand=gp, monthindex=20140501, ifimportdata=1, ltvfileindex=may);
%summary(brand=gp, monthindex=20140601, ifimportdata=1, ltvfileindex=june);
%summary(brand=gp, monthindex=20140701, ifimportdata=1, ltvfileindex=july);

