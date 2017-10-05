*ASSIGN LIBRARIES;

* 2033109 2034203;

rsubmit;
%let login=ta4u1r9;
%let password=AssassinsCreed002$!;
%let path="PX37SRV07.GID.GAP.COM:1521/GDSASP";

libname coresas oracle user=&login pass="&password" path=&path. PRESERVE_TAB_NAMES=YES schema=coresas;
libname &login. ORACLE user=&login pass="&password" path=&path. PRESERVE_TAB_NAMES=YES schema=&login.;
endrsubmit;


LIBNAME DATALIB "\\10.8.8.51\LV0\TANUMOY\DATASETS\From Hive\";

OPTIONS MACROGEN SYMBOLGEN MLOGIC MPRINT;

%LET BRAND=GP;




%MACRO CONVERTHIVE(SAMPLES, BRAND, INPATH, OUTPATH);

LIBNAME DATALIB "&OUTPATH"; 

LIBNAME INLIB "&INPATH";

%LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

%DO I=1 %TO &SAMPLECOUNT;
		
		%LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   		%PUT &SAMPLENAME;

   		%LET BASEDS=&BRAND._&SAMPLENAME._COMBINED_ONL;


	    %LET DATASET = &INPATH.\&BASEDS..TXT;
		%PUT &DATASET;

		%IF %SYSFUNC(FILEEXIST(&DATASET)) %THEN %DO;

			DATA DATALIB.&BASEDS;
			INFILE "&DATASET" 
			DELIMITER = '|' MISSOVER DSD LRECL=32767 FIRSTOBS=1;

INFORMAT campaign_version BEST32.;
INFORMAT customer_key BEST32.;
INFORMAT event_date yymmdd10.;
INFORMAT emailopens BEST32.;
INFORMAT emailopenflag BEST32.;
INFORMAT emailclicks BEST32.;
INFORMAT emailclickflag BEST32.;
INFORMAT responder BEST32.;
INFORMAT num_txns BEST32.;
INFORMAT item_qty BEST32.;
INFORMAT gross_sales_amt BEST32.;
INFORMAT discount_amt BEST32.;
INFORMAT tot_prd_cst_amt BEST32.;
INFORMAT net_sales_amt BEST32.;
INFORMAT net_margin BEST32.;
INFORMAT net_sales_amt_6mo_sls BEST32.;
INFORMAT net_sales_amt_12mo_sls BEST32.;
INFORMAT net_sales_amt_plcc_6mo_sls BEST32.;
INFORMAT net_sales_amt_plcc_12mo_sls BEST32.;
INFORMAT discount_amt_6mo_sls BEST32.;
INFORMAT discount_amt_12mo_sls BEST32.;
INFORMAT net_margin_6mo_sls BEST32.;
INFORMAT net_margin_12mo_sls BEST32.;
INFORMAT item_qty_6mo_sls BEST32.;
INFORMAT item_qty_12mo_sls BEST32.;
INFORMAT item_qty_onsale_6mo_sls BEST32.;
INFORMAT item_qty_onsale_12mo_sls BEST32.;
INFORMAT num_txns_6mo_sls BEST32.;
INFORMAT num_txns_12mo_sls BEST32.;
INFORMAT num_txns_plcc_6mo_sls BEST32.;
INFORMAT num_txns_plcc_12mo_sls BEST32.;
INFORMAT net_sales_amt_6mo_rtn BEST32.;
INFORMAT net_sales_amt_12mo_rtn BEST32.;
INFORMAT item_qty_6mo_rtn BEST32.;
INFORMAT item_qty_12mo_rtn BEST32.;
INFORMAT num_txns_6mo_rtn BEST32.;
INFORMAT num_txns_12mo_rtn BEST32.;
INFORMAT net_sales_amt_6mo_sls_cp BEST32.;
INFORMAT net_sales_amt_12mo_sls_cp BEST32.;
INFORMAT net_sales_amt_plcc_6mo_sls_cp BEST32.;
INFORMAT net_sales_amt_plcc_12mo_sls_cp BEST32.;
INFORMAT item_qty_6mo_sls_cp BEST32.;
INFORMAT item_qty_12mo_sls_cp BEST32.;
INFORMAT item_qty_onsale_6mo_sls_cp BEST32.;
INFORMAT item_qty_onsale_12mo_sls_cp BEST32.;
INFORMAT num_txns_6mo_sls_cp BEST32.;
INFORMAT num_txns_12mo_sls_cp BEST32.;
INFORMAT num_txns_plcc_6mo_sls_cp BEST32.;
INFORMAT num_txns_plcc_12mo_sls_cp BEST32.;
INFORMAT net_sales_amt_6mo_rtn_cp BEST32.;
INFORMAT net_sales_amt_12mo_rtn_cp BEST32.;
INFORMAT item_qty_6mo_rtn_cp BEST32.;
INFORMAT item_qty_12mo_rtn_cp BEST32.;
INFORMAT num_txns_6mo_rtn_cp BEST32.;
INFORMAT num_txns_12mo_rtn_cp BEST32.;
INFORMAT visasig_flag BEST32.;
INFORMAT basic_flag BEST32.;
INFORMAT silver_flag BEST32.;
INFORMAT sister_flag BEST32.;
INFORMAT card_status BEST32.;
INFORMAT days_last_pur BEST32.;
INFORMAT days_last_pur_cp BEST32.;
INFORMAT days_on_books BEST32.;
INFORMAT days_on_books_cp BEST32.;
INFORMAT div_shp BEST32.;
INFORMAT div_shp_cp BEST32.;
INFORMAT emails_clicked BEST32.;
INFORMAT emails_clicked_cp BEST32.;
INFORMAT emails_opened BEST32.;
INFORMAT emails_opened_cp BEST32.;

FORMAT campaign_version BEST32.;
FORMAT customer_key BEST32.;
FORMAT event_date yymmdd10.;
INFORMAT emailopens BEST32.;
INFORMAT emailopenflag BEST32.;
INFORMAT emailclicks BEST32.;
INFORMAT emailclickflag BEST32.;
FORMAT responder BEST32.;
FORMAT num_txns BEST32.;
FORMAT item_qty BEST32.;
FORMAT gross_sales_amt BEST32.;
FORMAT discount_amt BEST32.;
FORMAT tot_prd_cst_amt BEST32.;
FORMAT net_sales_amt BEST32.;
FORMAT net_margin BEST32.;
FORMAT net_sales_amt_6mo_sls BEST32.;
FORMAT net_sales_amt_12mo_sls BEST32.;
FORMAT net_sales_amt_plcc_6mo_sls BEST32.;
FORMAT net_sales_amt_plcc_12mo_sls BEST32.;
FORMAT discount_amt_6mo_sls BEST32.;
FORMAT discount_amt_12mo_sls BEST32.;
FORMAT net_margin_6mo_sls BEST32.;
FORMAT net_margin_12mo_sls BEST32.;
FORMAT item_qty_6mo_sls BEST32.;
FORMAT item_qty_12mo_sls BEST32.;
FORMAT item_qty_onsale_6mo_sls BEST32.;
FORMAT item_qty_onsale_12mo_sls BEST32.;
FORMAT num_txns_6mo_sls BEST32.;
FORMAT num_txns_12mo_sls BEST32.;
FORMAT num_txns_plcc_6mo_sls BEST32.;
FORMAT num_txns_plcc_12mo_sls BEST32.;
FORMAT net_sales_amt_6mo_rtn BEST32.;
FORMAT net_sales_amt_12mo_rtn BEST32.;
FORMAT item_qty_6mo_rtn BEST32.;
FORMAT item_qty_12mo_rtn BEST32.;
FORMAT num_txns_6mo_rtn BEST32.;
FORMAT num_txns_12mo_rtn BEST32.;
FORMAT net_sales_amt_6mo_sls_cp BEST32.;
FORMAT net_sales_amt_12mo_sls_cp BEST32.;
FORMAT net_sales_amt_plcc_6mo_sls_cp BEST32.;
FORMAT net_sales_amt_plcc_12mo_sls_cp BEST32.;
FORMAT item_qty_6mo_sls_cp BEST32.;
FORMAT item_qty_12mo_sls_cp BEST32.;
FORMAT item_qty_onsale_6mo_sls_cp BEST32.;
FORMAT item_qty_onsale_12mo_sls_cp BEST32.;
FORMAT num_txns_6mo_sls_cp BEST32.;
FORMAT num_txns_12mo_sls_cp BEST32.;
FORMAT num_txns_plcc_6mo_sls_cp BEST32.;
FORMAT num_txns_plcc_12mo_sls_cp BEST32.;
FORMAT net_sales_amt_6mo_rtn_cp BEST32.;
FORMAT net_sales_amt_12mo_rtn_cp BEST32.;
FORMAT item_qty_6mo_rtn_cp BEST32.;
FORMAT item_qty_12mo_rtn_cp BEST32.;
FORMAT num_txns_6mo_rtn_cp BEST32.;
FORMAT num_txns_12mo_rtn_cp BEST32.;
FORMAT visasig_flag BEST32.;
FORMAT basic_flag BEST32.;
FORMAT silver_flag BEST32.;
FORMAT sister_flag BEST32.;
FORMAT card_status BEST32.;
FORMAT days_last_pur BEST32.;
FORMAT days_last_pur_cp BEST32.;
FORMAT days_on_books BEST32.;
FORMAT days_on_books_cp BEST32.;
FORMAT div_shp BEST32.;
FORMAT div_shp_cp BEST32.;
FORMAT emails_clicked BEST32.;
FORMAT emails_clicked_cp BEST32.;
FORMAT emails_opened BEST32.;
FORMAT emails_opened_cp BEST32.;

INPUT
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
net_sales_amt_plcc_6mo_sls
net_sales_amt_plcc_12mo_sls
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
num_txns_plcc_6mo_sls
num_txns_plcc_12mo_sls
net_sales_amt_6mo_rtn
net_sales_amt_12mo_rtn
item_qty_6mo_rtn
item_qty_12mo_rtn
num_txns_6mo_rtn
num_txns_12mo_rtn
net_sales_amt_6mo_sls_cp
net_sales_amt_12mo_sls_cp
net_sales_amt_plcc_6mo_sls_cp
net_sales_amt_plcc_12mo_sls_cp
item_qty_6mo_sls_cp
item_qty_12mo_sls_cp
item_qty_onsale_6mo_sls_cp
item_qty_onsale_12mo_sls_cp
num_txns_6mo_sls_cp
num_txns_12mo_sls_cp
num_txns_plcc_6mo_sls_cp
num_txns_plcc_12mo_sls_cp
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

			RUN;

			OPTIONS NOXWAIT;
			
		%END;

%END;

%MEND;

%CONVERTHIVE
(SAMPLES=20170917, BRAND=GP,
INPATH =\\10.8.8.51\LV0\TANUMOY\DATASETS\From Hive,
OUTPATH=\\10.8.8.51\LV0\TANUMOY\DATASETS\From Hive);


*check for nulls or missings;
*proc means data=datalib.&BRAND._2033109_combined_onl n nmiss min mean std max; run; *8648234;
*proc means data=datalib.&BRAND._2034203_combined_onl n nmiss min mean std max; run; *8700561;







DATA DATALIB.&BRAND._EM_RESP_PROP_1_ONL;
 SET DATALIB.&BRAND._EM_RESP_PROP_1_ONL;
 CALL SYMPUT ("PROP_RESPONDERS", PROP_RESPONDERS);
 CALL SYMPUT ("PROP_RESPONDERS_BAL", PROP_RESPONDERS_BAL);
 CALL SYMPUT ("PROP_NONRESPONDERS", PROP_NONRESPONDERS);
 CALL SYMPUT ("PROP_NONRESPONDERS_BAL", PROP_NONRESPONDERS_BAL);
