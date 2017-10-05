*ASSIGN LIBRARIES;

LIBNAME TA4U1R9 ORACLE USER=TA4U1R9 PW="T$numoy009$!" PATH=SAS10P1 PRESERVE_TAB_NAMES=YES SCHEMA=TA4U1R9;

LIBNAME CORESAS ORACLE USER=TA4U1R9 PW="T$numoy009$!" PATH=SAS10P1 PRESERVE_TAB_NAMES=YES SCHEMA=CORESAS;

LIBNAME DATALIB "\\10.8.8.51\LV0\TANUMOY\DATASETS\MODEL REPLICATION";

OPTIONS MACROGEN SYMBOLGEN MLOGIC MPRINT;


%LET BRAND=GP;  %LET SAMPLENAME = 258059;

%MACRO CONVERTHIVE(SAMPLES, BRAND, INPATH, OUTPATH);

LIBNAME DATALIB "&OUTPATH"; 

LIBNAME INLIB "&INPATH";

%LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

%DO I=1 %TO &SAMPLECOUNT;
		
		%LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   		%PUT &SAMPLENAME;

   		%LET BASEDS=&BRAND._&SAMPLENAME._COMBINED;


	    %LET DATASET = &INPATH.\&BASEDS..TXT;
		%PUT &DATASET;

		%IF %SYSFUNC(FILEEXIST(&DATASET)) %THEN %DO;

			DATA DATALIB.&BASEDS;
			INFILE "&DATASET" 
			DELIMITER = '|' MISSOVER DSD LRECL=32767 FIRSTOBS=1;

			INFORMAT CUSTOMER_KEY BEST32. ;
			INFORMAT GROSS_SALES_AMT BEST32. ;
			INFORMAT DISCOUNT_AMT BEST32. ;
			INFORMAT TOT_PRD_CST_AMT BEST32. ;
			INFORMAT ITEM_QTY BEST32. ;
			INFORMAT NET_SALES_AMT BEST32. ;
			INFORMAT NUM_TXNS BEST32. ;
			INFORMAT AVG_ORD_SZ BEST32. ;
			INFORMAT RESPONDER BEST32. ;
			INFORMAT SHIP_AMOUNT_6MO_SLS BEST32. ;
			INFORMAT GROSS_SALES_AMT_6MO_SLS BEST32. ;
			INFORMAT DISCOUNT_AMT_6MO_SLS BEST32. ;
			INFORMAT TOT_PRD_CST_AMT_6MO_SLS BEST32. ;
			INFORMAT ITEM_QTY_6MO_SLS BEST32. ;
			INFORMAT SHIP_AMOUNT_12MO_SLS BEST32. ;
			INFORMAT GROSS_SALES_AMT_12MO_SLS BEST32. ;
			INFORMAT DISCOUNT_AMT_12MO_SLS BEST32. ;
			INFORMAT TOT_PRD_CST_AMT_12MO_SLS BEST32. ;
			INFORMAT ITEM_QTY_12MO_SLS BEST32. ;
			INFORMAT NUM_TXNS_6MO_SLS BEST32. ;
			INFORMAT NUM_TXNS_12MO_SLS BEST32. ;
			INFORMAT NUM_PLCC_TXNS_6MO_SLS BEST32. ;
			INFORMAT NUM_PLCC_TXNS_12MO_SLS BEST32. ;
			INFORMAT GROSS_SALES_AMT_6MO_RTN BEST32. ;
			INFORMAT DISCOUNT_AMT_6MO_RTN BEST32. ;
			INFORMAT ITEM_QTY_6MO_RTN BEST32. ;
			INFORMAT GROSS_SALES_AMT_12MO_RTN BEST32. ;
			INFORMAT DISCOUNT_AMT_12MO_RTN BEST32. ;
			INFORMAT ITEM_QTY_12MO_RTN BEST32. ;
			INFORMAT NUM_TXNS_6MO_RTN BEST32. ;
			INFORMAT NUM_TXNS_12MO_RTN BEST32. ;
			INFORMAT SHIP_AMOUNT_6MO_SLS_CP BEST32. ;
			INFORMAT GROSS_SALES_AMT_6MO_SLS_CP BEST32. ;
			INFORMAT DISCOUNT_AMT_6MO_SLS_CP BEST32. ;
			INFORMAT TOT_PRD_CST_AMT_6MO_SLS_CP BEST32. ;
			INFORMAT ITEM_QTY_6MO_SLS_CP BEST32. ;
			INFORMAT SHIP_AMOUNT_12MO_SLS_CP BEST32. ;
			INFORMAT GROSS_SALES_AMT_12MO_SLS_CP BEST32. ;
			INFORMAT DISCOUNT_AMT_12MO_SLS_CP BEST32. ;
			INFORMAT TOT_PRD_CST_AMT_12MO_SLS_CP BEST32. ;
			INFORMAT ITEM_QTY_12MO_SLS_CP BEST32. ;
			INFORMAT NUM_TXNS_6MO_SLS_CP BEST32. ;
			INFORMAT NUM_TXNS_12MO_SLS_CP BEST32. ;
			INFORMAT NUM_PLCC_TXNS_6MO_SLS_CP BEST32. ;
			INFORMAT NUM_PLCC_TXNS_12MO_SLS_CP BEST32. ;
			INFORMAT GROSS_SALES_AMT_6MO_RTN_CP BEST32. ;
			INFORMAT DISCOUNT_AMT_6MO_RTN_CP BEST32. ;
			INFORMAT ITEM_QTY_6MO_RTN_CP BEST32. ;
			INFORMAT GROSS_SALES_AMT_12MO_RTN_CP BEST32. ;
			INFORMAT DISCOUNT_AMT_12MO_RTN_CP BEST32. ;
			INFORMAT ITEM_QTY_12MO_RTN_CP BEST32. ;
			INFORMAT NUM_TXNS_6MO_RTN_CP BEST32. ;
			INFORMAT NUM_TXNS_12MO_RTN_CP BEST32. ;
			INFORMAT SHIP_AMOUNT_6MO_ONL_SLS BEST32.;
			INFORMAT GROSS_SALES_AMT_6MO_ONL_SLS BEST32.;
			INFORMAT DISCOUNT_AMT_6MO_ONL_SLS BEST32.;
			INFORMAT TOT_PRD_CST_AMT_6MO_ONL_SLS BEST32.;
			INFORMAT ITEM_QTY_6MO_ONL_SLS BEST32.;
			INFORMAT SHIP_AMOUNT_12MO_ONL_SLS BEST32.;
			INFORMAT GROSS_SALES_AMT_12MO_ONL_SLS BEST32.;
			INFORMAT DISCOUNT_AMT_12MO_ONL_SLS BEST32.;
			INFORMAT TOT_PRD_CST_AMT_12MO_ONL_SLS BEST32.;
			INFORMAT ITEM_QTY_12MO_ONL_SLS BEST32.;
			INFORMAT NUM_TXNS_6MO_ONL_SLS BEST32.;
			INFORMAT NUM_TXNS_12MO_ONL_SLS BEST32.;
            INFORMAT BASIC_FLAG BEST32. ;
			INFORMAT SILVER_FLAG BEST32. ;
			INFORMAT SISTER_FLAG BEST32. ;
			INFORMAT CARD_STATUS BEST32. ;
			INFORMAT DAYS_LAST_PUR_CP BEST32. ;
			INFORMAT DAYS_LAST_PUR_&BRAND BEST32. ;
			INFORMAT DAYS_ON_BOOKS_CP BEST32. ;
			INFORMAT DIV_SHP_&BRAND BEST32. ;
			INFORMAT ONSALE_QTY_12MO BEST32. ;
			INFORMAT ONSALE_QTY_6MO BEST32. ;
			INFORMAT PROMOTIONS_RECEIVED_CP BEST32. ;
			INFORMAT PROMOTIONS_RECEIVED_&BRAND BEST32. ;
			INFORMAT &BRAND._CAMPAIGNS_RECEIVED_12MO BEST32. ;
			INFORMAT &BRAND._PROMOTIONS_RECEIVED_12MO BEST32. ;
			INFORMAT &BRAND._PROMOTIONS_RESPONDED_12MO BEST32. ;
			INFORMAT RESPONSE_RATE_12MO BEST32. ;
			INFORMAT NUM_TXNS_SLS_PROMO_12MO BEST32. ;
			INFORMAT GROSS_SALES_SLS_PROMO_12MO BEST32. ;
			INFORMAT DISCOUNT_SLS_PROMO_12MO BEST32. ;
			INFORMAT NET_SALES_SLS_PROMO_12MO BEST32. ;
            INFORMAT EMAILS_CLICKED_&BRAND BEST32.;
			INFORMAT EMAILS_CLICKED_CP BEST32.;
			INFORMAT EMAILS_VIEWED_&BRAND BEST32.;
			INFORMAT EMAILS_VIEWED_CP BEST32.;
			INFORMAT START_DT $12. ;
			INFORMAT END_DT $12. ;


			FORMAT CUSTOMER_KEY BEST32. ;
			FORMAT GROSS_SALES_AMT BEST32. ;
			FORMAT DISCOUNT_AMT BEST32. ;
			FORMAT TOT_PRD_CST_AMT BEST32. ;
			FORMAT ITEM_QTY BEST32. ;
			FORMAT NET_SALES_AMT BEST32. ;
			FORMAT NUM_TXNS BEST32. ;
			FORMAT AVG_ORD_SZ BEST32. ;
			FORMAT RESPONDER BEST32. ;
			FORMAT SHIP_AMOUNT_6MO_SLS BEST32. ;
			FORMAT GROSS_SALES_AMT_6MO_SLS BEST32. ;
			FORMAT DISCOUNT_AMT_6MO_SLS BEST32. ;
			FORMAT TOT_PRD_CST_AMT_6MO_SLS BEST32. ;
			FORMAT ITEM_QTY_6MO_SLS BEST32. ;
			FORMAT SHIP_AMOUNT_12MO_SLS BEST32. ;
			FORMAT GROSS_SALES_AMT_12MO_SLS BEST32. ;
			FORMAT DISCOUNT_AMT_12MO_SLS BEST32. ;
			FORMAT TOT_PRD_CST_AMT_12MO_SLS BEST32. ;
			FORMAT ITEM_QTY_12MO_SLS BEST32. ;
			FORMAT NUM_TXNS_6MO_SLS BEST32. ;
			FORMAT NUM_TXNS_12MO_SLS BEST32. ;
			FORMAT NUM_PLCC_TXNS_6MO_SLS BEST32. ;
			FORMAT NUM_PLCC_TXNS_12MO_SLS BEST32. ;
			FORMAT GROSS_SALES_AMT_6MO_RTN BEST32. ;
			FORMAT DISCOUNT_AMT_6MO_RTN BEST32. ;
			FORMAT ITEM_QTY_6MO_RTN BEST32. ;
			FORMAT GROSS_SALES_AMT_12MO_RTN BEST32. ;
			FORMAT DISCOUNT_AMT_12MO_RTN BEST32. ;
			FORMAT ITEM_QTY_12MO_RTN BEST32. ;
			FORMAT NUM_TXNS_6MO_RTN BEST32. ;
			FORMAT NUM_TXNS_12MO_RTN BEST32. ;
			FORMAT SHIP_AMOUNT_6MO_SLS_CP BEST32. ;
			FORMAT GROSS_SALES_AMT_6MO_SLS_CP BEST32. ;
			FORMAT DISCOUNT_AMT_6MO_SLS_CP BEST32. ;
			FORMAT TOT_PRD_CST_AMT_6MO_SLS_CP BEST32. ;
			FORMAT ITEM_QTY_6MO_SLS_CP BEST32. ;
			FORMAT SHIP_AMOUNT_12MO_SLS_CP BEST32. ;
			FORMAT GROSS_SALES_AMT_12MO_SLS_CP BEST32. ;
			FORMAT DISCOUNT_AMT_12MO_SLS_CP BEST32. ;
			FORMAT TOT_PRD_CST_AMT_12MO_SLS_CP BEST32. ;
			FORMAT ITEM_QTY_12MO_SLS_CP BEST32. ;
			FORMAT NUM_TXNS_6MO_SLS_CP BEST32. ;
			FORMAT NUM_TXNS_12MO_SLS_CP BEST32. ;
			FORMAT NUM_PLCC_TXNS_6MO_SLS_CP BEST32. ;
			FORMAT NUM_PLCC_TXNS_12MO_SLS_CP BEST32. ;
			FORMAT GROSS_SALES_AMT_6MO_RTN_CP BEST32. ;
			FORMAT DISCOUNT_AMT_6MO_RTN_CP BEST32. ;
			FORMAT ITEM_QTY_6MO_RTN_CP BEST32. ;
			FORMAT GROSS_SALES_AMT_12MO_RTN_CP BEST32. ;
			FORMAT DISCOUNT_AMT_12MO_RTN_CP BEST32. ;
			FORMAT ITEM_QTY_12MO_RTN_CP BEST32. ;
			FORMAT NUM_TXNS_6MO_RTN_CP BEST32. ;
			FORMAT NUM_TXNS_12MO_RTN_CP BEST32. ;
			FORMAT SHIP_AMOUNT_6MO_ONL_SLS BEST32.;
			FORMAT GROSS_SALES_AMT_6MO_ONL_SLS BEST32.;
			FORMAT DISCOUNT_AMT_6MO_ONL_SLS BEST32.;
			FORMAT TOT_PRD_CST_AMT_6MO_ONL_SLS BEST32.;
			FORMAT ITEM_QTY_6MO_ONL_SLS BEST32.;
			FORMAT SHIP_AMOUNT_12MO_ONL_SLS BEST32.;
			FORMAT GROSS_SALES_AMT_12MO_ONL_SLS BEST32.;
			FORMAT DISCOUNT_AMT_12MO_ONL_SLS BEST32.;
			FORMAT TOT_PRD_CST_AMT_12MO_ONL_SLS BEST32.;
			FORMAT ITEM_QTY_12MO_ONL_SLS BEST32.;
			FORMAT NUM_TXNS_6MO_ONL_SLS BEST32.;
			FORMAT BASIC_FLAG BEST32. ;
			FORMAT SILVER_FLAG BEST32. ;
			FORMAT SISTER_FLAG BEST32. ;
			FORMAT CARD_STATUS BEST32. ;
			FORMAT DAYS_LAST_PUR_CP BEST32. ;
			FORMAT DAYS_LAST_PUR_&BRAND BEST32. ;
			FORMAT DAYS_ON_BOOKS_CP BEST32. ;
			FORMAT DIV_SHP_&BRAND BEST32. ;
			FORMAT ONSALE_QTY_12MO BEST32. ;
			FORMAT ONSALE_QTY_6MO BEST32. ;
			FORMAT PROMOTIONS_RECEIVED_CP BEST32. ;
			FORMAT PROMOTIONS_RECEIVED_&BRAND BEST32. ;
			FORMAT &BRAND._CAMPAIGNS_RECEIVED_12MO BEST32. ;
			FORMAT &BRAND._PROMOTIONS_RECEIVED_12MO BEST32. ;
			FORMAT &BRAND._PROMOTIONS_RESPONDED_12MO BEST32. ;
			FORMAT RESPONSE_RATE_12MO BEST32. ;
			FORMAT NUM_TXNS_SLS_PROMO_12MO BEST32. ;
			FORMAT GROSS_SALES_SLS_PROMO_12MO BEST32. ;
			FORMAT DISCOUNT_SLS_PROMO_12MO BEST32. ;
			FORMAT NET_SALES_SLS_PROMO_12MO BEST32. ;
            FORMAT EMAILS_CLICKED_&BRAND BEST32.;
			FORMAT EMAILS_CLICKED_CP BEST32.;
			FORMAT EMAILS_VIEWED_&BRAND BEST32.;
			FORMAT EMAILS_VIEWED_CP BEST32.;
			FORMAT NUM_TXNS_12MO_ONL_SLS BEST32.;
			FORMAT START_DT $12. ;
			FORMAT END_DT $12. ;


			INPUT
			CUSTOMER_KEY	
			GROSS_SALES_AMT	
			DISCOUNT_AMT	
			TOT_PRD_CST_AMT	
			ITEM_QTY	
			NET_SALES_AMT	
			NUM_TXNS	
			AVG_ORD_SZ	
			RESPONDER	
			SHIP_AMOUNT_6MO_SLS	
			GROSS_SALES_AMT_6MO_SLS	
			DISCOUNT_AMT_6MO_SLS	
			TOT_PRD_CST_AMT_6MO_SLS	
			ITEM_QTY_6MO_SLS	
			SHIP_AMOUNT_12MO_SLS	
			GROSS_SALES_AMT_12MO_SLS	
			DISCOUNT_AMT_12MO_SLS	
			TOT_PRD_CST_AMT_12MO_SLS	
			ITEM_QTY_12MO_SLS	
			NUM_TXNS_6MO_SLS	
			NUM_TXNS_12MO_SLS	
			NUM_PLCC_TXNS_6MO_SLS	
			NUM_PLCC_TXNS_12MO_SLS	
			GROSS_SALES_AMT_6MO_RTN	
			DISCOUNT_AMT_6MO_RTN	
			ITEM_QTY_6MO_RTN	
			GROSS_SALES_AMT_12MO_RTN	
			DISCOUNT_AMT_12MO_RTN	
			ITEM_QTY_12MO_RTN	
			NUM_TXNS_6MO_RTN	
			NUM_TXNS_12MO_RTN	
			SHIP_AMOUNT_6MO_SLS_CP	
			GROSS_SALES_AMT_6MO_SLS_CP	
			DISCOUNT_AMT_6MO_SLS_CP	
			TOT_PRD_CST_AMT_6MO_SLS_CP	
			ITEM_QTY_6MO_SLS_CP	
			SHIP_AMOUNT_12MO_SLS_CP	
			GROSS_SALES_AMT_12MO_SLS_CP	
			DISCOUNT_AMT_12MO_SLS_CP	
			TOT_PRD_CST_AMT_12MO_SLS_CP	
			ITEM_QTY_12MO_SLS_CP	
			NUM_TXNS_6MO_SLS_CP	
			NUM_TXNS_12MO_SLS_CP	
			NUM_PLCC_TXNS_6MO_SLS_CP	
			NUM_PLCC_TXNS_12MO_SLS_CP	
			GROSS_SALES_AMT_6MO_RTN_CP	
			DISCOUNT_AMT_6MO_RTN_CP	
			ITEM_QTY_6MO_RTN_CP	
			GROSS_SALES_AMT_12MO_RTN_CP	
			DISCOUNT_AMT_12MO_RTN_CP	
			ITEM_QTY_12MO_RTN_CP	
			NUM_TXNS_6MO_RTN_CP	
			NUM_TXNS_12MO_RTN_CP	
			SHIP_AMOUNT_6MO_ONL_SLS	
			GROSS_SALES_AMT_6MO_ONL_SLS	
			DISCOUNT_AMT_6MO_ONL_SLS	
			TOT_PRD_CST_AMT_6MO_ONL_SLS	
			ITEM_QTY_6MO_ONL_SLS	
			SHIP_AMOUNT_12MO_ONL_SLS	
			GROSS_SALES_AMT_12MO_ONL_SLS	
			DISCOUNT_AMT_12MO_ONL_SLS	
			TOT_PRD_CST_AMT_12MO_ONL_SLS	
			ITEM_QTY_12MO_ONL_SLS	
			NUM_TXNS_6MO_ONL_SLS	
			NUM_TXNS_12MO_ONL_SLS	
            BASIC_FLAG	
			SILVER_FLAG	
			SISTER_FLAG	
			CARD_STATUS	
			DAYS_LAST_PUR_CP	
			DAYS_LAST_PUR_&BRAND	
			DAYS_ON_BOOKS_CP	
			DIV_SHP_&BRAND	
			ONSALE_QTY_12MO	
			ONSALE_QTY_6MO	
			PROMOTIONS_RECEIVED_CP	
			PROMOTIONS_RECEIVED_&BRAND	
			&BRAND._CAMPAIGNS_RECEIVED_12MO	
			&BRAND._PROMOTIONS_RECEIVED_12MO	
			&BRAND._PROMOTIONS_RESPONDED_12MO	
			RESPONSE_RATE_12MO	
			NUM_TXNS_SLS_PROMO_12MO	
			GROSS_SALES_SLS_PROMO_12MO	
			DISCOUNT_SLS_PROMO_12MO	
			NET_SALES_SLS_PROMO_12MO	
			EMAILS_CLICKED_&BRAND	
			EMAILS_CLICKED_CP	
			EMAILS_VIEWED_&BRAND	
			EMAILS_VIEWED_CP	
			START_DT $
			END_DT $
			;
			RUN;

			OPTIONS NOXWAIT;
            %SYSEXEC DEL "&DATASET";
			
		%END;

