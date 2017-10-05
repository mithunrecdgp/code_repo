libname loc '\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication'; /*Working Directory for saving database*/
%let path = \\10.8.8.51\lv0\Tanumoy\Datasets\From Hive ;  /*Without quote, Where the data is*/

%let brand =AT;

%macro data_pull(input,output);
data loc.&output._num;
infile "&path.\&input..txt" DELIMITER = '|' MISSOVER DSD LRECL=32767 FIRSTOBS=1;
informat	customer_key	best32. ;
informat	frequency	best32. ;
informat	avg_ticket_size	best32. ;
informat	ratio_returns_sales	best32. ;
informat	recency	best32. ;
informat	ob_net_sales_p	best32. ;
informat	ratio_last_first	best32. ;
informat	average_discount_p	best32. ;
informat	recency_promo_purchase	best32. ;
informat	no_promo_responds	best32. ;
informat	no_mails_sent	best32. ;
informat	recency_mail	best32. ;
informat	count_division	best32. ;
informat	distinct_brands	best32. ;
informat	ob_recency	best32. ;
informat	attr_flag	best32. ;

format	customer_key	best32. ;
format	frequency	best32. ;
format	avg_ticket_size	best32. ;
format	ratio_returns_sales	best32. ;
format	recency	best32. ;
format	ob_net_sales_p	best32. ;
format	ratio_last_first	best32. ;
format	average_discount_p	best32. ;
format	recency_promo_purchase	best32. ;
format	no_promo_responds	best32. ;
format	no_mails_sent	best32. ;
format	recency_mail	best32. ;
format	count_division	best32. ;
format	distinct_brands	best32. ;
format	ob_recency	best32. ;
format	attr_flag	best32. ;

input
customer_key
frequency
avg_ticket_size
ratio_returns_sales
recency
ob_net_sales_p
ratio_last_first
average_discount_p
recency_promo_purchase
no_promo_responds
no_mails_sent
recency_mail
count_division
distinct_brands
ob_recency
attr_flag
;
run;



data loc.&output._char;
infile "&path.\&input..txt" DELIMITER = '|' MISSOVER DSD LRECL=32767 FIRSTOBS=1;
informat	customer_key	best32. ;
informat	frequency	$15. ;
informat	avg_ticket_size	$15. ;
informat	ratio_returns_sales	$15. ;
informat	recency	$15. ;
informat	ob_net_sales_p	$15. ;
informat	ratio_last_first	$15. ;
informat	average_discount_p	$15. ;
informat	recency_promo_purchase	$15. ;
informat	no_promo_responds	$15. ;
informat	no_mails_sent	$15. ;
informat	recency_mail	$15. ;
informat	count_division	$15. ;
informat	distinct_brands	$15. ;
informat	ob_recency	$15. ;
informat	attr_flag	best32. ;

format	customer_key	best32. ;
format	frequency	$15. ;
format	avg_ticket_size	$15. ;
format	ratio_returns_sales	$15. ;
format	recency	$15. ;
format	ob_net_sales_p	$15. ;
format	ratio_last_first	$15. ;
format	average_discount_p	$15. ;
format	recency_promo_purchase	$15. ;
format	no_promo_responds	$15. ;
format	no_mails_sent	$15. ;
format	recency_mail	$15. ;
format	count_division	$15. ;
format	distinct_brands	$15. ;
format	ob_recency	$15. ;
format	attr_flag	best32. ;

input
customer_key	
frequency	$
avg_ticket_size	$
ratio_returns_sales	$
recency	$
ob_net_sales_p	$
ratio_last_first	$
average_discount_p	$
recency_promo_purchase	$
no_promo_responds	$
no_mails_sent	$
recency_mail	$
count_division	$
distinct_brands	$
ob_recency	$
attr_flag	
;
run;
%mend data_pull;
%data_pull(&brand._recent_data,&brand._recent_data)




proc means data=loc.&brand._recent_data_num (drop=customer_key attr_flag) noprint;

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



%data_prep(&brand._recent_data)




proc reg data = loc.&brand._recent_data;
model attr_flag =  
					frequency
					avg_ticket_size
					ratio_returns_sales
					recency
					ob_net_sales_p
					ratio_last_first
					average_discount_p
					recency_promo_purchase
					no_promo_responds
					no_mails_sent
					recency_mail
					count_division
					distinct_brands
					ob_recency
					/vif;
run;
quit;

/*---- Drop the necessary variabbles after VIF screening--------*/


%let csv_save_path = \\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication ;


%macro create_csv(data_name);
PROC EXPORT DATA= loc.&data_name 
            OUTFILE= "&csv_save_path.\&data_name..csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
%mend;
%create_csv(&brand._recent_data)



proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._recent_data.csv"
     out=&brand._recent_data
     dbms=csv
     replace;
     getnames=yes;
run;

proc contents data=&brand._recent_data;
run;






%macro adequacy(varlist);

%let varcount=%sysfunc(countw(&varlist));
%if &brand eq "at" %then %let prior = 0.6233;

data &brand._recent_data;
set &brand._recent_data; 
offset = -log(%sysevalf(&prior)/(1-%sysevalf(&prior)));
run;

proc logistic data = &brand._recent_data;
model attr_flag (event='1') = &varlist
							  /expb lackfit ctable stb;
run;

%do i=1 %to &varcount;
		
	%let varname=%scan(&varlist,&i," ");
	%put &varname;

	proc logistic data=&brand._recent_data;
	  model attr_flag(event='1')=	&varname
									/expb lackfit ctable stb;
	run;

%end;

%mend;

%adequacy
(varlist=
average_discount_p
avg_ticket_size
count_division
distinct_brands
frequency
no_mails_sent
no_promo_responds
ob_net_sales_p
ob_recency
ratio_last_first
ratio_returns_sales
recency
recency_mail
recency_promo_purchase
);

proc sql;
select count(*), sum(attr_flag) from &brand._recent_data;
quit;


proc univariate data=loc.&brand._recent_data_num;
var
average_discount_p
avg_ticket_size
count_division
distinct_brands
frequency
no_mails_sent
no_promo_responds
ob_net_sales_p
ob_recency
ratio_last_first
ratio_returns_sales
recency
recency_mail
recency_promo_purchase
;
output out = percentile_info
pctlpre = 
average_discount_p_
avg_ticket_size_
count_division_
distinct_brands_
frequency_
no_mails_sent_
no_promo_responds_
ob_net_sales_p_
ob_recency_
ratio_last_first_
ratio_returns_sales_
recency_
recency_mail_
recency_promo_purchase_
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
            outfile= "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Attrition Files\AT\AE\Recent\outlier_limit.csv" 
            dbms=csv replace;
     putnames=yes;
run;
