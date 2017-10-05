libname datalib "\\10.8.8.51\lv0\tanumoy\datasets\from hive\";

options macrogen symbolgen mlogic mprint;

%let brand=gp;





%macro converthive(samples, brand, inpath, outpath);

libname datalib "&outpath"; 

libname inlib "&inpath";

%let samplecount=%sysfunc(countw(&samples));

%do i=1 %to &samplecount;
		
		%let samplename=%scan(&samples,&i," ");
   		%put &samplename;

   		%let baseds=&brand._&samplename._combined;


	    %let dataset = &inpath.\&baseds..txt;
		%put &dataset;

		%if %sysfunc(fileexist(&dataset)) %then %do;

			data datalib.&baseds;
			infile "&dataset" 
			delimiter = '|' missover dsd lrecl=32767 firstobs=1;

				informat campaign_version best32.;
				informat customer_key best32.;
				informat event_date yymmdd10.;
				informat emailopens best32.;
				informat emailopenflag best32.;
				informat emailclicks best32.;
				informat emailclickflag best32.;
				informat responder best32.;
				informat num_txns best32.;
				informat item_qty best32.;
				informat gross_sales_amt best32.;
				informat discount_amt best32.;
				informat tot_prd_cst_amt best32.;
				informat net_sales_amt best32.;
				informat net_margin best32.;
				informat net_sales_amt_6mo_sls best32.;
				informat net_sales_amt_12mo_sls best32.;
				informat net_sales_amt_plcb_6mo_sls best32.;
				informat net_sales_amt_plcb_12mo_sls best32.;
				informat discount_amt_6mo_sls best32.;
				informat discount_amt_12mo_sls best32.;
				informat net_margin_6mo_sls best32.;
				informat net_margin_12mo_sls best32.;
				informat item_qty_6mo_sls best32.;
				informat item_qty_12mo_sls best32.;
				informat item_qty_onsale_6mo_sls best32.;
				informat item_qty_onsale_12mo_sls best32.;
				informat num_txns_6mo_sls best32.;
				informat num_txns_12mo_sls best32.;
				informat num_txns_plcb_6mo_sls best32.;
				informat num_txns_plcb_12mo_sls best32.;
				informat net_sales_amt_6mo_rtn best32.;
				informat net_sales_amt_12mo_rtn best32.;
				informat item_qty_6mo_rtn best32.;
				informat item_qty_12mo_rtn best32.;
				informat num_txns_6mo_rtn best32.;
				informat num_txns_12mo_rtn best32.;
				informat net_sales_amt_6mo_sls_cp best32.;
				informat net_sales_amt_12mo_sls_cp best32.;
				informat net_sales_amt_plcb_6mo_sls_cp best32.;
				informat net_sales_amt_plcb_12mo_sls_cp best32.;
				informat item_qty_6mo_sls_cp best32.;
				informat item_qty_12mo_sls_cp best32.;
				informat item_qty_onsale_6mo_sls_cp best32.;
				informat item_qty_onsale_12mo_sls_cp best32.;
				informat num_txns_6mo_sls_cp best32.;
				informat num_txns_12mo_sls_cp best32.;
				informat num_txns_plcb_6mo_sls_cp best32.;
				informat num_txns_plcb_12mo_sls_cp best32.;
				informat net_sales_amt_6mo_rtn_cp best32.;
				informat net_sales_amt_12mo_rtn_cp best32.;
				informat item_qty_6mo_rtn_cp best32.;
				informat item_qty_12mo_rtn_cp best32.;
				informat num_txns_6mo_rtn_cp best32.;
				informat num_txns_12mo_rtn_cp best32.;
				informat visasig_flag best32.;
				informat basic_flag best32.;
				informat silver_flag best32.;
				informat sister_flag best32.;
				informat card_status best32.;
				informat days_last_pur best32.;
				informat days_last_pur_cp best32.;
				informat days_on_books best32.;
				informat days_on_books_cp best32.;
				informat div_shp best32.;
				informat div_shp_cp best32.;
				informat emails_clicked best32.;
				informat emails_clicked_cp best32.;
				informat emails_opened best32.;
				informat emails_opened_cp best32.;

				format campaign_version best32.;
				format customer_key best32.;
				format event_date yymmdd10.;
				informat emailopens best32.;
				informat emailopenflag best32.;
				informat emailclicks best32.;
				informat emailclickflag best32.;
				format responder best32.;
				format num_txns best32.;
				format item_qty best32.;
				format gross_sales_amt best32.;
				format discount_amt best32.;
				format tot_prd_cst_amt best32.;
				format net_sales_amt best32.;
				format net_margin best32.;
				format net_sales_amt_6mo_sls best32.;
				format net_sales_amt_12mo_sls best32.;
				format net_sales_amt_plcb_6mo_sls best32.;
				format net_sales_amt_plcb_12mo_sls best32.;
				format discount_amt_6mo_sls best32.;
				format discount_amt_12mo_sls best32.;
				format net_margin_6mo_sls best32.;
				format net_margin_12mo_sls best32.;
				format item_qty_6mo_sls best32.;
				format item_qty_12mo_sls best32.;
				format item_qty_onsale_6mo_sls best32.;
				format item_qty_onsale_12mo_sls best32.;
				format num_txns_6mo_sls best32.;
				format num_txns_12mo_sls best32.;
				format num_txns_plcb_6mo_sls best32.;
				format num_txns_plcb_12mo_sls best32.;
				format net_sales_amt_6mo_rtn best32.;
				format net_sales_amt_12mo_rtn best32.;
				format item_qty_6mo_rtn best32.;
				format item_qty_12mo_rtn best32.;
				format num_txns_6mo_rtn best32.;
				format num_txns_12mo_rtn best32.;
				format net_sales_amt_6mo_sls_cp best32.;
				format net_sales_amt_12mo_sls_cp best32.;
				format net_sales_amt_plcb_6mo_sls_cp best32.;
				format net_sales_amt_plcb_12mo_sls_cp best32.;
				format item_qty_6mo_sls_cp best32.;
				format item_qty_12mo_sls_cp best32.;
				format item_qty_onsale_6mo_sls_cp best32.;
				format item_qty_onsale_12mo_sls_cp best32.;
				format num_txns_6mo_sls_cp best32.;
				format num_txns_12mo_sls_cp best32.;
				format num_txns_plcb_6mo_sls_cp best32.;
				format num_txns_plcb_12mo_sls_cp best32.;
				format net_sales_amt_6mo_rtn_cp best32.;
				format net_sales_amt_12mo_rtn_cp best32.;
				format item_qty_6mo_rtn_cp best32.;
				format item_qty_12mo_rtn_cp best32.;
				format num_txns_6mo_rtn_cp best32.;
				format num_txns_12mo_rtn_cp best32.;
				format visasig_flag best32.;
				format basic_flag best32.;
				format silver_flag best32.;
				format sister_flag best32.;
				format card_status best32.;
				format days_last_pur best32.;
				format days_last_pur_cp best32.;
				format days_on_books best32.;
				format days_on_books_cp best32.;
				format div_shp best32.;
				format div_shp_cp best32.;
				format emails_clicked best32.;
				format emails_clicked_cp best32.;
				format emails_opened best32.;
				format emails_opened_cp best32.;

				input
				campaign_version
				customer_key
				event_date
				emailopens
				emailopenflag
				emailclicks
				emailclickflag
				responder
				num_txns
				item_qty
				gross_sales_amt
				discount_amt
				tot_prd_cst_amt
				net_sales_amt
				net_margin
				net_sales_amt_6mo_sls
				net_sales_amt_12mo_sls
				net_sales_amt_plcb_6mo_sls
				net_sales_amt_plcb_12mo_sls
				discount_amt_6mo_sls
				discount_amt_12mo_sls
				net_margin_6mo_sls
				net_margin_12mo_sls
				item_qty_6mo_sls
				item_qty_12mo_sls
				item_qty_onsale_6mo_sls
				item_qty_onsale_12mo_sls
				num_txns_6mo_sls
				num_txns_12mo_sls
				num_txns_plcb_6mo_sls
				num_txns_plcb_12mo_sls
				net_sales_amt_6mo_rtn
				net_sales_amt_12mo_rtn
				item_qty_6mo_rtn
				item_qty_12mo_rtn
				num_txns_6mo_rtn
				num_txns_12mo_rtn
				net_sales_amt_6mo_sls_cp
				net_sales_amt_12mo_sls_cp
				net_sales_amt_plcb_6mo_sls_cp
				net_sales_amt_plcb_12mo_sls_cp
				item_qty_6mo_sls_cp
				item_qty_12mo_sls_cp
				item_qty_onsale_6mo_sls_cp
				item_qty_onsale_12mo_sls_cp
				num_txns_6mo_sls_cp
				num_txns_12mo_sls_cp
				num_txns_plcb_6mo_sls_cp
				num_txns_plcb_12mo_sls_cp
				net_sales_amt_6mo_rtn_cp
				net_sales_amt_12mo_rtn_cp
				item_qty_6mo_rtn_cp
				item_qty_12mo_rtn_cp
				num_txns_6mo_rtn_cp
				num_txns_12mo_rtn_cp
				visasig_flag
				basic_flag
				silver_flag
				sister_flag
				card_status
				days_last_pur
				days_last_pur_cp
				days_on_books
				days_on_books_cp
				div_shp
				div_shp_cp
				emails_clicked
				emails_clicked_cp
				emails_opened
				emails_opened_cp
				;

			run;

			options noxwait;
			
		%end;

%end;

%mend;

%converthive
(samples=20170917, brand=gp,
inpath =\\10.8.8.51\lv0\tanumoy\datasets\from hive,
outpath=\\10.8.8.51\lv0\tanumoy\datasets\from hive);



*check for nulls or missings;
proc means data=datalib.gp_20170917_combined n nmiss min mean std max; run; *500000;








%macro append(libname, brand, samples);

 %let samplecount=%sysfunc(countw(&samples));

 %do i=1 %to &samplecount;

   %let samplename=%scan(&samples,&i," ");
   %put &samplename;
 
   %if &i=1 %then %do;
    data &libname..&brand._em_combined;
	 set &libname..&brand._&samplename._combined;
	run;
   %end;

   %if &i>1 %then %do;
    proc append base=&libname..&brand._em_combined
				data=&libname..&brand._&samplename._combined force;
	run;
   %end;

 %end;

%mend;

%append(libname=datalib, brand=gp, samples=20170917);




proc means data=datalib.gp_em_combined n nmiss min mean std max;; run; *500000;


*find proportion of responders and non responders in the combined sample and store the values in global variables;

proc sql;
 select count(*) into: responders from datalib.&brand._em_combined where responder=1;
 select count(*) into: nonresponders from datalib.&brand._em_combined where responder=0;
quit;

%let prop_responders=%sysevalf(&responders/%sysevalf(&responders+&nonresponders));
%let prop_nonresponders=%sysevalf(&nonresponders/%sysevalf(&responders+&nonresponders));
%put &prop_responders &prop_nonresponders;

/*symbolgen:  macro variable nonresponders resolves to 53008251*/
/*symbolgen:  macro variable responders resolves to   167501*/
/*symbolgen:  macro variable prop_responders resolves to 0.00314995075198*/
/*symbolgen:  macro variable prop_nonresponders resolves to 0.99685004924801*/


*assign global variables;

dm "output" clear;
%let seed=3000;
%let train_test=0.7;

*create training and testing/validation datasets from the combined sample. 
 also create the offset variable to adjust the intercept for balancing;

data datalib.&brand._em_combined;
 set datalib.&brand._em_combined;
 if training = . then do;
  random_no=ranuni(&seed);
  training=0; testing=0;
  if random_no<=&train_test then training=1;
  if random_no>&train_test then testing=1;
 end;
 drop random_no;
run;


*create a balanced sample for responders and nonresponders;

data datalib.&brand._em_responders;
 set datalib.&brand._em_combined;
 where responder=1;
 drop random_no;
run;

data datalib.&brand._em_nonresponders;
 set datalib.&brand._em_combined;
 where responder=0;
 random_no=ranuni(&seed);
run;

proc sort data=datalib.&brand._em_nonresponders
		  out=&brand._em_nonresponders;
 by random_no;
run;

data &brand._em_nonresponders;
 set &brand._em_nonresponders;
 if _n_<=round(&responders);
 drop random_no;
run;



data datalib.&brand._em_balanced;
 set datalib.&brand._em_responders;
run;

proc append base=datalib.&brand._em_balanced
            data=&brand._em_nonresponders force;
run;

proc freq data=datalib.&brand._em_balanced;
 table responder;
run;

*find proportion of responders and non responders in the balanced sample and store the values in global variables;

proc sql;
 select count(*) into: responders_bal from datalib.&brand._em_balanced where responder=1;
 select count(*) into: nonresponders_bal from datalib.&brand._em_balanced where responder=0;
quit;

%let prop_responders_bal=%sysevalf(&responders_bal/%sysevalf(&responders_bal+&nonresponders_bal));
%let prop_nonresponders_bal=%sysevalf(&nonresponders_bal/%sysevalf(&responders_bal+&nonresponders_bal));
%put &prop_responders_bal &prop_nonresponders_bal;


/*symbolgen:  macro variable nonresponders_bal resolves to   167501*/
/*symbolgen:  macro variable responders_bal resolves to   167501*/
/*symbolgen:  macro variable prop_responders_bal resolves to 0.5*/
/*symbolgen:  macro variable prop_nonresponders_bal resolves to 0.5*/



data datalib.&brand._em_resp_prop_1;
 prop_responders_bal = &prop_responders_bal;
 prop_nonresponders_bal = &prop_nonresponders_bal;
 prop_responders = &prop_responders;
 prop_nonresponders = &prop_nonresponders;
run;

data datalib.&brand._em_resp_prop_1;
 set datalib.&brand._em_resp_prop_1;
 call symput ("prop_responders", prop_responders);
 call symput ("prop_responders_bal", prop_responders_bal);
 call symput ("prop_nonresponders", prop_nonresponders);
 call symput ("prop_nonresponders_bal", prop_nonresponders_bal);
run;

%put &prop_responders &prop_nonresponders;
%put &prop_responders_bal &prop_nonresponders_bal;


*create the additional metrics for the balanced and unbalanced datasets;

	
data datalib.&brand._em_balanced;	
 set datalib.&brand._em_balanced;	

 if responder=1 then wt=&prop_responders/&prop_responders_bal;	
 if responder=0 then wt=&prop_nonresponders/&prop_nonresponders_bal;	
	
 units_per_txn_12mo_sls=0;	
 if num_txns_12mo_sls ne 0 then 	
	units_per_txn_12mo_sls=item_qty_12mo_sls/num_txns_12mo_sls;
	
 units_per_txn_6mo_sls=0;	
 if num_txns_6mo_sls ne 0 then 	
	units_per_txn_6mo_sls=item_qty_6mo_sls/num_txns_6mo_sls;
	
 avg_ord_sz_12mo=0;	
 if num_txns_12mo_sls ne 0 then 	
	avg_ord_sz_12mo=net_sales_amt_12mo_sls/num_txns_12mo_sls;

 avg_ord_sz_6mo=0;	
 if num_txns_6mo_sls ne 0 then 	
	avg_ord_sz_6mo=net_sales_amt_6mo_sls/num_txns_6mo_sls;
	
 avg_ord_sz_12mo_cp=0;	
 if num_txns_12mo_sls_cp ne 0 then 	
	avg_ord_sz_12mo_cp=net_sales_amt_12mo_sls_cp/num_txns_12mo_sls_cp;
	
 avg_ord_sz_6mo_cp=0;	
 if num_txns_6mo_sls_cp ne 0 then 	
	avg_ord_sz_6mo_cp=net_sales_amt_6mo_sls_cp/num_txns_6mo_sls_cp;
	
 discount_pct_12mo=0; discount_pct_6mo=0;	
 if net_sales_amt_12mo_sls ne 0 then 	
 	discount_pct_12mo=-discount_amt_12mo_sls/(net_sales_amt_12mo_sls-discount_amt_12mo_sls) * 100;
	
 if net_sales_amt_6mo_sls ne 0 then 	
 	discount_pct_6mo=-discount_amt_6mo_sls/(net_sales_amt_6mo_sls-discount_amt_6mo_sls) * 100;
	
 plcb_txn_pct_12mo=0;	
 if num_txns_12mo_sls ne 0 then	
 	 plcb_txn_pct_12mo=num_txns_plcb_12mo_sls/num_txns_12mo_sls * 100;
	
 plcb_txn_pct_6mo=0;	
 if num_txns_6mo_sls ne 0 then	
 	 plcb_txn_pct_6mo=num_txns_plcb_6mo_sls/num_txns_6mo_sls * 100;
	
 avg_unt_rtl_12mo=0;	
 if item_qty_12mo_sls ne 0 then 	
 avg_unt_rtl_12mo=net_sales_amt_12mo_sls/item_qty_12mo_sls;	
	
 avg_unt_rtl_6mo=0;	
 if item_qty_6mo_sls ne 0 then 	
 avg_unt_rtl_6mo=net_sales_amt_6mo_sls/item_qty_6mo_sls;	
	
 avg_unt_rtl_cp_12mo=0;	
 if item_qty_12mo_sls_cp ne 0 then 	
 avg_unt_rtl_cp_12mo=net_sales_amt_12mo_sls_cp/item_qty_12mo_sls_cp;	
	
 avg_unt_rtl_cp_6mo=0;	
 if item_qty_6mo_sls_cp ne 0 then 	
 avg_unt_rtl_cp_6mo=net_sales_amt_6mo_sls_cp/item_qty_6mo_sls_cp;	
	
 ratio_net_rtn_net_sls_12mo=0;	
 if net_sales_amt_12mo_sls ne 0 then	
 ratio_net_rtn_net_sls_12mo=net_sales_amt_12mo_rtn/net_sales_amt_12mo_sls;	
	
 ratio_net_rtn_net_sls_6mo=0;	
 if net_sales_amt_6mo_sls ne 0 then	
 ratio_net_rtn_net_sls_6mo=net_sales_amt_6mo_rtn/net_sales_amt_6mo_sls;	
	
 years_on_books=days_on_books_cp/365;	

 item_pct_onsale_12mo_sls = 0;
 if item_qty_12mo_sls ne 0 then
 item_pct_onsale_12mo_sls = item_qty_onsale_12mo_sls / item_qty_12mo_sls;

 item_pct_onsale_6mo_sls = 0;
 if item_qty_6mo_sls ne 0 then
 item_pct_onsale_6mo_sls = item_qty_onsale_6mo_sls / item_qty_6mo_sls;
 
 item_pct_onsale_12mo_sls_cp = 0;
 if item_qty_12mo_sls_cp ne 0 then
 item_pct_onsale_12mo_sls_cp = item_qty_onsale_12mo_sls_cp / item_qty_12mo_sls_cp;

 item_pct_onsale_6mo_sls_cp = 0;
 if item_qty_6mo_sls_cp ne 0 then
 item_pct_onsale_6mo_sls_cp = item_qty_onsale_6mo_sls_cp / item_qty_6mo_sls_cp;

 emails_pct_clicked = 0;
 if emails_opened ne 0 then
 emails_pct_clicked = emails_clicked/emails_opened;
 
 emails_pct_clicked_cp = 0;
 if emails_opened_cp ne 0 then
 emails_pct_clicked_cp = emails_clicked_cp/emails_opened_cp;

 div_shp_pct = div_shp / 8;

 offset=log((&prop_nonresponders * &prop_responders_bal)/(&prop_responders * &prop_nonresponders_bal));	
 	
run;	