%END;

%MEND;

%CONVERTHIVE
(
SAMPLES=258059, BRAND=GP,
INPATH =\\10.8.8.51\LV0\TANUMOY\DATASETS\FROM HIVE,
OUTPATH=\\10.8.8.51\LV0\TANUMOY\DATASETS\MODEL REPLICATION
);


*252008 252760 253899 254162 254800 256644;


%MACRO IMPUTE(LIBNAME, SAMPLES, INPUTLIB, BRAND);

 %LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

 %DO I=1 %TO &SAMPLECOUNT;

   %LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   %PUT &SAMPLENAME;
   
   DATA &LIBNAME..&BRAND._&SAMPLENAME._COMBINED(DROP=Z);                                                    
    SET &LIBNAME..&BRAND._&SAMPLENAME._COMBINED;                                                            
    ARRAY TESTMISS(*) _NUMERIC_;                                            
    DO Z = 1 TO DIM(TESTMISS);                                              
     IF TESTMISS(Z)=. THEN TESTMISS(Z)=0;                                    
    END;   
	CAMPAIGN="&SAMPLENAME";
   RUN;

 %END;
 

%MEND;

%IMPUTE(LIBNAME=DATALIB, INPUTLIB=TA4U1R9, BRAND=GP, SAMPLES=258059);