RUN;

%PUT &PROP_RESPONDERS &PROP_NONRESPONDERS;
%PUT &PROP_RESPONDERS_BAL &PROP_NONRESPONDERS_BAL;



*CREATE THE ADDITIONAL METRICS FOR THE UNBALANCED DATASETS;

%MACRO DATAPREPMACRO(SAMPLES, BRAND);
DATA DATALIB.&BRAND._&SAMPLES._combined_onl;
 SET DATALIB.&BRAND._&SAMPLES._combined_onl;
		
 IF RESPONDER=1 THEN WT=&PROP_RESPONDERS/&PROP_RESPONDERS_BAL;	
 IF RESPONDER=0 THEN WT=&PROP_NONRESPONDERS/&PROP_NONRESPONDERS_BAL;	
	
 UNITS_PER_TXN_12MO_SLS=0;	
 IF NUM_TXNS_12MO_SLS NE 0 THEN 	
	UNITS_PER_TXN_12MO_SLS=ITEM_QTY_12MO_SLS/NUM_TXNS_12MO_SLS;
	
 UNITS_PER_TXN_6MO_SLS=0;	
 IF NUM_TXNS_6MO_SLS NE 0 THEN 	
	UNITS_PER_TXN_6MO_SLS=ITEM_QTY_6MO_SLS/NUM_TXNS_6MO_SLS;
	
 AVG_ORD_SZ_12MO=0;	
 IF NUM_TXNS_12MO_SLS NE 0 THEN 	
	AVG_ORD_SZ_12MO=NET_SALES_AMT_12MO_SLS/NUM_TXNS_12MO_SLS;
	
 AVG_ORD_SZ_6MO=0;	
 IF NUM_TXNS_6MO_SLS NE 0 THEN 	
	AVG_ORD_SZ_6MO=NET_SALES_AMT_6MO_SLS/NUM_TXNS_6MO_SLS;
	
 AVG_ORD_SZ_12MO_CP=0;	
 IF NUM_TXNS_12MO_SLS_CP NE 0 THEN 	
	AVG_ORD_SZ_12MO_CP=NET_SALES_AMT_12MO_SLS_CP/NUM_TXNS_12MO_SLS_CP;
	
 AVG_ORD_SZ_6MO_CP=0;	
 IF NUM_TXNS_6MO_SLS_CP NE 0 THEN 	
	AVG_ORD_SZ_6MO_CP=NET_SALES_AMT_6MO_SLS_CP/NUM_TXNS_6MO_SLS_CP;
	
 DISCOUNT_PCT_12MO=0; DISCOUNT_PCT_6MO=0;	
 IF NET_SALES_AMT_12MO_SLS NE 0 THEN 	
 	DISCOUNT_PCT_12MO=-DISCOUNT_AMT_12MO_SLS/(NET_SALES_AMT_12MO_SLS-DISCOUNT_AMT_12MO_SLS) * 100;
	
 IF NET_SALES_AMT_6MO_SLS NE 0 THEN 	
 	DISCOUNT_PCT_6MO=-DISCOUNT_AMT_6MO_SLS/(NET_SALES_AMT_6MO_SLS-DISCOUNT_AMT_6MO_SLS) * 100;
	
 PLCC_TXN_PCT_12MO=0;	
 IF NUM_TXNS_12MO_SLS NE 0 THEN	
 	 PLCC_TXN_PCT_12MO=num_txns_plcc_12mo_sls/NUM_TXNS_12MO_SLS * 100;
	
 PLCC_TXN_PCT_6MO=0;	
 IF NUM_TXNS_6MO_SLS NE 0 THEN	
 	 PLCC_TXN_PCT_6MO=num_txns_plcc_6MO_sls/NUM_TXNS_6MO_SLS * 100;
	
 AVG_UNT_RTL_12MO=0;	
 IF ITEM_QTY_12MO_SLS NE 0 THEN 	
 AVG_UNT_RTL_12MO=NET_SALES_AMT_12MO_SLS/ITEM_QTY_12MO_SLS;	
	
 AVG_UNT_RTL_6MO=0;	
 IF ITEM_QTY_6MO_SLS NE 0 THEN 	
 AVG_UNT_RTL_6MO=NET_SALES_AMT_6MO_SLS/ITEM_QTY_6MO_SLS;	
	
 AVG_UNT_RTL_CP_12MO=0;	
 IF ITEM_QTY_12MO_SLS_CP NE 0 THEN 	
 AVG_UNT_RTL_CP_12MO=NET_SALES_AMT_12MO_SLS_CP/ITEM_QTY_12MO_SLS_CP;	
	
 AVG_UNT_RTL_CP_6MO=0;	
 IF ITEM_QTY_6MO_SLS_CP NE 0 THEN 	
 AVG_UNT_RTL_CP_6MO=NET_SALES_AMT_6MO_SLS_CP/ITEM_QTY_6MO_SLS_CP;	
	
 RATIO_NET_RTN_NET_SLS_12MO=0;	
 IF NET_SALES_AMT_12MO_SLS NE 0 THEN	
 RATIO_NET_RTN_NET_SLS_12MO=NET_SALES_AMT_12MO_RTN/NET_SALES_AMT_12MO_SLS;	
	
 RATIO_NET_RTN_NET_SLS_6MO=0;	
 IF NET_SALES_AMT_6MO_SLS NE 0 THEN	
 RATIO_NET_RTN_NET_SLS_6MO=NET_SALES_AMT_6MO_RTN/NET_SALES_AMT_6MO_SLS;	
	
 YEARS_ON_BOOKS=DAYS_ON_BOOKS_CP/365;	
	
 OFFSET=LOG((&PROP_NONRESPONDERS * &PROP_RESPONDERS_BAL)/(&PROP_RESPONDERS * &PROP_NONRESPONDERS_BAL));	
 		
RUN;


DATA DATALIB.&BRAND._EM_ALLCAMPAIGNS_PCTL_ONL;
SET DATALIB.&BRAND._EM_ALLCAMPAIGNS_PCTL_ONL;

CALL SYMPUT ("AVG_ORD_SZ_12MO_LC", AVG_ORD_SZ_12MO_0_5);
CALL SYMPUT ("AVG_ORD_SZ_12MO_CP_LC", AVG_ORD_SZ_12MO_CP_0_5);
CALL SYMPUT ("AVG_ORD_SZ_6MO_LC", AVG_ORD_SZ_6MO_0_5);
CALL SYMPUT ("AVG_ORD_SZ_6MO_CP_LC", AVG_ORD_SZ_6MO_CP_0_5);
CALL SYMPUT ("AVG_UNT_RTL_12MO_LC", AVG_UNT_RTL_12MO_0_5);
CALL SYMPUT ("AVG_UNT_RTL_6MO_LC", AVG_UNT_RTL_6MO_0_5);
CALL SYMPUT ("AVG_UNT_RTL_CP_12MO_LC", AVG_UNT_RTL_CP_12MO_0_5);
CALL SYMPUT ("AVG_UNT_RTL_CP_6MO_LC", AVG_UNT_RTL_CP_6MO_0_5);
CALL SYMPUT ("days_last_pur_LC", days_last_pur_0_5);
CALL SYMPUT ("days_last_pur_cp_LC", days_last_pur_cp_0_5);
CALL SYMPUT ("days_on_books_LC", days_on_books_0_5);
CALL SYMPUT ("days_on_books_cp_LC", days_on_books_cp_0_5);
CALL SYMPUT ("discount_amt_12mo_sls_LC", discount_amt_12mo_sls_0_5);
CALL SYMPUT ("discount_amt_6mo_sls_LC", discount_amt_6mo_sls_0_5);
CALL SYMPUT ("DISCOUNT_PCT_12MO_LC", DISCOUNT_PCT_12MO_0_5);
CALL SYMPUT ("DISCOUNT_PCT_6MO_LC", DISCOUNT_PCT_6MO_0_5);
CALL SYMPUT ("div_shp_LC", div_shp_0_5);
CALL SYMPUT ("div_shp_cp_LC", div_shp_cp_0_5);
CALL SYMPUT ("emails_clicked_LC", emails_clicked_0_5);
CALL SYMPUT ("emails_clicked_cp_LC", emails_clicked_cp_0_5);
CALL SYMPUT ("emails_opened_LC", emails_opened_0_5);
CALL SYMPUT ("emails_opened_cp_LC", emails_opened_cp_0_5);
CALL SYMPUT ("item_qty_12mo_rtn_LC", item_qty_12mo_rtn_0_5);
CALL SYMPUT ("item_qty_12mo_rtn_cp_LC", item_qty_12mo_rtn_cp_0_5);
CALL SYMPUT ("item_qty_12mo_sls_LC", item_qty_12mo_sls_0_5);
CALL SYMPUT ("item_qty_12mo_sls_cp_LC", item_qty_12mo_sls_cp_0_5);
CALL SYMPUT ("item_qty_6mo_rtn_LC", item_qty_6mo_rtn_0_5);
CALL SYMPUT ("item_qty_6mo_rtn_cp_LC", item_qty_6mo_rtn_cp_0_5);
CALL SYMPUT ("item_qty_6mo_sls_LC", item_qty_6mo_sls_0_5);
CALL SYMPUT ("item_qty_6mo_sls_cp_LC", item_qty_6mo_sls_cp_0_5);
CALL SYMPUT ("item_qty_onsale_12mo_sls_LC", item_qty_onsale_12mo_sls_0_5);
CALL SYMPUT ("item_qty_onsale_12mo_sls_cp_LC", item_qty_onsale_12mo_sls_cp_0_5);
CALL SYMPUT ("item_qty_onsale_6mo_sls_LC", item_qty_onsale_6mo_sls_0_5);
CALL SYMPUT ("item_qty_onsale_6mo_sls_cp_LC", item_qty_onsale_6mo_sls_cp_0_5);
CALL SYMPUT ("net_margin_12mo_sls_LC", net_margin_12mo_sls_0_5);
CALL SYMPUT ("net_margin_6mo_sls_LC", net_margin_6mo_sls_0_5);
CALL SYMPUT ("netsales_12mo_rtn_LC", netsales_12mo_rtn_0_5);
CALL SYMPUT ("netsales_12mo_rtn_cp_LC", netsales_12mo_rtn_cp_0_5);
CALL SYMPUT ("netsales_12mo_sls_LC", netsales_12mo_sls_0_5);
CALL SYMPUT ("netsales_12mo_sls_cp_LC", netsales_12mo_sls_cp_0_5);
CALL SYMPUT ("netsales_6mo_rtn_LC", netsales_6mo_rtn_0_5);
CALL SYMPUT ("netsales_6mo_rtn_cp_LC", netsales_6mo_rtn_cp_0_5);
CALL SYMPUT ("netsales_6mo_sls_LC", netsales_6mo_sls_0_5);
CALL SYMPUT ("netsales_6mo_sls_cp_LC", netsales_6mo_sls_cp_0_5);
CALL SYMPUT ("netsales_plcc_12mo_sls_LC", netsales_plcc_12mo_sls_0_5);
CALL SYMPUT ("netsales_plcc_12mo_sls_cp_LC", netsales_plcc_12mo_sls_cp_0_5);
CALL SYMPUT ("netsales_plcc_6mo_sls_LC", netsales_plcc_6mo_sls_0_5);
CALL SYMPUT ("netsales_plcc_6mo_sls_cp_LC", netsales_plcc_6mo_sls_cp_0_5);
CALL SYMPUT ("num_txns_12mo_rtn_LC", num_txns_12mo_rtn_0_5);
CALL SYMPUT ("num_txns_12mo_rtn_cp_LC", num_txns_12mo_rtn_cp_0_5);
CALL SYMPUT ("num_txns_12mo_sls_LC", num_txns_12mo_sls_0_5);
CALL SYMPUT ("num_txns_12mo_sls_cp_LC", num_txns_12mo_sls_cp_0_5);
CALL SYMPUT ("num_txns_6mo_rtn_LC", num_txns_6mo_rtn_0_5);
CALL SYMPUT ("num_txns_6mo_rtn_cp_LC", num_txns_6mo_rtn_cp_0_5);
CALL SYMPUT ("num_txns_6mo_sls_LC", num_txns_6mo_sls_0_5);
CALL SYMPUT ("num_txns_6mo_sls_cp_LC", num_txns_6mo_sls_cp_0_5);
CALL SYMPUT ("num_txns_plcc_12mo_sls_LC", num_txns_plcc_12mo_sls_0_5);
CALL SYMPUT ("num_txns_plcc_12mo_sls_cp_LC", num_txns_plcc_12mo_sls_cp_0_5);
CALL SYMPUT ("num_txns_plcc_6mo_sls_LC", num_txns_plcc_6mo_sls_0_5);
CALL SYMPUT ("num_txns_plcc_6mo_sls_cp_LC", num_txns_plcc_6mo_sls_cp_0_5);
CALL SYMPUT ("PLCC_TXN_PCT_12MO_LC", PLCC_TXN_PCT_12MO_0_5);
CALL SYMPUT ("PLCC_TXN_PCT_6MO_LC", PLCC_TXN_PCT_6MO_0_5);
CALL SYMPUT ("RATIO_NET_RTN_NET_SLS_12MO_LC", RATIO_NET_RTN_NET_SLS_12MO_0_5);
CALL SYMPUT ("RATIO_NET_RTN_NET_SLS_6MO_LC", RATIO_NET_RTN_NET_SLS_6MO_0_5);
CALL SYMPUT ("UNITS_PER_TXN_12MO_SLS_LC", UNITS_PER_TXN_12MO_SLS_0_5);
CALL SYMPUT ("UNITS_PER_TXN_6MO_SLS_LC", UNITS_PER_TXN_6MO_SLS_0_5);
CALL SYMPUT ("YEARS_ON_BOOKS_LC", YEARS_ON_BOOKS_0_5);