data datalib.&brand._em_combined;	
 set datalib.&brand._em_combined;	

 if responder=1 then wt=&prop_responders/&prop_responders_bal;	
 if responder=0 then wt=&prop_nonresponders/&prop_nonresponders_bal;	
	
 units_per_txn_12mo_sls=0;	
 if num_txns_12mo_sls ne 0 then 	
	units_per_txn_12mo_sls=item_qty_12mo_sls/num_txns_12mo_sls;
	
 units_per_txn_6mo_sls=0;	
 if num_txns_6mo_sls ne 0 then 	
	units_per_txn_6mo_sls=item_qty_6mo_sls/num_txns_6mo_sls;
	
 avg_ord_sz_12mo=0;	
 if num_txns_12mo_sls ne 0 then 	
	avg_ord_sz_12mo=net_sales_amt_12mo_sls/num_txns_12mo_sls;

 avg_ord_sz_6mo=0;	
 if num_txns_6mo_sls ne 0 then 	
	avg_ord_sz_6mo=net_sales_amt_6mo_sls/num_txns_6mo_sls;
	
 avg_ord_sz_12mo_cp=0;	
 if num_txns_12mo_sls_cp ne 0 then 	
	avg_ord_sz_12mo_cp=net_sales_amt_12mo_sls_cp/num_txns_12mo_sls_cp;
	
 avg_ord_sz_6mo_cp=0;	
 if num_txns_6mo_sls_cp ne 0 then 	
	avg_ord_sz_6mo_cp=net_sales_amt_6mo_sls_cp/num_txns_6mo_sls_cp;
	
 discount_pct_12mo=0; discount_pct_6mo=0;	
 if net_sales_amt_12mo_sls ne 0 then 	
 	discount_pct_12mo=-discount_amt_12mo_sls/(net_sales_amt_12mo_sls-discount_amt_12mo_sls) * 100;
	
 if net_sales_amt_6mo_sls ne 0 then 	
 	discount_pct_6mo=-discount_amt_6mo_sls/(net_sales_amt_6mo_sls-discount_amt_6mo_sls) * 100;
	
 plcb_txn_pct_12mo=0;	
 if num_txns_12mo_sls ne 0 then	
 	 plcb_txn_pct_12mo=num_txns_plcb_12mo_sls/num_txns_12mo_sls * 100;
	
 plcb_txn_pct_6mo=0;	
 if num_txns_6mo_sls ne 0 then	
 	 plcb_txn_pct_6mo=num_txns_plcb_6mo_sls/num_txns_6mo_sls * 100;
	
 avg_unt_rtl_12mo=0;	
 if item_qty_12mo_sls ne 0 then 	
 avg_unt_rtl_12mo=net_sales_amt_12mo_sls/item_qty_12mo_sls;	
	
 avg_unt_rtl_6mo=0;	
 if item_qty_6mo_sls ne 0 then 	
 avg_unt_rtl_6mo=net_sales_amt_6mo_sls/item_qty_6mo_sls;	
	
 avg_unt_rtl_cp_12mo=0;	
 if item_qty_12mo_sls_cp ne 0 then 	
 avg_unt_rtl_cp_12mo=net_sales_amt_12mo_sls_cp/item_qty_12mo_sls_cp;	
	
 avg_unt_rtl_cp_6mo=0;	
 if item_qty_6mo_sls_cp ne 0 then 	
 avg_unt_rtl_cp_6mo=net_sales_amt_6mo_sls_cp/item_qty_6mo_sls_cp;	
	
 ratio_net_rtn_net_sls_12mo=0;	
 if net_sales_amt_12mo_sls ne 0 then	
 ratio_net_rtn_net_sls_12mo=net_sales_amt_12mo_rtn/net_sales_amt_12mo_sls;	
	
 ratio_net_rtn_net_sls_6mo=0;	
 if net_sales_amt_6mo_sls ne 0 then	
 ratio_net_rtn_net_sls_6mo=net_sales_amt_6mo_rtn/net_sales_amt_6mo_sls;	
	
 years_on_books=days_on_books_cp/365;	

 item_pct_onsale_12mo_sls = 0;
 if item_qty_12mo_sls ne 0 then
 item_pct_onsale_12mo_sls = item_qty_onsale_12mo_sls / item_qty_12mo_sls;

 item_pct_onsale_6mo_sls = 0;
 if item_qty_6mo_sls ne 0 then
 item_pct_onsale_6mo_sls = item_qty_onsale_6mo_sls / item_qty_6mo_sls;
 
 item_pct_onsale_12mo_sls_cp = 0;
 if item_qty_12mo_sls_cp ne 0 then
 item_pct_onsale_12mo_sls_cp = item_qty_onsale_12mo_sls_cp / item_qty_12mo_sls_cp;

 item_pct_onsale_6mo_sls_cp = 0;
 if item_qty_6mo_sls_cp ne 0 then
 item_pct_onsale_6mo_sls_cp = item_qty_onsale_6mo_sls_cp / item_qty_6mo_sls_cp;

 emails_pct_clicked = 0;
 if emails_opened ne 0 then
 emails_pct_clicked = emails_clicked/emails_opened;
 
 emails_pct_clicked_cp = 0;
 if emails_opened_cp ne 0 then
 emails_pct_clicked_cp = emails_clicked_cp/emails_opened_cp;

 div_shp_pct = div_shp / 8; 

 offset=log((&prop_nonresponders * &prop_responders_bal)/(&prop_responders * &prop_nonresponders_bal));	
 	
run;	


proc univariate data=datalib.&brand._em_combined;
var 
avg_ord_sz_12mo
avg_ord_sz_12mo_cp
avg_ord_sz_6mo
avg_ord_sz_6mo_cp
avg_unt_rtl_12mo
avg_unt_rtl_6mo
avg_unt_rtl_cp_12mo
avg_unt_rtl_cp_6mo
days_last_pur
days_last_pur_cp
days_on_books
days_on_books_cp
discount_amt_12mo_sls
discount_amt_6mo_sls
discount_pct_12mo
discount_pct_6mo
div_shp
div_shp_cp
emails_clicked
emails_clicked_cp
emails_opened
emails_opened_cp
emails_pct_clicked
emails_pct_clicked_cp
item_qty_12mo_rtn
item_qty_12mo_rtn_cp
item_qty_12mo_sls
item_qty_12mo_sls_cp
item_qty_6mo_rtn
item_qty_6mo_rtn_cp
item_qty_6mo_sls
item_qty_6mo_sls_cp
item_qty_onsale_12mo_sls
item_qty_onsale_12mo_sls_cp
item_qty_onsale_6mo_sls
item_qty_onsale_6mo_sls_cp
item_pct_onsale_12mo_sls
item_pct_onsale_12mo_sls_cp
item_pct_onsale_6mo_sls
item_pct_onsale_6mo_sls_cp
net_margin_12mo_sls
net_margin_6mo_sls
net_sales_amt_12mo_rtn
net_sales_amt_12mo_rtn_cp
net_sales_amt_12mo_sls
net_sales_amt_12mo_sls_cp
net_sales_amt_6mo_rtn
net_sales_amt_6mo_rtn_cp
net_sales_amt_6mo_sls
net_sales_amt_6mo_sls_cp
net_sales_amt_plcb_12mo_sls
net_sales_amt_plcb_12mo_sls_cp
net_sales_amt_plcb_6mo_sls
net_sales_amt_plcb_6mo_sls_cp
num_txns_12mo_rtn
num_txns_12mo_rtn_cp
num_txns_12mo_sls
num_txns_12mo_sls_cp
num_txns_6mo_rtn
num_txns_6mo_rtn_cp
num_txns_6mo_sls
num_txns_6mo_sls_cp
num_txns_plcb_12mo_sls
num_txns_plcb_12mo_sls_cp
num_txns_plcb_6mo_sls
num_txns_plcb_6mo_sls_cp
plcb_txn_pct_12mo
plcb_txn_pct_6mo
ratio_net_rtn_net_sls_12mo
ratio_net_rtn_net_sls_6mo
units_per_txn_12mo_sls
units_per_txn_6mo_sls
years_on_books
     ;
     
output out=datalib.&brand._em_allcampaigns_pctl
	   pctlpre = avg_ord_sz_12mo_
avg_ord_sz_12mo_cp_
avg_ord_sz_6mo_
avg_ord_sz_6mo_cp_
avg_unt_rtl_12mo_
avg_unt_rtl_6mo_
avg_unt_rtl_cp_12mo_
avg_unt_rtl_cp_6mo_
days_last_pur_
days_last_pur_cp_
days_on_books_
days_on_books_cp_
discount_amt_12mo_sls_
discount_amt_6mo_sls_
discount_pct_12mo_
discount_pct_6mo_
div_shp_
div_shp_cp_
emails_clicked_
emails_clicked_cp_
emails_pct_clicked_
emails_pct_clicked_cp_
emails_opened_
emails_opened_cp_
item_qty_12mo_rtn_
item_qty_12mo_rtn_cp_
item_qty_12mo_sls_
item_qty_12mo_sls_cp_
item_qty_6mo_rtn_
item_qty_6mo_rtn_cp_
item_qty_6mo_sls_
item_qty_6mo_sls_cp_
item_qty_onsale_12mo_sls_
item_qty_onsale_12mo_sls_cp_
item_qty_onsale_6mo_sls_
item_qty_onsale_6mo_sls_cp_
item_pct_onsale_12mo_sls_
item_pct_onsale_12mo_sls_cp_
item_pct_onsale_6mo_sls_
item_pct_onsale_6mo_sls_cp_
net_margin_12mo_sls_
net_margin_6mo_sls_
netsales_12mo_rtn_
netsales_12mo_rtn_cp_
netsales_12mo_sls_
netsales_12mo_sls_cp_
netsales_6mo_rtn_
netsales_6mo_rtn_cp_
netsales_6mo_sls_
netsales_6mo_sls_cp_
netsales_plcb_12mo_sls_
netsales_plcb_12mo_sls_cp_
netsales_plcb_6mo_sls_
netsales_plcb_6mo_sls_cp_
num_txns_12mo_rtn_
num_txns_12mo_rtn_cp_
num_txns_12mo_sls_
num_txns_12mo_sls_cp_
num_txns_6mo_rtn_
num_txns_6mo_rtn_cp_
num_txns_6mo_sls_
num_txns_6mo_sls_cp_
num_txns_plcb_12mo_sls_
num_txns_plcb_12mo_sls_cp_
num_txns_plcb_6mo_sls_
num_txns_plcb_6mo_sls_cp_
plcb_txn_pct_12mo_
plcb_txn_pct_6mo_
ratio_net_rtn_net_sls_12mo_
ratio_net_rtn_net_sls_6mo_
units_per_txn_12mo_sls_
units_per_txn_6mo_sls_
years_on_books_
	   pctlpts= 0 0.3 0.5 1 50 99 99.5 99.7 100;
run;

proc transpose data=datalib.&brand._em_allcampaigns_pctl
			   out =datalib.&brand._em_allcampaigns_pctl_t;
run;

data datalib.&brand._em_allcampaigns_pctl_t;
 set datalib.&brand._em_allcampaigns_pctl_t;
 drop _label_;
 where index(_name_,"_0_5") > 0 or index(_name_,"_50") > 0 or index(_name_,"_99_5") > 0;
 if index(_name_,"_0_5") > 0 then percentile_pts = 0.5;
 if index(_name_,"_50") > 0 then percentile_pts = 50;
 if index(_name_,"_99_5") > 0 then percentile_pts = 99.5;
run;


proc sort data=datalib.&brand._em_allcampaigns_pctl_t
          out=datalib.&brand._em_allcampaigns_pctl_t;
 by percentile_pts;
run;

data datalib.&brand._em_allcampaigns_pctl;
set datalib.&brand._em_allcampaigns_pctl;

call symput ("avg_ord_sz_12mo_lc", avg_ord_sz_12mo_0_5);
call symput ("avg_ord_sz_12mo_cp_lc", avg_ord_sz_12mo_cp_0_5);
call symput ("avg_ord_sz_6mo_lc", avg_ord_sz_6mo_0_5);
call symput ("avg_ord_sz_6mo_cp_lc", avg_ord_sz_6mo_cp_0_5);
call symput ("avg_unt_rtl_12mo_lc", avg_unt_rtl_12mo_0_5);
call symput ("avg_unt_rtl_6mo_lc", avg_unt_rtl_6mo_0_5);
call symput ("avg_unt_rtl_cp_12mo_lc", avg_unt_rtl_cp_12mo_0_5);
call symput ("avg_unt_rtl_cp_6mo_lc", avg_unt_rtl_cp_6mo_0_5);
call symput ("days_last_pur_lc", days_last_pur_0_5);
call symput ("days_last_pur_cp_lc", days_last_pur_cp_0_5);
call symput ("days_on_books_lc", days_on_books_0_5);
call symput ("days_on_books_cp_lc", days_on_books_cp_0_5);
call symput ("discount_amt_12mo_sls_lc", discount_amt_12mo_sls_0_5);
call symput ("discount_amt_6mo_sls_lc", discount_amt_6mo_sls_0_5);
call symput ("discount_pct_12mo_lc", discount_pct_12mo_0_5);
call symput ("discount_pct_6mo_lc", discount_pct_6mo_0_5);
call symput ("div_shp_lc", div_shp_0_5);
call symput ("div_shp_cp_lc", div_shp_cp_0_5);
call symput ("emails_clicked_lc", emails_clicked_0_5);
call symput ("emails_clicked_cp_lc", emails_clicked_cp_0_5);
call symput ("emails_opened_lc", emails_opened_0_5);
call symput ("emails_opened_cp_lc", emails_opened_cp_0_5);
call symput ("emails_pct_clicked_lc", emails_pct_clicked_0_5);
call symput ("emails_pct_clicked_cp_lc", emails_pct_clicked_cp_0_5);
call symput ("item_qty_12mo_rtn_lc", item_qty_12mo_rtn_0_5);
call symput ("item_qty_12mo_rtn_cp_lc", item_qty_12mo_rtn_cp_0_5);
call symput ("item_qty_12mo_sls_lc", item_qty_12mo_sls_0_5);
call symput ("item_qty_12mo_sls_cp_lc", item_qty_12mo_sls_cp_0_5);
call symput ("item_qty_6mo_rtn_lc", item_qty_6mo_rtn_0_5);
call symput ("item_qty_6mo_rtn_cp_lc", item_qty_6mo_rtn_cp_0_5);
call symput ("item_qty_6mo_sls_lc", item_qty_6mo_sls_0_5);
call symput ("item_qty_6mo_sls_cp_lc", item_qty_6mo_sls_cp_0_5);
call symput ("item_qty_onsale_12mo_sls_lc", item_qty_onsale_12mo_sls_0_5);
call symput ("item_qty_onsale_12mo_sls_cp_lc", item_qty_onsale_12mo_sls_cp_0_5);
call symput ("item_qty_onsale_6mo_sls_lc", item_qty_onsale_6mo_sls_0_5);
call symput ("item_qty_onsale_6mo_sls_cp_lc", item_qty_onsale_6mo_sls_cp_0_5);
call symput ("item_pct_onsale_12mo_sls_lc", item_pct_onsale_12mo_sls_0_5);
call symput ("item_pct_onsale_12mo_sls_cp_lc", item_pct_onsale_12mo_sls_cp_0_5);
call symput ("item_pct_onsale_6mo_sls_lc", item_pct_onsale_6mo_sls_0_5);
call symput ("item_pct_onsale_6mo_sls_cp_lc", item_pct_onsale_6mo_sls_cp_0_5);
call symput ("net_margin_12mo_sls_lc", net_margin_12mo_sls_0_5);
call symput ("net_margin_6mo_sls_lc", net_margin_6mo_sls_0_5);
call symput ("netsales_12mo_rtn_lc", netsales_12mo_rtn_0_5);
call symput ("netsales_12mo_rtn_cp_lc", netsales_12mo_rtn_cp_0_5);
call symput ("netsales_12mo_sls_lc", netsales_12mo_sls_0_5);
call symput ("netsales_12mo_sls_cp_lc", netsales_12mo_sls_cp_0_5);
call symput ("netsales_6mo_rtn_lc", netsales_6mo_rtn_0_5);
call symput ("netsales_6mo_rtn_cp_lc", netsales_6mo_rtn_cp_0_5);
call symput ("netsales_6mo_sls_lc", netsales_6mo_sls_0_5);
call symput ("netsales_6mo_sls_cp_lc", netsales_6mo_sls_cp_0_5);
call symput ("netsales_plcb_12mo_sls_lc", netsales_plcb_12mo_sls_0_5);
call symput ("netsales_plcb_12mo_sls_cp_lc", netsales_plcb_12mo_sls_cp_0_5);
call symput ("netsales_plcb_6mo_sls_lc", netsales_plcb_6mo_sls_0_5);
call symput ("netsales_plcb_6mo_sls_cp_lc", netsales_plcb_6mo_sls_cp_0_5);
call symput ("num_txns_12mo_rtn_lc", num_txns_12mo_rtn_0_5);
call symput ("num_txns_12mo_rtn_cp_lc", num_txns_12mo_rtn_cp_0_5);
call symput ("num_txns_12mo_sls_lc", num_txns_12mo_sls_0_5);
call symput ("num_txns_12mo_sls_cp_lc", num_txns_12mo_sls_cp_0_5);
call symput ("num_txns_6mo_rtn_lc", num_txns_6mo_rtn_0_5);
call symput ("num_txns_6mo_rtn_cp_lc", num_txns_6mo_rtn_cp_0_5);
call symput ("num_txns_6mo_sls_lc", num_txns_6mo_sls_0_5);
call symput ("num_txns_6mo_sls_cp_lc", num_txns_6mo_sls_cp_0_5);
call symput ("num_txns_plcb_12mo_sls_lc", num_txns_plcb_12mo_sls_0_5);
call symput ("num_txns_plcb_12mo_sls_cp_lc", num_txns_plcb_12mo_sls_cp_0_5);
call symput ("num_txns_plcb_6mo_sls_lc", num_txns_plcb_6mo_sls_0_5);
call symput ("num_txns_plcb_6mo_sls_cp_lc", num_txns_plcb_6mo_sls_cp_0_5);
call symput ("plcb_txn_pct_12mo_lc", plcb_txn_pct_12mo_0_5);
call symput ("plcb_txn_pct_6mo_lc", plcb_txn_pct_6mo_0_5);
call symput ("ratio_net_rtn_net_sls_12mo_lc", ratio_net_rtn_net_sls_12mo_0_5);
call symput ("ratio_net_rtn_net_sls_6mo_lc", ratio_net_rtn_net_sls_6mo_0_5);
call symput ("units_per_txn_12mo_sls_lc", units_per_txn_12mo_sls_0_5);
call symput ("units_per_txn_6mo_sls_lc", units_per_txn_6mo_sls_0_5);
call symput ("years_on_books_lc", years_on_books_0_5);