DATA DATALIB.&BRAND._EM_ALLCAMPAIGNS_RESP_PROP_1;
 SET DATALIB.&BRAND._EM_ALLCAMPAIGNS_RESP_PROP_1;
 CALL SYMPUT ("PROP_RESPONDERS", PROP_RESPONDERS);
 CALL SYMPUT ("PROP_RESPONDERS_BAL", PROP_RESPONDERS_BAL);
 CALL SYMPUT ("PROP_NONRESPONDERS", PROP_NONRESPONDERS);
 CALL SYMPUT ("PROP_NONRESPONDERS_BAL", PROP_NONRESPONDERS_BAL);
RUN;

%PUT &PROP_RESPONDERS &PROP_NONRESPONDERS;
%PUT &PROP_RESPONDERS_BAL &PROP_NONRESPONDERS_BAL;


DATA DATALIB.&BRAND._&SAMPLENAME._COMBINED;
 SET DATALIB.&BRAND._&SAMPLENAME._COMBINED;

 LENGTH_PROMO=INPUT(SUBSTR(END_DT,1,10), YYMMDD10.) - INPUT(SUBSTR(START_DT,1,10), YYMMDD10.) + 1;

 IF RESPONDER=1 THEN WT=&PROP_RESPONDERS/&PROP_RESPONDERS_BAL;
 IF RESPONDER=0 THEN WT=&PROP_NONRESPONDERS/&PROP_NONRESPONDERS_BAL;

 NET_SALES_AMT_12MO_SLS=GROSS_SALES_AMT_12MO_SLS+DISCOUNT_AMT_12MO_SLS;
 NET_SALES_AMT_12MO_SLS_CP=GROSS_SALES_AMT_12MO_SLS_CP+DISCOUNT_AMT_12MO_SLS_CP;
 NET_SALES_AMT_12MO_SLS_OTH=NET_SALES_AMT_12MO_SLS_CP-NET_SALES_AMT_12MO_SLS;

 NET_SALES_AMT_12MO_RTN = -(GROSS_SALES_AMT_12MO_RTN+DISCOUNT_AMT_12MO_RTN);
 NET_SALES_AMT_12MO_RTN_CP = -(GROSS_SALES_AMT_12MO_RTN_CP+DISCOUNT_AMT_12MO_RTN_CP);
 NET_SALES_AMT_12MO_RTN_OTH = NET_SALES_AMT_12MO_RTN_CP-NET_SALES_AMT_12MO_RTN;
 

 NET_SALES_AMT_12MO_ONL_SLS=GROSS_SALES_AMT_12MO_ONL_SLS+DISCOUNT_AMT_12MO_ONL_SLS;
 NET_SALES_ONL_PCT_12MO = 0;
 IF NET_SALES_AMT_12MO_SLS NE 0 THEN 
	NET_SALES_ONL_PCT_12MO=NET_SALES_AMT_12MO_ONL_SLS / NET_SALES_AMT_12MO_SLS;
 

 NUM_TXNS_ONL_PCT_12MO = 0;
 IF NUM_TXNS_12MO_SLS NE 0 THEN 
	NUM_TXNS_ONL_PCT_12MO=NUM_TXNS_12MO_ONL_SLS / NUM_TXNS_12MO_SLS;

 
 ITEM_QTY_ONL_PCT_12MO = 0;
 IF ITEM_QTY_12MO_SLS NE 0 THEN 
	ITEM_QTY_ONL_PCT_12MO=ITEM_QTY_12MO_ONL_SLS / ITEM_QTY_12MO_SLS;

 UNITS_PER_TXN_12MO_SLS=0;
 IF NUM_TXNS_12MO_SLS NE 0 THEN 
	UNITS_PER_TXN_12MO_SLS=ITEM_QTY_12MO_SLS/NUM_TXNS_12MO_SLS;

 AVG_ORD_SZ_PROMO_12MO=0;
 IF NUM_TXNS_SLS_PROMO_12MO NE 0 THEN
	AVG_ORD_SZ_PROMO_12MO=NET_SALES_SLS_PROMO_12MO/NUM_TXNS_SLS_PROMO_12MO;

 AVG_ORD_SZ_12MO=0;
 IF NUM_TXNS_12MO_SLS NE 0 THEN 
	AVG_ORD_SZ_12MO=GROSS_SALES_AMT_12MO_SLS/NUM_TXNS_12MO_SLS;

 AVG_ORD_SZ_12MO_CP=0;
 IF NUM_TXNS_12MO_SLS_CP NE 0 THEN 
	AVG_ORD_SZ_12MO_CP=GROSS_SALES_AMT_12MO_SLS_CP/NUM_TXNS_12MO_SLS_CP;
 
 DISCOUNT_PCT_12MO=0; DISCOUNT_PCT_6MO=0;
 IF GROSS_SALES_AMT_12MO_SLS NE 0 THEN 
 	DISCOUNT_PCT_12MO=-DISCOUNT_AMT_12MO_SLS/GROSS_SALES_AMT_12MO_SLS * 100;

 IF GROSS_SALES_AMT_6MO_SLS NE 0 THEN
 	DISCOUNT_PCT_6MO=-DISCOUNT_AMT_6MO_SLS/GROSS_SALES_AMT_6MO_SLS * 100;

 PLCC_TXN_PCT=0;
 IF NUM_TXNS_12MO_SLS NE 0 THEN
 	PLCC_TXN_PCT=NUM_PLCC_TXNS_12MO_SLS/NUM_TXNS_12MO_SLS * 100;

 AVG_UNT_RTL=0;
 IF ITEM_QTY_12MO_SLS NE 0 THEN 
 AVG_UNT_RTL=NET_SALES_AMT_12MO_SLS/ITEM_QTY_12MO_SLS;
 
 AVG_UNT_RTL_CP=0;
 IF ITEM_QTY_12MO_SLS_CP NE 0 THEN 
 AVG_UNT_RTL_CP=NET_SALES_AMT_12MO_SLS_CP/ITEM_QTY_12MO_SLS_CP;

 RATIO_NET_RTN_NET_SLS=0;
 IF NET_SALES_AMT_12MO_SLS NE 0 THEN
 RATIO_NET_RTN_NET_SLS=NET_SALES_AMT_12MO_RTN/NET_SALES_AMT_12MO_SLS;

 YEARS_ON_BOOKS=DAYS_ON_BOOKS_CP/365;

 OFFSET=LOG((&PROP_NONRESPONDERS * &PROP_RESPONDERS_BAL)/(&PROP_RESPONDERS * &PROP_NONRESPONDERS_BAL));
 