CALL SYMPUT ("AVG_ORD_SZ_12MO_50", AVG_ORD_SZ_12MO_50);
CALL SYMPUT ("AVG_ORD_SZ_12MO_CP_50", AVG_ORD_SZ_12MO_CP_50);
CALL SYMPUT ("AVG_ORD_SZ_6MO_50", AVG_ORD_SZ_6MO_50);
CALL SYMPUT ("AVG_ORD_SZ_6MO_CP_50", AVG_ORD_SZ_6MO_CP_50);
CALL SYMPUT ("AVG_UNT_RTL_12MO_50", AVG_UNT_RTL_12MO_50);
CALL SYMPUT ("AVG_UNT_RTL_6MO_50", AVG_UNT_RTL_6MO_50);
CALL SYMPUT ("AVG_UNT_RTL_CP_12MO_50", AVG_UNT_RTL_CP_12MO_50);
CALL SYMPUT ("AVG_UNT_RTL_CP_6MO_50", AVG_UNT_RTL_CP_6MO_50);
CALL SYMPUT ("days_last_pur_50", days_last_pur_50);
CALL SYMPUT ("days_last_pur_cp_50", days_last_pur_cp_50);
CALL SYMPUT ("days_on_books_50", days_on_books_50);
CALL SYMPUT ("days_on_books_cp_50", days_on_books_cp_50);
CALL SYMPUT ("discount_amt_12mo_sls_50", discount_amt_12mo_sls_50);
CALL SYMPUT ("discount_amt_6mo_sls_50", discount_amt_6mo_sls_50);
CALL SYMPUT ("DISCOUNT_PCT_12MO_50", DISCOUNT_PCT_12MO_50);
CALL SYMPUT ("DISCOUNT_PCT_6MO_50", DISCOUNT_PCT_6MO_50);
CALL SYMPUT ("div_shp_50", div_shp_50);
CALL SYMPUT ("div_shp_cp_50", div_shp_cp_50);
CALL SYMPUT ("emails_clicked_50", emails_clicked_50);
CALL SYMPUT ("emails_clicked_cp_50", emails_clicked_cp_50);
CALL SYMPUT ("emails_opened_50", emails_opened_50);
CALL SYMPUT ("emails_opened_cp_50", emails_opened_cp_50);
CALL SYMPUT ("item_qty_12mo_rtn_50", item_qty_12mo_rtn_50);
CALL SYMPUT ("item_qty_12mo_rtn_cp_50", item_qty_12mo_rtn_cp_50);
CALL SYMPUT ("item_qty_12mo_sls_50", item_qty_12mo_sls_50);
CALL SYMPUT ("item_qty_12mo_sls_cp_50", item_qty_12mo_sls_cp_50);
CALL SYMPUT ("item_qty_6mo_rtn_50", item_qty_6mo_rtn_50);
CALL SYMPUT ("item_qty_6mo_rtn_cp_50", item_qty_6mo_rtn_cp_50);
CALL SYMPUT ("item_qty_6mo_sls_50", item_qty_6mo_sls_50);
CALL SYMPUT ("item_qty_6mo_sls_cp_50", item_qty_6mo_sls_cp_50);
CALL SYMPUT ("item_qty_onsale_12mo_sls_50", item_qty_onsale_12mo_sls_50);
CALL SYMPUT ("item_qty_onsale_12mo_sls_cp_50", item_qty_onsale_12mo_sls_cp_50);
CALL SYMPUT ("item_qty_onsale_6mo_sls_50", item_qty_onsale_6mo_sls_50);
CALL SYMPUT ("item_qty_onsale_6mo_sls_cp_50", item_qty_onsale_6mo_sls_cp_50);
CALL SYMPUT ("net_margin_12mo_sls_50", net_margin_12mo_sls_50);
CALL SYMPUT ("net_margin_6mo_sls_50", net_margin_6mo_sls_50);
CALL SYMPUT ("netsales_12mo_rtn_50", netsales_12mo_rtn_50);
CALL SYMPUT ("netsales_12mo_rtn_cp_50", netsales_12mo_rtn_cp_50);
CALL SYMPUT ("netsales_12mo_sls_50", netsales_12mo_sls_50);
CALL SYMPUT ("netsales_12mo_sls_cp_50", netsales_12mo_sls_cp_50);
CALL SYMPUT ("netsales_6mo_rtn_50", netsales_6mo_rtn_50);
CALL SYMPUT ("netsales_6mo_rtn_cp_50", netsales_6mo_rtn_cp_50);
CALL SYMPUT ("netsales_6mo_sls_50", netsales_6mo_sls_50);
CALL SYMPUT ("netsales_6mo_sls_cp_50", netsales_6mo_sls_cp_50);
CALL SYMPUT ("netsales_plcc_12mo_sls_50", netsales_plcc_12mo_sls_50);
CALL SYMPUT ("netsales_plcc_12mo_sls_cp_50", netsales_plcc_12mo_sls_cp_50);
CALL SYMPUT ("netsales_plcc_6mo_sls_50", netsales_plcc_6mo_sls_50);
CALL SYMPUT ("netsales_plcc_6mo_sls_cp_50", netsales_plcc_6mo_sls_cp_50);
CALL SYMPUT ("num_txns_12mo_rtn_50", num_txns_12mo_rtn_50);
CALL SYMPUT ("num_txns_12mo_rtn_cp_50", num_txns_12mo_rtn_cp_50);
CALL SYMPUT ("num_txns_12mo_sls_50", num_txns_12mo_sls_50);
CALL SYMPUT ("num_txns_12mo_sls_cp_50", num_txns_12mo_sls_cp_50);
CALL SYMPUT ("num_txns_6mo_rtn_50", num_txns_6mo_rtn_50);
CALL SYMPUT ("num_txns_6mo_rtn_cp_50", num_txns_6mo_rtn_cp_50);
CALL SYMPUT ("num_txns_6mo_sls_50", num_txns_6mo_sls_50);
CALL SYMPUT ("num_txns_6mo_sls_cp_50", num_txns_6mo_sls_cp_50);
CALL SYMPUT ("num_txns_plcc_12mo_sls_50", num_txns_plcc_12mo_sls_50);
CALL SYMPUT ("num_txns_plcc_12mo_sls_cp_50", num_txns_plcc_12mo_sls_cp_50);
CALL SYMPUT ("num_txns_plcc_6mo_sls_50", num_txns_plcc_6mo_sls_50);
CALL SYMPUT ("num_txns_plcc_6mo_sls_cp_50", num_txns_plcc_6mo_sls_cp_50);
CALL SYMPUT ("PLCC_TXN_PCT_12MO_50", PLCC_TXN_PCT_12MO_50);
CALL SYMPUT ("PLCC_TXN_PCT_6MO_50", PLCC_TXN_PCT_6MO_50);
CALL SYMPUT ("RATIO_NET_RTN_NET_SLS_12MO_50", RATIO_NET_RTN_NET_SLS_12MO_50);
CALL SYMPUT ("RATIO_NET_RTN_NET_SLS_6MO_50", RATIO_NET_RTN_NET_SLS_6MO_50);
CALL SYMPUT ("UNITS_PER_TXN_12MO_SLS_50", UNITS_PER_TXN_12MO_SLS_50);
CALL SYMPUT ("UNITS_PER_TXN_6MO_SLS_50", UNITS_PER_TXN_6MO_SLS_50);
CALL SYMPUT ("YEARS_ON_BOOKS_50", YEARS_ON_BOOKS_50);