call symput ("avg_ord_sz_12mo_50", avg_ord_sz_12mo_50);
call symput ("avg_ord_sz_12mo_cp_50", avg_ord_sz_12mo_cp_50);
call symput ("avg_ord_sz_6mo_50", avg_ord_sz_6mo_50);
call symput ("avg_ord_sz_6mo_cp_50", avg_ord_sz_6mo_cp_50);
call symput ("avg_unt_rtl_12mo_50", avg_unt_rtl_12mo_50);
call symput ("avg_unt_rtl_6mo_50", avg_unt_rtl_6mo_50);
call symput ("avg_unt_rtl_cp_12mo_50", avg_unt_rtl_cp_12mo_50);
call symput ("avg_unt_rtl_cp_6mo_50", avg_unt_rtl_cp_6mo_50);
call symput ("days_last_pur_50", days_last_pur_50);
call symput ("days_last_pur_cp_50", days_last_pur_cp_50);
call symput ("days_on_books_50", days_on_books_50);
call symput ("days_on_books_cp_50", days_on_books_cp_50);
call symput ("discount_amt_12mo_sls_50", discount_amt_12mo_sls_50);
call symput ("discount_amt_6mo_sls_50", discount_amt_6mo_sls_50);
call symput ("discount_pct_12mo_50", discount_pct_12mo_50);
call symput ("discount_pct_6mo_50", discount_pct_6mo_50);
call symput ("div_shp_50", div_shp_50);
call symput ("div_shp_cp_50", div_shp_cp_50);
call symput ("emails_clicked_50", emails_clicked_50);
call symput ("emails_clicked_cp_50", emails_clicked_cp_50);
call symput ("emails_opened_50", emails_opened_50);
call symput ("emails_opened_cp_50", emails_opened_cp_50);
call symput ("emails_pct_clicked_50", emails_pct_clicked_50);
call symput ("emails_pct_clicked_cp_50", emails_pct_clicked_cp_50);
call symput ("item_qty_12mo_rtn_50", item_qty_12mo_rtn_50);
call symput ("item_qty_12mo_rtn_cp_50", item_qty_12mo_rtn_cp_50);
call symput ("item_qty_12mo_sls_50", item_qty_12mo_sls_50);
call symput ("item_qty_12mo_sls_cp_50", item_qty_12mo_sls_cp_50);
call symput ("item_qty_6mo_rtn_50", item_qty_6mo_rtn_50);
call symput ("item_qty_6mo_rtn_cp_50", item_qty_6mo_rtn_cp_50);
call symput ("item_qty_6mo_sls_50", item_qty_6mo_sls_50);
call symput ("item_qty_6mo_sls_cp_50", item_qty_6mo_sls_cp_50);
call symput ("item_qty_onsale_12mo_sls_50", item_qty_onsale_12mo_sls_50);
call symput ("item_qty_onsale_12mo_sls_cp_50", item_qty_onsale_12mo_sls_cp_50);
call symput ("item_qty_onsale_6mo_sls_50", item_qty_onsale_6mo_sls_50);
call symput ("item_qty_onsale_6mo_sls_cp_50", item_qty_onsale_6mo_sls_cp_50);
call symput ("item_pct_onsale_12mo_sls_50", item_pct_onsale_12mo_sls_50);
call symput ("item_pct_onsale_12mo_sls_cp_50", item_pct_onsale_12mo_sls_cp_50);
call symput ("item_pct_onsale_6mo_sls_50", item_pct_onsale_6mo_sls_50);
call symput ("item_pct_onsale_6mo_sls_cp_50", item_pct_onsale_6mo_sls_cp_50);
call symput ("net_margin_12mo_sls_50", net_margin_12mo_sls_50);
call symput ("net_margin_6mo_sls_50", net_margin_6mo_sls_50);
call symput ("netsales_12mo_rtn_50", netsales_12mo_rtn_50);
call symput ("netsales_12mo_rtn_cp_50", netsales_12mo_rtn_cp_50);
call symput ("netsales_12mo_sls_50", netsales_12mo_sls_50);
call symput ("netsales_12mo_sls_cp_50", netsales_12mo_sls_cp_50);
call symput ("netsales_6mo_rtn_50", netsales_6mo_rtn_50);
call symput ("netsales_6mo_rtn_cp_50", netsales_6mo_rtn_cp_50);
call symput ("netsales_6mo_sls_50", netsales_6mo_sls_50);
call symput ("netsales_6mo_sls_cp_50", netsales_6mo_sls_cp_50);
call symput ("netsales_plcb_12mo_sls_50", netsales_plcb_12mo_sls_50);
call symput ("netsales_plcb_12mo_sls_cp_50", netsales_plcb_12mo_sls_cp_50);
call symput ("netsales_plcb_6mo_sls_50", netsales_plcb_6mo_sls_50);
call symput ("netsales_plcb_6mo_sls_cp_50", netsales_plcb_6mo_sls_cp_50);
call symput ("num_txns_12mo_rtn_50", num_txns_12mo_rtn_50);
call symput ("num_txns_12mo_rtn_cp_50", num_txns_12mo_rtn_cp_50);
call symput ("num_txns_12mo_sls_50", num_txns_12mo_sls_50);
call symput ("num_txns_12mo_sls_cp_50", num_txns_12mo_sls_cp_50);
call symput ("num_txns_6mo_rtn_50", num_txns_6mo_rtn_50);
call symput ("num_txns_6mo_rtn_cp_50", num_txns_6mo_rtn_cp_50);
call symput ("num_txns_6mo_sls_50", num_txns_6mo_sls_50);
call symput ("num_txns_6mo_sls_cp_50", num_txns_6mo_sls_cp_50);
call symput ("num_txns_plcb_12mo_sls_50", num_txns_plcb_12mo_sls_50);
call symput ("num_txns_plcb_12mo_sls_cp_50", num_txns_plcb_12mo_sls_cp_50);
call symput ("num_txns_plcb_6mo_sls_50", num_txns_plcb_6mo_sls_50);
call symput ("num_txns_plcb_6mo_sls_cp_50", num_txns_plcb_6mo_sls_cp_50);
call symput ("plcb_txn_pct_12mo_50", plcb_txn_pct_12mo_50);
call symput ("plcb_txn_pct_6mo_50", plcb_txn_pct_6mo_50);
call symput ("ratio_net_rtn_net_sls_12mo_50", ratio_net_rtn_net_sls_12mo_50);
call symput ("ratio_net_rtn_net_sls_6mo_50", ratio_net_rtn_net_sls_6mo_50);
call symput ("units_per_txn_12mo_sls_50", units_per_txn_12mo_sls_50);
call symput ("units_per_txn_6mo_sls_50", units_per_txn_6mo_sls_50);
call symput ("years_on_books_50", years_on_books_50);

call symput ("avg_ord_sz_12mo_uc", avg_ord_sz_12mo_99_5);
call symput ("avg_ord_sz_12mo_cp_uc", avg_ord_sz_12mo_cp_99_5);
call symput ("avg_ord_sz_6mo_uc", avg_ord_sz_6mo_99_5);
call symput ("avg_ord_sz_6mo_cp_uc", avg_ord_sz_6mo_cp_99_5);
call symput ("avg_unt_rtl_12mo_uc", avg_unt_rtl_12mo_99_5);
call symput ("avg_unt_rtl_6mo_uc", avg_unt_rtl_6mo_99_5);
call symput ("avg_unt_rtl_cp_12mo_uc", avg_unt_rtl_cp_12mo_99_5);
call symput ("avg_unt_rtl_cp_6mo_uc", avg_unt_rtl_cp_6mo_99_5);
call symput ("days_last_pur_uc", days_last_pur_99_5);
call symput ("days_last_pur_cp_uc", days_last_pur_cp_99_5);
call symput ("days_on_books_uc", days_on_books_99_5);
call symput ("days_on_books_cp_uc", days_on_books_cp_99_5);
call symput ("discount_amt_12mo_sls_uc", discount_amt_12mo_sls_99_5);
call symput ("discount_amt_6mo_sls_uc", discount_amt_6mo_sls_99_5);
call symput ("discount_pct_12mo_uc", discount_pct_12mo_99_5);
call symput ("discount_pct_6mo_uc", discount_pct_6mo_99_5);
call symput ("div_shp_uc", div_shp_99_5);
call symput ("div_shp_cp_uc", div_shp_cp_99_5);
call symput ("emails_clicked_uc", emails_clicked_99_5);
call symput ("emails_clicked_cp_uc", emails_clicked_cp_99_5);
call symput ("emails_opened_uc", emails_opened_99_5);
call symput ("emails_opened_cp_uc", emails_opened_cp_99_5);
call symput ("emails_pct_clicked_uc", emails_pct_clicked_99_5);
call symput ("emails_pct_clicked_cp_uc", emails_pct_clicked_cp_99_5);
call symput ("item_qty_12mo_rtn_uc", item_qty_12mo_rtn_99_5);
call symput ("item_qty_12mo_rtn_cp_uc", item_qty_12mo_rtn_cp_99_5);
call symput ("item_qty_12mo_sls_uc", item_qty_12mo_sls_99_5);
call symput ("item_qty_12mo_sls_cp_uc", item_qty_12mo_sls_cp_99_5);
call symput ("item_qty_6mo_rtn_uc", item_qty_6mo_rtn_99_5);
call symput ("item_qty_6mo_rtn_cp_uc", item_qty_6mo_rtn_cp_99_5);
call symput ("item_qty_6mo_sls_uc", item_qty_6mo_sls_99_5);
call symput ("item_qty_6mo_sls_cp_uc", item_qty_6mo_sls_cp_99_5);
call symput ("item_qty_onsale_12mo_sls_uc", item_qty_onsale_12mo_sls_99_5);
call symput ("item_qty_onsale_12mo_sls_cp_uc", item_qty_onsale_12mo_sls_cp_99_5);
call symput ("item_qty_onsale_6mo_sls_uc", item_qty_onsale_6mo_sls_99_5);
call symput ("item_qty_onsale_6mo_sls_cp_uc", item_qty_onsale_6mo_sls_cp_99_5);
call symput ("item_pct_onsale_12mo_sls_uc", item_pct_onsale_12mo_sls_99_5);
call symput ("item_pct_onsale_12mo_sls_cp_uc", item_pct_onsale_12mo_sls_cp_99_5);
call symput ("item_pct_onsale_6mo_sls_uc", item_pct_onsale_6mo_sls_99_5);
call symput ("item_pct_onsale_6mo_sls_cp_uc", item_pct_onsale_6mo_sls_cp_99_5);
call symput ("net_margin_12mo_sls_uc", net_margin_12mo_sls_99_5);
call symput ("net_margin_6mo_sls_uc", net_margin_6mo_sls_99_5);
call symput ("netsales_12mo_rtn_uc", netsales_12mo_rtn_99_5);
call symput ("netsales_12mo_rtn_cp_uc", netsales_12mo_rtn_cp_99_5);
call symput ("netsales_12mo_sls_uc", netsales_12mo_sls_99_5);
call symput ("netsales_12mo_sls_cp_uc", netsales_12mo_sls_cp_99_5);
call symput ("netsales_6mo_rtn_uc", netsales_6mo_rtn_99_5);
call symput ("netsales_6mo_rtn_cp_uc", netsales_6mo_rtn_cp_99_5);
call symput ("netsales_6mo_sls_uc", netsales_6mo_sls_99_5);
call symput ("netsales_6mo_sls_cp_uc", netsales_6mo_sls_cp_99_5);
call symput ("netsales_plcb_12mo_sls_uc", netsales_plcb_12mo_sls_99_5);
call symput ("netsales_plcb_12mo_sls_cp_uc", netsales_plcb_12mo_sls_cp_99_5);
call symput ("netsales_plcb_6mo_sls_uc", netsales_plcb_6mo_sls_99_5);
call symput ("netsales_plcb_6mo_sls_cp_uc", netsales_plcb_6mo_sls_cp_99_5);
call symput ("num_txns_12mo_rtn_uc", num_txns_12mo_rtn_99_5);
call symput ("num_txns_12mo_rtn_cp_uc", num_txns_12mo_rtn_cp_99_5);
call symput ("num_txns_12mo_sls_uc", num_txns_12mo_sls_99_5);
call symput ("num_txns_12mo_sls_cp_uc", num_txns_12mo_sls_cp_99_5);
call symput ("num_txns_6mo_rtn_uc", num_txns_6mo_rtn_99_5);
call symput ("num_txns_6mo_rtn_cp_uc", num_txns_6mo_rtn_cp_99_5);
call symput ("num_txns_6mo_sls_uc", num_txns_6mo_sls_99_5);
call symput ("num_txns_6mo_sls_cp_uc", num_txns_6mo_sls_cp_99_5);
call symput ("num_txns_plcb_12mo_sls_uc", num_txns_plcb_12mo_sls_99_5);
call symput ("num_txns_plcb_12mo_sls_cp_uc", num_txns_plcb_12mo_sls_cp_99_5);
call symput ("num_txns_plcb_6mo_sls_uc", num_txns_plcb_6mo_sls_99_5);
call symput ("num_txns_plcb_6mo_sls_cp_uc", num_txns_plcb_6mo_sls_cp_99_5);
call symput ("plcb_txn_pct_12mo_uc", plcb_txn_pct_12mo_99_5);
call symput ("plcb_txn_pct_6mo_uc", plcb_txn_pct_6mo_99_5);
call symput ("ratio_net_rtn_net_sls_12mo_uc", ratio_net_rtn_net_sls_12mo_99_5);
call symput ("ratio_net_rtn_net_sls_6mo_uc", ratio_net_rtn_net_sls_6mo_99_5);
call symput ("units_per_txn_12mo_sls_uc", units_per_txn_12mo_sls_99_5);
call symput ("units_per_txn_6mo_sls_uc", units_per_txn_6mo_sls_99_5);
call symput ("years_on_books_uc", years_on_books_99_5);

run;


%put &avg_ord_sz_12mo_lc;  %put &avg_ord_sz_12mo_50;  %put &avg_ord_sz_12mo_uc;
%put &avg_ord_sz_12mo_cp_lc;  %put &avg_ord_sz_12mo_cp_50;  %put &avg_ord_sz_12mo_cp_uc;
%put &avg_ord_sz_6mo_lc;  %put &avg_ord_sz_6mo_50;  %put &avg_ord_sz_6mo_uc;
%put &avg_ord_sz_6mo_cp_lc;  %put &avg_ord_sz_6mo_cp_50;  %put &avg_ord_sz_6mo_cp_uc;
%put &avg_unt_rtl_12mo_lc;  %put &avg_unt_rtl_12mo_50;  %put &avg_unt_rtl_12mo_uc;
%put &avg_unt_rtl_6mo_lc;  %put &avg_unt_rtl_6mo_50;  %put &avg_unt_rtl_6mo_uc;
%put &avg_unt_rtl_cp_12mo_lc;  %put &avg_unt_rtl_cp_12mo_50;  %put &avg_unt_rtl_cp_12mo_uc;
%put &avg_unt_rtl_cp_6mo_lc;  %put &avg_unt_rtl_cp_6mo_50;  %put &avg_unt_rtl_cp_6mo_uc;
%put &days_last_pur_lc;  %put &days_last_pur_50;  %put &days_last_pur_uc;
%put &days_last_pur_cp_lc;  %put &days_last_pur_cp_50;  %put &days_last_pur_cp_uc;
%put &days_on_books_lc;  %put &days_on_books_50;  %put &days_on_books_uc;
%put &days_on_books_cp_lc;  %put &days_on_books_cp_50;  %put &days_on_books_cp_uc;
%put &discount_amt_12mo_sls_lc;  %put &discount_amt_12mo_sls_50;  %put &discount_amt_12mo_sls_uc;
%put &discount_amt_6mo_sls_lc;  %put &discount_amt_6mo_sls_50;  %put &discount_amt_6mo_sls_uc;
%put &discount_pct_12mo_lc;  %put &discount_pct_12mo_50;  %put &discount_pct_12mo_uc;
%put &discount_pct_6mo_lc;  %put &discount_pct_6mo_50;  %put &discount_pct_6mo_uc;
%put &div_shp_lc;  %put &div_shp_50;  %put &div_shp_uc;
%put &div_shp_cp_lc;  %put &div_shp_cp_50;  %put &div_shp_cp_uc;
%put &emails_clicked_lc;  %put &emails_clicked_50;  %put &emails_clicked_uc;
%put &emails_clicked_cp_lc;  %put &emails_clicked_cp_50;  %put &emails_clicked_cp_uc;
%put &emails_opened_lc;  %put &emails_opened_50;  %put &emails_opened_uc;
%put &emails_opened_cp_lc;  %put &emails_opened_cp_50;  %put &emails_opened_cp_uc;
%put &emails_pct_clicked_lc;  %put &emails_pct_clicked_50;  %put &emails_pct_clicked_uc;
%put &emails_pct_clicked_cp_lc;  %put &emails_pct_clicked_cp_50;  %put &emails_pct_clicked_cp_uc;
%put &item_qty_12mo_rtn_lc;  %put &item_qty_12mo_rtn_50;  %put &item_qty_12mo_rtn_uc;
%put &item_qty_12mo_rtn_cp_lc;  %put &item_qty_12mo_rtn_cp_50;  %put &item_qty_12mo_rtn_cp_uc;
%put &item_qty_12mo_sls_lc;  %put &item_qty_12mo_sls_50;  %put &item_qty_12mo_sls_uc;
%put &item_qty_12mo_sls_cp_lc;  %put &item_qty_12mo_sls_cp_50;  %put &item_qty_12mo_sls_cp_uc;
%put &item_qty_6mo_rtn_lc;  %put &item_qty_6mo_rtn_50;  %put &item_qty_6mo_rtn_uc;
%put &item_qty_6mo_rtn_cp_lc;  %put &item_qty_6mo_rtn_cp_50;  %put &item_qty_6mo_rtn_cp_uc;
%put &item_qty_6mo_sls_lc;  %put &item_qty_6mo_sls_50;  %put &item_qty_6mo_sls_uc;
%put &item_qty_6mo_sls_cp_lc;  %put &item_qty_6mo_sls_cp_50;  %put &item_qty_6mo_sls_cp_uc;
%put &item_qty_onsale_12mo_sls_lc;  %put &item_qty_onsale_12mo_sls_50;  %put &item_qty_onsale_12mo_sls_uc;
%put &item_qty_onsale_12mo_sls_cp_lc;  %put &item_qty_onsale_12mo_sls_cp_50;  %put &item_qty_onsale_12mo_sls_cp_uc;
%put &item_qty_onsale_6mo_sls_lc;  %put &item_qty_onsale_6mo_sls_50;  %put &item_qty_onsale_6mo_sls_uc;
%put &item_qty_onsale_6mo_sls_cp_lc;  %put &item_qty_onsale_6mo_sls_cp_50;  %put &item_qty_onsale_6mo_sls_cp_uc;
%put &item_pct_onsale_12mo_sls_lc;  %put &item_pct_onsale_12mo_sls_50;  %put &item_pct_onsale_12mo_sls_uc;
%put &item_pct_onsale_12mo_sls_cp_lc;  %put &item_pct_onsale_12mo_sls_cp_50;  %put &item_pct_onsale_12mo_sls_cp_uc;
%put &item_pct_onsale_6mo_sls_lc;  %put &item_pct_onsale_6mo_sls_50;  %put &item_pct_onsale_6mo_sls_uc;
%put &item_pct_onsale_6mo_sls_cp_lc;  %put &item_pct_onsale_6mo_sls_cp_50;  %put &item_pct_onsale_6mo_sls_cp_uc;
%put &net_margin_12mo_sls_lc;  %put &net_margin_12mo_sls_50;  %put &net_margin_12mo_sls_uc;
%put &net_margin_6mo_sls_lc;  %put &net_margin_6mo_sls_50;  %put &net_margin_6mo_sls_uc;
%put &netsales_12mo_rtn_lc;  %put &netsales_12mo_rtn_50;  %put &netsales_12mo_rtn_uc;
%put &netsales_12mo_rtn_cp_lc;  %put &netsales_12mo_rtn_cp_50;  %put &netsales_12mo_rtn_cp_uc;
%put &netsales_12mo_sls_lc;  %put &netsales_12mo_sls_50;  %put &netsales_12mo_sls_uc;
%put &netsales_12mo_sls_cp_lc;  %put &netsales_12mo_sls_cp_50;  %put &netsales_12mo_sls_cp_uc;
%put &netsales_6mo_rtn_lc;  %put &netsales_6mo_rtn_50;  %put &netsales_6mo_rtn_uc;
%put &netsales_6mo_rtn_cp_lc;  %put &netsales_6mo_rtn_cp_50;  %put &netsales_6mo_rtn_cp_uc;
%put &netsales_6mo_sls_lc;  %put &netsales_6mo_sls_50;  %put &netsales_6mo_sls_uc;
%put &netsales_6mo_sls_cp_lc;  %put &netsales_6mo_sls_cp_50;  %put &netsales_6mo_sls_cp_uc;
%put &netsales_plcb_12mo_sls_lc;  %put &netsales_plcb_12mo_sls_50;  %put &netsales_plcb_12mo_sls_uc;
%put &netsales_plcb_12mo_sls_cp_lc;  %put &netsales_plcb_12mo_sls_cp_50;  %put &netsales_plcb_12mo_sls_cp_uc;
%put &netsales_plcb_6mo_sls_lc;  %put &netsales_plcb_6mo_sls_50;  %put &netsales_plcb_6mo_sls_uc;
%put &netsales_plcb_6mo_sls_cp_lc;  %put &netsales_plcb_6mo_sls_cp_50;  %put &netsales_plcb_6mo_sls_cp_uc;
%put &num_txns_12mo_rtn_lc;  %put &num_txns_12mo_rtn_50;  %put &num_txns_12mo_rtn_uc;
%put &num_txns_12mo_rtn_cp_lc;  %put &num_txns_12mo_rtn_cp_50;  %put &num_txns_12mo_rtn_cp_uc;
%put &num_txns_12mo_sls_lc;  %put &num_txns_12mo_sls_50;  %put &num_txns_12mo_sls_uc;
%put &num_txns_12mo_sls_cp_lc;  %put &num_txns_12mo_sls_cp_50;  %put &num_txns_12mo_sls_cp_uc;
%put &num_txns_6mo_rtn_lc;  %put &num_txns_6mo_rtn_50;  %put &num_txns_6mo_rtn_uc;
%put &num_txns_6mo_rtn_cp_lc;  %put &num_txns_6mo_rtn_cp_50;  %put &num_txns_6mo_rtn_cp_uc;
%put &num_txns_6mo_sls_lc;  %put &num_txns_6mo_sls_50;  %put &num_txns_6mo_sls_uc;
%put &num_txns_6mo_sls_cp_lc;  %put &num_txns_6mo_sls_cp_50;  %put &num_txns_6mo_sls_cp_uc;
%put &num_txns_plcb_12mo_sls_lc;  %put &num_txns_plcb_12mo_sls_50;  %put &num_txns_plcb_12mo_sls_uc;
%put &num_txns_plcb_12mo_sls_cp_lc;  %put &num_txns_plcb_12mo_sls_cp_50;  %put &num_txns_plcb_12mo_sls_cp_uc;
%put &num_txns_plcb_6mo_sls_lc;  %put &num_txns_plcb_6mo_sls_50;  %put &num_txns_plcb_6mo_sls_uc;
%put &num_txns_plcb_6mo_sls_cp_lc;  %put &num_txns_plcb_6mo_sls_cp_50;  %put &num_txns_plcb_6mo_sls_cp_uc;
%put &plcb_txn_pct_12mo_lc;  %put &plcb_txn_pct_12mo_50;  %put &plcb_txn_pct_12mo_uc;
%put &plcb_txn_pct_6mo_lc;  %put &plcb_txn_pct_6mo_50;  %put &plcb_txn_pct_6mo_uc;
%put &ratio_net_rtn_net_sls_12mo_lc;  %put &ratio_net_rtn_net_sls_12mo_50;  %put &ratio_net_rtn_net_sls_12mo_uc;
%put &ratio_net_rtn_net_sls_6mo_lc;  %put &ratio_net_rtn_net_sls_6mo_50;  %put &ratio_net_rtn_net_sls_6mo_uc;
%put &units_per_txn_12mo_sls_lc;  %put &units_per_txn_12mo_sls_50;  %put &units_per_txn_12mo_sls_uc;
%put &units_per_txn_6mo_sls_lc;  %put &units_per_txn_6mo_sls_50;  %put &units_per_txn_6mo_sls_uc;
%put &years_on_books_lc;  %put &years_on_books_50;  %put &years_on_books_uc;