RUN;




DATA &BRAND._&SAMPLENAME._COMBINED_1;
 KEEP AVG_ORD_SZ_12MO_CP 
	  AVG_ORD_SZ_12MO 
 	  CARD_STATUS
	  ONSALE_QTY_12MO 
	  NET_SALES_AMT_12MO_RTN 
	  NET_SALES_AMT_12MO_SLS
	  NUM_TXNS_SLS_PROMO_12MO 
	  AVG_UNT_RTL_CP 
	  AVG_UNT_RTL 
	  DISCOUNT_PCT_12MO 
	  YEARS_ON_BOOKS 
	  UNITS_PER_TXN_12MO_SLS 
	  NUM_TXNS_12MO_SLS  
	  NUM_TXNS_12MO_RTN
      DIV_SHP_GP
	  GP_PROMOTIONS_RECEIVED_12MO 
	  DISCOUNT_SLS_PROMO_12MO
	  NET_SALES_SLS_PROMO_12MO
	  ONSALE_QTY_6MO
	  CUSTOMER_KEY 
	  RESPONDER
	  NET_SALES_AMT 
	  CAMPAIGN 
	  OFFSET 
	  WT 
	  AVG_ORD_SZ_PROMO_12MO 
	  LENGTH_PROMO 
	  DAYS_LAST_PUR_GP
	  DAYS_LAST_PUR_CP 
	  PLCC_TXN_PCT 
	  NUM_PLCC_TXNS_12MO_SLS 
	  RESPONSE_RATE_12MO 
	  BASIC_FLAG 
	  SILVER_FLAG 
	  SISTER_FLAG
      NUM_PLCC_TXNS_12MO_SLS
	  NUM_TXNS_12MO_ONL_SLS
      NET_SALES_AMT_12MO_ONL_SLS
      EMAILS_VIEWED_GP
      EMAILS_VIEWED_CP
      EMAILS_CLICKED_GP
      EMAILS_CLICKED_CP
	  NET_SALES_ONL_PCT_12MO
      NUM_TXNS_ONL_PCT_12MO
      ITEM_QTY_ONL_PCT_12MO; 
 SET DATALIB.&BRAND._&SAMPLENAME._COMBINED;
RUN;



DATA DATALIB.GP_EM_ALLCAMPAIGNS_PCTL;
SET DATALIB.GP_EM_ALLCAMPAIGNS_PCTL;

CALL SYMPUT ("AVG_ORD_SZ_12MO_CP_LC", AVG_ORD_SZ_12MO_CP_0_5);
CALL SYMPUT ("AVG_ORD_SZ_12MO_LC", AVG_ORD_SZ_12MO_0_5);
CALL SYMPUT ("ONSALE_QTY_12MO_LC", ONSALE_QTY_12MO_0_5);
CALL SYMPUT ("NUM_TXNS_SLS_PROMO_12MO_LC", NUM_TXNS_SLS_PROMO_12MO_0_5);
CALL SYMPUT ("NET_SALES_AMT_12MO_RTN_LC", NET_SALES_AMT_12MO_RTN_0_5);
CALL SYMPUT ("NET_SALES_AMT_12MO_SLS_LC", NET_SALES_AMT_12MO_SLS_0_5);
CALL SYMPUT ("AVG_ORD_SZ_PROMO_12MO_LC", AVG_ORD_SZ_PROMO_12MO_0_5);
CALL SYMPUT ("AVG_UNT_RTL_CP_LC", AVG_UNT_RTL_CP_0_5);
CALL SYMPUT ("AVG_UNT_RTL_LC", AVG_UNT_RTL_0_5);
CALL SYMPUT ("DISCOUNT_PCT_12MO_LC", DISCOUNT_PCT_12MO_0_5);
CALL SYMPUT ("YEARS_ON_BOOKS_LC", YEARS_ON_BOOKS_0_5);
CALL SYMPUT ("DISCOUNT_SLS_PROMO_12MO_LC", DISCOUNT_SLS_PROMO_12MO_0_5);
CALL SYMPUT ("UNITS_PER_TXN_12MO_SLS_LC", UNITS_PER_TXN_12MO_SLS_0_5);
CALL SYMPUT ("NUM_TXNS_12MO_SLS_LC", NUM_TXNS_12MO_SLS_0_5);
CALL SYMPUT ("NUM_TXNS_12MO_RTN_LC", NUM_TXNS_12MO_RTN_0_5);
CALL SYMPUT ("DIV_SHP_GP_LC", DIV_SHP_GP_0_5);
CALL SYMPUT ("GP_PROMOTIONS_RECEIVED_12MO_LC", GP_PROMOTIONS_RECEIVED_12MO_0_5);
CALL SYMPUT ("ONSALE_QTY_6MO_LC", ONSALE_QTY_6MO_0_5);
CALL SYMPUT ("NET_SALES_SLS_PROMO_12MO_LC", NET_SALES_SLS_PROMO_12MO_0_5);
CALL SYMPUT ("DAYS_LAST_PUR_GP_LC", DAYS_LAST_PUR_GP_0_5);
CALL SYMPUT ("DAYS_LAST_PUR_CP_LC", DAYS_LAST_PUR_CP_0_5);
CALL SYMPUT ("PLCC_TXN_PCT_LC", PLCC_TXN_PCT_0_5);
CALL SYMPUT ("NUM_PLCC_TXNS_12MO_SLS_LC", NUM_PLCC_TXNS_12MO_SLS_0_5);
CALL SYMPUT ("NUM_TXNS_12MO_ONL_SLS_LC", NUM_TXNS_12MO_ONL_SLS_0_5);
CALL SYMPUT ("NET_SALES_AMT_12MO_ONL_SLS_LC", NET_SALES_AMT_12MO_ONL_SLS_0_5);
CALL SYMPUT ("EMAILS_VIEWED_GP_LC", EMAILS_VIEWED_GP_0_5);
CALL SYMPUT ("EMAILS_VIEWED_CP_LC", EMAILS_VIEWED_CP_0_5);
CALL SYMPUT ("EMAILS_CLICKED_GP_LC", EMAILS_CLICKED_GP_0_5);
CALL SYMPUT ("EMAILS_CLICKED_CP_LC", EMAILS_CLICKED_CP_0_5);
CALL SYMPUT ("NET_SALES_ONL_PCT_12MO_LC", NET_SALES_ONL_PCT_12MO_0_5);
CALL SYMPUT ("NUM_TXNS_ONL_PCT_12MO_LC", NUM_TXNS_ONL_PCT_12MO_0_5);
CALL SYMPUT ("ITEM_QTY_ONL_PCT_12MO_LC", ITEM_QTY_ONL_PCT_12MO_0_5);