CALL SYMPUT ("AVG_ORD_SZ_12MO_UC", AVG_ORD_SZ_12MO_99_5);
CALL SYMPUT ("AVG_ORD_SZ_12MO_CP_UC", AVG_ORD_SZ_12MO_CP_99_5);
CALL SYMPUT ("AVG_ORD_SZ_6MO_UC", AVG_ORD_SZ_6MO_99_5);
CALL SYMPUT ("AVG_ORD_SZ_6MO_CP_UC", AVG_ORD_SZ_6MO_CP_99_5);
CALL SYMPUT ("AVG_UNT_RTL_12MO_UC", AVG_UNT_RTL_12MO_99_5);
CALL SYMPUT ("AVG_UNT_RTL_6MO_UC", AVG_UNT_RTL_6MO_99_5);
CALL SYMPUT ("AVG_UNT_RTL_CP_12MO_UC", AVG_UNT_RTL_CP_12MO_99_5);
CALL SYMPUT ("AVG_UNT_RTL_CP_6MO_UC", AVG_UNT_RTL_CP_6MO_99_5);
CALL SYMPUT ("days_last_pur_UC", days_last_pur_99_5);
CALL SYMPUT ("days_last_pur_cp_UC", days_last_pur_cp_99_5);
CALL SYMPUT ("days_on_books_UC", days_on_books_99_5);
CALL SYMPUT ("days_on_books_cp_UC", days_on_books_cp_99_5);
CALL SYMPUT ("discount_amt_12mo_sls_UC", discount_amt_12mo_sls_99_5);
CALL SYMPUT ("discount_amt_6mo_sls_UC", discount_amt_6mo_sls_99_5);
CALL SYMPUT ("DISCOUNT_PCT_12MO_UC", DISCOUNT_PCT_12MO_99_5);
CALL SYMPUT ("DISCOUNT_PCT_6MO_UC", DISCOUNT_PCT_6MO_99_5);
CALL SYMPUT ("div_shp_UC", div_shp_99_5);
CALL SYMPUT ("div_shp_cp_UC", div_shp_cp_99_5);
CALL SYMPUT ("emails_clicked_UC", emails_clicked_99_5);
CALL SYMPUT ("emails_clicked_cp_UC", emails_clicked_cp_99_5);
CALL SYMPUT ("emails_opened_UC", emails_opened_99_5);
CALL SYMPUT ("emails_opened_cp_UC", emails_opened_cp_99_5);
CALL SYMPUT ("item_qty_12mo_rtn_UC", item_qty_12mo_rtn_99_5);
CALL SYMPUT ("item_qty_12mo_rtn_cp_UC", item_qty_12mo_rtn_cp_99_5);
CALL SYMPUT ("item_qty_12mo_sls_UC", item_qty_12mo_sls_99_5);
CALL SYMPUT ("item_qty_12mo_sls_cp_UC", item_qty_12mo_sls_cp_99_5);
CALL SYMPUT ("item_qty_6mo_rtn_UC", item_qty_6mo_rtn_99_5);
CALL SYMPUT ("item_qty_6mo_rtn_cp_UC", item_qty_6mo_rtn_cp_99_5);
CALL SYMPUT ("item_qty_6mo_sls_UC", item_qty_6mo_sls_99_5);
CALL SYMPUT ("item_qty_6mo_sls_cp_UC", item_qty_6mo_sls_cp_99_5);
CALL SYMPUT ("item_qty_onsale_12mo_sls_UC", item_qty_onsale_12mo_sls_99_5);
CALL SYMPUT ("item_qty_onsale_12mo_sls_cp_UC", item_qty_onsale_12mo_sls_cp_99_5);
CALL SYMPUT ("item_qty_onsale_6mo_sls_UC", item_qty_onsale_6mo_sls_99_5);
CALL SYMPUT ("item_qty_onsale_6mo_sls_cp_UC", item_qty_onsale_6mo_sls_cp_99_5);
CALL SYMPUT ("net_margin_12mo_sls_UC", net_margin_12mo_sls_99_5);
CALL SYMPUT ("net_margin_6mo_sls_UC", net_margin_6mo_sls_99_5);
CALL SYMPUT ("netsales_12mo_rtn_UC", netsales_12mo_rtn_99_5);
CALL SYMPUT ("netsales_12mo_rtn_cp_UC", netsales_12mo_rtn_cp_99_5);
CALL SYMPUT ("netsales_12mo_sls_UC", netsales_12mo_sls_99_5);
CALL SYMPUT ("netsales_12mo_sls_cp_UC", netsales_12mo_sls_cp_99_5);
CALL SYMPUT ("netsales_6mo_rtn_UC", netsales_6mo_rtn_99_5);
CALL SYMPUT ("netsales_6mo_rtn_cp_UC", netsales_6mo_rtn_cp_99_5);
CALL SYMPUT ("netsales_6mo_sls_UC", netsales_6mo_sls_99_5);
CALL SYMPUT ("netsales_6mo_sls_cp_UC", netsales_6mo_sls_cp_99_5);
CALL SYMPUT ("netsales_plcc_12mo_sls_UC", netsales_plcc_12mo_sls_99_5);
CALL SYMPUT ("netsales_plcc_12mo_sls_cp_UC", netsales_plcc_12mo_sls_cp_99_5);
CALL SYMPUT ("netsales_plcc_6mo_sls_UC", netsales_plcc_6mo_sls_99_5);
CALL SYMPUT ("netsales_plcc_6mo_sls_cp_UC", netsales_plcc_6mo_sls_cp_99_5);
CALL SYMPUT ("num_txns_12mo_rtn_UC", num_txns_12mo_rtn_99_5);
CALL SYMPUT ("num_txns_12mo_rtn_cp_UC", num_txns_12mo_rtn_cp_99_5);
CALL SYMPUT ("num_txns_12mo_sls_UC", num_txns_12mo_sls_99_5);
CALL SYMPUT ("num_txns_12mo_sls_cp_UC", num_txns_12mo_sls_cp_99_5);
CALL SYMPUT ("num_txns_6mo_rtn_UC", num_txns_6mo_rtn_99_5);
CALL SYMPUT ("num_txns_6mo_rtn_cp_UC", num_txns_6mo_rtn_cp_99_5);
CALL SYMPUT ("num_txns_6mo_sls_UC", num_txns_6mo_sls_99_5);
CALL SYMPUT ("num_txns_6mo_sls_cp_UC", num_txns_6mo_sls_cp_99_5);
CALL SYMPUT ("num_txns_plcc_12mo_sls_UC", num_txns_plcc_12mo_sls_99_5);
CALL SYMPUT ("num_txns_plcc_12mo_sls_cp_UC", num_txns_plcc_12mo_sls_cp_99_5);
CALL SYMPUT ("num_txns_plcc_6mo_sls_UC", num_txns_plcc_6mo_sls_99_5);
CALL SYMPUT ("num_txns_plcc_6mo_sls_cp_UC", num_txns_plcc_6mo_sls_cp_99_5);
CALL SYMPUT ("PLCC_TXN_PCT_12MO_UC", PLCC_TXN_PCT_12MO_99_5);
CALL SYMPUT ("PLCC_TXN_PCT_6MO_UC", PLCC_TXN_PCT_6MO_99_5);
CALL SYMPUT ("RATIO_NET_RTN_NET_SLS_12MO_UC", RATIO_NET_RTN_NET_SLS_12MO_99_5);
CALL SYMPUT ("RATIO_NET_RTN_NET_SLS_6MO_UC", RATIO_NET_RTN_NET_SLS_6MO_99_5);
CALL SYMPUT ("UNITS_PER_TXN_12MO_SLS_UC", UNITS_PER_TXN_12MO_SLS_99_5);
CALL SYMPUT ("UNITS_PER_TXN_6MO_SLS_UC", UNITS_PER_TXN_6MO_SLS_99_5);
CALL SYMPUT ("YEARS_ON_BOOKS_UC", YEARS_ON_BOOKS_99_5);

RUN;


