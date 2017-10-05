options mlogic macrogen symbolgen mprint;


proc export data = on_july_eq_wt
     file="\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\on_july_eq_wt.txt"
     dbms=dlm
     replace;
	 delimiter="|";
run;

%macro reg(ds, num_quantiles);

	%let trainintv = %eval(&traincount/&num_quantiles);

	%let varname = ltv_all_eq_wt;

	proc sort data=on_july_eq_wt
			  out=on_july_eq_wt;
	 by descending &varname;
	run;


	data on_july_eq_wt;
	 set on_july_eq_wt;
	 do i = 1 to &num_quantiles;
	  if _n_ ge 1 + (i-1) * round(&trainintv) then ltv_grp = i;
	  else ltv_grp=ltv_grp;
	 end;
	run;

	%do i = 1 %to &num_quantiles;
		proc reg data = &ds;
		 model spend_12 = ltv_palive_chall ltv_palive_champ ltv_poff_chall ltv_poff_champ / noint vif;
		 *restrict ltv_palive_chall + ltv_palive_champ + ltv_poff_chall + ltv_poff_champ = 1;
		 where percentile_bin = &i;
		 output out=test&i p=ltv_reg_noint;
		quit;

	    %if &i = 1 %then %do;
 		  data &ds._reg; set test&i; run;
		%end;

	    %if &i > 1 %then %do;
 		  data &ds._reg; set &ds._reg test&i; run;
		%end;

	%end;

%mend;
%reg(ds=on_may_eq_wt, num_quantiles=10); 




proc sql;
 select count(*) into: traincount from on_may_eq_wt_reg;
quit;

%let num_quantiles=100; 
%let trainintv = %eval(&traincount/&num_quantiles);

%let varname = ltv_reg_noint;

proc sort data=on_may_eq_wt_reg
		  out=on_may_eq_wt_reg;
 by descending &varname;
run;


data on_may_eq_wt_reg;
set on_may_eq_wt_reg;
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
	    from on_may_eq_wt_reg
		group by ltv_grp order by ltv_grp;
quit;









proc sql;
 select count(*) into: traincount from on_may_eq_wt;
quit;

%let num_quantiles=10; 
%let trainintv = %eval(&traincount/&num_quantiles);

%let varname = ltv_all_eq_wt;

proc sort data=on_may_eq_wt
		  out=on_may_eq_wt;
 by descending &varname;
run;


data on_may_opt_wt;
drop percentile_bin;
set on_may_eq_wt;
do i = 1 to &num_quantiles;
 if _n_ ge 1 + (i-1) * round(&trainintv) then ltv_grp = i;
 else ltv_grp=ltv_grp;
end;
drop i;
run;

data on_may_opt_wt;
set on_may_opt_wt;
if ltv_grp=1 then ltv_all_opt_wt = 0.042952 * ltv_poff_chall + 0 * ltv_palive_chall + 0.957048 * ltv_poff_champ + 0 * ltv_palive_champ;
if ltv_grp=2 then ltv_all_opt_wt = 0.8942505 * ltv_poff_chall + 0 * ltv_palive_chall + 0.1057495 * ltv_poff_champ + 0 * ltv_palive_champ;
if ltv_grp=3 then ltv_all_opt_wt = 0 * ltv_poff_chall + 0 * ltv_palive_chall + 1 * ltv_poff_champ + 0 * ltv_palive_champ;
if ltv_grp=4 then ltv_all_opt_wt = 0.0013315 * ltv_poff_chall + 0 * ltv_palive_chall + 0.9986685 * ltv_poff_champ + 0 * ltv_palive_champ;
if ltv_grp=5 then ltv_all_opt_wt = 0 * ltv_poff_chall + 0 * ltv_palive_chall + 1 * ltv_poff_champ + 0 * ltv_palive_champ;
if ltv_grp=6 then ltv_all_opt_wt = 0 * ltv_poff_chall + 0 * ltv_palive_chall + 1 * ltv_poff_champ + 0 * ltv_palive_champ;
if ltv_grp=7 then ltv_all_opt_wt = 0.4642555 * ltv_poff_chall + 0.234914 * ltv_palive_chall + 0.300831 * ltv_poff_champ + 0 * ltv_palive_champ;
if ltv_grp=8 then ltv_all_opt_wt = 0.3914865 * ltv_poff_chall + 0.2765485 * ltv_palive_chall + 0.1483435 * ltv_poff_champ + 0.1836225 * ltv_palive_champ;
if ltv_grp=9 then ltv_all_opt_wt = 0.30198 * ltv_poff_chall + 0.22432 * ltv_palive_chall + 0 * ltv_poff_champ + 0.473699 * ltv_palive_champ;
if ltv_grp=10 then ltv_all_opt_wt = 0 * ltv_poff_chall + 0.188366 * ltv_palive_chall + 0 * ltv_poff_champ + 0.811634 * ltv_palive_champ;
run;


%let num_quantiles=100; 
%let trainintv = %eval(&traincount/&num_quantiles);

%let varname = ltv_all_eq_wt;

proc sort data=on_may_opt_wt
		  out=on_may_opt_wt;
 by descending &varname;
run;


data on_may_opt_wt;
set on_may_opt_wt;
do i = 1 to &num_quantiles;
 if _n_ ge 1 + (i-1) * round(&trainintv) then ltv_grp = i;
 else ltv_grp=ltv_grp;
end;
drop i;
run;

%let varname = ltv_all_opt_wt;

proc sql;
 create table test as select distinct ltv_grp, 
									  count(customer_key) as customers,
									  sum(spend_12) as spend_12, 
									  sum(&varname) as &varname
	    from on_may_opt_wt
		group by ltv_grp order by ltv_grp;
quit;