CALL SYMPUT ("AVG_ORD_SZ_12MO_CP_50", AVG_ORD_SZ_12MO_CP_50);
CALL SYMPUT ("AVG_ORD_SZ_12MO_50", AVG_ORD_SZ_12MO_50);
CALL SYMPUT ("ONSALE_QTY_12MO_50", ONSALE_QTY_12MO_50);
CALL SYMPUT ("NUM_TXNS_SLS_PROMO_12MO_50", NUM_TXNS_SLS_PROMO_12MO_50);
CALL SYMPUT ("NET_SALES_AMT_12MO_RTN_50", NET_SALES_AMT_12MO_RTN_50);
CALL SYMPUT ("NET_SALES_AMT_12MO_SLS_50", NET_SALES_AMT_12MO_SLS_50);
CALL SYMPUT ("AVG_ORD_SZ_PROMO_12MO_50", AVG_ORD_SZ_PROMO_12MO_50);
CALL SYMPUT ("AVG_UNT_RTL_CP_50", AVG_UNT_RTL_CP_50);
CALL SYMPUT ("AVG_UNT_RTL_50", AVG_UNT_RTL_50);
CALL SYMPUT ("DISCOUNT_PCT_12MO_50", DISCOUNT_PCT_12MO_50);
CALL SYMPUT ("YEARS_ON_BOOKS_50", YEARS_ON_BOOKS_50);
CALL SYMPUT ("DISCOUNT_SLS_PROMO_12MO_50", DISCOUNT_SLS_PROMO_12MO_50);
CALL SYMPUT ("UNITS_PER_TXN_12MO_SLS_50", UNITS_PER_TXN_12MO_SLS_50);
CALL SYMPUT ("NUM_TXNS_12MO_SLS_50", NUM_TXNS_12MO_SLS_50);
CALL SYMPUT ("NUM_TXNS_12MO_RTN_50", NUM_TXNS_12MO_RTN_50);
CALL SYMPUT ("DIV_SHP_GP_50", DIV_SHP_GP_50);
CALL SYMPUT ("GP_PROMOTIONS_RECEIVED_12MO_50", GP_PROMOTIONS_RECEIVED_12MO_50);
CALL SYMPUT ("ONSALE_QTY_6MO_50", ONSALE_QTY_6MO_50);
CALL SYMPUT ("NET_SALES_SLS_PROMO_12MO_50", NET_SALES_SLS_PROMO_12MO_50);
CALL SYMPUT ("DAYS_LAST_PUR_GP_50", DAYS_LAST_PUR_GP_50);
CALL SYMPUT ("DAYS_LAST_PUR_CP_50", DAYS_LAST_PUR_CP_50);
CALL SYMPUT ("PLCC_TXN_PCT_50", PLCC_TXN_PCT_50);
CALL SYMPUT ("NUM_PLCC_TXNS_12MO_SLS_50", NUM_PLCC_TXNS_12MO_SLS_50);
CALL SYMPUT ("NUM_TXNS_12MO_ONL_SLS_50", NUM_TXNS_12MO_ONL_SLS_50);
CALL SYMPUT ("NET_SALES_AMT_12MO_ONL_SLS_50", NET_SALES_AMT_12MO_ONL_SLS_50);
CALL SYMPUT ("EMAILS_VIEWED_GP_50", EMAILS_VIEWED_GP_50);
CALL SYMPUT ("EMAILS_VIEWED_CP_50", EMAILS_VIEWED_CP_50);
CALL SYMPUT ("EMAILS_CLICKED_GP_50", EMAILS_CLICKED_GP_50);
CALL SYMPUT ("EMAILS_CLICKED_CP_50", EMAILS_CLICKED_CP_50);
CALL SYMPUT ("NET_SALES_ONL_PCT_12MO_50", NET_SALES_ONL_PCT_12MO_50);
CALL SYMPUT ("NUM_TXNS_ONL_PCT_12MO_50", NUM_TXNS_ONL_PCT_12MO_50);
CALL SYMPUT ("ITEM_QTY_ONL_PCT_12MO_50", ITEM_QTY_ONL_PCT_12MO_50);

CALL SYMPUT ("AVG_ORD_SZ_12MO_CP_UC", AVG_ORD_SZ_12MO_CP_99_5);
CALL SYMPUT ("AVG_ORD_SZ_12MO_UC", AVG_ORD_SZ_12MO_99_5);
CALL SYMPUT ("ONSALE_QTY_12MO_UC", ONSALE_QTY_12MO_99_5);
CALL SYMPUT ("NUM_TXNS_SLS_PROMO_12MO_UC", NUM_TXNS_SLS_PROMO_12MO_99_5);
CALL SYMPUT ("NET_SALES_AMT_12MO_RTN_UC", NET_SALES_AMT_12MO_RTN_99_5);
CALL SYMPUT ("NET_SALES_AMT_12MO_SLS_UC", NET_SALES_AMT_12MO_SLS_99_5);
CALL SYMPUT ("AVG_ORD_SZ_PROMO_12MO_UC", AVG_ORD_SZ_PROMO_12MO_99_5);
CALL SYMPUT ("AVG_UNT_RTL_CP_UC", AVG_UNT_RTL_CP_99_5);
CALL SYMPUT ("AVG_UNT_RTL_UC", AVG_UNT_RTL_99_5);
CALL SYMPUT ("DISCOUNT_PCT_12MO_UC", DISCOUNT_PCT_12MO_99_5);
CALL SYMPUT ("YEARS_ON_BOOKS_UC", YEARS_ON_BOOKS_99_5);
CALL SYMPUT ("DISCOUNT_SLS_PROMO_12MO_UC", DISCOUNT_SLS_PROMO_12MO_99_5);
CALL SYMPUT ("UNITS_PER_TXN_12MO_SLS_UC", UNITS_PER_TXN_12MO_SLS_99_5);
CALL SYMPUT ("NUM_TXNS_12MO_SLS_UC", NUM_TXNS_12MO_SLS_99_5);
CALL SYMPUT ("NUM_TXNS_12MO_RTN_UC", NUM_TXNS_12MO_RTN_99_5);
CALL SYMPUT ("DIV_SHP_GP_UC", DIV_SHP_GP_99_5);
CALL SYMPUT ("GP_PROMOTIONS_RECEIVED_12MO_UC", GP_PROMOTIONS_RECEIVED_12MO_99_5);
CALL SYMPUT ("ONSALE_QTY_6MO_UC", ONSALE_QTY_6MO_99_5);
CALL SYMPUT ("NET_SALES_SLS_PROMO_12MO_UC", NET_SALES_SLS_PROMO_12MO_99_5);
CALL SYMPUT ("DAYS_LAST_PUR_GP_UC", DAYS_LAST_PUR_GP_99_5);
CALL SYMPUT ("DAYS_LAST_PUR_CP_UC", DAYS_LAST_PUR_CP_99_5);
CALL SYMPUT ("PLCC_TXN_PCT_UC", PLCC_TXN_PCT_99_5);
CALL SYMPUT ("NUM_PLCC_TXNS_12MO_SLS_UC", NUM_PLCC_TXNS_12MO_SLS_99_5);
CALL SYMPUT ("NUM_TXNS_12MO_ONL_SLS_UC", NUM_TXNS_12MO_ONL_SLS_99_5);
CALL SYMPUT ("NET_SALES_AMT_12MO_ONL_SLS_UC", NET_SALES_AMT_12MO_ONL_SLS_99_5);
CALL SYMPUT ("EMAILS_VIEWED_GP_UC", EMAILS_VIEWED_GP_99_5);
CALL SYMPUT ("EMAILS_VIEWED_CP_UC", EMAILS_VIEWED_CP_99_5);
CALL SYMPUT ("EMAILS_CLICKED_GP_UC", EMAILS_CLICKED_GP_99_5);
CALL SYMPUT ("EMAILS_CLICKED_CP_UC", EMAILS_CLICKED_CP_99_5);
CALL SYMPUT ("NET_SALES_ONL_PCT_12MO_UC", NET_SALES_ONL_PCT_12MO_99_5);
CALL SYMPUT ("NUM_TXNS_ONL_PCT_12MO_UC", NUM_TXNS_ONL_PCT_12MO_99_5);
CALL SYMPUT ("ITEM_QTY_ONL_PCT_12MO_UC", ITEM_QTY_ONL_PCT_12MO_99_5);

RUN;


