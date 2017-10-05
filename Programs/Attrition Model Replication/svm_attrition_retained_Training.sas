libname loc '\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication'; /*Working Directory for saving database*/
%let path = \\10.8.8.51\lv0\Tanumoy\Datasets\From Hive ;  /*Without quote, Where the data is*/

%let brand =AT;

%macro data_pull(input,output);
data loc.&output._num;
infile "&path.\&input..txt" DELIMITER = '|' MISSOVER DSD LRECL=32767 FIRSTOBS=1;
informat	customer_key	best32.;
informat	avg_ticket_size_ratio	best32. ;
informat	discounts_p_ratio	best32. ;
informat	frequency_ratio	best32. ;
informat	gross_sales_ratio	best32. ;
informat	items_on_sale_p_ratio	best32. ;
informat	items_purchased_ratio	best32. ;
informat	net_sales_ratio	best32. ;
informat	ob_avg_ticket_size_p_ratio	best32. ;
informat	ob_net_sales_p_ratio	best32. ;
informat	ob_frequency_p_ratio	best32. ;
informat	offline_freq_p_ratio	best32. ;
informat	offline_sales_p_ratio	best32. ;
informat	online_freq_p_ratio	best32. ;
informat	online_sales_p_ratio	best32. ;
informat	recency	best32. ;
informat	distinct_brands	best32. ;
informat	attr_flag	best32. ;

format	customer_key	best32.;
format	avg_ticket_size_ratio	best32. ;
format	discounts_p_ratio	best32. ;
format	frequency_ratio	best32. ;
format	gross_sales_ratio	best32. ;
format	items_on_sale_p_ratio	best32. ;
format	items_purchased_ratio	best32. ;
format	net_sales_ratio	best32. ;
format	ob_avg_ticket_size_p_ratio	best32. ;
format	ob_net_sales_p_ratio	best32. ;
format	ob_frequency_p_ratio	best32. ;
format	offline_freq_p_ratio	best32. ;
format	offline_sales_p_ratio	best32. ;
format	online_freq_p_ratio	best32. ;
format	online_sales_p_ratio	best32. ;
format	recency	best32. ;
format	distinct_brands	best32. ;
format	attr_flag	best32. ;

input
customer_key
avg_ticket_size_ratio
discounts_p_ratio
frequency_ratio
gross_sales_ratio
items_on_sale_p_ratio
items_purchased_ratio
net_sales_ratio
ob_avg_ticket_size_p_ratio
ob_net_sales_p_ratio
ob_frequency_p_ratio
offline_freq_p_ratio
offline_sales_p_ratio
online_freq_p_ratio
online_sales_p_ratio
recency
distinct_brands
attr_flag
;
run;



data loc.&output._char;
infile "&path.\&input..txt" DELIMITER = '|' MISSOVER DSD LRECL=32767 FIRSTOBS=1;
informat	customer_key	best32. ;
informat	avg_ticket_size_ratio	$15. ;
informat	discounts_p_ratio	$15. ;
informat	frequency_ratio	$15. ;
informat	gross_sales_ratio	$15. ;
informat	items_on_sale_p_ratio	$15. ;
informat	items_purchased_ratio	$15. ;
informat	net_sales_ratio	$15. ;
informat	ob_avg_ticket_size_p_ratio	$15. ;
informat	ob_net_sales_p_ratio	$15. ;
informat	ob_frequency_p_ratio	$15. ;
informat	offline_freq_p_ratio	$15. ;
informat	offline_sales_p_ratio	$15. ;
informat	online_freq_p_ratio	$15. ;
informat	online_sales_p_ratio	$15. ;
informat	recency	$15. ;
informat	distinct_brands	$15. ;
informat	attr_flag	best32. ;

format	customer_key	best32. ;
format	avg_ticket_size_ratio	$15. ;
format	discounts_p_ratio	$15. ;
format	frequency_ratio	$15. ;
format	gross_sales_ratio	$15. ;
format	items_on_sale_p_ratio	$15. ;
format	items_purchased_ratio	$15. ;
format	net_sales_ratio	$15. ;
format	ob_avg_ticket_size_p_ratio	$15. ;
format	ob_net_sales_p_ratio	$15. ;
format	ob_frequency_p_ratio	$15. ;
format	offline_freq_p_ratio	$15. ;
format	offline_sales_p_ratio	$15. ;
format	online_freq_p_ratio	$15. ;
format	online_sales_p_ratio	$15. ;
format	recency	$15. ;
format	distinct_brands	$15. ;
format	attr_flag	best32. ;

input
customer_key	
avg_ticket_size_ratio	$
discounts_p_ratio	$
frequency_ratio	$
gross_sales_ratio	$
items_on_sale_p_ratio	$
items_purchased_ratio	$
net_sales_ratio	$
ob_avg_ticket_size_p_ratio	$
ob_net_sales_p_ratio	$
ob_frequency_p_ratio	$
offline_freq_p_ratio	$
offline_sales_p_ratio	$
online_freq_p_ratio	$
online_sales_p_ratio	$
recency	$
distinct_brands	$
attr_flag
;
run;
%mend data_pull;
%data_pull(&brand._retained_data,&brand._retained_data)


proc freq data = loc.&brand._retained_data_num;
tables attr_flag;
run;

proc freq data = loc.&brand._retained_data;
tables attr_flag;
run;


proc means data=loc.&brand._retained_data_num (drop=customer_key attr_flag) noprint;

output out = percentile_info P1 = P99 = /autoname;
run;
proc transpose data = percentile_info out = percentile_info_v1 ;
run;


/************************************************************************************************/




/*-----------------------data prep Starts----------------*/

%macro data_prep(dataset);
proc sort data = loc.&dataset._num ;
by customer_key;
run;
proc sort data = loc.&dataset._char;
by customer_key;
run;