data &brand._em_balanced_2;
set datalib.&brand._em_balanced;

if avg_ord_sz_12mo ge &avg_ord_sz_12mo_uc then avg_ord_sz_12mo=&avg_ord_sz_12mo_uc;
if avg_ord_sz_12mo_cp ge &avg_ord_sz_12mo_cp_uc then avg_ord_sz_12mo_cp=&avg_ord_sz_12mo_cp_uc;
if avg_ord_sz_6mo ge &avg_ord_sz_6mo_uc then avg_ord_sz_6mo=&avg_ord_sz_6mo_uc;
if avg_ord_sz_6mo_cp ge &avg_ord_sz_6mo_cp_uc then avg_ord_sz_6mo_cp=&avg_ord_sz_6mo_cp_uc;
if avg_unt_rtl_12mo ge &avg_unt_rtl_12mo_uc then avg_unt_rtl_12mo=&avg_unt_rtl_12mo_uc;
if avg_unt_rtl_6mo ge &avg_unt_rtl_6mo_uc then avg_unt_rtl_6mo=&avg_unt_rtl_6mo_uc;
if avg_unt_rtl_cp_12mo ge &avg_unt_rtl_cp_12mo_uc then avg_unt_rtl_cp_12mo=&avg_unt_rtl_cp_12mo_uc;
if avg_unt_rtl_cp_6mo ge &avg_unt_rtl_cp_6mo_uc then avg_unt_rtl_cp_6mo=&avg_unt_rtl_cp_6mo_uc;
if days_last_pur ge &days_last_pur_uc then days_last_pur=&days_last_pur_uc;
if days_last_pur_cp ge &days_last_pur_cp_uc then days_last_pur_cp=&days_last_pur_cp_uc;
if days_on_books ge &days_on_books_uc then days_on_books=&days_on_books_uc;
if days_on_books_cp ge &days_on_books_cp_uc then days_on_books_cp=&days_on_books_cp_uc;
if discount_amt_12mo_sls ge &discount_amt_12mo_sls_uc then discount_amt_12mo_sls=&discount_amt_12mo_sls_uc;
if discount_amt_6mo_sls ge &discount_amt_6mo_sls_uc then discount_amt_6mo_sls=&discount_amt_6mo_sls_uc;
if discount_pct_12mo ge &discount_pct_12mo_uc then discount_pct_12mo=&discount_pct_12mo_uc;
if discount_pct_6mo ge &discount_pct_6mo_uc then discount_pct_6mo=&discount_pct_6mo_uc;
if div_shp ge &div_shp_uc then div_shp=&div_shp_uc;
if div_shp_cp ge &div_shp_cp_uc then div_shp_cp=&div_shp_cp_uc;
if emails_clicked ge &emails_clicked_uc then emails_clicked=&emails_clicked_uc;
if emails_clicked_cp ge &emails_clicked_cp_uc then emails_clicked_cp=&emails_clicked_cp_uc;
if emails_opened ge &emails_opened_uc then emails_opened=&emails_opened_uc;
if emails_opened_cp ge &emails_opened_cp_uc then emails_opened_cp=&emails_opened_cp_uc;
if emails_pct_clicked ge &emails_pct_clicked_uc then emails_pct_clicked=&emails_pct_clicked_uc;
if emails_pct_clicked_cp ge &emails_pct_clicked_cp_uc then emails_pct_clicked_cp=&emails_pct_clicked_cp_uc;
if item_qty_12mo_rtn ge &item_qty_12mo_rtn_uc then item_qty_12mo_rtn=&item_qty_12mo_rtn_uc;
if item_qty_12mo_rtn_cp ge &item_qty_12mo_rtn_cp_uc then item_qty_12mo_rtn_cp=&item_qty_12mo_rtn_cp_uc;
if item_qty_12mo_sls ge &item_qty_12mo_sls_uc then item_qty_12mo_sls=&item_qty_12mo_sls_uc;
if item_qty_12mo_sls_cp ge &item_qty_12mo_sls_cp_uc then item_qty_12mo_sls_cp=&item_qty_12mo_sls_cp_uc;
if item_qty_6mo_rtn ge &item_qty_6mo_rtn_uc then item_qty_6mo_rtn=&item_qty_6mo_rtn_uc;
if item_qty_6mo_rtn_cp ge &item_qty_6mo_rtn_cp_uc then item_qty_6mo_rtn_cp=&item_qty_6mo_rtn_cp_uc;
if item_qty_6mo_sls ge &item_qty_6mo_sls_uc then item_qty_6mo_sls=&item_qty_6mo_sls_uc;
if item_qty_6mo_sls_cp ge &item_qty_6mo_sls_cp_uc then item_qty_6mo_sls_cp=&item_qty_6mo_sls_cp_uc;
if item_qty_onsale_12mo_sls ge &item_qty_onsale_12mo_sls_uc then item_qty_onsale_12mo_sls=&item_qty_onsale_12mo_sls_uc;
if item_qty_onsale_12mo_sls_cp ge &item_qty_onsale_12mo_sls_cp_uc then item_qty_onsale_12mo_sls_cp=&item_qty_onsale_12mo_sls_cp_uc;
if item_qty_onsale_6mo_sls ge &item_qty_onsale_6mo_sls_uc then item_qty_onsale_6mo_sls=&item_qty_onsale_6mo_sls_uc;
if item_qty_onsale_6mo_sls_cp ge &item_qty_onsale_6mo_sls_cp_uc then item_qty_onsale_6mo_sls_cp=&item_qty_onsale_6mo_sls_cp_uc;
if item_pct_onsale_12mo_sls ge &item_pct_onsale_12mo_sls_uc then item_pct_onsale_12mo_sls=&item_pct_onsale_12mo_sls_uc;
if item_pct_onsale_12mo_sls_cp ge &item_pct_onsale_12mo_sls_cp_uc then item_pct_onsale_12mo_sls_cp=&item_pct_onsale_12mo_sls_cp_uc;
if item_pct_onsale_6mo_sls ge &item_pct_onsale_6mo_sls_uc then item_pct_onsale_6mo_sls=&item_pct_onsale_6mo_sls_uc;
if item_pct_onsale_6mo_sls_cp ge &item_pct_onsale_6mo_sls_cp_uc then item_pct_onsale_6mo_sls_cp=&item_pct_onsale_6mo_sls_cp_uc;
if net_margin_12mo_sls ge &net_margin_12mo_sls_uc then net_margin_12mo_sls=&net_margin_12mo_sls_uc;
if net_margin_6mo_sls ge &net_margin_6mo_sls_uc then net_margin_6mo_sls=&net_margin_6mo_sls_uc;
if net_sales_amt_12mo_rtn ge &netsales_12mo_rtn_uc then net_sales_amt_12mo_rtn=&netsales_12mo_rtn_uc;
if net_sales_amt_12mo_rtn_cp ge &netsales_12mo_rtn_cp_uc then net_sales_amt_12mo_rtn_cp=&netsales_12mo_rtn_cp_uc;
if net_sales_amt_12mo_sls ge &netsales_12mo_sls_uc then net_sales_amt_12mo_sls=&netsales_12mo_sls_uc;
if net_sales_amt_12mo_sls_cp ge &netsales_12mo_sls_cp_uc then net_sales_amt_12mo_sls_cp=&netsales_12mo_sls_cp_uc;
if net_sales_amt_6mo_rtn ge &netsales_6mo_rtn_uc then net_sales_amt_6mo_rtn=&netsales_6mo_rtn_uc;
if net_sales_amt_6mo_rtn_cp ge &netsales_6mo_rtn_cp_uc then net_sales_amt_6mo_rtn_cp=&netsales_6mo_rtn_cp_uc;
if net_sales_amt_6mo_sls ge &netsales_6mo_sls_uc then net_sales_amt_6mo_sls=&netsales_6mo_sls_uc;
if net_sales_amt_6mo_sls_cp ge &netsales_6mo_sls_cp_uc then net_sales_amt_6mo_sls_cp=&netsales_6mo_sls_cp_uc;
if net_sales_amt_plcb_12mo_sls ge &netsales_plcb_12mo_sls_uc then net_sales_amt_plcb_12mo_sls=&netsales_plcb_12mo_sls_uc;
if net_sales_amt_plcb_12mo_sls_cp ge &netsales_plcb_12mo_sls_cp_uc then net_sales_amt_plcb_12mo_sls_cp=&netsales_plcb_12mo_sls_cp_uc;
if net_sales_amt_plcb_6mo_sls ge &netsales_plcb_6mo_sls_uc then net_sales_amt_plcb_6mo_sls=&netsales_plcb_6mo_sls_uc;
if net_sales_amt_plcb_6mo_sls_cp ge &netsales_plcb_6mo_sls_cp_uc then net_sales_amt_plcb_6mo_sls_cp=&netsales_plcb_6mo_sls_cp_uc;
if num_txns_12mo_rtn ge &num_txns_12mo_rtn_uc then num_txns_12mo_rtn=&num_txns_12mo_rtn_uc;
if num_txns_12mo_rtn_cp ge &num_txns_12mo_rtn_cp_uc then num_txns_12mo_rtn_cp=&num_txns_12mo_rtn_cp_uc;
if num_txns_12mo_sls ge &num_txns_12mo_sls_uc then num_txns_12mo_sls=&num_txns_12mo_sls_uc;
if num_txns_12mo_sls_cp ge &num_txns_12mo_sls_cp_uc then num_txns_12mo_sls_cp=&num_txns_12mo_sls_cp_uc;
if num_txns_6mo_rtn ge &num_txns_6mo_rtn_uc then num_txns_6mo_rtn=&num_txns_6mo_rtn_uc;
if num_txns_6mo_rtn_cp ge &num_txns_6mo_rtn_cp_uc then num_txns_6mo_rtn_cp=&num_txns_6mo_rtn_cp_uc;
if num_txns_6mo_sls ge &num_txns_6mo_sls_uc then num_txns_6mo_sls=&num_txns_6mo_sls_uc;
if num_txns_6mo_sls_cp ge &num_txns_6mo_sls_cp_uc then num_txns_6mo_sls_cp=&num_txns_6mo_sls_cp_uc;
if num_txns_plcb_12mo_sls ge &num_txns_plcb_12mo_sls_uc then num_txns_plcb_12mo_sls=&num_txns_plcb_12mo_sls_uc;
if num_txns_plcb_12mo_sls_cp ge &num_txns_plcb_12mo_sls_cp_uc then num_txns_plcb_12mo_sls_cp=&num_txns_plcb_12mo_sls_cp_uc;
if num_txns_plcb_6mo_sls ge &num_txns_plcb_6mo_sls_uc then num_txns_plcb_6mo_sls=&num_txns_plcb_6mo_sls_uc;
if num_txns_plcb_6mo_sls_cp ge &num_txns_plcb_6mo_sls_cp_uc then num_txns_plcb_6mo_sls_cp=&num_txns_plcb_6mo_sls_cp_uc;
if plcb_txn_pct_12mo ge &plcb_txn_pct_12mo_uc then plcb_txn_pct_12mo=&plcb_txn_pct_12mo_uc;
if plcb_txn_pct_6mo ge &plcb_txn_pct_6mo_uc then plcb_txn_pct_6mo=&plcb_txn_pct_6mo_uc;
if ratio_net_rtn_net_sls_12mo ge &ratio_net_rtn_net_sls_12mo_uc then ratio_net_rtn_net_sls_12mo=&ratio_net_rtn_net_sls_12mo_uc;
if ratio_net_rtn_net_sls_6mo ge &ratio_net_rtn_net_sls_6mo_uc then ratio_net_rtn_net_sls_6mo=&ratio_net_rtn_net_sls_6mo_uc;
if units_per_txn_12mo_sls ge &units_per_txn_12mo_sls_uc then units_per_txn_12mo_sls=&units_per_txn_12mo_sls_uc;
if units_per_txn_6mo_sls ge &units_per_txn_6mo_sls_uc then units_per_txn_6mo_sls=&units_per_txn_6mo_sls_uc;
if years_on_books ge &years_on_books_uc then years_on_books=&years_on_books_uc;

if avg_ord_sz_12mo le &avg_ord_sz_12mo_lc then avg_ord_sz_12mo=&avg_ord_sz_12mo_lc;
if avg_ord_sz_12mo_cp le &avg_ord_sz_12mo_cp_lc then avg_ord_sz_12mo_cp=&avg_ord_sz_12mo_cp_lc;
if avg_ord_sz_6mo le &avg_ord_sz_6mo_lc then avg_ord_sz_6mo=&avg_ord_sz_6mo_lc;
if avg_ord_sz_6mo_cp le &avg_ord_sz_6mo_cp_lc then avg_ord_sz_6mo_cp=&avg_ord_sz_6mo_cp_lc;
if avg_unt_rtl_12mo le &avg_unt_rtl_12mo_lc then avg_unt_rtl_12mo=&avg_unt_rtl_12mo_lc;
if avg_unt_rtl_6mo le &avg_unt_rtl_6mo_lc then avg_unt_rtl_6mo=&avg_unt_rtl_6mo_lc;
if avg_unt_rtl_cp_12mo le &avg_unt_rtl_cp_12mo_lc then avg_unt_rtl_cp_12mo=&avg_unt_rtl_cp_12mo_lc;
if avg_unt_rtl_cp_6mo le &avg_unt_rtl_cp_6mo_lc then avg_unt_rtl_cp_6mo=&avg_unt_rtl_cp_6mo_lc;
if days_last_pur le &days_last_pur_lc then days_last_pur=&days_last_pur_lc;
if days_last_pur_cp le &days_last_pur_cp_lc then days_last_pur_cp=&days_last_pur_cp_lc;
if days_on_books le &days_on_books_lc then days_on_books=&days_on_books_lc;
if days_on_books_cp le &days_on_books_cp_lc then days_on_books_cp=&days_on_books_cp_lc;
if discount_amt_12mo_sls le &discount_amt_12mo_sls_lc then discount_amt_12mo_sls=&discount_amt_12mo_sls_lc;
if discount_amt_6mo_sls le &discount_amt_6mo_sls_lc then discount_amt_6mo_sls=&discount_amt_6mo_sls_lc;
if discount_pct_12mo le &discount_pct_12mo_lc then discount_pct_12mo=&discount_pct_12mo_lc;
if discount_pct_6mo le &discount_pct_6mo_lc then discount_pct_6mo=&discount_pct_6mo_lc;
if div_shp le &div_shp_lc then div_shp=&div_shp_lc;
if div_shp_cp le &div_shp_cp_lc then div_shp_cp=&div_shp_cp_lc;
if emails_clicked le &emails_clicked_lc then emails_clicked=&emails_clicked_lc;
if emails_clicked_cp le &emails_clicked_cp_lc then emails_clicked_cp=&emails_clicked_cp_lc;
if emails_opened le &emails_opened_lc then emails_opened=&emails_opened_lc;
if emails_opened_cp le &emails_opened_cp_lc then emails_opened_cp=&emails_opened_cp_lc;
if emails_pct_clicked le &emails_pct_clicked_lc then emails_pct_clicked=&emails_pct_clicked_lc;
if emails_pct_clicked_cp le &emails_pct_clicked_cp_lc then emails_pct_clicked_cp=&emails_pct_clicked_cp_lc;
if item_qty_12mo_rtn le &item_qty_12mo_rtn_lc then item_qty_12mo_rtn=&item_qty_12mo_rtn_lc;
if item_qty_12mo_rtn_cp le &item_qty_12mo_rtn_cp_lc then item_qty_12mo_rtn_cp=&item_qty_12mo_rtn_cp_lc;
if item_qty_12mo_sls le &item_qty_12mo_sls_lc then item_qty_12mo_sls=&item_qty_12mo_sls_lc;
if item_qty_12mo_sls_cp le &item_qty_12mo_sls_cp_lc then item_qty_12mo_sls_cp=&item_qty_12mo_sls_cp_lc;
if item_qty_6mo_rtn le &item_qty_6mo_rtn_lc then item_qty_6mo_rtn=&item_qty_6mo_rtn_lc;
if item_qty_6mo_rtn_cp le &item_qty_6mo_rtn_cp_lc then item_qty_6mo_rtn_cp=&item_qty_6mo_rtn_cp_lc;
if item_qty_6mo_sls le &item_qty_6mo_sls_lc then item_qty_6mo_sls=&item_qty_6mo_sls_lc;
if item_qty_6mo_sls_cp le &item_qty_6mo_sls_cp_lc then item_qty_6mo_sls_cp=&item_qty_6mo_sls_cp_lc;
if item_qty_onsale_12mo_sls le &item_qty_onsale_12mo_sls_lc then item_qty_onsale_12mo_sls=&item_qty_onsale_12mo_sls_lc;
if item_qty_onsale_12mo_sls_cp le &item_qty_onsale_12mo_sls_cp_lc then item_qty_onsale_12mo_sls_cp=&item_qty_onsale_12mo_sls_cp_lc;
if item_qty_onsale_6mo_sls le &item_qty_onsale_6mo_sls_lc then item_qty_onsale_6mo_sls=&item_qty_onsale_6mo_sls_lc;
if item_qty_onsale_6mo_sls_cp le &item_qty_onsale_6mo_sls_cp_lc then item_qty_onsale_6mo_sls_cp=&item_qty_onsale_6mo_sls_cp_lc;
if item_pct_onsale_12mo_sls le &item_pct_onsale_12mo_sls_lc then item_pct_onsale_12mo_sls=&item_pct_onsale_12mo_sls_lc;
if item_pct_onsale_12mo_sls_cp le &item_pct_onsale_12mo_sls_cp_lc then item_pct_onsale_12mo_sls_cp=&item_pct_onsale_12mo_sls_cp_lc;
if item_pct_onsale_6mo_sls le &item_pct_onsale_6mo_sls_lc then item_pct_onsale_6mo_sls=&item_pct_onsale_6mo_sls_lc;
if item_pct_onsale_6mo_sls_cp le &item_pct_onsale_6mo_sls_cp_lc then item_pct_onsale_6mo_sls_cp=&item_pct_onsale_6mo_sls_cp_lc;
if net_margin_12mo_sls le &net_margin_12mo_sls_lc then net_margin_12mo_sls=&net_margin_12mo_sls_lc;
if net_margin_6mo_sls le &net_margin_6mo_sls_lc then net_margin_6mo_sls=&net_margin_6mo_sls_lc;
if net_sales_amt_12mo_rtn le &netsales_12mo_rtn_lc then net_sales_amt_12mo_rtn=&netsales_12mo_rtn_lc;
if net_sales_amt_12mo_rtn_cp le &netsales_12mo_rtn_cp_lc then net_sales_amt_12mo_rtn_cp=&netsales_12mo_rtn_cp_lc;
if net_sales_amt_12mo_sls le &netsales_12mo_sls_lc then net_sales_amt_12mo_sls=&netsales_12mo_sls_lc;
if net_sales_amt_12mo_sls_cp le &netsales_12mo_sls_cp_lc then net_sales_amt_12mo_sls_cp=&netsales_12mo_sls_cp_lc;
if net_sales_amt_6mo_rtn le &netsales_6mo_rtn_lc then net_sales_amt_6mo_rtn=&netsales_6mo_rtn_lc;
if net_sales_amt_6mo_rtn_cp le &netsales_6mo_rtn_cp_lc then net_sales_amt_6mo_rtn_cp=&netsales_6mo_rtn_cp_lc;
if net_sales_amt_6mo_sls le &netsales_6mo_sls_lc then net_sales_amt_6mo_sls=&netsales_6mo_sls_lc;
if net_sales_amt_6mo_sls_cp le &netsales_6mo_sls_cp_lc then net_sales_amt_6mo_sls_cp=&netsales_6mo_sls_cp_lc;
if net_sales_amt_plcb_12mo_sls le &netsales_plcb_12mo_sls_lc then net_sales_amt_plcb_12mo_sls=&netsales_plcb_12mo_sls_lc;
if net_sales_amt_plcb_12mo_sls_cp le &netsales_plcb_12mo_sls_cp_lc then net_sales_amt_plcb_12mo_sls_cp=&netsales_plcb_12mo_sls_cp_lc;
if net_sales_amt_plcb_6mo_sls le &netsales_plcb_6mo_sls_lc then net_sales_amt_plcb_6mo_sls=&netsales_plcb_6mo_sls_lc;
if net_sales_amt_plcb_6mo_sls_cp le &netsales_plcb_6mo_sls_cp_lc then net_sales_amt_plcb_6mo_sls_cp=&netsales_plcb_6mo_sls_cp_lc;
if num_txns_12mo_rtn le &num_txns_12mo_rtn_lc then num_txns_12mo_rtn=&num_txns_12mo_rtn_lc;
if num_txns_12mo_rtn_cp le &num_txns_12mo_rtn_cp_lc then num_txns_12mo_rtn_cp=&num_txns_12mo_rtn_cp_lc;
if num_txns_12mo_sls le &num_txns_12mo_sls_lc then num_txns_12mo_sls=&num_txns_12mo_sls_lc;
if num_txns_12mo_sls_cp le &num_txns_12mo_sls_cp_lc then num_txns_12mo_sls_cp=&num_txns_12mo_sls_cp_lc;
if num_txns_6mo_rtn le &num_txns_6mo_rtn_lc then num_txns_6mo_rtn=&num_txns_6mo_rtn_lc;
if num_txns_6mo_rtn_cp le &num_txns_6mo_rtn_cp_lc then num_txns_6mo_rtn_cp=&num_txns_6mo_rtn_cp_lc;
if num_txns_6mo_sls le &num_txns_6mo_sls_lc then num_txns_6mo_sls=&num_txns_6mo_sls_lc;
if num_txns_6mo_sls_cp le &num_txns_6mo_sls_cp_lc then num_txns_6mo_sls_cp=&num_txns_6mo_sls_cp_lc;
if num_txns_plcb_12mo_sls le &num_txns_plcb_12mo_sls_lc then num_txns_plcb_12mo_sls=&num_txns_plcb_12mo_sls_lc;
if num_txns_plcb_12mo_sls_cp le &num_txns_plcb_12mo_sls_cp_lc then num_txns_plcb_12mo_sls_cp=&num_txns_plcb_12mo_sls_cp_lc;
if num_txns_plcb_6mo_sls le &num_txns_plcb_6mo_sls_lc then num_txns_plcb_6mo_sls=&num_txns_plcb_6mo_sls_lc;
if num_txns_plcb_6mo_sls_cp le &num_txns_plcb_6mo_sls_cp_lc then num_txns_plcb_6mo_sls_cp=&num_txns_plcb_6mo_sls_cp_lc;
if plcb_txn_pct_12mo le &plcb_txn_pct_12mo_lc then plcb_txn_pct_12mo=&plcb_txn_pct_12mo_lc;
if plcb_txn_pct_6mo le &plcb_txn_pct_6mo_lc then plcb_txn_pct_6mo=&plcb_txn_pct_6mo_lc;
if ratio_net_rtn_net_sls_12mo le &ratio_net_rtn_net_sls_12mo_lc then ratio_net_rtn_net_sls_12mo=&ratio_net_rtn_net_sls_12mo_lc;
if ratio_net_rtn_net_sls_6mo le &ratio_net_rtn_net_sls_6mo_lc then ratio_net_rtn_net_sls_6mo=&ratio_net_rtn_net_sls_6mo_lc;
if units_per_txn_12mo_sls le &units_per_txn_12mo_sls_lc then units_per_txn_12mo_sls=&units_per_txn_12mo_sls_lc;
if units_per_txn_6mo_sls le &units_per_txn_6mo_sls_lc then units_per_txn_6mo_sls=&units_per_txn_6mo_sls_lc;
if years_on_books le &years_on_books_lc then years_on_books=&years_on_books_lc;