%PUT &AVG_ORD_SZ_12MO_LC;  %PUT &AVG_ORD_SZ_12MO_50;  %PUT &AVG_ORD_SZ_12MO_UC;
%PUT &AVG_ORD_SZ_12MO_CP_LC;  %PUT &AVG_ORD_SZ_12MO_CP_50;  %PUT &AVG_ORD_SZ_12MO_CP_UC;
%PUT &AVG_ORD_SZ_6MO_LC;  %PUT &AVG_ORD_SZ_6MO_50;  %PUT &AVG_ORD_SZ_6MO_UC;
%PUT &AVG_ORD_SZ_6MO_CP_LC;  %PUT &AVG_ORD_SZ_6MO_CP_50;  %PUT &AVG_ORD_SZ_6MO_CP_UC;
%PUT &AVG_UNT_RTL_12MO_LC;  %PUT &AVG_UNT_RTL_12MO_50;  %PUT &AVG_UNT_RTL_12MO_UC;
%PUT &AVG_UNT_RTL_6MO_LC;  %PUT &AVG_UNT_RTL_6MO_50;  %PUT &AVG_UNT_RTL_6MO_UC;
%PUT &AVG_UNT_RTL_CP_12MO_LC;  %PUT &AVG_UNT_RTL_CP_12MO_50;  %PUT &AVG_UNT_RTL_CP_12MO_UC;
%PUT &AVG_UNT_RTL_CP_6MO_LC;  %PUT &AVG_UNT_RTL_CP_6MO_50;  %PUT &AVG_UNT_RTL_CP_6MO_UC;
%PUT &days_last_pur_LC;  %PUT &days_last_pur_50;  %PUT &days_last_pur_UC;
%PUT &days_last_pur_cp_LC;  %PUT &days_last_pur_cp_50;  %PUT &days_last_pur_cp_UC;
%PUT &days_on_books_LC;  %PUT &days_on_books_50;  %PUT &days_on_books_UC;
%PUT &days_on_books_cp_LC;  %PUT &days_on_books_cp_50;  %PUT &days_on_books_cp_UC;
%PUT &discount_amt_12mo_sls_LC;  %PUT &discount_amt_12mo_sls_50;  %PUT &discount_amt_12mo_sls_UC;
%PUT &discount_amt_6mo_sls_LC;  %PUT &discount_amt_6mo_sls_50;  %PUT &discount_amt_6mo_sls_UC;
%PUT &DISCOUNT_PCT_12MO_LC;  %PUT &DISCOUNT_PCT_12MO_50;  %PUT &DISCOUNT_PCT_12MO_UC;
%PUT &DISCOUNT_PCT_6MO_LC;  %PUT &DISCOUNT_PCT_6MO_50;  %PUT &DISCOUNT_PCT_6MO_UC;
%PUT &div_shp_LC;  %PUT &div_shp_50;  %PUT &div_shp_UC;
%PUT &div_shp_cp_LC;  %PUT &div_shp_cp_50;  %PUT &div_shp_cp_UC;
%PUT &emails_clicked_LC;  %PUT &emails_clicked_50;  %PUT &emails_clicked_UC;
%PUT &emails_clicked_cp_LC;  %PUT &emails_clicked_cp_50;  %PUT &emails_clicked_cp_UC;
%PUT &emails_opened_LC;  %PUT &emails_opened_50;  %PUT &emails_opened_UC;
%PUT &emails_opened_cp_LC;  %PUT &emails_opened_cp_50;  %PUT &emails_opened_cp_UC;
%PUT &item_qty_12mo_rtn_LC;  %PUT &item_qty_12mo_rtn_50;  %PUT &item_qty_12mo_rtn_UC;
%PUT &item_qty_12mo_rtn_cp_LC;  %PUT &item_qty_12mo_rtn_cp_50;  %PUT &item_qty_12mo_rtn_cp_UC;
%PUT &item_qty_12mo_sls_LC;  %PUT &item_qty_12mo_sls_50;  %PUT &item_qty_12mo_sls_UC;
%PUT &item_qty_12mo_sls_cp_LC;  %PUT &item_qty_12mo_sls_cp_50;  %PUT &item_qty_12mo_sls_cp_UC;
%PUT &item_qty_6mo_rtn_LC;  %PUT &item_qty_6mo_rtn_50;  %PUT &item_qty_6mo_rtn_UC;
%PUT &item_qty_6mo_rtn_cp_LC;  %PUT &item_qty_6mo_rtn_cp_50;  %PUT &item_qty_6mo_rtn_cp_UC;
%PUT &item_qty_6mo_sls_LC;  %PUT &item_qty_6mo_sls_50;  %PUT &item_qty_6mo_sls_UC;
%PUT &item_qty_6mo_sls_cp_LC;  %PUT &item_qty_6mo_sls_cp_50;  %PUT &item_qty_6mo_sls_cp_UC;
%PUT &item_qty_onsale_12mo_sls_LC;  %PUT &item_qty_onsale_12mo_sls_50;  %PUT &item_qty_onsale_12mo_sls_UC;
%PUT &item_qty_onsale_12mo_sls_cp_LC;  %PUT &item_qty_onsale_12mo_sls_cp_50;  %PUT &item_qty_onsale_12mo_sls_cp_UC;
%PUT &item_qty_onsale_6mo_sls_LC;  %PUT &item_qty_onsale_6mo_sls_50;  %PUT &item_qty_onsale_6mo_sls_UC;
%PUT &item_qty_onsale_6mo_sls_cp_LC;  %PUT &item_qty_onsale_6mo_sls_cp_50;  %PUT &item_qty_onsale_6mo_sls_cp_UC;
%PUT &net_margin_12mo_sls_LC;  %PUT &net_margin_12mo_sls_50;  %PUT &net_margin_12mo_sls_UC;
%PUT &net_margin_6mo_sls_LC;  %PUT &net_margin_6mo_sls_50;  %PUT &net_margin_6mo_sls_UC;
%PUT &netsales_12mo_rtn_LC;  %PUT &netsales_12mo_rtn_50;  %PUT &netsales_12mo_rtn_UC;
%PUT &netsales_12mo_rtn_cp_LC;  %PUT &netsales_12mo_rtn_cp_50;  %PUT &netsales_12mo_rtn_cp_UC;
%PUT &netsales_12mo_sls_LC;  %PUT &netsales_12mo_sls_50;  %PUT &netsales_12mo_sls_UC;
%PUT &netsales_12mo_sls_cp_LC;  %PUT &netsales_12mo_sls_cp_50;  %PUT &netsales_12mo_sls_cp_UC;
%PUT &netsales_6mo_rtn_LC;  %PUT &netsales_6mo_rtn_50;  %PUT &netsales_6mo_rtn_UC;
%PUT &netsales_6mo_rtn_cp_LC;  %PUT &netsales_6mo_rtn_cp_50;  %PUT &netsales_6mo_rtn_cp_UC;
%PUT &netsales_6mo_sls_LC;  %PUT &netsales_6mo_sls_50;  %PUT &netsales_6mo_sls_UC;
%PUT &netsales_6mo_sls_cp_LC;  %PUT &netsales_6mo_sls_cp_50;  %PUT &netsales_6mo_sls_cp_UC;
%PUT &netsales_plcc_12mo_sls_LC;  %PUT &netsales_plcc_12mo_sls_50;  %PUT &netsales_plcc_12mo_sls_UC;
%PUT &netsales_plcc_12mo_sls_cp_LC;  %PUT &netsales_plcc_12mo_sls_cp_50;  %PUT &netsales_plcc_12mo_sls_cp_UC;
%PUT &netsales_plcc_6mo_sls_LC;  %PUT &netsales_plcc_6mo_sls_50;  %PUT &netsales_plcc_6mo_sls_UC;
%PUT &netsales_plcc_6mo_sls_cp_LC;  %PUT &netsales_plcc_6mo_sls_cp_50;  %PUT &netsales_plcc_6mo_sls_cp_UC;
%PUT &num_txns_12mo_rtn_LC;  %PUT &num_txns_12mo_rtn_50;  %PUT &num_txns_12mo_rtn_UC;
%PUT &num_txns_12mo_rtn_cp_LC;  %PUT &num_txns_12mo_rtn_cp_50;  %PUT &num_txns_12mo_rtn_cp_UC;
%PUT &num_txns_12mo_sls_LC;  %PUT &num_txns_12mo_sls_50;  %PUT &num_txns_12mo_sls_UC;
%PUT &num_txns_12mo_sls_cp_LC;  %PUT &num_txns_12mo_sls_cp_50;  %PUT &num_txns_12mo_sls_cp_UC;
%PUT &num_txns_6mo_rtn_LC;  %PUT &num_txns_6mo_rtn_50;  %PUT &num_txns_6mo_rtn_UC;
%PUT &num_txns_6mo_rtn_cp_LC;  %PUT &num_txns_6mo_rtn_cp_50;  %PUT &num_txns_6mo_rtn_cp_UC;
%PUT &num_txns_6mo_sls_LC;  %PUT &num_txns_6mo_sls_50;  %PUT &num_txns_6mo_sls_UC;
%PUT &num_txns_6mo_sls_cp_LC;  %PUT &num_txns_6mo_sls_cp_50;  %PUT &num_txns_6mo_sls_cp_UC;
%PUT &num_txns_plcc_12mo_sls_LC;  %PUT &num_txns_plcc_12mo_sls_50;  %PUT &num_txns_plcc_12mo_sls_UC;
%PUT &num_txns_plcc_12mo_sls_cp_LC;  %PUT &num_txns_plcc_12mo_sls_cp_50;  %PUT &num_txns_plcc_12mo_sls_cp_UC;
%PUT &num_txns_plcc_6mo_sls_LC;  %PUT &num_txns_plcc_6mo_sls_50;  %PUT &num_txns_plcc_6mo_sls_UC;
%PUT &num_txns_plcc_6mo_sls_cp_LC;  %PUT &num_txns_plcc_6mo_sls_cp_50;  %PUT &num_txns_plcc_6mo_sls_cp_UC;
%PUT &PLCC_TXN_PCT_12MO_LC;  %PUT &PLCC_TXN_PCT_12MO_50;  %PUT &PLCC_TXN_PCT_12MO_UC;
%PUT &PLCC_TXN_PCT_6MO_LC;  %PUT &PLCC_TXN_PCT_6MO_50;  %PUT &PLCC_TXN_PCT_6MO_UC;
%PUT &RATIO_NET_RTN_NET_SLS_12MO_LC;  %PUT &RATIO_NET_RTN_NET_SLS_12MO_50;  %PUT &RATIO_NET_RTN_NET_SLS_12MO_UC;
%PUT &RATIO_NET_RTN_NET_SLS_6MO_LC;  %PUT &RATIO_NET_RTN_NET_SLS_6MO_50;  %PUT &RATIO_NET_RTN_NET_SLS_6MO_UC;
%PUT &UNITS_PER_TXN_12MO_SLS_LC;  %PUT &UNITS_PER_TXN_12MO_SLS_50;  %PUT &UNITS_PER_TXN_12MO_SLS_UC;
%PUT &UNITS_PER_TXN_6MO_SLS_LC;  %PUT &UNITS_PER_TXN_6MO_SLS_50;  %PUT &UNITS_PER_TXN_6MO_SLS_UC;
%PUT &YEARS_ON_BOOKS_LC;  %PUT &YEARS_ON_BOOKS_50;  %PUT &YEARS_ON_BOOKS_UC;



DATA &BRAND._&SAMPLES._UNBALANCED_2_ONL;
SET DATALIB.&BRAND._&SAMPLES._combined_onl;