data column_name(keep=name);
set sashelp.vcolumn;
where libname = 'LOC' and memname = "%upcase(&dataset._char)";
run;

data column_name;
set column_name ;
name_char= cats(name, " = ", name ,"_char");
name_num=cats(name , " = ", name,"_num");
run;

proc sql noprint;
select name,name_char,name_num into :v_name separated by " ", :v_name_char separated by " ", :v_name_num separated by " "
from column_name where name not in ("customer_key", "attr_flag");
quit;

%put &v_name;
%put &v_name_char ;
%put &v_name_num ;

data _null_;
set percentile_info_v1;
call symputx( _NAME_ , COL1 );
run;

data loc.&dataset ;
merge loc.&dataset._num (rename=(&v_name_num) ) loc.&dataset._char (rename=(&v_name_char) );
by customer_key;


%do i = 1 %to %sysfunc(countw(&v_name));
%let work_var = %scan(&v_name,&i);

select (&work_var._char);
   when ('Infinity') &work_var = &&&work_var._P99 ;
   when ('INF') &work_var = &&&work_var._P99 ;
   when ('') &work_var = &&&work_var._P1 ;
   when ('-Infinity') &work_var = &&&work_var._P1 ; 
   when ('NaN') &work_var = 0 ;
otherwise &work_var = &work_var._num;
end;
if &work_var._num > &&&work_var._P99 then &work_var = &&&work_var._P99 ;
if (&work_var._num ne . and &work_var._num <&&&work_var._P1) then &work_var =&&&work_var._P1 ;

drop &&work_var._num &&work_var._char ;
%end;

run;

%mend data_prep;



%data_prep(&brand._retained_data)




proc reg data = loc.&brand._retained_data;
 model attr_flag = 
					avg_ticket_size_ratio
					discounts_p_ratio
/*					frequency_ratio*/
/*					gross_sales_ratio*/
					items_on_sale_p_ratio
/*					items_purchased_ratio*/
					net_sales_ratio
					ob_avg_ticket_size_p_ratio
					ob_net_sales_p_ratio
					ob_frequency_p_ratio
					offline_freq_p_ratio
					offline_sales_p_ratio
					online_freq_p_ratio
					online_sales_p_ratio
					recency
					distinct_brands / vif;
run;
quit;




/*---- Drop the necessary variabbles after VIF screening--------*/

data &brand._retained_data;
set loc.&brand._retained_data;
drop 
frequency_ratio 
gross_sales_ratio
items_purchased_ratio
;
run;

proc contents data = &brand._retained_data;
run;


%let csv_save_path = \\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication ;


%macro create_csv(data_name);
PROC EXPORT DATA= &data_name 
            OUTFILE= "&csv_save_path.\&data_name..csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
%mend;
%create_csv(&brand._retained_data);



proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._retained_data.csv"
     out=&brand._retained_data
     dbms=csv
     replace;
     getnames=yes;
run;

proc contents data=&brand._retained_data;
run;






%macro adequacy(varlist);

%let varcount=%sysfunc(countw(&varlist));
%if &brand eq "at" %then %let prior = 0.3730;

data &brand._retained_data;
set &brand._retained_data; 
offset = -log(%sysevalf(&prior)/(1-%sysevalf(&prior)));
run;

proc logistic data = &brand._retained_data;
model attr_flag (event='1') = &varlist
							  /expb lackfit ctable stb;
run;

%do i=1 %to &varcount;
		
	%let varname=%scan(&varlist,&i," ");
	%put &varname;

	proc logistic data=&brand._retained_data;
	  model attr_flag(event='1')=	&varname
									/expb lackfit ctable stb;
	run;

%end;

%mend;

%adequacy
(varlist=
avg_ticket_size_ratio
discounts_p_ratio
distinct_brands
items_on_sale_p_ratio
net_sales_ratio
ob_avg_ticket_size_p_ratio
ob_frequency_p_ratio
ob_net_sales_p_ratio
offline_freq_p_ratio
offline_sales_p_ratio
online_freq_p_ratio
online_sales_p_ratio
recency
);

proc sql;
select count(*), sum(attr_flag) from &brand._retained_data;
quit;


proc univariate data=loc.&brand._retained_data_num;
var
avg_ticket_size_ratio
discounts_p_ratio
distinct_brands
items_on_sale_p_ratio
net_sales_ratio
ob_avg_ticket_size_p_ratio
ob_frequency_p_ratio
ob_net_sales_p_ratio
offline_freq_p_ratio
offline_sales_p_ratio
online_freq_p_ratio
online_sales_p_ratio
recency
;
output out = percentile_info
pctlpre = 
avg_ticket_size_ratio_
discounts_p_ratio_
distinct_brands_
items_on_sale_p_ratio_
net_sales_ratio_
ob_avg_ticket_size_p_ratio_
ob_frequency_p_ratio_
ob_net_sales_p_ratio_
offline_freq_p_ratio_
offline_sales_p_ratio_
online_freq_p_ratio_
online_sales_p_ratio_
recency_
pctlpts = 1 99
;
run;
proc transpose data = percentile_info out = percentile_info_v1 ;
run;

data test1;
set percentile_info_v1;
where index(_name_,"_1")>0;
drop _label_;
_name_ = tranwrd(_name_, "_1", "");
rename col1=ll;
run;

data test2;
set percentile_info_v1;
where index(_name_,"_99")>0;
drop _label_;
_name_ = tranwrd(_name_, "_99", "");
rename col1=ul;
run;

data outlier_limit;
merge test1 test2;
by _name_;
run;

proc export data= outlier_limit 
            outfile= "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Attrition Files\AT\AE\Retained\outlier_limit.csv" 
            dbms=csv replace;
     putnames=yes;
run;