run;



data datalib.&brand._em_balanced_3;
set &brand._em_balanced_2;

avg_ord_sz_12mo = (avg_ord_sz_12mo - &avg_ord_sz_12mo_lc) / (&avg_ord_sz_12mo_uc - &avg_ord_sz_12mo_lc);
avg_ord_sz_12mo_cp = (avg_ord_sz_12mo_cp - &avg_ord_sz_12mo_cp_lc) / (&avg_ord_sz_12mo_cp_uc - &avg_ord_sz_12mo_cp_lc);
avg_ord_sz_6mo = (avg_ord_sz_6mo - &avg_ord_sz_6mo_lc) / (&avg_ord_sz_6mo_uc - &avg_ord_sz_6mo_lc);
avg_ord_sz_6mo_cp = (avg_ord_sz_6mo_cp - &avg_ord_sz_6mo_cp_lc) / (&avg_ord_sz_6mo_cp_uc - &avg_ord_sz_6mo_cp_lc);
avg_unt_rtl_12mo = (avg_unt_rtl_12mo - &avg_unt_rtl_12mo_lc) / (&avg_unt_rtl_12mo_uc - &avg_unt_rtl_12mo_lc);
avg_unt_rtl_6mo = (avg_unt_rtl_6mo - &avg_unt_rtl_6mo_lc) / (&avg_unt_rtl_6mo_uc - &avg_unt_rtl_6mo_lc);
avg_unt_rtl_cp_12mo = (avg_unt_rtl_cp_12mo - &avg_unt_rtl_cp_12mo_lc) / (&avg_unt_rtl_cp_12mo_uc - &avg_unt_rtl_cp_12mo_lc);
avg_unt_rtl_cp_6mo = (avg_unt_rtl_cp_6mo - &avg_unt_rtl_cp_6mo_lc) / (&avg_unt_rtl_cp_6mo_uc - &avg_unt_rtl_cp_6mo_lc);
days_last_pur = (days_last_pur - &days_last_pur_lc) / (&days_last_pur_uc - &days_last_pur_lc);
days_last_pur_cp = (days_last_pur_cp - &days_last_pur_cp_lc) / (&days_last_pur_cp_uc - &days_last_pur_cp_lc);
days_on_books = (days_on_books - &days_on_books_lc) / (&days_on_books_uc - &days_on_books_lc);
days_on_books_cp = (days_on_books_cp - &days_on_books_cp_lc) / (&days_on_books_cp_uc - &days_on_books_cp_lc);
discount_amt_12mo_sls = (discount_amt_12mo_sls - &discount_amt_12mo_sls_lc) / (&discount_amt_12mo_sls_uc - &discount_amt_12mo_sls_lc);
discount_amt_6mo_sls = (discount_amt_6mo_sls - &discount_amt_6mo_sls_lc) / (&discount_amt_6mo_sls_uc - &discount_amt_6mo_sls_lc);
discount_pct_12mo = (discount_pct_12mo - &discount_pct_12mo_lc) / (&discount_pct_12mo_uc - &discount_pct_12mo_lc);
discount_pct_6mo = (discount_pct_6mo - &discount_pct_6mo_lc) / (&discount_pct_6mo_uc - &discount_pct_6mo_lc);
div_shp = (div_shp - &div_shp_lc) / (&div_shp_uc - &div_shp_lc);
div_shp_cp = (div_shp_cp - &div_shp_cp_lc) / (&div_shp_cp_uc - &div_shp_cp_lc);
emails_clicked = (emails_clicked - &emails_clicked_lc) / (&emails_clicked_uc - &emails_clicked_lc);
emails_clicked_cp = (emails_clicked_cp - &emails_clicked_cp_lc) / (&emails_clicked_cp_uc - &emails_clicked_cp_lc);
emails_opened = (emails_opened - &emails_opened_lc) / (&emails_opened_uc - &emails_opened_lc);
emails_opened_cp = (emails_opened_cp - &emails_opened_cp_lc) / (&emails_opened_cp_uc - &emails_opened_cp_lc);
emails_pct_clicked = (emails_pct_clicked - &emails_pct_clicked_lc) / (&emails_pct_clicked_uc - &emails_pct_clicked_lc);
emails_pct_clicked_cp = (emails_pct_clicked_cp - &emails_pct_clicked_cp_lc) / (&emails_pct_clicked_cp_uc - &emails_pct_clicked_cp_lc);
item_qty_12mo_rtn = (item_qty_12mo_rtn - &item_qty_12mo_rtn_lc) / (&item_qty_12mo_rtn_uc - &item_qty_12mo_rtn_lc);
item_qty_12mo_rtn_cp = (item_qty_12mo_rtn_cp - &item_qty_12mo_rtn_cp_lc) / (&item_qty_12mo_rtn_cp_uc - &item_qty_12mo_rtn_cp_lc);
item_qty_12mo_sls = (item_qty_12mo_sls - &item_qty_12mo_sls_lc) / (&item_qty_12mo_sls_uc - &item_qty_12mo_sls_lc);
item_qty_12mo_sls_cp = (item_qty_12mo_sls_cp - &item_qty_12mo_sls_cp_lc) / (&item_qty_12mo_sls_cp_uc - &item_qty_12mo_sls_cp_lc);
item_qty_6mo_rtn = (item_qty_6mo_rtn - &item_qty_6mo_rtn_lc) / (&item_qty_6mo_rtn_uc - &item_qty_6mo_rtn_lc);
item_qty_6mo_rtn_cp = (item_qty_6mo_rtn_cp - &item_qty_6mo_rtn_cp_lc) / (&item_qty_6mo_rtn_cp_uc - &item_qty_6mo_rtn_cp_lc);
item_qty_6mo_sls = (item_qty_6mo_sls - &item_qty_6mo_sls_lc) / (&item_qty_6mo_sls_uc - &item_qty_6mo_sls_lc);
item_qty_6mo_sls_cp = (item_qty_6mo_sls_cp - &item_qty_6mo_sls_cp_lc) / (&item_qty_6mo_sls_cp_uc - &item_qty_6mo_sls_cp_lc);
item_qty_onsale_12mo_sls = (item_qty_onsale_12mo_sls - &item_qty_onsale_12mo_sls_lc) / (&item_qty_onsale_12mo_sls_uc - &item_qty_onsale_12mo_sls_lc);
item_qty_onsale_12mo_sls_cp = (item_qty_onsale_12mo_sls_cp - &item_qty_onsale_12mo_sls_cp_lc) / (&item_qty_onsale_12mo_sls_cp_uc - &item_qty_onsale_12mo_sls_cp_lc);
item_qty_onsale_6mo_sls = (item_qty_onsale_6mo_sls - &item_qty_onsale_6mo_sls_lc) / (&item_qty_onsale_6mo_sls_uc - &item_qty_onsale_6mo_sls_lc);
item_qty_onsale_6mo_sls_cp = (item_qty_onsale_6mo_sls_cp - &item_qty_onsale_6mo_sls_cp_lc) / (&item_qty_onsale_6mo_sls_cp_uc - &item_qty_onsale_6mo_sls_cp_lc);
item_pct_onsale_12mo_sls = (item_pct_onsale_12mo_sls - &item_pct_onsale_12mo_sls_lc) / (&item_pct_onsale_12mo_sls_uc - &item_pct_onsale_12mo_sls_lc);
item_pct_onsale_12mo_sls_cp = (item_pct_onsale_12mo_sls_cp - &item_pct_onsale_12mo_sls_cp_lc) / (&item_pct_onsale_12mo_sls_cp_uc - &item_pct_onsale_12mo_sls_cp_lc);
item_pct_onsale_6mo_sls = (item_pct_onsale_6mo_sls - &item_pct_onsale_6mo_sls_lc) / (&item_pct_onsale_6mo_sls_uc - &item_pct_onsale_6mo_sls_lc);
item_pct_onsale_6mo_sls_cp = (item_pct_onsale_6mo_sls_cp - &item_pct_onsale_6mo_sls_cp_lc) / (&item_pct_onsale_6mo_sls_cp_uc - &item_pct_onsale_6mo_sls_cp_lc);
net_margin_12mo_sls = (net_margin_12mo_sls - &net_margin_12mo_sls_lc) / (&net_margin_12mo_sls_uc - &net_margin_12mo_sls_lc);
net_margin_6mo_sls = (net_margin_6mo_sls - &net_margin_6mo_sls_lc) / (&net_margin_6mo_sls_uc - &net_margin_6mo_sls_lc);
net_sales_amt_12mo_rtn = (net_sales_amt_12mo_rtn - &netsales_12mo_rtn_lc) / (&netsales_12mo_rtn_uc - &netsales_12mo_rtn_lc);
net_sales_amt_12mo_rtn_cp = (net_sales_amt_12mo_rtn_cp - &netsales_12mo_rtn_cp_lc) / (&netsales_12mo_rtn_cp_uc - &netsales_12mo_rtn_cp_lc);
net_sales_amt_12mo_sls = (net_sales_amt_12mo_sls - &netsales_12mo_sls_lc) / (&netsales_12mo_sls_uc - &netsales_12mo_sls_lc);
net_sales_amt_12mo_sls_cp = (net_sales_amt_12mo_sls_cp - &netsales_12mo_sls_cp_lc) / (&netsales_12mo_sls_cp_uc - &netsales_12mo_sls_cp_lc);
net_sales_amt_6mo_rtn = (net_sales_amt_6mo_rtn - &netsales_6mo_rtn_lc) / (&netsales_6mo_rtn_uc - &netsales_6mo_rtn_lc);
net_sales_amt_6mo_rtn_cp = (net_sales_amt_6mo_rtn_cp - &netsales_6mo_rtn_cp_lc) / (&netsales_6mo_rtn_cp_uc - &netsales_6mo_rtn_cp_lc);
net_sales_amt_6mo_sls = (net_sales_amt_6mo_sls - &netsales_6mo_sls_lc) / (&netsales_6mo_sls_uc - &netsales_6mo_sls_lc);
net_sales_amt_6mo_sls_cp = (net_sales_amt_6mo_sls_cp - &netsales_6mo_sls_cp_lc) / (&netsales_6mo_sls_cp_uc - &netsales_6mo_sls_cp_lc);
net_sales_amt_plcb_12mo_sls = (net_sales_amt_plcb_12mo_sls - &netsales_plcb_12mo_sls_lc) / (&netsales_plcb_12mo_sls_uc - &netsales_plcb_12mo_sls_lc);
net_sales_amt_plcb_12mo_sls_cp = (net_sales_amt_plcb_12mo_sls_cp - &netsales_plcb_12mo_sls_cp_lc) / (&netsales_plcb_12mo_sls_cp_uc - &netsales_plcb_12mo_sls_cp_lc);
net_sales_amt_plcb_6mo_sls = (net_sales_amt_plcb_6mo_sls - &netsales_plcb_6mo_sls_lc) / (&netsales_plcb_6mo_sls_uc - &netsales_plcb_6mo_sls_lc);
net_sales_amt_plcb_6mo_sls_cp = (net_sales_amt_plcb_6mo_sls_cp - &netsales_plcb_6mo_sls_cp_lc) / (&netsales_plcb_6mo_sls_cp_uc - &netsales_plcb_6mo_sls_cp_lc);
num_txns_12mo_rtn = (num_txns_12mo_rtn - &num_txns_12mo_rtn_lc) / (&num_txns_12mo_rtn_uc - &num_txns_12mo_rtn_lc);
num_txns_12mo_rtn_cp = (num_txns_12mo_rtn_cp - &num_txns_12mo_rtn_cp_lc) / (&num_txns_12mo_rtn_cp_uc - &num_txns_12mo_rtn_cp_lc);
num_txns_12mo_sls = (num_txns_12mo_sls - &num_txns_12mo_sls_lc) / (&num_txns_12mo_sls_uc - &num_txns_12mo_sls_lc);
num_txns_12mo_sls_cp = (num_txns_12mo_sls_cp - &num_txns_12mo_sls_cp_lc) / (&num_txns_12mo_sls_cp_uc - &num_txns_12mo_sls_cp_lc);
num_txns_6mo_rtn = (num_txns_6mo_rtn - &num_txns_6mo_rtn_lc) / (&num_txns_6mo_rtn_uc - &num_txns_6mo_rtn_lc);
num_txns_6mo_rtn_cp = (num_txns_6mo_rtn_cp - &num_txns_6mo_rtn_cp_lc) / (&num_txns_6mo_rtn_cp_uc - &num_txns_6mo_rtn_cp_lc);
num_txns_6mo_sls = (num_txns_6mo_sls - &num_txns_6mo_sls_lc) / (&num_txns_6mo_sls_uc - &num_txns_6mo_sls_lc);
num_txns_6mo_sls_cp = (num_txns_6mo_sls_cp - &num_txns_6mo_sls_cp_lc) / (&num_txns_6mo_sls_cp_uc - &num_txns_6mo_sls_cp_lc);
num_txns_plcb_12mo_sls = (num_txns_plcb_12mo_sls - &num_txns_plcb_12mo_sls_lc) / (&num_txns_plcb_12mo_sls_uc - &num_txns_plcb_12mo_sls_lc);
num_txns_plcb_12mo_sls_cp = (num_txns_plcb_12mo_sls_cp - &num_txns_plcb_12mo_sls_cp_lc) / (&num_txns_plcb_12mo_sls_cp_uc - &num_txns_plcb_12mo_sls_cp_lc);
num_txns_plcb_6mo_sls = (num_txns_plcb_6mo_sls - &num_txns_plcb_6mo_sls_lc) / (&num_txns_plcb_6mo_sls_uc - &num_txns_plcb_6mo_sls_lc);
num_txns_plcb_6mo_sls_cp = (num_txns_plcb_6mo_sls_cp - &num_txns_plcb_6mo_sls_cp_lc) / (&num_txns_plcb_6mo_sls_cp_uc - &num_txns_plcb_6mo_sls_cp_lc);
plcb_txn_pct_12mo = (plcb_txn_pct_12mo - &plcb_txn_pct_12mo_lc) / (&plcb_txn_pct_12mo_uc - &plcb_txn_pct_12mo_lc);
plcb_txn_pct_6mo = (plcb_txn_pct_6mo - &plcb_txn_pct_6mo_lc) / (&plcb_txn_pct_6mo_uc - &plcb_txn_pct_6mo_lc);
ratio_net_rtn_net_sls_12mo = (ratio_net_rtn_net_sls_12mo - &ratio_net_rtn_net_sls_12mo_lc) / (&ratio_net_rtn_net_sls_12mo_uc - &ratio_net_rtn_net_sls_12mo_lc);
ratio_net_rtn_net_sls_6mo = (ratio_net_rtn_net_sls_6mo - &ratio_net_rtn_net_sls_6mo_lc) / (&ratio_net_rtn_net_sls_6mo_uc - &ratio_net_rtn_net_sls_6mo_lc);
units_per_txn_12mo_sls = (units_per_txn_12mo_sls - &units_per_txn_12mo_sls_lc) / (&units_per_txn_12mo_sls_uc - &units_per_txn_12mo_sls_lc);
units_per_txn_6mo_sls = (units_per_txn_6mo_sls - &units_per_txn_6mo_sls_lc) / (&units_per_txn_6mo_sls_uc - &units_per_txn_6mo_sls_lc);
years_on_books = (years_on_books - &years_on_books_lc) / (&years_on_books_uc - &years_on_books_lc);