IF AVG_ORD_SZ_12MO GE &AVG_ORD_SZ_12MO_UC THEN AVG_ORD_SZ_12MO=&AVG_ORD_SZ_12MO_UC;
IF AVG_ORD_SZ_12MO_CP GE &AVG_ORD_SZ_12MO_CP_UC THEN AVG_ORD_SZ_12MO_CP=&AVG_ORD_SZ_12MO_CP_UC;
IF AVG_ORD_SZ_6MO GE &AVG_ORD_SZ_6MO_UC THEN AVG_ORD_SZ_6MO=&AVG_ORD_SZ_6MO_UC;
IF AVG_ORD_SZ_6MO_CP GE &AVG_ORD_SZ_6MO_CP_UC THEN AVG_ORD_SZ_6MO_CP=&AVG_ORD_SZ_6MO_CP_UC;
IF AVG_UNT_RTL_12MO GE &AVG_UNT_RTL_12MO_UC THEN AVG_UNT_RTL_12MO=&AVG_UNT_RTL_12MO_UC;
IF AVG_UNT_RTL_6MO GE &AVG_UNT_RTL_6MO_UC THEN AVG_UNT_RTL_6MO=&AVG_UNT_RTL_6MO_UC;
IF AVG_UNT_RTL_CP_12MO GE &AVG_UNT_RTL_CP_12MO_UC THEN AVG_UNT_RTL_CP_12MO=&AVG_UNT_RTL_CP_12MO_UC;
IF AVG_UNT_RTL_CP_6MO GE &AVG_UNT_RTL_CP_6MO_UC THEN AVG_UNT_RTL_CP_6MO=&AVG_UNT_RTL_CP_6MO_UC;
IF days_last_pur GE &days_last_pur_UC THEN days_last_pur=&days_last_pur_UC;
IF days_last_pur_cp GE &days_last_pur_cp_UC THEN days_last_pur_cp=&days_last_pur_cp_UC;
IF days_on_books GE &days_on_books_UC THEN days_on_books=&days_on_books_UC;
IF days_on_books_cp GE &days_on_books_cp_UC THEN days_on_books_cp=&days_on_books_cp_UC;
IF discount_amt_12mo_sls GE &discount_amt_12mo_sls_UC THEN discount_amt_12mo_sls=&discount_amt_12mo_sls_UC;
IF discount_amt_6mo_sls GE &discount_amt_6mo_sls_UC THEN discount_amt_6mo_sls=&discount_amt_6mo_sls_UC;
IF DISCOUNT_PCT_12MO GE &DISCOUNT_PCT_12MO_UC THEN DISCOUNT_PCT_12MO=&DISCOUNT_PCT_12MO_UC;
IF DISCOUNT_PCT_6MO GE &DISCOUNT_PCT_6MO_UC THEN DISCOUNT_PCT_6MO=&DISCOUNT_PCT_6MO_UC;
IF div_shp GE &div_shp_UC THEN div_shp=&div_shp_UC;
IF div_shp_cp GE &div_shp_cp_UC THEN div_shp_cp=&div_shp_cp_UC;
IF emails_clicked GE &emails_clicked_UC THEN emails_clicked=&emails_clicked_UC;
IF emails_clicked_cp GE &emails_clicked_cp_UC THEN emails_clicked_cp=&emails_clicked_cp_UC;
IF emails_opened GE &emails_opened_UC THEN emails_opened=&emails_opened_UC;
IF emails_opened_cp GE &emails_opened_cp_UC THEN emails_opened_cp=&emails_opened_cp_UC;
IF item_qty_12mo_rtn GE &item_qty_12mo_rtn_UC THEN item_qty_12mo_rtn=&item_qty_12mo_rtn_UC;
IF item_qty_12mo_rtn_cp GE &item_qty_12mo_rtn_cp_UC THEN item_qty_12mo_rtn_cp=&item_qty_12mo_rtn_cp_UC;
IF item_qty_12mo_sls GE &item_qty_12mo_sls_UC THEN item_qty_12mo_sls=&item_qty_12mo_sls_UC;
IF item_qty_12mo_sls_cp GE &item_qty_12mo_sls_cp_UC THEN item_qty_12mo_sls_cp=&item_qty_12mo_sls_cp_UC;
IF item_qty_6mo_rtn GE &item_qty_6mo_rtn_UC THEN item_qty_6mo_rtn=&item_qty_6mo_rtn_UC;
IF item_qty_6mo_rtn_cp GE &item_qty_6mo_rtn_cp_UC THEN item_qty_6mo_rtn_cp=&item_qty_6mo_rtn_cp_UC;
IF item_qty_6mo_sls GE &item_qty_6mo_sls_UC THEN item_qty_6mo_sls=&item_qty_6mo_sls_UC;
IF item_qty_6mo_sls_cp GE &item_qty_6mo_sls_cp_UC THEN item_qty_6mo_sls_cp=&item_qty_6mo_sls_cp_UC;
IF item_qty_onsale_12mo_sls GE &item_qty_onsale_12mo_sls_UC THEN item_qty_onsale_12mo_sls=&item_qty_onsale_12mo_sls_UC;
IF item_qty_onsale_12mo_sls_cp GE &item_qty_onsale_12mo_sls_cp_UC THEN item_qty_onsale_12mo_sls_cp=&item_qty_onsale_12mo_sls_cp_UC;
IF item_qty_onsale_6mo_sls GE &item_qty_onsale_6mo_sls_UC THEN item_qty_onsale_6mo_sls=&item_qty_onsale_6mo_sls_UC;
IF item_qty_onsale_6mo_sls_cp GE &item_qty_onsale_6mo_sls_cp_UC THEN item_qty_onsale_6mo_sls_cp=&item_qty_onsale_6mo_sls_cp_UC;
IF net_margin_12mo_sls GE &net_margin_12mo_sls_UC THEN net_margin_12mo_sls=&net_margin_12mo_sls_UC;
IF net_margin_6mo_sls GE &net_margin_6mo_sls_UC THEN net_margin_6mo_sls=&net_margin_6mo_sls_UC;
IF net_sales_amt_12mo_rtn GE &netsales_12mo_rtn_UC THEN net_sales_amt_12mo_rtn=&netsales_12mo_rtn_UC;
IF net_sales_amt_12mo_rtn_cp GE &netsales_12mo_rtn_cp_UC THEN net_sales_amt_12mo_rtn_cp=&netsales_12mo_rtn_cp_UC;
IF net_sales_amt_12mo_sls GE &netsales_12mo_sls_UC THEN net_sales_amt_12mo_sls=&netsales_12mo_sls_UC;
IF net_sales_amt_12mo_sls_cp GE &netsales_12mo_sls_cp_UC THEN net_sales_amt_12mo_sls_cp=&netsales_12mo_sls_cp_UC;
IF net_sales_amt_6mo_rtn GE &netsales_6mo_rtn_UC THEN net_sales_amt_6mo_rtn=&netsales_6mo_rtn_UC;
IF net_sales_amt_6mo_rtn_cp GE &netsales_6mo_rtn_cp_UC THEN net_sales_amt_6mo_rtn_cp=&netsales_6mo_rtn_cp_UC;
IF net_sales_amt_6mo_sls GE &netsales_6mo_sls_UC THEN net_sales_amt_6mo_sls=&netsales_6mo_sls_UC;
IF net_sales_amt_6mo_sls_cp GE &netsales_6mo_sls_cp_UC THEN net_sales_amt_6mo_sls_cp=&netsales_6mo_sls_cp_UC;
IF net_sales_amt_plcc_12mo_sls GE &netsales_plcc_12mo_sls_UC THEN net_sales_amt_plcc_12mo_sls=&netsales_plcc_12mo_sls_UC;
IF net_sales_amt_plcc_12mo_sls_cp GE &netsales_plcc_12mo_sls_cp_UC THEN net_sales_amt_plcc_12mo_sls_cp=&netsales_plcc_12mo_sls_cp_UC;
IF net_sales_amt_plcc_6mo_sls GE &netsales_plcc_6mo_sls_UC THEN net_sales_amt_plcc_6mo_sls=&netsales_plcc_6mo_sls_UC;
IF net_sales_amt_plcc_6mo_sls_cp GE &netsales_plcc_6mo_sls_cp_UC THEN net_sales_amt_plcc_6mo_sls_cp=&netsales_plcc_6mo_sls_cp_UC;
IF num_txns_12mo_rtn GE &num_txns_12mo_rtn_UC THEN num_txns_12mo_rtn=&num_txns_12mo_rtn_UC;
IF num_txns_12mo_rtn_cp GE &num_txns_12mo_rtn_cp_UC THEN num_txns_12mo_rtn_cp=&num_txns_12mo_rtn_cp_UC;
IF num_txns_12mo_sls GE &num_txns_12mo_sls_UC THEN num_txns_12mo_sls=&num_txns_12mo_sls_UC;
IF num_txns_12mo_sls_cp GE &num_txns_12mo_sls_cp_UC THEN num_txns_12mo_sls_cp=&num_txns_12mo_sls_cp_UC;
IF num_txns_6mo_rtn GE &num_txns_6mo_rtn_UC THEN num_txns_6mo_rtn=&num_txns_6mo_rtn_UC;
IF num_txns_6mo_rtn_cp GE &num_txns_6mo_rtn_cp_UC THEN num_txns_6mo_rtn_cp=&num_txns_6mo_rtn_cp_UC;
IF num_txns_6mo_sls GE &num_txns_6mo_sls_UC THEN num_txns_6mo_sls=&num_txns_6mo_sls_UC;
IF num_txns_6mo_sls_cp GE &num_txns_6mo_sls_cp_UC THEN num_txns_6mo_sls_cp=&num_txns_6mo_sls_cp_UC;
IF num_txns_plcc_12mo_sls GE &num_txns_plcc_12mo_sls_UC THEN num_txns_plcc_12mo_sls=&num_txns_plcc_12mo_sls_UC;
IF num_txns_plcc_12mo_sls_cp GE &num_txns_plcc_12mo_sls_cp_UC THEN num_txns_plcc_12mo_sls_cp=&num_txns_plcc_12mo_sls_cp_UC;
IF num_txns_plcc_6mo_sls GE &num_txns_plcc_6mo_sls_UC THEN num_txns_plcc_6mo_sls=&num_txns_plcc_6mo_sls_UC;
IF num_txns_plcc_6mo_sls_cp GE &num_txns_plcc_6mo_sls_cp_UC THEN num_txns_plcc_6mo_sls_cp=&num_txns_plcc_6mo_sls_cp_UC;
IF PLCC_TXN_PCT_12MO GE &PLCC_TXN_PCT_12MO_UC THEN PLCC_TXN_PCT_12MO=&PLCC_TXN_PCT_12MO_UC;
IF PLCC_TXN_PCT_6MO GE &PLCC_TXN_PCT_6MO_UC THEN PLCC_TXN_PCT_6MO=&PLCC_TXN_PCT_6MO_UC;
IF RATIO_NET_RTN_NET_SLS_12MO GE &RATIO_NET_RTN_NET_SLS_12MO_UC THEN RATIO_NET_RTN_NET_SLS_12MO=&RATIO_NET_RTN_NET_SLS_12MO_UC;
IF RATIO_NET_RTN_NET_SLS_6MO GE &RATIO_NET_RTN_NET_SLS_6MO_UC THEN RATIO_NET_RTN_NET_SLS_6MO=&RATIO_NET_RTN_NET_SLS_6MO_UC;
IF UNITS_PER_TXN_12MO_SLS GE &UNITS_PER_TXN_12MO_SLS_UC THEN UNITS_PER_TXN_12MO_SLS=&UNITS_PER_TXN_12MO_SLS_UC;
IF UNITS_PER_TXN_6MO_SLS GE &UNITS_PER_TXN_6MO_SLS_UC THEN UNITS_PER_TXN_6MO_SLS=&UNITS_PER_TXN_6MO_SLS_UC;
IF YEARS_ON_BOOKS GE &YEARS_ON_BOOKS_UC THEN YEARS_ON_BOOKS=&YEARS_ON_BOOKS_UC;