%PUT &AVG_ORD_SZ_12MO_CP_LC;	%PUT &AVG_ORD_SZ_12MO_CP_50;	%PUT &AVG_ORD_SZ_12MO_CP_UC;
%PUT &AVG_ORD_SZ_12MO_LC;	%PUT &AVG_ORD_SZ_12MO_50;	%PUT &AVG_ORD_SZ_12MO_UC;
%PUT &ONSALE_QTY_12MO_LC;	%PUT &ONSALE_QTY_12MO_50;	%PUT &ONSALE_QTY_12MO_UC;
%PUT &NUM_TXNS_SLS_PROMO_12MO_LC;	%PUT &NUM_TXNS_SLS_PROMO_12MO_50;	%PUT &NUM_TXNS_SLS_PROMO_12MO_UC;
%PUT &NET_SALES_AMT_12MO_RTN_LC;	%PUT &NET_SALES_AMT_12MO_RTN_50;	%PUT &NET_SALES_AMT_12MO_RTN_UC;
%PUT &NET_SALES_AMT_12MO_SLS_LC;	%PUT &NET_SALES_AMT_12MO_SLS_50;	%PUT &NET_SALES_AMT_12MO_SLS_UC;
%PUT &AVG_ORD_SZ_PROMO_12MO_LC;	%PUT &AVG_ORD_SZ_PROMO_12MO_50;	%PUT &AVG_ORD_SZ_PROMO_12MO_UC;
%PUT &AVG_UNT_RTL_CP_LC;	%PUT &AVG_UNT_RTL_CP_50;	%PUT &AVG_UNT_RTL_CP_UC;
%PUT &AVG_UNT_RTL_LC;	%PUT &AVG_UNT_RTL_50;	%PUT &AVG_UNT_RTL_UC;
%PUT &DISCOUNT_PCT_12MO_LC;	%PUT &DISCOUNT_PCT_12MO_50;	%PUT &DISCOUNT_PCT_12MO_UC;
%PUT &YEARS_ON_BOOKS_LC;	%PUT &YEARS_ON_BOOKS_50;	%PUT &YEARS_ON_BOOKS_UC;
%PUT &DISCOUNT_SLS_PROMO_12MO_LC;	%PUT &DISCOUNT_SLS_PROMO_12MO_50;	%PUT &DISCOUNT_SLS_PROMO_12MO_UC;
%PUT &UNITS_PER_TXN_12MO_SLS_LC;	%PUT &UNITS_PER_TXN_12MO_SLS_50;	%PUT &UNITS_PER_TXN_12MO_SLS_UC;
%PUT &NUM_TXNS_12MO_SLS_LC;	%PUT &NUM_TXNS_12MO_SLS_50;	%PUT &NUM_TXNS_12MO_SLS_UC;
%PUT &NUM_TXNS_12MO_RTN_LC;	%PUT &NUM_TXNS_12MO_RTN_50;	%PUT &NUM_TXNS_12MO_RTN_UC;
%PUT &DIV_SHP_GP_LC;	%PUT &DIV_SHP_GP_50;	%PUT &DIV_SHP_GP_UC;
%PUT &GP_PROMOTIONS_RECEIVED_12MO_LC;	%PUT &GP_PROMOTIONS_RECEIVED_12MO_50;	%PUT &GP_PROMOTIONS_RECEIVED_12MO_UC;
%PUT &ONSALE_QTY_6MO_LC;	%PUT &ONSALE_QTY_6MO_50;	%PUT &ONSALE_QTY_6MO_UC;
%PUT &NET_SALES_SLS_PROMO_12MO_LC;	%PUT &NET_SALES_SLS_PROMO_12MO_50;	%PUT &NET_SALES_SLS_PROMO_12MO_UC;
%PUT &DAYS_LAST_PUR_GP_LC;	%PUT &DAYS_LAST_PUR_GP_50;	%PUT &DAYS_LAST_PUR_GP_UC;
%PUT &DAYS_LAST_PUR_CP_LC;	%PUT &DAYS_LAST_PUR_CP_50;	%PUT &DAYS_LAST_PUR_CP_UC;
%PUT &PLCC_TXN_PCT_LC;	%PUT &PLCC_TXN_PCT_50;	%PUT &PLCC_TXN_PCT_UC;
%PUT &NUM_PLCC_TXNS_12MO_SLS_LC;	%PUT &NUM_PLCC_TXNS_12MO_SLS_50;	%PUT &NUM_PLCC_TXNS_12MO_SLS_UC;
%PUT &NUM_TXNS_12MO_ONL_SLS_LC;	%PUT &NUM_TXNS_12MO_ONL_SLS_50;	%PUT &NUM_TXNS_12MO_ONL_SLS_UC;
%PUT &NET_SALES_AMT_12MO_ONL_SLS_LC;	%PUT &NET_SALES_AMT_12MO_ONL_SLS_50;	%PUT &NET_SALES_AMT_12MO_ONL_SLS_UC;
%PUT &EMAILS_VIEWED_GP_LC;	%PUT &EMAILS_VIEWED_GP_50;	%PUT &EMAILS_VIEWED_GP_UC;
%PUT &EMAILS_VIEWED_CP_LC;	%PUT &EMAILS_VIEWED_CP_50;	%PUT &EMAILS_VIEWED_CP_UC;
%PUT &EMAILS_CLICKED_GP_LC;	%PUT &EMAILS_CLICKED_GP_50;	%PUT &EMAILS_CLICKED_GP_UC;
%PUT &EMAILS_CLICKED_CP_LC;	%PUT &EMAILS_CLICKED_CP_50;	%PUT &EMAILS_CLICKED_CP_UC;
%PUT &NET_SALES_ONL_PCT_12MO_LC;	%PUT &NET_SALES_ONL_PCT_12MO_50;	%PUT &NET_SALES_ONL_PCT_12MO_UC;
%PUT &NUM_TXNS_ONL_PCT_12MO_LC;	%PUT &NUM_TXNS_ONL_PCT_12MO_50;	%PUT &NUM_TXNS_ONL_PCT_12MO_UC;
%PUT &ITEM_QTY_ONL_PCT_12MO_LC;	%PUT &ITEM_QTY_ONL_PCT_12MO_50;	%PUT &ITEM_QTY_ONL_PCT_12MO_UC;



DATA &BRAND._&SAMPLENAME._COMBINED_2;
SET &BRAND._&SAMPLENAME._COMBINED_1;

IF AVG_ORD_SZ_12MO_CP GE &AVG_ORD_SZ_12MO_CP_UC THEN AVG_ORD_SZ_12MO_CP=&AVG_ORD_SZ_12MO_CP_UC;
IF AVG_ORD_SZ_12MO GE &AVG_ORD_SZ_12MO_UC THEN AVG_ORD_SZ_12MO=&AVG_ORD_SZ_12MO_UC;
IF ONSALE_QTY_12MO GE &ONSALE_QTY_12MO_UC THEN ONSALE_QTY_12MO=&ONSALE_QTY_12MO_UC;
IF NUM_TXNS_SLS_PROMO_12MO GE &NUM_TXNS_SLS_PROMO_12MO_UC THEN NUM_TXNS_SLS_PROMO_12MO=&NUM_TXNS_SLS_PROMO_12MO_UC;
IF NET_SALES_AMT_12MO_RTN GE &NET_SALES_AMT_12MO_RTN_UC THEN NET_SALES_AMT_12MO_RTN=&NET_SALES_AMT_12MO_RTN_UC;
IF NET_SALES_AMT_12MO_SLS GE &NET_SALES_AMT_12MO_SLS_UC THEN NET_SALES_AMT_12MO_SLS=&NET_SALES_AMT_12MO_SLS_UC;
IF AVG_ORD_SZ_PROMO_12MO GE &AVG_ORD_SZ_PROMO_12MO_UC THEN AVG_ORD_SZ_PROMO_12MO=&AVG_ORD_SZ_PROMO_12MO_UC;
IF AVG_UNT_RTL_CP GE &AVG_UNT_RTL_CP_UC THEN AVG_UNT_RTL_CP=&AVG_UNT_RTL_CP_UC;
IF AVG_UNT_RTL GE &AVG_UNT_RTL_UC THEN AVG_UNT_RTL=&AVG_UNT_RTL_UC;
IF DISCOUNT_PCT_12MO GE &DISCOUNT_PCT_12MO_UC THEN DISCOUNT_PCT_12MO=&DISCOUNT_PCT_12MO_UC;
IF YEARS_ON_BOOKS GE &YEARS_ON_BOOKS_UC THEN YEARS_ON_BOOKS=&YEARS_ON_BOOKS_UC;
IF DISCOUNT_SLS_PROMO_12MO GE &DISCOUNT_SLS_PROMO_12MO_UC THEN DISCOUNT_SLS_PROMO_12MO=&DISCOUNT_SLS_PROMO_12MO_UC;
IF UNITS_PER_TXN_12MO_SLS GE &UNITS_PER_TXN_12MO_SLS_UC THEN UNITS_PER_TXN_12MO_SLS=&UNITS_PER_TXN_12MO_SLS_UC;
IF NUM_TXNS_12MO_SLS GE &NUM_TXNS_12MO_SLS_UC THEN NUM_TXNS_12MO_SLS=&NUM_TXNS_12MO_SLS_UC;
IF NUM_TXNS_12MO_RTN GE &NUM_TXNS_12MO_RTN_UC THEN NUM_TXNS_12MO_RTN=&NUM_TXNS_12MO_RTN_UC;
IF DIV_SHP_GP GE &DIV_SHP_GP_UC THEN DIV_SHP_GP=&DIV_SHP_GP_UC;
IF GP_PROMOTIONS_RECEIVED_12MO GE &GP_PROMOTIONS_RECEIVED_12MO_UC THEN GP_PROMOTIONS_RECEIVED_12MO=&GP_PROMOTIONS_RECEIVED_12MO_UC;
IF ONSALE_QTY_6MO GE &ONSALE_QTY_6MO_UC THEN ONSALE_QTY_6MO=&ONSALE_QTY_6MO_UC;
IF NET_SALES_SLS_PROMO_12MO GE &NET_SALES_SLS_PROMO_12MO_UC THEN NET_SALES_SLS_PROMO_12MO=&NET_SALES_SLS_PROMO_12MO_UC;
IF DAYS_LAST_PUR_GP GE &DAYS_LAST_PUR_GP_UC THEN DAYS_LAST_PUR_GP=&DAYS_LAST_PUR_GP_UC;
IF DAYS_LAST_PUR_CP GE &DAYS_LAST_PUR_CP_UC THEN DAYS_LAST_PUR_CP=&DAYS_LAST_PUR_CP_UC;
IF PLCC_TXN_PCT GE &PLCC_TXN_PCT_UC THEN PLCC_TXN_PCT=&PLCC_TXN_PCT_UC;
IF NUM_PLCC_TXNS_12MO_SLS GE &NUM_PLCC_TXNS_12MO_SLS_UC THEN NUM_PLCC_TXNS_12MO_SLS=&NUM_PLCC_TXNS_12MO_SLS_UC;
IF NUM_TXNS_12MO_ONL_SLS GE &NUM_TXNS_12MO_ONL_SLS_UC THEN NUM_TXNS_12MO_ONL_SLS=&NUM_TXNS_12MO_ONL_SLS_UC;
IF NET_SALES_AMT_12MO_ONL_SLS GE &NET_SALES_AMT_12MO_ONL_SLS_UC THEN NET_SALES_AMT_12MO_ONL_SLS=&NET_SALES_AMT_12MO_ONL_SLS_UC;
IF EMAILS_VIEWED_GP GE &EMAILS_VIEWED_GP_UC THEN EMAILS_VIEWED_GP=&EMAILS_VIEWED_GP_UC;
IF EMAILS_VIEWED_CP GE &EMAILS_VIEWED_CP_UC THEN EMAILS_VIEWED_CP=&EMAILS_VIEWED_CP_UC;
IF EMAILS_CLICKED_GP GE &EMAILS_CLICKED_GP_UC THEN EMAILS_CLICKED_GP=&EMAILS_CLICKED_GP_UC;
IF EMAILS_CLICKED_CP GE &EMAILS_CLICKED_CP_UC THEN EMAILS_CLICKED_CP=&EMAILS_CLICKED_CP_UC;
IF NET_SALES_ONL_PCT_12MO GE &NET_SALES_ONL_PCT_12MO_UC THEN NET_SALES_ONL_PCT_12MO=&NET_SALES_ONL_PCT_12MO_UC;
IF NUM_TXNS_ONL_PCT_12MO GE &NUM_TXNS_ONL_PCT_12MO_UC THEN NUM_TXNS_ONL_PCT_12MO=&NUM_TXNS_ONL_PCT_12MO_UC;
IF ITEM_QTY_ONL_PCT_12MO GE &ITEM_QTY_ONL_PCT_12MO_UC THEN ITEM_QTY_ONL_PCT_12MO=&ITEM_QTY_ONL_PCT_12MO_UC;