run;

proc means data=datalib.&brand._em_balanced_3;run;


proc freq data = datalib.&brand._em_combined;
 table card_status;
run;


proc freq data = datalib.&brand._em_balanced;
 table card_status;
run;

proc export data=datalib.&brand._em_balanced_3
			outfile="z:\tanumoy\datasets\model replication\&brand._em_gen2_balanced_3.txt"
            dbms=dlm replace;
     delimiter="|";
run;


proc contents data = datalib.&brand._em_balanced_3;
run;


/*proc print data=datalib.&brand._em_balanced_model_1; run;*/
/**/
/**/
/*proc logistic data=datalib.&brand._em_balanced_3*/
/*	 outest=datalib.&brand._em_balanced_parms_1*/
/*	 outmodel=datalib.&brand._em_balanced_model_1;*/
/*class card_status (ref='5');*/
/*model */
/*responder(event='1')=   */
/*avg_ord_sz_12mo*/
/*avg_ord_sz_12mo_cp*/
/*avg_ord_sz_6mo*/
/*avg_ord_sz_6mo_cp*/
/*avg_unt_rtl_12mo*/
/*avg_unt_rtl_6mo*/
/*avg_unt_rtl_cp_12mo*/
/*avg_unt_rtl_cp_6mo*/
/*card_status*/
/*days_last_pur*/
/*days_last_pur_cp*/
/*days_on_books*/
/*days_on_books_cp*/
/*discount_amt_12mo_sls*/
/*discount_amt_6mo_sls*/
/*discount_pct_12mo*/
/*discount_pct_6mo*/
/*div_shp*/
/*div_shp_cp*/
/*emails_clicked*/
/*emails_clicked_cp*/
/*emails_opened*/
/*emails_opened_cp*/
/*item_qty_12mo_rtn*/
/*item_qty_12mo_rtn_cp*/
/*item_qty_12mo_sls*/
/*item_qty_12mo_sls_cp*/
/*item_qty_6mo_rtn*/
/*item_qty_6mo_rtn_cp*/
/*item_qty_6mo_sls*/
/*item_qty_6mo_sls_cp*/
/*item_qty_onsale_12mo_sls*/
/*item_qty_onsale_12mo_sls_cp*/
/*item_qty_onsale_6mo_sls*/
/*item_qty_onsale_6mo_sls_cp*/
/*item_pct_onsale_12mo_sls*/
/*item_pct_onsale_6mo_sls*/
/*net_margin_12mo_sls*/
/*net_margin_6mo_sls*/
/*net_sales_amt_12mo_rtn*/
/*net_sales_amt_12mo_rtn_cp*/
/*net_sales_amt_12mo_sls*/
/*net_sales_amt_12mo_sls_cp*/
/*net_sales_amt_6mo_rtn*/
/*net_sales_amt_6mo_rtn_cp*/
/*net_sales_amt_6mo_sls*/
/*net_sales_amt_6mo_sls_cp*/
/*net_sales_amt_plcb_12mo_sls*/
/*net_sales_amt_plcb_12mo_sls_cp*/
/*net_sales_amt_plcb_6mo_sls*/
/*net_sales_amt_plcb_6mo_sls_cp*/
/*num_txns_12mo_rtn*/
/*num_txns_12mo_rtn_cp*/
/*num_txns_12mo_sls*/
/*num_txns_12mo_sls_cp*/
/*num_txns_6mo_rtn*/
/*num_txns_6mo_rtn_cp*/
/*num_txns_6mo_sls*/
/*num_txns_6mo_sls_cp*/
/*num_txns_plcb_12mo_sls*/
/*num_txns_plcb_12mo_sls_cp*/
/*num_txns_plcb_6mo_sls*/
/*num_txns_plcb_6mo_sls_cp*/
/*plcb_txn_pct_12mo*/
/*plcb_txn_pct_6mo*/
/*ratio_net_rtn_net_sls_12mo*/
/*ratio_net_rtn_net_sls_6mo*/
/*units_per_txn_12mo_sls*/
/*units_per_txn_6mo_sls*/
/*years_on_books*/
/*/expb lackfit stepwise slentry=0.05 slstay=0.05 ctable offset=offset stb;*/
/*where training=1;*/
/*run;*/
/**/
/*proc print data=datalib.&brand._em_balanced_model_1; run;*/

/* 
avg_ord_sz_12mo_cp
avg_ord_sz_6mo_cp
avg_unt_rtl_12mo
avg_unt_rtl_6mo
avg_unt_rtl_cp_12mo
avg_unt_rtl_cp_6mo
card_status
days_last_pur
days_last_pur_cp
days_on_books
discount_amt_12mo_sls
discount_amt_6mo_sls
discount_pct_12mo
div_shp
div_shp_cp
emails_clicked
emails_clicked_cp
emails_opened
emails_opened_cp
item_qty_12mo_rtn_cp
item_qty_onsale_12mo_sls_cp
item_qty_onsale_6mo_sls
item_qty_onsale_6mo_sls_cp
net_margin_12mo_sls
net_sales_amt_12mo_rtn
net_sales_amt_12mo_sls
net_sales_amt_12mo_sls_cp
num_txns_12mo_rtn
num_txns_12mo_sls
num_txns_12mo_sls_cp
num_txns_6mo_sls
num_txns_plcb_12mo_sls
num_txns_plcb_6mo_sls
num_txns_plcb_6mo_sls_cp
plcb_txn_pct_12mo
plcb_txn_pct_6mo
ratio_net_rtn_net_sls_12mo
ratio_net_rtn_net_sls_6mo
units_per_txn_12mo_sls
units_per_txn_6mo_sls
years_on_books
*/

/* check vif */
proc reg data=datalib.&brand._em_balanced_3;
model responder =	
avg_unt_rtl_12mo
avg_ord_sz_12mo
days_last_pur
days_on_books
discount_pct_12mo
plcb_txn_pct_12mo
/*div_shp_pct*/
emails_pct_clicked
emails_opened
net_sales_amt_6mo_sls
item_pct_onsale_12mo_sls
item_pct_onsale_12mo_sls_cp
/vif;
where training=1;
run;
quit;


proc means data=datalib.&brand._em_balanced_3; var num_txns_6mo_sls; run;

/* final predictors */
proc logistic data=datalib.&brand._em_balanced_3
	 outest=datalib.&brand._em_balanced_parms_1
	 outmodel=datalib.&brand._em_balanced_model_1;

class card_status (ref='5');
model responder(event='1')=	
card_status
avg_ord_sz_12mo
days_last_pur
days_on_books
discount_pct_12mo
plcb_txn_pct_12mo
/*div_shp_pct*/
emails_pct_clicked
net_sales_amt_6mo_sls
item_pct_onsale_12mo_sls
item_pct_onsale_12mo_sls_cp
units_per_txn_6mo_sls
/expb lackfit ctable offset=offset stb;
where training=1;
output out=&brand._em_balanced_fits_1 p=p_fixed xbeta=l_fixed;
run;

data &brand._em_balanced_fits_1;
 set &brand._em_balanced_fits_1;
 logit=log(p_fixed) - log(1-p_fixed);
run;


%macro adequacy(varlist);

%let varcount=%sysfunc(countw(&varlist));

%do i=1 %to &varcount;
		
	%let varname=%scan(&varlist,&i," ");
	%put &varname;

	proc logistic data=datalib.&brand._em_balanced_3;
	  class card_status (ref='5');
	  model responder(event='1')=	&varname
									/expb lackfit ctable offset=offset stb;
	  where training=1;
	run;

%end;

%mend;

%adequacy
(varlist=
		card_status
		avg_unt_rtl_6mo
		days_last_pur
		days_on_books
		discount_pct_12mo
		plcb_txn_pct_12mo
		div_shp
		emails_clicked
		emails_opened
		num_txns_12mo_sls
		units_per_txn_6mo_sls
		item_pct_onsale_12mo_sls
		item_pct_onsale_12mo_sls_cp
);



proc logistic inmodel=datalib.&brand._em_balanced_model_1;
 score data=datalib.&brand._em_balanced_3 out=&brand._em_balanced_pred_1;
run;


data &brand._em_balanced_pred_1;
 set &brand._em_balanced_pred_1;
 if p_1 ne 1;
 logit_1=log(p_1) - log(1-p_1);
 poffset_1=logistic(logit_1-offset);
 label p_1 = "resp_prob_1";
 rename p_1 = resp_prob_1;
 drop p_0;
run;


proc sql;
 select count(*) into: traincount from &brand._em_balanced_pred_1 where training=1;
quit;
 
%let trainintv = %eval(&traincount/10);

proc sort data=&brand._em_balanced_pred_1
		  out=&brand._em_balanced_pred_train;
 by descending poffset_1;
 where training=1;
run;


data &brand._em_balanced_pred_train;
 set &brand._em_balanced_pred_train;
 if _n_ ge 1 + 0 * round(&trainintv) then new_resp_prob_grp=1;
 if _n_ ge 1 + 1 * round(&trainintv) then new_resp_prob_grp=2;
 if _n_ ge 1 + 2 * round(&trainintv) then new_resp_prob_grp=3;
 if _n_ ge 1 + 3 * round(&trainintv) then new_resp_prob_grp=4;
 if _n_ ge 1 + 4 * round(&trainintv) then new_resp_prob_grp=5;
 if _n_ ge 1 + 5 * round(&trainintv) then new_resp_prob_grp=6;
 if _n_ ge 1 + 6 * round(&trainintv) then new_resp_prob_grp=7;
 if _n_ ge 1 + 7 * round(&trainintv) then new_resp_prob_grp=8;
 if _n_ ge 1 + 8 * round(&trainintv) then new_resp_prob_grp=9;
 if _n_ ge 1 + 9 * round(&trainintv) then new_resp_prob_grp=10;
run;

proc freq data=&brand._em_balanced_pred_train;
 table new_resp_prob_grp * responder;
run;

proc sql;
 create table summary_train as select distinct 
        new_resp_prob_grp, count(customer_key) as customers,
        sum(responder) as responders,
		sum(net_sales_amt) as netsales
	    from &brand._em_balanced_pred_train
		group by new_resp_prob_grp order by new_resp_prob_grp;
quit;


proc sql;
 select count(*) into: testcount from &brand._em_balanced_pred_1 where testing=1;
quit;
 
%let testintv = %eval(&testcount/10);

proc sort data=&brand._em_balanced_pred_1
		  out=&brand._em_balanced_pred_test;
 by descending poffset_1;
 where testing=1;
run;


data &brand._em_balanced_pred_test;
 set &brand._em_balanced_pred_test;
 if _n_ ge 1 + 0 * round(&testintv) then new_resp_prob_grp=1;
 if _n_ ge 1 + 1 * round(&testintv) then new_resp_prob_grp=2;
 if _n_ ge 1 + 2 * round(&testintv) then new_resp_prob_grp=3;
 if _n_ ge 1 + 3 * round(&testintv) then new_resp_prob_grp=4;
 if _n_ ge 1 + 4 * round(&testintv) then new_resp_prob_grp=5;
 if _n_ ge 1 + 5 * round(&testintv) then new_resp_prob_grp=6;
 if _n_ ge 1 + 6 * round(&testintv) then new_resp_prob_grp=7;
 if _n_ ge 1 + 7 * round(&testintv) then new_resp_prob_grp=8;
 if _n_ ge 1 + 8 * round(&testintv) then new_resp_prob_grp=9;
 if _n_ ge 1 + 9 * round(&testintv) then new_resp_prob_grp=10;
run;

proc freq data=&brand._em_balanced_pred_test;
 table new_resp_prob_grp * responder;
run;


proc sql;
 create table summary_test as select distinct 
        new_resp_prob_grp, count(customer_key) as customers,
        sum(responder) as responders,
		sum(net_sales_amt) as netsales
	    from &brand._em_balanced_pred_test
		group by new_resp_prob_grp order by new_resp_prob_grp;
quit;

proc print data=summary_train; run;
proc print data=summary_test; run;







/* calculate test dataset auc */
data &brand._em_balanced_3_train; set datalib.&brand._em_balanced_3(where=(training=1)); run;
data &brand._em_balanced_3_test; set datalib.&brand._em_balanced_3(where=(training=0)); run;

      proc logistic data=&brand._em_balanced_3_train; /* training dataset */
		class card_status (ref='5');
        model responder(event='1') = avg_unt_rtl_cp_12mo
		days_on_books
		discount_amt_6mo_sls
		discount_pct_12mo
		div_shp
		emails_clicked
		num_txns_6mo_sls
		units_per_txn_12mo_sls/ outroc=troc;
        score data=&brand._em_balanced_3_test out=valpred outroc=vroc;
        run;

		/* test auc = 0.8843 */

      data a; 
        set troc(in=train) vroc;
        data="valid"; 
        if train then data="train";
        run;

      proc sgplot data=a noautolegend;
        xaxis values=(0 to 1 by 0.25) grid offsetmin=.05 offsetmax=.05; 
        yaxis values=(0 to 1 by 0.25) grid offsetmin=.05 offsetmax=.05;
        lineparm x=0 y=0 slope=1 / transparency=.7;
        series x=_1mspec_ y=_sensit_ / group=data;
        run;
*http://support.sas.com/kb/52/973.html;




proc means data=datalib.&brand._em_combined; run;



*create the additional metrics for the unbalanced datasets;



data &brand._em_combined_2;
set datalib.&brand._em_combined;

if avg_ord_sz_12mo ge &avg_ord_sz_12mo_uc then avg_ord_sz_12mo=&avg_ord_sz_12mo_uc;
if avg_ord_sz_12mo_cp ge &avg_ord_sz_12mo_cp_uc then avg_ord_sz_12mo_cp=&avg_ord_sz_12mo_cp_uc;
if avg_ord_sz_6mo ge &avg_ord_sz_6mo_uc then avg_ord_sz_6mo=&avg_ord_sz_6mo_uc;
if avg_ord_sz_6mo_cp ge &avg_ord_sz_6mo_cp_uc then avg_ord_sz_6mo_cp=&avg_ord_sz_6mo_cp_uc;
if avg_unt_rtl_12mo ge &avg_unt_rtl_12mo_uc then avg_unt_rtl_12mo=&avg_unt_rtl_12mo_uc;
if avg_unt_rtl_6mo ge &avg_unt_rtl_6mo_uc then avg_unt_rtl_6mo=&avg_unt_rtl_6mo_uc;
if avg_unt_rtl_cp_12mo ge &avg_unt_rtl_cp_12mo_uc then avg_unt_rtl_cp_12mo=&avg_unt_rtl_cp_12mo_uc;
if avg_unt_rtl_cp_6mo ge &avg_unt_rtl_cp_6mo_uc then avg_unt_rtl_cp_6mo=&avg_unt_rtl_cp_6mo_uc;
if days_last_pur ge &days_last_pur_uc then days_last_pur=&days_last_pur_uc;
if days_last_pur_cp ge &days_last_pur_cp_uc then days_last_pur_cp=&days_last_pur_cp_uc;
if days_on_books ge &days_on_books_uc then days_on_books=&days_on_books_uc;
if days_on_books_cp ge &days_on_books_cp_uc then days_on_books_cp=&days_on_books_cp_uc;
if discount_amt_12mo_sls ge &discount_amt_12mo_sls_uc then discount_amt_12mo_sls=&discount_amt_12mo_sls_uc;
if discount_amt_6mo_sls ge &discount_amt_6mo_sls_uc then discount_amt_6mo_sls=&discount_amt_6mo_sls_uc;
if discount_pct_12mo ge &discount_pct_12mo_uc then discount_pct_12mo=&discount_pct_12mo_uc;
if discount_pct_6mo ge &discount_pct_6mo_uc then discount_pct_6mo=&discount_pct_6mo_uc;
if div_shp ge &div_shp_uc then div_shp=&div_shp_uc;
if div_shp_cp ge &div_shp_cp_uc then div_shp_cp=&div_shp_cp_uc;
if emails_clicked ge &emails_clicked_uc then emails_clicked=&emails_clicked_uc;
if emails_clicked_cp ge &emails_clicked_cp_uc then emails_clicked_cp=&emails_clicked_cp_uc;
if emails_opened ge &emails_opened_uc then emails_opened=&emails_opened_uc;
if emails_opened_cp ge &emails_opened_cp_uc then emails_opened_cp=&emails_opened_cp_uc;
if emails_pct_clicked ge &emails_pct_clicked_uc then emails_pct_clicked=&emails_pct_clicked_uc;
if emails_pct_clicked_cp ge &emails_pct_clicked_cp_uc then emails_pct_clicked_cp=&emails_pct_clicked_cp_uc;
if item_qty_12mo_rtn ge &item_qty_12mo_rtn_uc then item_qty_12mo_rtn=&item_qty_12mo_rtn_uc;
if item_qty_12mo_rtn_cp ge &item_qty_12mo_rtn_cp_uc then item_qty_12mo_rtn_cp=&item_qty_12mo_rtn_cp_uc;
if item_qty_12mo_sls ge &item_qty_12mo_sls_uc then item_qty_12mo_sls=&item_qty_12mo_sls_uc;
if item_qty_12mo_sls_cp ge &item_qty_12mo_sls_cp_uc then item_qty_12mo_sls_cp=&item_qty_12mo_sls_cp_uc;
if item_qty_6mo_rtn ge &item_qty_6mo_rtn_uc then item_qty_6mo_rtn=&item_qty_6mo_rtn_uc;
if item_qty_6mo_rtn_cp ge &item_qty_6mo_rtn_cp_uc then item_qty_6mo_rtn_cp=&item_qty_6mo_rtn_cp_uc;
if item_qty_6mo_sls ge &item_qty_6mo_sls_uc then item_qty_6mo_sls=&item_qty_6mo_sls_uc;
if item_qty_6mo_sls_cp ge &item_qty_6mo_sls_cp_uc then item_qty_6mo_sls_cp=&item_qty_6mo_sls_cp_uc;
if item_qty_onsale_12mo_sls ge &item_qty_onsale_12mo_sls_uc then item_qty_onsale_12mo_sls=&item_qty_onsale_12mo_sls_uc;
if item_qty_onsale_12mo_sls_cp ge &item_qty_onsale_12mo_sls_cp_uc then item_qty_onsale_12mo_sls_cp=&item_qty_onsale_12mo_sls_cp_uc;
if item_qty_onsale_6mo_sls ge &item_qty_onsale_6mo_sls_uc then item_qty_onsale_6mo_sls=&item_qty_onsale_6mo_sls_uc;
if item_qty_onsale_6mo_sls_cp ge &item_qty_onsale_6mo_sls_cp_uc then item_qty_onsale_6mo_sls_cp=&item_qty_onsale_6mo_sls_cp_uc;
if item_pct_onsale_12mo_sls ge &item_pct_onsale_12mo_sls_uc then item_pct_onsale_12mo_sls=&item_pct_onsale_12mo_sls_uc;
if item_pct_onsale_12mo_sls_cp ge &item_pct_onsale_12mo_sls_cp_uc then item_pct_onsale_12mo_sls_cp=&item_pct_onsale_12mo_sls_cp_uc;
if item_pct_onsale_6mo_sls ge &item_pct_onsale_6mo_sls_uc then item_pct_onsale_6mo_sls=&item_pct_onsale_6mo_sls_uc;
if item_pct_onsale_6mo_sls_cp ge &item_pct_onsale_6mo_sls_cp_uc then item_pct_onsale_6mo_sls_cp=&item_pct_onsale_6mo_sls_cp_uc;
if net_margin_12mo_sls ge &net_margin_12mo_sls_uc then net_margin_12mo_sls=&net_margin_12mo_sls_uc;
if net_margin_6mo_sls ge &net_margin_6mo_sls_uc then net_margin_6mo_sls=&net_margin_6mo_sls_uc;
if net_sales_amt_12mo_rtn ge &netsales_12mo_rtn_uc then net_sales_amt_12mo_rtn=&netsales_12mo_rtn_uc;
if net_sales_amt_12mo_rtn_cp ge &netsales_12mo_rtn_cp_uc then net_sales_amt_12mo_rtn_cp=&netsales_12mo_rtn_cp_uc;
if net_sales_amt_12mo_sls ge &netsales_12mo_sls_uc then net_sales_amt_12mo_sls=&netsales_12mo_sls_uc;
if net_sales_amt_12mo_sls_cp ge &netsales_12mo_sls_cp_uc then net_sales_amt_12mo_sls_cp=&netsales_12mo_sls_cp_uc;
if net_sales_amt_6mo_rtn ge &netsales_6mo_rtn_uc then net_sales_amt_6mo_rtn=&netsales_6mo_rtn_uc;
if net_sales_amt_6mo_rtn_cp ge &netsales_6mo_rtn_cp_uc then net_sales_amt_6mo_rtn_cp=&netsales_6mo_rtn_cp_uc;
if net_sales_amt_6mo_sls ge &netsales_6mo_sls_uc then net_sales_amt_6mo_sls=&netsales_6mo_sls_uc;
if net_sales_amt_6mo_sls_cp ge &netsales_6mo_sls_cp_uc then net_sales_amt_6mo_sls_cp=&netsales_6mo_sls_cp_uc;
if net_sales_amt_plcb_12mo_sls ge &netsales_plcb_12mo_sls_uc then net_sales_amt_plcb_12mo_sls=&netsales_plcb_12mo_sls_uc;
if net_sales_amt_plcb_12mo_sls_cp ge &netsales_plcb_12mo_sls_cp_uc then net_sales_amt_plcb_12mo_sls_cp=&netsales_plcb_12mo_sls_cp_uc;
if net_sales_amt_plcb_6mo_sls ge &netsales_plcb_6mo_sls_uc then net_sales_amt_plcb_6mo_sls=&netsales_plcb_6mo_sls_uc;
if net_sales_amt_plcb_6mo_sls_cp ge &netsales_plcb_6mo_sls_cp_uc then net_sales_amt_plcb_6mo_sls_cp=&netsales_plcb_6mo_sls_cp_uc;
if num_txns_12mo_rtn ge &num_txns_12mo_rtn_uc then num_txns_12mo_rtn=&num_txns_12mo_rtn_uc;
if num_txns_12mo_rtn_cp ge &num_txns_12mo_rtn_cp_uc then num_txns_12mo_rtn_cp=&num_txns_12mo_rtn_cp_uc;
if num_txns_12mo_sls ge &num_txns_12mo_sls_uc then num_txns_12mo_sls=&num_txns_12mo_sls_uc;
if num_txns_12mo_sls_cp ge &num_txns_12mo_sls_cp_uc then num_txns_12mo_sls_cp=&num_txns_12mo_sls_cp_uc;
if num_txns_6mo_rtn ge &num_txns_6mo_rtn_uc then num_txns_6mo_rtn=&num_txns_6mo_rtn_uc;
if num_txns_6mo_rtn_cp ge &num_txns_6mo_rtn_cp_uc then num_txns_6mo_rtn_cp=&num_txns_6mo_rtn_cp_uc;
if num_txns_6mo_sls ge &num_txns_6mo_sls_uc then num_txns_6mo_sls=&num_txns_6mo_sls_uc;
if num_txns_6mo_sls_cp ge &num_txns_6mo_sls_cp_uc then num_txns_6mo_sls_cp=&num_txns_6mo_sls_cp_uc;
if num_txns_plcb_12mo_sls ge &num_txns_plcb_12mo_sls_uc then num_txns_plcb_12mo_sls=&num_txns_plcb_12mo_sls_uc;
if num_txns_plcb_12mo_sls_cp ge &num_txns_plcb_12mo_sls_cp_uc then num_txns_plcb_12mo_sls_cp=&num_txns_plcb_12mo_sls_cp_uc;
if num_txns_plcb_6mo_sls ge &num_txns_plcb_6mo_sls_uc then num_txns_plcb_6mo_sls=&num_txns_plcb_6mo_sls_uc;
if num_txns_plcb_6mo_sls_cp ge &num_txns_plcb_6mo_sls_cp_uc then num_txns_plcb_6mo_sls_cp=&num_txns_plcb_6mo_sls_cp_uc;
if plcb_txn_pct_12mo ge &plcb_txn_pct_12mo_uc then plcb_txn_pct_12mo=&plcb_txn_pct_12mo_uc;
if plcb_txn_pct_6mo ge &plcb_txn_pct_6mo_uc then plcb_txn_pct_6mo=&plcb_txn_pct_6mo_uc;
if ratio_net_rtn_net_sls_12mo ge &ratio_net_rtn_net_sls_12mo_uc then ratio_net_rtn_net_sls_12mo=&ratio_net_rtn_net_sls_12mo_uc;
if ratio_net_rtn_net_sls_6mo ge &ratio_net_rtn_net_sls_6mo_uc then ratio_net_rtn_net_sls_6mo=&ratio_net_rtn_net_sls_6mo_uc;
if units_per_txn_12mo_sls ge &units_per_txn_12mo_sls_uc then units_per_txn_12mo_sls=&units_per_txn_12mo_sls_uc;
if units_per_txn_6mo_sls ge &units_per_txn_6mo_sls_uc then units_per_txn_6mo_sls=&units_per_txn_6mo_sls_uc;
if years_on_books ge &years_on_books_uc then years_on_books=&years_on_books_uc;