IF AVG_ORD_SZ_12MO LE &AVG_ORD_SZ_12MO_LC THEN AVG_ORD_SZ_12MO=&AVG_ORD_SZ_12MO_LC;
IF AVG_ORD_SZ_12MO_CP LE &AVG_ORD_SZ_12MO_CP_LC THEN AVG_ORD_SZ_12MO_CP=&AVG_ORD_SZ_12MO_CP_LC;
IF AVG_ORD_SZ_6MO LE &AVG_ORD_SZ_6MO_LC THEN AVG_ORD_SZ_6MO=&AVG_ORD_SZ_6MO_LC;
IF AVG_ORD_SZ_6MO_CP LE &AVG_ORD_SZ_6MO_CP_LC THEN AVG_ORD_SZ_6MO_CP=&AVG_ORD_SZ_6MO_CP_LC;
IF AVG_UNT_RTL_12MO LE &AVG_UNT_RTL_12MO_LC THEN AVG_UNT_RTL_12MO=&AVG_UNT_RTL_12MO_LC;
IF AVG_UNT_RTL_6MO LE &AVG_UNT_RTL_6MO_LC THEN AVG_UNT_RTL_6MO=&AVG_UNT_RTL_6MO_LC;
IF AVG_UNT_RTL_CP_12MO LE &AVG_UNT_RTL_CP_12MO_LC THEN AVG_UNT_RTL_CP_12MO=&AVG_UNT_RTL_CP_12MO_LC;
IF AVG_UNT_RTL_CP_6MO LE &AVG_UNT_RTL_CP_6MO_LC THEN AVG_UNT_RTL_CP_6MO=&AVG_UNT_RTL_CP_6MO_LC;
IF days_last_pur LE &days_last_pur_LC THEN days_last_pur=&days_last_pur_LC;
IF days_last_pur_cp LE &days_last_pur_cp_LC THEN days_last_pur_cp=&days_last_pur_cp_LC;
IF days_on_books LE &days_on_books_LC THEN days_on_books=&days_on_books_LC;
IF days_on_books_cp LE &days_on_books_cp_LC THEN days_on_books_cp=&days_on_books_cp_LC;
IF discount_amt_12mo_sls LE &discount_amt_12mo_sls_LC THEN discount_amt_12mo_sls=&discount_amt_12mo_sls_LC;
IF discount_amt_6mo_sls LE &discount_amt_6mo_sls_LC THEN discount_amt_6mo_sls=&discount_amt_6mo_sls_LC;
IF DISCOUNT_PCT_12MO LE &DISCOUNT_PCT_12MO_LC THEN DISCOUNT_PCT_12MO=&DISCOUNT_PCT_12MO_LC;
IF DISCOUNT_PCT_6MO LE &DISCOUNT_PCT_6MO_LC THEN DISCOUNT_PCT_6MO=&DISCOUNT_PCT_6MO_LC;
IF div_shp LE &div_shp_LC THEN div_shp=&div_shp_LC;
IF div_shp_cp LE &div_shp_cp_LC THEN div_shp_cp=&div_shp_cp_LC;
IF emails_clicked LE &emails_clicked_LC THEN emails_clicked=&emails_clicked_LC;
IF emails_clicked_cp LE &emails_clicked_cp_LC THEN emails_clicked_cp=&emails_clicked_cp_LC;
IF emails_opened LE &emails_opened_LC THEN emails_opened=&emails_opened_LC;
IF emails_opened_cp LE &emails_opened_cp_LC THEN emails_opened_cp=&emails_opened_cp_LC;
IF item_qty_12mo_rtn LE &item_qty_12mo_rtn_LC THEN item_qty_12mo_rtn=&item_qty_12mo_rtn_LC;
IF item_qty_12mo_rtn_cp LE &item_qty_12mo_rtn_cp_LC THEN item_qty_12mo_rtn_cp=&item_qty_12mo_rtn_cp_LC;
IF item_qty_12mo_sls LE &item_qty_12mo_sls_LC THEN item_qty_12mo_sls=&item_qty_12mo_sls_LC;
IF item_qty_12mo_sls_cp LE &item_qty_12mo_sls_cp_LC THEN item_qty_12mo_sls_cp=&item_qty_12mo_sls_cp_LC;
IF item_qty_6mo_rtn LE &item_qty_6mo_rtn_LC THEN item_qty_6mo_rtn=&item_qty_6mo_rtn_LC;
IF item_qty_6mo_rtn_cp LE &item_qty_6mo_rtn_cp_LC THEN item_qty_6mo_rtn_cp=&item_qty_6mo_rtn_cp_LC;
IF item_qty_6mo_sls LE &item_qty_6mo_sls_LC THEN item_qty_6mo_sls=&item_qty_6mo_sls_LC;
IF item_qty_6mo_sls_cp LE &item_qty_6mo_sls_cp_LC THEN item_qty_6mo_sls_cp=&item_qty_6mo_sls_cp_LC;
IF item_qty_onsale_12mo_sls LE &item_qty_onsale_12mo_sls_LC THEN item_qty_onsale_12mo_sls=&item_qty_onsale_12mo_sls_LC;
IF item_qty_onsale_12mo_sls_cp LE &item_qty_onsale_12mo_sls_cp_LC THEN item_qty_onsale_12mo_sls_cp=&item_qty_onsale_12mo_sls_cp_LC;
IF item_qty_onsale_6mo_sls LE &item_qty_onsale_6mo_sls_LC THEN item_qty_onsale_6mo_sls=&item_qty_onsale_6mo_sls_LC;
IF item_qty_onsale_6mo_sls_cp LE &item_qty_onsale_6mo_sls_cp_LC THEN item_qty_onsale_6mo_sls_cp=&item_qty_onsale_6mo_sls_cp_LC;
IF net_margin_12mo_sls LE &net_margin_12mo_sls_LC THEN net_margin_12mo_sls=&net_margin_12mo_sls_LC;
IF net_margin_6mo_sls LE &net_margin_6mo_sls_LC THEN net_margin_6mo_sls=&net_margin_6mo_sls_LC;
IF net_sales_amt_12mo_rtn LE &netsales_12mo_rtn_LC THEN net_sales_amt_12mo_rtn=&netsales_12mo_rtn_LC;
IF net_sales_amt_12mo_rtn_cp LE &netsales_12mo_rtn_cp_LC THEN net_sales_amt_12mo_rtn_cp=&netsales_12mo_rtn_cp_LC;
IF net_sales_amt_12mo_sls LE &netsales_12mo_sls_LC THEN net_sales_amt_12mo_sls=&netsales_12mo_sls_LC;
IF net_sales_amt_12mo_sls_cp LE &netsales_12mo_sls_cp_LC THEN net_sales_amt_12mo_sls_cp=&netsales_12mo_sls_cp_LC;
IF net_sales_amt_6mo_rtn LE &netsales_6mo_rtn_LC THEN net_sales_amt_6mo_rtn=&netsales_6mo_rtn_LC;
IF net_sales_amt_6mo_rtn_cp LE &netsales_6mo_rtn_cp_LC THEN net_sales_amt_6mo_rtn_cp=&netsales_6mo_rtn_cp_LC;
IF net_sales_amt_6mo_sls LE &netsales_6mo_sls_LC THEN net_sales_amt_6mo_sls=&netsales_6mo_sls_LC;
IF net_sales_amt_6mo_sls_cp LE &netsales_6mo_sls_cp_LC THEN net_sales_amt_6mo_sls_cp=&netsales_6mo_sls_cp_LC;
IF net_sales_amt_plcc_12mo_sls LE &netsales_plcc_12mo_sls_LC THEN net_sales_amt_plcc_12mo_sls=&netsales_plcc_12mo_sls_LC;
IF net_sales_amt_plcc_12mo_sls_cp LE &netsales_plcc_12mo_sls_cp_LC THEN net_sales_amt_plcc_12mo_sls_cp=&netsales_plcc_12mo_sls_cp_LC;
IF net_sales_amt_plcc_6mo_sls LE &netsales_plcc_6mo_sls_LC THEN net_sales_amt_plcc_6mo_sls=&netsales_plcc_6mo_sls_LC;
IF net_sales_amt_plcc_6mo_sls_cp LE &netsales_plcc_6mo_sls_cp_LC THEN net_sales_amt_plcc_6mo_sls_cp=&netsales_plcc_6mo_sls_cp_LC;
IF num_txns_12mo_rtn LE &num_txns_12mo_rtn_LC THEN num_txns_12mo_rtn=&num_txns_12mo_rtn_LC;
IF num_txns_12mo_rtn_cp LE &num_txns_12mo_rtn_cp_LC THEN num_txns_12mo_rtn_cp=&num_txns_12mo_rtn_cp_LC;
IF num_txns_12mo_sls LE &num_txns_12mo_sls_LC THEN num_txns_12mo_sls=&num_txns_12mo_sls_LC;
IF num_txns_12mo_sls_cp LE &num_txns_12mo_sls_cp_LC THEN num_txns_12mo_sls_cp=&num_txns_12mo_sls_cp_LC;
IF num_txns_6mo_rtn LE &num_txns_6mo_rtn_LC THEN num_txns_6mo_rtn=&num_txns_6mo_rtn_LC;
IF num_txns_6mo_rtn_cp LE &num_txns_6mo_rtn_cp_LC THEN num_txns_6mo_rtn_cp=&num_txns_6mo_rtn_cp_LC;
IF num_txns_6mo_sls LE &num_txns_6mo_sls_LC THEN num_txns_6mo_sls=&num_txns_6mo_sls_LC;
IF num_txns_6mo_sls_cp LE &num_txns_6mo_sls_cp_LC THEN num_txns_6mo_sls_cp=&num_txns_6mo_sls_cp_LC;
IF num_txns_plcc_12mo_sls LE &num_txns_plcc_12mo_sls_LC THEN num_txns_plcc_12mo_sls=&num_txns_plcc_12mo_sls_LC;
IF num_txns_plcc_12mo_sls_cp LE &num_txns_plcc_12mo_sls_cp_LC THEN num_txns_plcc_12mo_sls_cp=&num_txns_plcc_12mo_sls_cp_LC;
IF num_txns_plcc_6mo_sls LE &num_txns_plcc_6mo_sls_LC THEN num_txns_plcc_6mo_sls=&num_txns_plcc_6mo_sls_LC;
IF num_txns_plcc_6mo_sls_cp LE &num_txns_plcc_6mo_sls_cp_LC THEN num_txns_plcc_6mo_sls_cp=&num_txns_plcc_6mo_sls_cp_LC;
IF PLCC_TXN_PCT_12MO LE &PLCC_TXN_PCT_12MO_LC THEN PLCC_TXN_PCT_12MO=&PLCC_TXN_PCT_12MO_LC;
IF PLCC_TXN_PCT_6MO LE &PLCC_TXN_PCT_6MO_LC THEN PLCC_TXN_PCT_6MO=&PLCC_TXN_PCT_6MO_LC;
IF RATIO_NET_RTN_NET_SLS_12MO LE &RATIO_NET_RTN_NET_SLS_12MO_LC THEN RATIO_NET_RTN_NET_SLS_12MO=&RATIO_NET_RTN_NET_SLS_12MO_LC;
IF RATIO_NET_RTN_NET_SLS_6MO LE &RATIO_NET_RTN_NET_SLS_6MO_LC THEN RATIO_NET_RTN_NET_SLS_6MO=&RATIO_NET_RTN_NET_SLS_6MO_LC;
IF UNITS_PER_TXN_12MO_SLS LE &UNITS_PER_TXN_12MO_SLS_LC THEN UNITS_PER_TXN_12MO_SLS=&UNITS_PER_TXN_12MO_SLS_LC;
IF UNITS_PER_TXN_6MO_SLS LE &UNITS_PER_TXN_6MO_SLS_LC THEN UNITS_PER_TXN_6MO_SLS=&UNITS_PER_TXN_6MO_SLS_LC;
IF YEARS_ON_BOOKS LE &YEARS_ON_BOOKS_LC THEN YEARS_ON_BOOKS=&YEARS_ON_BOOKS_LC;

RUN;

DATA DATALIB.&BRAND._&SAMPLES._UNBALANCED_3_ONL;
SET &BRAND._&SAMPLES._UNBALANCED_2_ONL;