IF AVG_ORD_SZ_12MO_CP LE &AVG_ORD_SZ_12MO_CP_LC THEN AVG_ORD_SZ_12MO_CP=&AVG_ORD_SZ_12MO_CP_LC;
IF AVG_ORD_SZ_12MO LE &AVG_ORD_SZ_12MO_LC THEN AVG_ORD_SZ_12MO=&AVG_ORD_SZ_12MO_LC;
IF ONSALE_QTY_12MO LE &ONSALE_QTY_12MO_LC THEN ONSALE_QTY_12MO=&ONSALE_QTY_12MO_LC;
IF NUM_TXNS_SLS_PROMO_12MO LE &NUM_TXNS_SLS_PROMO_12MO_LC THEN NUM_TXNS_SLS_PROMO_12MO=&NUM_TXNS_SLS_PROMO_12MO_LC;
IF NET_SALES_AMT_12MO_RTN LE &NET_SALES_AMT_12MO_RTN_LC THEN NET_SALES_AMT_12MO_RTN=&NET_SALES_AMT_12MO_RTN_LC;
IF NET_SALES_AMT_12MO_SLS LE &NET_SALES_AMT_12MO_SLS_LC THEN NET_SALES_AMT_12MO_SLS=&NET_SALES_AMT_12MO_SLS_LC;
IF AVG_ORD_SZ_PROMO_12MO LE &AVG_ORD_SZ_PROMO_12MO_LC THEN AVG_ORD_SZ_PROMO_12MO=&AVG_ORD_SZ_PROMO_12MO_LC;
IF AVG_UNT_RTL_CP LE &AVG_UNT_RTL_CP_LC THEN AVG_UNT_RTL_CP=&AVG_UNT_RTL_CP_LC;
IF AVG_UNT_RTL LE &AVG_UNT_RTL_LC THEN AVG_UNT_RTL=&AVG_UNT_RTL_LC;
IF DISCOUNT_PCT_12MO LE &DISCOUNT_PCT_12MO_LC THEN DISCOUNT_PCT_12MO=&DISCOUNT_PCT_12MO_LC;
IF YEARS_ON_BOOKS LE &YEARS_ON_BOOKS_LC THEN YEARS_ON_BOOKS=&YEARS_ON_BOOKS_LC;
IF DISCOUNT_SLS_PROMO_12MO LE &DISCOUNT_SLS_PROMO_12MO_LC THEN DISCOUNT_SLS_PROMO_12MO=&DISCOUNT_SLS_PROMO_12MO_LC;
IF UNITS_PER_TXN_12MO_SLS LE &UNITS_PER_TXN_12MO_SLS_LC THEN UNITS_PER_TXN_12MO_SLS=&UNITS_PER_TXN_12MO_SLS_LC;
IF NUM_TXNS_12MO_SLS LE &NUM_TXNS_12MO_SLS_LC THEN NUM_TXNS_12MO_SLS=&NUM_TXNS_12MO_SLS_LC;
IF NUM_TXNS_12MO_RTN LE &NUM_TXNS_12MO_RTN_LC THEN NUM_TXNS_12MO_RTN=&NUM_TXNS_12MO_RTN_LC;
IF DIV_SHP_GP LE &DIV_SHP_GP_LC THEN DIV_SHP_GP=&DIV_SHP_GP_LC;
IF GP_PROMOTIONS_RECEIVED_12MO LE &GP_PROMOTIONS_RECEIVED_12MO_LC THEN GP_PROMOTIONS_RECEIVED_12MO=&GP_PROMOTIONS_RECEIVED_12MO_LC;
IF ONSALE_QTY_6MO LE &ONSALE_QTY_6MO_LC THEN ONSALE_QTY_6MO=&ONSALE_QTY_6MO_LC;
IF NET_SALES_SLS_PROMO_12MO LE &NET_SALES_SLS_PROMO_12MO_LC THEN NET_SALES_SLS_PROMO_12MO=&NET_SALES_SLS_PROMO_12MO_LC;
IF DAYS_LAST_PUR_GP LE &DAYS_LAST_PUR_GP_LC THEN DAYS_LAST_PUR_GP=&DAYS_LAST_PUR_GP_LC;
IF DAYS_LAST_PUR_CP LE &DAYS_LAST_PUR_CP_LC THEN DAYS_LAST_PUR_CP=&DAYS_LAST_PUR_CP_LC;
IF PLCC_TXN_PCT LE &PLCC_TXN_PCT_LC THEN PLCC_TXN_PCT=&PLCC_TXN_PCT_LC;
IF NUM_PLCC_TXNS_12MO_SLS LE &NUM_PLCC_TXNS_12MO_SLS_LC THEN NUM_PLCC_TXNS_12MO_SLS=&NUM_PLCC_TXNS_12MO_SLS_LC;
IF NUM_TXNS_12MO_ONL_SLS LE &NUM_TXNS_12MO_ONL_SLS_LC THEN NUM_TXNS_12MO_ONL_SLS=&NUM_TXNS_12MO_ONL_SLS_LC;
IF NET_SALES_AMT_12MO_ONL_SLS LE &NET_SALES_AMT_12MO_ONL_SLS_LC THEN NET_SALES_AMT_12MO_ONL_SLS=&NET_SALES_AMT_12MO_ONL_SLS_LC;
IF EMAILS_VIEWED_GP LE &EMAILS_VIEWED_GP_LC THEN EMAILS_VIEWED_GP=&EMAILS_VIEWED_GP_LC;
IF EMAILS_VIEWED_CP LE &EMAILS_VIEWED_CP_LC THEN EMAILS_VIEWED_CP=&EMAILS_VIEWED_CP_LC;
IF EMAILS_CLICKED_GP LE &EMAILS_CLICKED_GP_LC THEN EMAILS_CLICKED_GP=&EMAILS_CLICKED_GP_LC;
IF EMAILS_CLICKED_CP LE &EMAILS_CLICKED_CP_LC THEN EMAILS_CLICKED_CP=&EMAILS_CLICKED_CP_LC;
IF NET_SALES_ONL_PCT_12MO LE &NET_SALES_ONL_PCT_12MO_LC THEN NET_SALES_ONL_PCT_12MO=&NET_SALES_ONL_PCT_12MO_LC;
IF NUM_TXNS_ONL_PCT_12MO LE &NUM_TXNS_ONL_PCT_12MO_LC THEN NUM_TXNS_ONL_PCT_12MO=&NUM_TXNS_ONL_PCT_12MO_LC;
IF ITEM_QTY_ONL_PCT_12MO LE &ITEM_QTY_ONL_PCT_12MO_LC THEN ITEM_QTY_ONL_PCT_12MO=&ITEM_QTY_ONL_PCT_12MO_LC;

RUN;


DATA &BRAND._&SAMPLENAME._COMBINED_3;
SET &BRAND._&SAMPLENAME._COMBINED_2;