if avg_ord_sz_12mo le &avg_ord_sz_12mo_lc then avg_ord_sz_12mo=&avg_ord_sz_12mo_lc;
if avg_ord_sz_12mo_cp le &avg_ord_sz_12mo_cp_lc then avg_ord_sz_12mo_cp=&avg_ord_sz_12mo_cp_lc;
if avg_ord_sz_6mo le &avg_ord_sz_6mo_lc then avg_ord_sz_6mo=&avg_ord_sz_6mo_lc;
if avg_ord_sz_6mo_cp le &avg_ord_sz_6mo_cp_lc then avg_ord_sz_6mo_cp=&avg_ord_sz_6mo_cp_lc;
if avg_unt_rtl_12mo le &avg_unt_rtl_12mo_lc then avg_unt_rtl_12mo=&avg_unt_rtl_12mo_lc;
if avg_unt_rtl_6mo le &avg_unt_rtl_6mo_lc then avg_unt_rtl_6mo=&avg_unt_rtl_6mo_lc;
if avg_unt_rtl_cp_12mo le &avg_unt_rtl_cp_12mo_lc then avg_unt_rtl_cp_12mo=&avg_unt_rtl_cp_12mo_lc;
if avg_unt_rtl_cp_6mo le &avg_unt_rtl_cp_6mo_lc then avg_unt_rtl_cp_6mo=&avg_unt_rtl_cp_6mo_lc;
if days_last_pur le &days_last_pur_lc then days_last_pur=&days_last_pur_lc;
if days_last_pur_cp le &days_last_pur_cp_lc then days_last_pur_cp=&days_last_pur_cp_lc;
if days_on_books le &days_on_books_lc then days_on_books=&days_on_books_lc;
if days_on_books_cp le &days_on_books_cp_lc then days_on_books_cp=&days_on_books_cp_lc;
if discount_amt_12mo_sls le &discount_amt_12mo_sls_lc then discount_amt_12mo_sls=&discount_amt_12mo_sls_lc;
if discount_amt_6mo_sls le &discount_amt_6mo_sls_lc then discount_amt_6mo_sls=&discount_amt_6mo_sls_lc;
if discount_pct_12mo le &discount_pct_12mo_lc then discount_pct_12mo=&discount_pct_12mo_lc;
if discount_pct_6mo le &discount_pct_6mo_lc then discount_pct_6mo=&discount_pct_6mo_lc;
if div_shp le &div_shp_lc then div_shp=&div_shp_lc;
if div_shp_cp le &div_shp_cp_lc then div_shp_cp=&div_shp_cp_lc;
if emails_clicked le &emails_clicked_lc then emails_clicked=&emails_clicked_lc;
if emails_clicked_cp le &emails_clicked_cp_lc then emails_clicked_cp=&emails_clicked_cp_lc;
if emails_opened le &emails_opened_lc then emails_opened=&emails_opened_lc;
if emails_opened_cp le &emails_opened_cp_lc then emails_opened_cp=&emails_opened_cp_lc;
if emails_pct_clicked le &emails_pct_clicked_lc then emails_pct_clicked=&emails_pct_clicked_lc;
if emails_pct_clicked_cp le &emails_pct_clicked_cp_lc then emails_pct_clicked_cp=&emails_pct_clicked_cp_lc;
if item_qty_12mo_rtn le &item_qty_12mo_rtn_lc then item_qty_12mo_rtn=&item_qty_12mo_rtn_lc;
if item_qty_12mo_rtn_cp le &item_qty_12mo_rtn_cp_lc then item_qty_12mo_rtn_cp=&item_qty_12mo_rtn_cp_lc;
if item_qty_12mo_sls le &item_qty_12mo_sls_lc then item_qty_12mo_sls=&item_qty_12mo_sls_lc;
if item_qty_12mo_sls_cp le &item_qty_12mo_sls_cp_lc then item_qty_12mo_sls_cp=&item_qty_12mo_sls_cp_lc;
if item_qty_6mo_rtn le &item_qty_6mo_rtn_lc then item_qty_6mo_rtn=&item_qty_6mo_rtn_lc;
if item_qty_6mo_rtn_cp le &item_qty_6mo_rtn_cp_lc then item_qty_6mo_rtn_cp=&item_qty_6mo_rtn_cp_lc;
if item_qty_6mo_sls le &item_qty_6mo_sls_lc then item_qty_6mo_sls=&item_qty_6mo_sls_lc;
if item_qty_6mo_sls_cp le &item_qty_6mo_sls_cp_lc then item_qty_6mo_sls_cp=&item_qty_6mo_sls_cp_lc;
if item_qty_onsale_12mo_sls le &item_qty_onsale_12mo_sls_lc then item_qty_onsale_12mo_sls=&item_qty_onsale_12mo_sls_lc;
if item_qty_onsale_12mo_sls_cp le &item_qty_onsale_12mo_sls_cp_lc then item_qty_onsale_12mo_sls_cp=&item_qty_onsale_12mo_sls_cp_lc;
if item_qty_onsale_6mo_sls le &item_qty_onsale_6mo_sls_lc then item_qty_onsale_6mo_sls=&item_qty_onsale_6mo_sls_lc;
if item_qty_onsale_6mo_sls_cp le &item_qty_onsale_6mo_sls_cp_lc then item_qty_onsale_6mo_sls_cp=&item_qty_onsale_6mo_sls_cp_lc;
if item_pct_onsale_12mo_sls le &item_pct_onsale_12mo_sls_lc then item_pct_onsale_12mo_sls=&item_pct_onsale_12mo_sls_lc;
if item_pct_onsale_12mo_sls_cp le &item_pct_onsale_12mo_sls_cp_lc then item_pct_onsale_12mo_sls_cp=&item_pct_onsale_12mo_sls_cp_lc;
if item_pct_onsale_6mo_sls le &item_pct_onsale_6mo_sls_lc then item_pct_onsale_6mo_sls=&item_pct_onsale_6mo_sls_lc;
if item_pct_onsale_6mo_sls_cp le &item_pct_onsale_6mo_sls_cp_lc then item_pct_onsale_6mo_sls_cp=&item_pct_onsale_6mo_sls_cp_lc;
if net_margin_12mo_sls le &net_margin_12mo_sls_lc then net_margin_12mo_sls=&net_margin_12mo_sls_lc;
if net_margin_6mo_sls le &net_margin_6mo_sls_lc then net_margin_6mo_sls=&net_margin_6mo_sls_lc;
if net_sales_amt_12mo_rtn le &netsales_12mo_rtn_lc then net_sales_amt_12mo_rtn=&netsales_12mo_rtn_lc;
if net_sales_amt_12mo_rtn_cp le &netsales_12mo_rtn_cp_lc then net_sales_amt_12mo_rtn_cp=&netsales_12mo_rtn_cp_lc;
if net_sales_amt_12mo_sls le &netsales_12mo_sls_lc then net_sales_amt_12mo_sls=&netsales_12mo_sls_lc;
if net_sales_amt_12mo_sls_cp le &netsales_12mo_sls_cp_lc then net_sales_amt_12mo_sls_cp=&netsales_12mo_sls_cp_lc;
if net_sales_amt_6mo_rtn le &netsales_6mo_rtn_lc then net_sales_amt_6mo_rtn=&netsales_6mo_rtn_lc;
if net_sales_amt_6mo_rtn_cp le &netsales_6mo_rtn_cp_lc then net_sales_amt_6mo_rtn_cp=&netsales_6mo_rtn_cp_lc;
if net_sales_amt_6mo_sls le &netsales_6mo_sls_lc then net_sales_amt_6mo_sls=&netsales_6mo_sls_lc;
if net_sales_amt_6mo_sls_cp le &netsales_6mo_sls_cp_lc then net_sales_amt_6mo_sls_cp=&netsales_6mo_sls_cp_lc;
if net_sales_amt_plcb_12mo_sls le &netsales_plcb_12mo_sls_lc then net_sales_amt_plcb_12mo_sls=&netsales_plcb_12mo_sls_lc;
if net_sales_amt_plcb_12mo_sls_cp le &netsales_plcb_12mo_sls_cp_lc then net_sales_amt_plcb_12mo_sls_cp=&netsales_plcb_12mo_sls_cp_lc;
if net_sales_amt_plcb_6mo_sls le &netsales_plcb_6mo_sls_lc then net_sales_amt_plcb_6mo_sls=&netsales_plcb_6mo_sls_lc;
if net_sales_amt_plcb_6mo_sls_cp le &netsales_plcb_6mo_sls_cp_lc then net_sales_amt_plcb_6mo_sls_cp=&netsales_plcb_6mo_sls_cp_lc;
if num_txns_12mo_rtn le &num_txns_12mo_rtn_lc then num_txns_12mo_rtn=&num_txns_12mo_rtn_lc;
if num_txns_12mo_rtn_cp le &num_txns_12mo_rtn_cp_lc then num_txns_12mo_rtn_cp=&num_txns_12mo_rtn_cp_lc;
if num_txns_12mo_sls le &num_txns_12mo_sls_lc then num_txns_12mo_sls=&num_txns_12mo_sls_lc;
if num_txns_12mo_sls_cp le &num_txns_12mo_sls_cp_lc then num_txns_12mo_sls_cp=&num_txns_12mo_sls_cp_lc;
if num_txns_6mo_rtn le &num_txns_6mo_rtn_lc then num_txns_6mo_rtn=&num_txns_6mo_rtn_lc;
if num_txns_6mo_rtn_cp le &num_txns_6mo_rtn_cp_lc then num_txns_6mo_rtn_cp=&num_txns_6mo_rtn_cp_lc;
if num_txns_6mo_sls le &num_txns_6mo_sls_lc then num_txns_6mo_sls=&num_txns_6mo_sls_lc;
if num_txns_6mo_sls_cp le &num_txns_6mo_sls_cp_lc then num_txns_6mo_sls_cp=&num_txns_6mo_sls_cp_lc;
if num_txns_plcb_12mo_sls le &num_txns_plcb_12mo_sls_lc then num_txns_plcb_12mo_sls=&num_txns_plcb_12mo_sls_lc;
if num_txns_plcb_12mo_sls_cp le &num_txns_plcb_12mo_sls_cp_lc then num_txns_plcb_12mo_sls_cp=&num_txns_plcb_12mo_sls_cp_lc;
if num_txns_plcb_6mo_sls le &num_txns_plcb_6mo_sls_lc then num_txns_plcb_6mo_sls=&num_txns_plcb_6mo_sls_lc;
if num_txns_plcb_6mo_sls_cp le &num_txns_plcb_6mo_sls_cp_lc then num_txns_plcb_6mo_sls_cp=&num_txns_plcb_6mo_sls_cp_lc;
if plcb_txn_pct_12mo le &plcb_txn_pct_12mo_lc then plcb_txn_pct_12mo=&plcb_txn_pct_12mo_lc;
if plcb_txn_pct_6mo le &plcb_txn_pct_6mo_lc then plcb_txn_pct_6mo=&plcb_txn_pct_6mo_lc;
if ratio_net_rtn_net_sls_12mo le &ratio_net_rtn_net_sls_12mo_lc then ratio_net_rtn_net_sls_12mo=&ratio_net_rtn_net_sls_12mo_lc;
if ratio_net_rtn_net_sls_6mo le &ratio_net_rtn_net_sls_6mo_lc then ratio_net_rtn_net_sls_6mo=&ratio_net_rtn_net_sls_6mo_lc;
if units_per_txn_12mo_sls le &units_per_txn_12mo_sls_lc then units_per_txn_12mo_sls=&units_per_txn_12mo_sls_lc;
if units_per_txn_6mo_sls le &units_per_txn_6mo_sls_lc then units_per_txn_6mo_sls=&units_per_txn_6mo_sls_lc;
if years_on_books le &years_on_books_lc then years_on_books=&years_on_books_lc;

run;



data datalib.&brand._em_combined_3;
set &brand._em_combined_2;