AVG_ORD_SZ_12MO = (AVG_ORD_SZ_12MO - &AVG_ORD_SZ_12MO_LC) / (&AVG_ORD_SZ_12MO_UC - &AVG_ORD_SZ_12MO_LC);
AVG_ORD_SZ_12MO_CP = (AVG_ORD_SZ_12MO_CP - &AVG_ORD_SZ_12MO_CP_LC) / (&AVG_ORD_SZ_12MO_CP_UC - &AVG_ORD_SZ_12MO_CP_LC);
AVG_ORD_SZ_6MO = (AVG_ORD_SZ_6MO - &AVG_ORD_SZ_6MO_LC) / (&AVG_ORD_SZ_6MO_UC - &AVG_ORD_SZ_6MO_LC);
AVG_ORD_SZ_6MO_CP = (AVG_ORD_SZ_6MO_CP - &AVG_ORD_SZ_6MO_CP_LC) / (&AVG_ORD_SZ_6MO_CP_UC - &AVG_ORD_SZ_6MO_CP_LC);
AVG_UNT_RTL_12MO = (AVG_UNT_RTL_12MO - &AVG_UNT_RTL_12MO_LC) / (&AVG_UNT_RTL_12MO_UC - &AVG_UNT_RTL_12MO_LC);
AVG_UNT_RTL_6MO = (AVG_UNT_RTL_6MO - &AVG_UNT_RTL_6MO_LC) / (&AVG_UNT_RTL_6MO_UC - &AVG_UNT_RTL_6MO_LC);
AVG_UNT_RTL_CP_12MO = (AVG_UNT_RTL_CP_12MO - &AVG_UNT_RTL_CP_12MO_LC) / (&AVG_UNT_RTL_CP_12MO_UC - &AVG_UNT_RTL_CP_12MO_LC);
AVG_UNT_RTL_CP_6MO = (AVG_UNT_RTL_CP_6MO - &AVG_UNT_RTL_CP_6MO_LC) / (&AVG_UNT_RTL_CP_6MO_UC - &AVG_UNT_RTL_CP_6MO_LC);
days_last_pur = (days_last_pur - &days_last_pur_LC) / (&days_last_pur_UC - &days_last_pur_LC);
days_last_pur_cp = (days_last_pur_cp - &days_last_pur_cp_LC) / (&days_last_pur_cp_UC - &days_last_pur_cp_LC);
days_on_books = (days_on_books - &days_on_books_LC) / (&days_on_books_UC - &days_on_books_LC);
days_on_books_cp = (days_on_books_cp - &days_on_books_cp_LC) / (&days_on_books_cp_UC - &days_on_books_cp_LC);
discount_amt_12mo_sls = (discount_amt_12mo_sls - &discount_amt_12mo_sls_LC) / (&discount_amt_12mo_sls_UC - &discount_amt_12mo_sls_LC);
discount_amt_6mo_sls = (discount_amt_6mo_sls - &discount_amt_6mo_sls_LC) / (&discount_amt_6mo_sls_UC - &discount_amt_6mo_sls_LC);
DISCOUNT_PCT_12MO = (DISCOUNT_PCT_12MO - &DISCOUNT_PCT_12MO_LC) / (&DISCOUNT_PCT_12MO_UC - &DISCOUNT_PCT_12MO_LC);
DISCOUNT_PCT_6MO = (DISCOUNT_PCT_6MO - &DISCOUNT_PCT_6MO_LC) / (&DISCOUNT_PCT_6MO_UC - &DISCOUNT_PCT_6MO_LC);
div_shp = (div_shp - &div_shp_LC) / (&div_shp_UC - &div_shp_LC);
div_shp_cp = (div_shp_cp - &div_shp_cp_LC) / (&div_shp_cp_UC - &div_shp_cp_LC);
emails_clicked = (emails_clicked - &emails_clicked_LC) / (&emails_clicked_UC - &emails_clicked_LC);
emails_clicked_cp = (emails_clicked_cp - &emails_clicked_cp_LC) / (&emails_clicked_cp_UC - &emails_clicked_cp_LC);
emails_opened = (emails_opened - &emails_opened_LC) / (&emails_opened_UC - &emails_opened_LC);
emails_opened_cp = (emails_opened_cp - &emails_opened_cp_LC) / (&emails_opened_cp_UC - &emails_opened_cp_LC);
item_qty_12mo_rtn = (item_qty_12mo_rtn - &item_qty_12mo_rtn_LC) / (&item_qty_12mo_rtn_UC - &item_qty_12mo_rtn_LC);
item_qty_12mo_rtn_cp = (item_qty_12mo_rtn_cp - &item_qty_12mo_rtn_cp_LC) / (&item_qty_12mo_rtn_cp_UC - &item_qty_12mo_rtn_cp_LC);
item_qty_12mo_sls = (item_qty_12mo_sls - &item_qty_12mo_sls_LC) / (&item_qty_12mo_sls_UC - &item_qty_12mo_sls_LC);
item_qty_12mo_sls_cp = (item_qty_12mo_sls_cp - &item_qty_12mo_sls_cp_LC) / (&item_qty_12mo_sls_cp_UC - &item_qty_12mo_sls_cp_LC);
item_qty_6mo_rtn = (item_qty_6mo_rtn - &item_qty_6mo_rtn_LC) / (&item_qty_6mo_rtn_UC - &item_qty_6mo_rtn_LC);
item_qty_6mo_rtn_cp = (item_qty_6mo_rtn_cp - &item_qty_6mo_rtn_cp_LC) / (&item_qty_6mo_rtn_cp_UC - &item_qty_6mo_rtn_cp_LC);
item_qty_6mo_sls = (item_qty_6mo_sls - &item_qty_6mo_sls_LC) / (&item_qty_6mo_sls_UC - &item_qty_6mo_sls_LC);
item_qty_6mo_sls_cp = (item_qty_6mo_sls_cp - &item_qty_6mo_sls_cp_LC) / (&item_qty_6mo_sls_cp_UC - &item_qty_6mo_sls_cp_LC);
item_qty_onsale_12mo_sls = (item_qty_onsale_12mo_sls - &item_qty_onsale_12mo_sls_LC) / (&item_qty_onsale_12mo_sls_UC - &item_qty_onsale_12mo_sls_LC);
item_qty_onsale_12mo_sls_cp = (item_qty_onsale_12mo_sls_cp - &item_qty_onsale_12mo_sls_cp_LC) / (&item_qty_onsale_12mo_sls_cp_UC - &item_qty_onsale_12mo_sls_cp_LC);
item_qty_onsale_6mo_sls = (item_qty_onsale_6mo_sls - &item_qty_onsale_6mo_sls_LC) / (&item_qty_onsale_6mo_sls_UC - &item_qty_onsale_6mo_sls_LC);
item_qty_onsale_6mo_sls_cp = (item_qty_onsale_6mo_sls_cp - &item_qty_onsale_6mo_sls_cp_LC) / (&item_qty_onsale_6mo_sls_cp_UC - &item_qty_onsale_6mo_sls_cp_LC);
net_margin_12mo_sls = (net_margin_12mo_sls - &net_margin_12mo_sls_LC) / (&net_margin_12mo_sls_UC - &net_margin_12mo_sls_LC);
net_margin_6mo_sls = (net_margin_6mo_sls - &net_margin_6mo_sls_LC) / (&net_margin_6mo_sls_UC - &net_margin_6mo_sls_LC);
net_sales_amt_12mo_rtn = (net_sales_amt_12mo_rtn - &netsales_12mo_rtn_LC) / (&netsales_12mo_rtn_UC - &netsales_12mo_rtn_LC);
net_sales_amt_12mo_rtn_cp = (net_sales_amt_12mo_rtn_cp - &netsales_12mo_rtn_cp_LC) / (&netsales_12mo_rtn_cp_UC - &netsales_12mo_rtn_cp_LC);
net_sales_amt_12mo_sls = (net_sales_amt_12mo_sls - &netsales_12mo_sls_LC) / (&netsales_12mo_sls_UC - &netsales_12mo_sls_LC);
net_sales_amt_12mo_sls_cp = (net_sales_amt_12mo_sls_cp - &netsales_12mo_sls_cp_LC) / (&netsales_12mo_sls_cp_UC - &netsales_12mo_sls_cp_LC);
net_sales_amt_6mo_rtn = (net_sales_amt_6mo_rtn - &netsales_6mo_rtn_LC) / (&netsales_6mo_rtn_UC - &netsales_6mo_rtn_LC);
net_sales_amt_6mo_rtn_cp = (net_sales_amt_6mo_rtn_cp - &netsales_6mo_rtn_cp_LC) / (&netsales_6mo_rtn_cp_UC - &netsales_6mo_rtn_cp_LC);
net_sales_amt_6mo_sls = (net_sales_amt_6mo_sls - &netsales_6mo_sls_LC) / (&netsales_6mo_sls_UC - &netsales_6mo_sls_LC);
net_sales_amt_6mo_sls_cp = (net_sales_amt_6mo_sls_cp - &netsales_6mo_sls_cp_LC) / (&netsales_6mo_sls_cp_UC - &netsales_6mo_sls_cp_LC);
net_sales_amt_plcc_12mo_sls = (net_sales_amt_plcc_12mo_sls - &netsales_plcc_12mo_sls_LC) / (&netsales_plcc_12mo_sls_UC - &netsales_plcc_12mo_sls_LC);
net_sales_amt_plcc_12mo_sls_cp = (net_sales_amt_plcc_12mo_sls_cp - &netsales_plcc_12mo_sls_cp_LC) / (&netsales_plcc_12mo_sls_cp_UC - &netsales_plcc_12mo_sls_cp_LC);
net_sales_amt_plcc_6mo_sls = (net_sales_amt_plcc_6mo_sls - &netsales_plcc_6mo_sls_LC) / (&netsales_plcc_6mo_sls_UC - &netsales_plcc_6mo_sls_LC);
net_sales_amt_plcc_6mo_sls_cp = (net_sales_amt_plcc_6mo_sls_cp - &netsales_plcc_6mo_sls_cp_LC) / (&netsales_plcc_6mo_sls_cp_UC - &netsales_plcc_6mo_sls_cp_LC);
num_txns_12mo_rtn = (num_txns_12mo_rtn - &num_txns_12mo_rtn_LC) / (&num_txns_12mo_rtn_UC - &num_txns_12mo_rtn_LC);
num_txns_12mo_rtn_cp = (num_txns_12mo_rtn_cp - &num_txns_12mo_rtn_cp_LC) / (&num_txns_12mo_rtn_cp_UC - &num_txns_12mo_rtn_cp_LC);
num_txns_12mo_sls = (num_txns_12mo_sls - &num_txns_12mo_sls_LC) / (&num_txns_12mo_sls_UC - &num_txns_12mo_sls_LC);
num_txns_12mo_sls_cp = (num_txns_12mo_sls_cp - &num_txns_12mo_sls_cp_LC) / (&num_txns_12mo_sls_cp_UC - &num_txns_12mo_sls_cp_LC);
num_txns_6mo_rtn = (num_txns_6mo_rtn - &num_txns_6mo_rtn_LC) / (&num_txns_6mo_rtn_UC - &num_txns_6mo_rtn_LC);
num_txns_6mo_rtn_cp = (num_txns_6mo_rtn_cp - &num_txns_6mo_rtn_cp_LC) / (&num_txns_6mo_rtn_cp_UC - &num_txns_6mo_rtn_cp_LC);
num_txns_6mo_sls = (num_txns_6mo_sls - &num_txns_6mo_sls_LC) / (&num_txns_6mo_sls_UC - &num_txns_6mo_sls_LC);
num_txns_6mo_sls_cp = (num_txns_6mo_sls_cp - &num_txns_6mo_sls_cp_LC) / (&num_txns_6mo_sls_cp_UC - &num_txns_6mo_sls_cp_LC);
num_txns_plcc_12mo_sls = (num_txns_plcc_12mo_sls - &num_txns_plcc_12mo_sls_LC) / (&num_txns_plcc_12mo_sls_UC - &num_txns_plcc_12mo_sls_LC);
num_txns_plcc_12mo_sls_cp = (num_txns_plcc_12mo_sls_cp - &num_txns_plcc_12mo_sls_cp_LC) / (&num_txns_plcc_12mo_sls_cp_UC - &num_txns_plcc_12mo_sls_cp_LC);
num_txns_plcc_6mo_sls = (num_txns_plcc_6mo_sls - &num_txns_plcc_6mo_sls_LC) / (&num_txns_plcc_6mo_sls_UC - &num_txns_plcc_6mo_sls_LC);
num_txns_plcc_6mo_sls_cp = (num_txns_plcc_6mo_sls_cp - &num_txns_plcc_6mo_sls_cp_LC) / (&num_txns_plcc_6mo_sls_cp_UC - &num_txns_plcc_6mo_sls_cp_LC);
PLCC_TXN_PCT_12MO = (PLCC_TXN_PCT_12MO - &PLCC_TXN_PCT_12MO_LC) / (&PLCC_TXN_PCT_12MO_UC - &PLCC_TXN_PCT_12MO_LC);
PLCC_TXN_PCT_6MO = (PLCC_TXN_PCT_6MO - &PLCC_TXN_PCT_6MO_LC) / (&PLCC_TXN_PCT_6MO_UC - &PLCC_TXN_PCT_6MO_LC);
RATIO_NET_RTN_NET_SLS_12MO = (RATIO_NET_RTN_NET_SLS_12MO - &RATIO_NET_RTN_NET_SLS_12MO_LC) / (&RATIO_NET_RTN_NET_SLS_12MO_UC - &RATIO_NET_RTN_NET_SLS_12MO_LC);
RATIO_NET_RTN_NET_SLS_6MO = (RATIO_NET_RTN_NET_SLS_6MO - &RATIO_NET_RTN_NET_SLS_6MO_LC) / (&RATIO_NET_RTN_NET_SLS_6MO_UC - &RATIO_NET_RTN_NET_SLS_6MO_LC);
UNITS_PER_TXN_12MO_SLS = (UNITS_PER_TXN_12MO_SLS - &UNITS_PER_TXN_12MO_SLS_LC) / (&UNITS_PER_TXN_12MO_SLS_UC - &UNITS_PER_TXN_12MO_SLS_LC);
UNITS_PER_TXN_6MO_SLS = (UNITS_PER_TXN_6MO_SLS - &UNITS_PER_TXN_6MO_SLS_LC) / (&UNITS_PER_TXN_6MO_SLS_UC - &UNITS_PER_TXN_6MO_SLS_LC);
YEARS_ON_BOOKS = (YEARS_ON_BOOKS - &YEARS_ON_BOOKS_LC) / (&YEARS_ON_BOOKS_UC - &YEARS_ON_BOOKS_LC);

RUN;

proc means DATA=DATALIB.&BRAND._&SAMPLES._UNBALANCED_3_ONL; run;


PROC EXPORT DATA=DATALIB.&BRAND._&SAMPLES._UNBALANCED_3_ONL
			OUTFILE="Z:\JEWELS\Email Model Gen 2\&BRAND._EM_&SAMPLES._UNBALANCED_3_ONL.CSV"
            DBMS=DLM REPLACE;
     DELIMITER=",";
RUN;
%MEND DATAPREPMACRO;

*%DATAPREPMACRO(2033109,BRAND=GP);
*%DATAPREPMACRO(2034203,BRAND=GP);