AVG_ORD_SZ_12MO_CP = (AVG_ORD_SZ_12MO_CP - &AVG_ORD_SZ_12MO_CP_LC) / (&AVG_ORD_SZ_12MO_CP_UC - &AVG_ORD_SZ_12MO_CP_LC);
AVG_ORD_SZ_12MO = (AVG_ORD_SZ_12MO - &AVG_ORD_SZ_12MO_LC) / (&AVG_ORD_SZ_12MO_UC - &AVG_ORD_SZ_12MO_LC);
ONSALE_QTY_12MO = (ONSALE_QTY_12MO - &ONSALE_QTY_12MO_LC) / (&ONSALE_QTY_12MO_UC - &ONSALE_QTY_12MO_LC);
NUM_TXNS_SLS_PROMO_12MO = (NUM_TXNS_SLS_PROMO_12MO - &NUM_TXNS_SLS_PROMO_12MO_LC) / (&NUM_TXNS_SLS_PROMO_12MO_UC - &NUM_TXNS_SLS_PROMO_12MO_LC);
NET_SALES_AMT_12MO_RTN = (NET_SALES_AMT_12MO_RTN - &NET_SALES_AMT_12MO_RTN_LC) / (&NET_SALES_AMT_12MO_RTN_UC - &NET_SALES_AMT_12MO_RTN_LC);
NET_SALES_AMT_12MO_SLS = (NET_SALES_AMT_12MO_SLS - &NET_SALES_AMT_12MO_SLS_LC) / (&NET_SALES_AMT_12MO_SLS_UC - &NET_SALES_AMT_12MO_SLS_LC);
AVG_ORD_SZ_PROMO_12MO = (AVG_ORD_SZ_PROMO_12MO - &AVG_ORD_SZ_PROMO_12MO_LC) / (&AVG_ORD_SZ_PROMO_12MO_UC - &AVG_ORD_SZ_PROMO_12MO_LC);
AVG_UNT_RTL_CP = (AVG_UNT_RTL_CP - &AVG_UNT_RTL_CP_LC) / (&AVG_UNT_RTL_CP_UC - &AVG_UNT_RTL_CP_LC);
AVG_UNT_RTL = (AVG_UNT_RTL - &AVG_UNT_RTL_LC) / (&AVG_UNT_RTL_UC - &AVG_UNT_RTL_LC);
DISCOUNT_PCT_12MO = (DISCOUNT_PCT_12MO - &DISCOUNT_PCT_12MO_LC) / (&DISCOUNT_PCT_12MO_UC - &DISCOUNT_PCT_12MO_LC);
YEARS_ON_BOOKS = (YEARS_ON_BOOKS - &YEARS_ON_BOOKS_LC) / (&YEARS_ON_BOOKS_UC - &YEARS_ON_BOOKS_LC);
DISCOUNT_SLS_PROMO_12MO = (DISCOUNT_SLS_PROMO_12MO - &DISCOUNT_SLS_PROMO_12MO_LC) / (&DISCOUNT_SLS_PROMO_12MO_UC - &DISCOUNT_SLS_PROMO_12MO_LC);
UNITS_PER_TXN_12MO_SLS = (UNITS_PER_TXN_12MO_SLS - &UNITS_PER_TXN_12MO_SLS_LC) / (&UNITS_PER_TXN_12MO_SLS_UC - &UNITS_PER_TXN_12MO_SLS_LC);
NUM_TXNS_12MO_SLS = (NUM_TXNS_12MO_SLS - &NUM_TXNS_12MO_SLS_LC) / (&NUM_TXNS_12MO_SLS_UC - &NUM_TXNS_12MO_SLS_LC);
NUM_TXNS_12MO_RTN = (NUM_TXNS_12MO_RTN - &NUM_TXNS_12MO_RTN_LC) / (&NUM_TXNS_12MO_RTN_UC - &NUM_TXNS_12MO_RTN_LC);
DIV_SHP_GP = (DIV_SHP_GP - &DIV_SHP_GP_LC) / (&DIV_SHP_GP_UC - &DIV_SHP_GP_LC);
GP_PROMOTIONS_RECEIVED_12MO = (GP_PROMOTIONS_RECEIVED_12MO - &GP_PROMOTIONS_RECEIVED_12MO_LC) / (&GP_PROMOTIONS_RECEIVED_12MO_UC - &GP_PROMOTIONS_RECEIVED_12MO_LC);
ONSALE_QTY_6MO = (ONSALE_QTY_6MO - &ONSALE_QTY_6MO_LC) / (&ONSALE_QTY_6MO_UC - &ONSALE_QTY_6MO_LC);
NET_SALES_SLS_PROMO_12MO = (NET_SALES_SLS_PROMO_12MO - &NET_SALES_SLS_PROMO_12MO_LC) / (&NET_SALES_SLS_PROMO_12MO_UC - &NET_SALES_SLS_PROMO_12MO_LC);
DAYS_LAST_PUR_GP = (DAYS_LAST_PUR_GP - &DAYS_LAST_PUR_GP_LC) / (&DAYS_LAST_PUR_GP_UC - &DAYS_LAST_PUR_GP_LC);
DAYS_LAST_PUR_CP = (DAYS_LAST_PUR_CP - &DAYS_LAST_PUR_CP_LC) / (&DAYS_LAST_PUR_CP_UC - &DAYS_LAST_PUR_CP_LC);
PLCC_TXN_PCT = (PLCC_TXN_PCT - &PLCC_TXN_PCT_LC) / (&PLCC_TXN_PCT_UC - &PLCC_TXN_PCT_LC);
NUM_PLCC_TXNS_12MO_SLS = (NUM_PLCC_TXNS_12MO_SLS - &NUM_PLCC_TXNS_12MO_SLS_LC) / (&NUM_PLCC_TXNS_12MO_SLS_UC - &NUM_PLCC_TXNS_12MO_SLS_LC);
NUM_TXNS_12MO_ONL_SLS = (NUM_TXNS_12MO_ONL_SLS - &NUM_TXNS_12MO_ONL_SLS_LC) / (&NUM_TXNS_12MO_ONL_SLS_UC - &NUM_TXNS_12MO_ONL_SLS_LC);
NET_SALES_AMT_12MO_ONL_SLS = (NET_SALES_AMT_12MO_ONL_SLS - &NET_SALES_AMT_12MO_ONL_SLS_LC) / (&NET_SALES_AMT_12MO_ONL_SLS_UC - &NET_SALES_AMT_12MO_ONL_SLS_LC);
EMAILS_VIEWED_GP = (EMAILS_VIEWED_GP - &EMAILS_VIEWED_GP_LC) / (&EMAILS_VIEWED_GP_UC - &EMAILS_VIEWED_GP_LC);
EMAILS_VIEWED_CP = (EMAILS_VIEWED_CP - &EMAILS_VIEWED_CP_LC) / (&EMAILS_VIEWED_CP_UC - &EMAILS_VIEWED_CP_LC);
EMAILS_CLICKED_GP = (EMAILS_CLICKED_GP - &EMAILS_CLICKED_GP_LC) / (&EMAILS_CLICKED_GP_UC - &EMAILS_CLICKED_GP_LC);
EMAILS_CLICKED_CP = (EMAILS_CLICKED_CP - &EMAILS_CLICKED_CP_LC) / (&EMAILS_CLICKED_CP_UC - &EMAILS_CLICKED_CP_LC);
NET_SALES_ONL_PCT_12MO = (NET_SALES_ONL_PCT_12MO - &NET_SALES_ONL_PCT_12MO_LC) / (&NET_SALES_ONL_PCT_12MO_UC - &NET_SALES_ONL_PCT_12MO_LC);
NUM_TXNS_ONL_PCT_12MO = (NUM_TXNS_ONL_PCT_12MO - &NUM_TXNS_ONL_PCT_12MO_LC) / (&NUM_TXNS_ONL_PCT_12MO_UC - &NUM_TXNS_ONL_PCT_12MO_LC);
ITEM_QTY_ONL_PCT_12MO = (ITEM_QTY_ONL_PCT_12MO - &ITEM_QTY_ONL_PCT_12MO_LC) / (&ITEM_QTY_ONL_PCT_12MO_UC - &ITEM_QTY_ONL_PCT_12MO_LC);

RUN;

PROC MEANS DATA=&BRAND._&SAMPLENAME._COMBINED_3 N NMISS;
VAR _NUMERIC_;
RUN;



PROC LOGISTIC INMODEL=DATALIB.GP_EM_BALANCED_MODEL_1;
 SCORE DATA=&BRAND._&SAMPLENAME._COMBINED_3 OUT=&BRAND._&SAMPLENAME._COMBINED_4;
RUN;


DATA DATALIB.&BRAND._&SAMPLENAME._COMBINED_SCORE;
 KEEP CAMPAIGN CUSTOMER_KEY CARD_STATUS NUM_TXNS_12MO_SLS ACTIVE_FLAG RESPONDER P_1 POFFSET_1;
 SET &BRAND._&SAMPLENAME._COMBINED_4;
 IF P_1 NE 1;
 LOGIT_1=LOG(P_1) - LOG(1-P_1);
 POFFSET_1=LOGISTIC(LOGIT_1-OFFSET);
 LABEL P_1 = "RESP_PROB_1";
 RENAME P_1 = RESP_PROB_1;
 DROP P_0;
 ACTIVE_FLAG=0;
 IF NUM_TXNS_12MO_SLS > 0 THEN ACTIVE_FLAG=1;
RUN;