avg_ord_sz_12mo = (avg_ord_sz_12mo - &avg_ord_sz_12mo_lc) / (&avg_ord_sz_12mo_uc - &avg_ord_sz_12mo_lc);
avg_ord_sz_12mo_cp = (avg_ord_sz_12mo_cp - &avg_ord_sz_12mo_cp_lc) / (&avg_ord_sz_12mo_cp_uc - &avg_ord_sz_12mo_cp_lc);
avg_ord_sz_6mo = (avg_ord_sz_6mo - &avg_ord_sz_6mo_lc) / (&avg_ord_sz_6mo_uc - &avg_ord_sz_6mo_lc);
avg_ord_sz_6mo_cp = (avg_ord_sz_6mo_cp - &avg_ord_sz_6mo_cp_lc) / (&avg_ord_sz_6mo_cp_uc - &avg_ord_sz_6mo_cp_lc);
avg_unt_rtl_12mo = (avg_unt_rtl_12mo - &avg_unt_rtl_12mo_lc) / (&avg_unt_rtl_12mo_uc - &avg_unt_rtl_12mo_lc);
avg_unt_rtl_6mo = (avg_unt_rtl_6mo - &avg_unt_rtl_6mo_lc) / (&avg_unt_rtl_6mo_uc - &avg_unt_rtl_6mo_lc);
avg_unt_rtl_cp_12mo = (avg_unt_rtl_cp_12mo - &avg_unt_rtl_cp_12mo_lc) / (&avg_unt_rtl_cp_12mo_uc - &avg_unt_rtl_cp_12mo_lc);
avg_unt_rtl_cp_6mo = (avg_unt_rtl_cp_6mo - &avg_unt_rtl_cp_6mo_lc) / (&avg_unt_rtl_cp_6mo_uc - &avg_unt_rtl_cp_6mo_lc);
days_last_pur = (days_last_pur - &days_last_pur_lc) / (&days_last_pur_uc - &days_last_pur_lc);
days_last_pur_cp = (days_last_pur_cp - &days_last_pur_cp_lc) / (&days_last_pur_cp_uc - &days_last_pur_cp_lc);
days_on_books = (days_on_books - &days_on_books_lc) / (&days_on_books_uc - &days_on_books_lc);
days_on_books_cp = (days_on_books_cp - &days_on_books_cp_lc) / (&days_on_books_cp_uc - &days_on_books_cp_lc);
discount_amt_12mo_sls = (discount_amt_12mo_sls - &discount_amt_12mo_sls_lc) / (&discount_amt_12mo_sls_uc - &discount_amt_12mo_sls_lc);
discount_amt_6mo_sls = (discount_amt_6mo_sls - &discount_amt_6mo_sls_lc) / (&discount_amt_6mo_sls_uc - &discount_amt_6mo_sls_lc);
discount_pct_12mo = (discount_pct_12mo - &discount_pct_12mo_lc) / (&discount_pct_12mo_uc - &discount_pct_12mo_lc);
discount_pct_6mo = (discount_pct_6mo - &discount_pct_6mo_lc) / (&discount_pct_6mo_uc - &discount_pct_6mo_lc);
div_shp = (div_shp - &div_shp_lc) / (&div_shp_uc - &div_shp_lc);
div_shp_cp = (div_shp_cp - &div_shp_cp_lc) / (&div_shp_cp_uc - &div_shp_cp_lc);
emails_clicked = (emails_clicked - &emails_clicked_lc) / (&emails_clicked_uc - &emails_clicked_lc);
emails_clicked_cp = (emails_clicked_cp - &emails_clicked_cp_lc) / (&emails_clicked_cp_uc - &emails_clicked_cp_lc);
emails_opened = (emails_opened - &emails_opened_lc) / (&emails_opened_uc - &emails_opened_lc);
emails_opened_cp = (emails_opened_cp - &emails_opened_cp_lc) / (&emails_opened_cp_uc - &emails_opened_cp_lc);
emails_pct_clicked = (emails_pct_clicked - &emails_pct_clicked_lc) / (&emails_pct_clicked_uc - &emails_pct_clicked_lc);
emails_pct_clicked_cp = (emails_pct_clicked_cp - &emails_pct_clicked_cp_lc) / (&emails_pct_clicked_cp_uc - &emails_pct_clicked_cp_lc);
item_qty_12mo_rtn = (item_qty_12mo_rtn - &item_qty_12mo_rtn_lc) / (&item_qty_12mo_rtn_uc - &item_qty_12mo_rtn_lc);
item_qty_12mo_rtn_cp = (item_qty_12mo_rtn_cp - &item_qty_12mo_rtn_cp_lc) / (&item_qty_12mo_rtn_cp_uc - &item_qty_12mo_rtn_cp_lc);
item_qty_12mo_sls = (item_qty_12mo_sls - &item_qty_12mo_sls_lc) / (&item_qty_12mo_sls_uc - &item_qty_12mo_sls_lc);
item_qty_12mo_sls_cp = (item_qty_12mo_sls_cp - &item_qty_12mo_sls_cp_lc) / (&item_qty_12mo_sls_cp_uc - &item_qty_12mo_sls_cp_lc);
item_qty_6mo_rtn = (item_qty_6mo_rtn - &item_qty_6mo_rtn_lc) / (&item_qty_6mo_rtn_uc - &item_qty_6mo_rtn_lc);
item_qty_6mo_rtn_cp = (item_qty_6mo_rtn_cp - &item_qty_6mo_rtn_cp_lc) / (&item_qty_6mo_rtn_cp_uc - &item_qty_6mo_rtn_cp_lc);
item_qty_6mo_sls = (item_qty_6mo_sls - &item_qty_6mo_sls_lc) / (&item_qty_6mo_sls_uc - &item_qty_6mo_sls_lc);
item_qty_6mo_sls_cp = (item_qty_6mo_sls_cp - &item_qty_6mo_sls_cp_lc) / (&item_qty_6mo_sls_cp_uc - &item_qty_6mo_sls_cp_lc);
item_qty_onsale_12mo_sls = (item_qty_onsale_12mo_sls - &item_qty_onsale_12mo_sls_lc) / (&item_qty_onsale_12mo_sls_uc - &item_qty_onsale_12mo_sls_lc);
item_qty_onsale_12mo_sls_cp = (item_qty_onsale_12mo_sls_cp - &item_qty_onsale_12mo_sls_cp_lc) / (&item_qty_onsale_12mo_sls_cp_uc - &item_qty_onsale_12mo_sls_cp_lc);
item_qty_onsale_6mo_sls = (item_qty_onsale_6mo_sls - &item_qty_onsale_6mo_sls_lc) / (&item_qty_onsale_6mo_sls_uc - &item_qty_onsale_6mo_sls_lc);
item_qty_onsale_6mo_sls_cp = (item_qty_onsale_6mo_sls_cp - &item_qty_onsale_6mo_sls_cp_lc) / (&item_qty_onsale_6mo_sls_cp_uc - &item_qty_onsale_6mo_sls_cp_lc);
item_pct_onsale_12mo_sls = (item_pct_onsale_12mo_sls - &item_pct_onsale_12mo_sls_lc) / (&item_pct_onsale_12mo_sls_uc - &item_pct_onsale_12mo_sls_lc);
item_pct_onsale_12mo_sls_cp = (item_pct_onsale_12mo_sls_cp - &item_pct_onsale_12mo_sls_cp_lc) / (&item_pct_onsale_12mo_sls_cp_uc - &item_pct_onsale_12mo_sls_cp_lc);
item_pct_onsale_6mo_sls = (item_pct_onsale_6mo_sls - &item_pct_onsale_6mo_sls_lc) / (&item_pct_onsale_6mo_sls_uc - &item_pct_onsale_6mo_sls_lc);
item_pct_onsale_6mo_sls_cp = (item_pct_onsale_6mo_sls_cp - &item_pct_onsale_6mo_sls_cp_lc) / (&item_pct_onsale_6mo_sls_cp_uc - &item_pct_onsale_6mo_sls_cp_lc);
net_margin_12mo_sls = (net_margin_12mo_sls - &net_margin_12mo_sls_lc) / (&net_margin_12mo_sls_uc - &net_margin_12mo_sls_lc);
net_margin_6mo_sls = (net_margin_6mo_sls - &net_margin_6mo_sls_lc) / (&net_margin_6mo_sls_uc - &net_margin_6mo_sls_lc);
net_sales_amt_12mo_rtn = (net_sales_amt_12mo_rtn - &netsales_12mo_rtn_lc) / (&netsales_12mo_rtn_uc - &netsales_12mo_rtn_lc);
net_sales_amt_12mo_rtn_cp = (net_sales_amt_12mo_rtn_cp - &netsales_12mo_rtn_cp_lc) / (&netsales_12mo_rtn_cp_uc - &netsales_12mo_rtn_cp_lc);
net_sales_amt_12mo_sls = (net_sales_amt_12mo_sls - &netsales_12mo_sls_lc) / (&netsales_12mo_sls_uc - &netsales_12mo_sls_lc);
net_sales_amt_12mo_sls_cp = (net_sales_amt_12mo_sls_cp - &netsales_12mo_sls_cp_lc) / (&netsales_12mo_sls_cp_uc - &netsales_12mo_sls_cp_lc);
net_sales_amt_6mo_rtn = (net_sales_amt_6mo_rtn - &netsales_6mo_rtn_lc) / (&netsales_6mo_rtn_uc - &netsales_6mo_rtn_lc);
net_sales_amt_6mo_rtn_cp = (net_sales_amt_6mo_rtn_cp - &netsales_6mo_rtn_cp_lc) / (&netsales_6mo_rtn_cp_uc - &netsales_6mo_rtn_cp_lc);
net_sales_amt_6mo_sls = (net_sales_amt_6mo_sls - &netsales_6mo_sls_lc) / (&netsales_6mo_sls_uc - &netsales_6mo_sls_lc);
net_sales_amt_6mo_sls_cp = (net_sales_amt_6mo_sls_cp - &netsales_6mo_sls_cp_lc) / (&netsales_6mo_sls_cp_uc - &netsales_6mo_sls_cp_lc);
net_sales_amt_plcb_12mo_sls = (net_sales_amt_plcb_12mo_sls - &netsales_plcb_12mo_sls_lc) / (&netsales_plcb_12mo_sls_uc - &netsales_plcb_12mo_sls_lc);
net_sales_amt_plcb_12mo_sls_cp = (net_sales_amt_plcb_12mo_sls_cp - &netsales_plcb_12mo_sls_cp_lc) / (&netsales_plcb_12mo_sls_cp_uc - &netsales_plcb_12mo_sls_cp_lc);
net_sales_amt_plcb_6mo_sls = (net_sales_amt_plcb_6mo_sls - &netsales_plcb_6mo_sls_lc) / (&netsales_plcb_6mo_sls_uc - &netsales_plcb_6mo_sls_lc);
net_sales_amt_plcb_6mo_sls_cp = (net_sales_amt_plcb_6mo_sls_cp - &netsales_plcb_6mo_sls_cp_lc) / (&netsales_plcb_6mo_sls_cp_uc - &netsales_plcb_6mo_sls_cp_lc);
num_txns_12mo_rtn = (num_txns_12mo_rtn - &num_txns_12mo_rtn_lc) / (&num_txns_12mo_rtn_uc - &num_txns_12mo_rtn_lc);
num_txns_12mo_rtn_cp = (num_txns_12mo_rtn_cp - &num_txns_12mo_rtn_cp_lc) / (&num_txns_12mo_rtn_cp_uc - &num_txns_12mo_rtn_cp_lc);
num_txns_12mo_sls = (num_txns_12mo_sls - &num_txns_12mo_sls_lc) / (&num_txns_12mo_sls_uc - &num_txns_12mo_sls_lc);
num_txns_12mo_sls_cp = (num_txns_12mo_sls_cp - &num_txns_12mo_sls_cp_lc) / (&num_txns_12mo_sls_cp_uc - &num_txns_12mo_sls_cp_lc);
num_txns_6mo_rtn = (num_txns_6mo_rtn - &num_txns_6mo_rtn_lc) / (&num_txns_6mo_rtn_uc - &num_txns_6mo_rtn_lc);
num_txns_6mo_rtn_cp = (num_txns_6mo_rtn_cp - &num_txns_6mo_rtn_cp_lc) / (&num_txns_6mo_rtn_cp_uc - &num_txns_6mo_rtn_cp_lc);
num_txns_6mo_sls = (num_txns_6mo_sls - &num_txns_6mo_sls_lc) / (&num_txns_6mo_sls_uc - &num_txns_6mo_sls_lc);
num_txns_6mo_sls_cp = (num_txns_6mo_sls_cp - &num_txns_6mo_sls_cp_lc) / (&num_txns_6mo_sls_cp_uc - &num_txns_6mo_sls_cp_lc);
num_txns_plcb_12mo_sls = (num_txns_plcb_12mo_sls - &num_txns_plcb_12mo_sls_lc) / (&num_txns_plcb_12mo_sls_uc - &num_txns_plcb_12mo_sls_lc);
num_txns_plcb_12mo_sls_cp = (num_txns_plcb_12mo_sls_cp - &num_txns_plcb_12mo_sls_cp_lc) / (&num_txns_plcb_12mo_sls_cp_uc - &num_txns_plcb_12mo_sls_cp_lc);
num_txns_plcb_6mo_sls = (num_txns_plcb_6mo_sls - &num_txns_plcb_6mo_sls_lc) / (&num_txns_plcb_6mo_sls_uc - &num_txns_plcb_6mo_sls_lc);
num_txns_plcb_6mo_sls_cp = (num_txns_plcb_6mo_sls_cp - &num_txns_plcb_6mo_sls_cp_lc) / (&num_txns_plcb_6mo_sls_cp_uc - &num_txns_plcb_6mo_sls_cp_lc);
plcb_txn_pct_12mo = (plcb_txn_pct_12mo - &plcb_txn_pct_12mo_lc) / (&plcb_txn_pct_12mo_uc - &plcb_txn_pct_12mo_lc);
plcb_txn_pct_6mo = (plcb_txn_pct_6mo - &plcb_txn_pct_6mo_lc) / (&plcb_txn_pct_6mo_uc - &plcb_txn_pct_6mo_lc);
ratio_net_rtn_net_sls_12mo = (ratio_net_rtn_net_sls_12mo - &ratio_net_rtn_net_sls_12mo_lc) / (&ratio_net_rtn_net_sls_12mo_uc - &ratio_net_rtn_net_sls_12mo_lc);
ratio_net_rtn_net_sls_6mo = (ratio_net_rtn_net_sls_6mo - &ratio_net_rtn_net_sls_6mo_lc) / (&ratio_net_rtn_net_sls_6mo_uc - &ratio_net_rtn_net_sls_6mo_lc);
units_per_txn_12mo_sls = (units_per_txn_12mo_sls - &units_per_txn_12mo_sls_lc) / (&units_per_txn_12mo_sls_uc - &units_per_txn_12mo_sls_lc);
units_per_txn_6mo_sls = (units_per_txn_6mo_sls - &units_per_txn_6mo_sls_lc) / (&units_per_txn_6mo_sls_uc - &units_per_txn_6mo_sls_lc);
years_on_books = (years_on_books - &years_on_books_lc) / (&years_on_books_uc - &years_on_books_lc);

run;

proc means data=datalib.&brand._em_combined_3;run;


proc freq data = datalib.&brand._em_combined;
 table card_status;
run;


proc freq data = datalib.&brand._em_combined;
 table card_status;
run;

proc export data=datalib.&brand._em_combined_3
			outfile="z:\tanumoy\datasets\model replication\&brand._em_gen2_combined_3.txt"
            dbms=dlm replace;
     delimiter="|";
run;

proc logistic inmodel=datalib.gp_em_balanced_model_1;
 score data=gp_em_combined_3 out=gp_em_combined_4;
run;


data gp_em_combined_4;
 keep campaign training customer_key card_status num_txns_12mo_sls active_flag responder p_1 poffset_1;
 set gp_em_combined_4;
 if p_1 ne 1;
 logit_1=log(p_1) - log(1-p_1);
 poffset_1=logistic(logit_1-offset);
 label p_1 = "resp_prob_1";
 rename p_1 = resp_prob_1;
 drop p_0;
 active_flag=0;
 if num_txns_12mo_sls > 0 then active_flag=1;
run;




proc sql;
 select count(*) into: traincount from gp_em_combined_4 where training=1 and active_flag ne 1;
quit;
 
%let trainintv = %eval(&traincount/10);

proc sort data=gp_em_combined_4
		  out=gp_em_combined_pred_train;
 by descending poffset_1;
 where training=1 and active_flag ne 1;
run;


data gp_em_combined_pred_train;
 set gp_em_combined_pred_train;
 if _n_ ge 1 + 0 * round(&trainintv) then new_resp_prob_grp=1;
 if _n_ ge 1 + 1 * round(&trainintv) then new_resp_prob_grp=2;
 if _n_ ge 1 + 2 * round(&trainintv) then new_resp_prob_grp=3;
 if _n_ ge 1 + 3 * round(&trainintv) then new_resp_prob_grp=4;
 if _n_ ge 1 + 4 * round(&trainintv) then new_resp_prob_grp=5;
 if _n_ ge 1 + 5 * round(&trainintv) then new_resp_prob_grp=6;
 if _n_ ge 1 + 6 * round(&trainintv) then new_resp_prob_grp=7;
 if _n_ ge 1 + 7 * round(&trainintv) then new_resp_prob_grp=8;
 if _n_ ge 1 + 8 * round(&trainintv) then new_resp_prob_grp=9;
 if _n_ ge 1 + 9 * round(&trainintv) then new_resp_prob_grp=10;
run;

proc freq data=gp_em_combined_pred_train;
 table new_resp_prob_grp * responder;
run;


proc sql;
 create table summary_train as select distinct 
        new_resp_prob_grp, count(customer_key) as customers,
        sum(responder) as responders
	    from gp_em_combined_pred_train
		group by new_resp_prob_grp order by new_resp_prob_grp;
quit;







proc sql;
 select count(*) into: testcount from gp_em_combined_4 where training=0  and active_flag ne 1;
quit;
 
%let testintv = %eval(&testcount/10);

proc sort data=gp_em_combined_4
		  out=gp_em_combined_pred_test;
 by descending poffset_1;
 where training=0  and active_flag ne 1;
run;


data gp_em_combined_pred_test;
 set gp_em_combined_pred_test;
 if _n_ ge 1 + 0 * round(&testintv) then new_resp_prob_grp=1;
 if _n_ ge 1 + 1 * round(&testintv) then new_resp_prob_grp=2;
 if _n_ ge 1 + 2 * round(&testintv) then new_resp_prob_grp=3;
 if _n_ ge 1 + 3 * round(&testintv) then new_resp_prob_grp=4;
 if _n_ ge 1 + 4 * round(&testintv) then new_resp_prob_grp=5;
 if _n_ ge 1 + 5 * round(&testintv) then new_resp_prob_grp=6;
 if _n_ ge 1 + 6 * round(&testintv) then new_resp_prob_grp=7;
 if _n_ ge 1 + 7 * round(&testintv) then new_resp_prob_grp=8;
 if _n_ ge 1 + 8 * round(&testintv) then new_resp_prob_grp=9;
 if _n_ ge 1 + 9 * round(&testintv) then new_resp_prob_grp=10;
run;

proc freq data=gp_em_combined_pred_test;
 table new_resp_prob_grp * responder;
run;


proc sql;
 create table summary_test as select distinct 
        new_resp_prob_grp, count(customer_key) as customers,
        sum(responder) as responders
	    from gp_em_combined_pred_test
		group by new_resp_prob_grp order by new_resp_prob_grp;
quit;












proc sql;
 select count(*) into: traincount from gp_em_combined_4 where training=1;
quit;
 
%let trainintv = %eval(&traincount/10);

proc sort data=gp_em_combined_4
		  out=gp_em_combined_pred_train;
 by descending poffset_1;
 where training=1;
run;


data gp_em_combined_pred_train;
 set gp_em_combined_pred_train;
 if _n_ ge 1 + 0 * round(&trainintv) then new_resp_prob_grp=1;
 if _n_ ge 1 + 1 * round(&trainintv) then new_resp_prob_grp=2;
 if _n_ ge 1 + 2 * round(&trainintv) then new_resp_prob_grp=3;
 if _n_ ge 1 + 3 * round(&trainintv) then new_resp_prob_grp=4;
 if _n_ ge 1 + 4 * round(&trainintv) then new_resp_prob_grp=5;
 if _n_ ge 1 + 5 * round(&trainintv) then new_resp_prob_grp=6;
 if _n_ ge 1 + 6 * round(&trainintv) then new_resp_prob_grp=7;
 if _n_ ge 1 + 7 * round(&trainintv) then new_resp_prob_grp=8;
 if _n_ ge 1 + 8 * round(&trainintv) then new_resp_prob_grp=9;
 if _n_ ge 1 + 9 * round(&trainintv) then new_resp_prob_grp=10;
run;

proc freq data=gp_em_combined_pred_train;
 table new_resp_prob_grp * responder;
run;


proc sql;
 create table summary_train as select distinct 
        new_resp_prob_grp, count(customer_key) as customers,
        sum(responder) as responders
	    from gp_em_combined_pred_train
		group by new_resp_prob_grp order by new_resp_prob_grp;
quit;







proc sql;
 select count(*) into: testcount from gp_em_combined_4 where training=0 ;
quit;
 
%let testintv = %eval(&testcount/10);

proc sort data=gp_em_combined_4
		  out=gp_em_combined_pred_test;
 by descending poffset_1;
 where training=0 ;
run;


data gp_em_combined_pred_test;
 set gp_em_combined_pred_test;
 if _n_ ge 1 + 0 * round(&testintv) then new_resp_prob_grp=1;
 if _n_ ge 1 + 1 * round(&testintv) then new_resp_prob_grp=2;
 if _n_ ge 1 + 2 * round(&testintv) then new_resp_prob_grp=3;
 if _n_ ge 1 + 3 * round(&testintv) then new_resp_prob_grp=4;
 if _n_ ge 1 + 4 * round(&testintv) then new_resp_prob_grp=5;
 if _n_ ge 1 + 5 * round(&testintv) then new_resp_prob_grp=6;
 if _n_ ge 1 + 6 * round(&testintv) then new_resp_prob_grp=7;
 if _n_ ge 1 + 7 * round(&testintv) then new_resp_prob_grp=8;
 if _n_ ge 1 + 8 * round(&testintv) then new_resp_prob_grp=9;
 if _n_ ge 1 + 9 * round(&testintv) then new_resp_prob_grp=10;
run;

proc freq data=gp_em_combined_pred_test;
 table new_resp_prob_grp * responder;
run;


proc sql;
 create table summary_test as select distinct 
        new_resp_prob_grp, count(customer_key) as customers,
        sum(responder) as responders
	    from gp_em_combined_pred_test
		group by new_resp_prob_grp order by new_resp_prob_grp;
quit;
