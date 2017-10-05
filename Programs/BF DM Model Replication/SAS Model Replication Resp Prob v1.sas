*ASSIGN LIBRARIES;

LIBNAME TA4U1R9 ORACLE USER=TA4U1R9 PW="T$numoy009$!" PATH=SAS10P1 PRESERVE_TAB_NAMES=YES SCHEMA=TA4U1R9;

LIBNAME CORESAS ORACLE USER=TA4U1R9 PW="T$numoy009$!" PATH=SAS10P1 PRESERVE_TAB_NAMES=YES SCHEMA=CORESAS;

LIBNAME DATALIB "\\10.8.8.51\LV0\TANUMOY\DATASETS\MODEL REPLICATION";

LIBNAME MODLIB "\\10.8.8.51\LV0\TANUMOY\DATASETS\MODEL DIAGNOSTICS";

OPTIONS MACROGEN SYMBOLGEN MLOGIC MPRINT;

DM "LOG" CLEAR;

%LET REMHOST=PAEPHAP5.GAP.COM;

OPTIONS REMOTE=REMHOST;

FILENAME PMINSCR 'C:\PROGRAM FILES\SAS\SASFOUNDATION\9.2\CONNECT\SASLINK\TCPUNIX.SCR';

SIGNON  SCRIPT=PMINSCR;

*IMPORT THE DATA FROM TA4U1R9 USER SCHEMA IN MDS TO LOCAL DRIVE THROUGH SAS;

%MACRO IMPORT(LIBNAME, SAMPLES, INPUTLIB);

 PROC DATASETS LIBRARY=&INPUTLIB MEMTYPE=DATA NODETAILS;
  CONTENTS OUT=WORK.TEMP1 (KEEP=MEMNAME) DATA=_ALL_ NOPRINT;
 RUN;

 DATA TEMP1;  SET TEMP1;
  WHERE MEMNAME NE "QUEST_TEMP_EXPLAIN" AND INDEX(MEMNAME,"DATERANGE")=0
		  AND  INDEX(MEMNAME,"ORDLN")=0 AND INDEX(MEMNAME,"TXN_P365")=0
		  AND  INDEX(MEMNAME,"BF")>0 AND INDEX(MEMNAME,"MAILED_SEGS")=0
		  AND  INDEX(MEMNAME,"COMBINED")=0 AND INDEX(MEMNAME,"SHOPPED")=0
		  AND  INDEX(MEMNAME,"REDEEMED")=0 AND INDEX(MEMNAME,"SCORES")=0
		  AND  INDEX(MEMNAME,"BALANCED")=0 ;
 RUN;

 PROC SQL UNDO_POLICY=NONE;
  CREATE TABLE TEMP1 AS SELECT DISTINCT * FROM TEMP1;
 QUIT;

 
 %LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

 %DO I=1 %TO &SAMPLECOUNT;
   %LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   %PUT &SAMPLENAME;

   DATA TEMP2; SET TEMP1; WHERE INDEX(MEMNAME,"_&SAMPLENAME._")>0; RUN;

   %LET BASEDS=BF_&SAMPLENAME._DM;
   
    PROC SQL UNDO_POLICY=NONE;
	 SELECT COUNT(*) INTO: NUM_DATASETS FROM TEMP2;
	QUIT;
    
	DATA &LIBNAME..&BASEDS;
	 SET &INPUTLIB..&BASEDS;
	RUN;

    PROC SORT DATA=&LIBNAME..&BASEDS OUT=&LIBNAME..BF_&SAMPLENAME._COMBINED;
	 BY CUSTOMER_KEY;
	RUN;

   %DO J=1 %TO &NUM_DATASETS;

     DATA TEMP3; SET TEMP2; IF _N_=&J; 
	  CALL SYMPUT("DSNAME", MEMNAME);
	 RUN;
		
	 %PUT &DSNAME; 

	 %IF &DSNAME NE &BASEDS %THEN %DO;
	 	
	    DATA &LIBNAME..&DSNAME;
		 SET &INPUTLIB..&DSNAME;
		RUN;

		PROC SQL;
		 *DROP TABLE &INPUTLIB..&DSNAME;
		QUIT;

		PROC SORT DATA=&LIBNAME..&DSNAME;
		 BY CUSTOMER_KEY;
		RUN;

		DATA &LIBNAME..BF_&SAMPLENAME._COMBINED;
		 MERGE &LIBNAME..BF_&SAMPLENAME._COMBINED (IN=A)
			   &LIBNAME..&DSNAME (IN=B);
  		 BY CUSTOMER_KEY;
		 IF A=1;
		RUN;

     %END;

   %END;

   DATA &LIBNAME..BF_&SAMPLENAME._COMBINED;
    SET &LIBNAME..BF_&SAMPLENAME._COMBINED;
	LENGTH CELL_LABEL_1 $200.; LENGTH TREATMENT_CODE_1 $200.; LENGTH EVENT_TYPE_1 $200.;
	FORMAT CELL_LABEL_1 $200.; FORMAT TREATMENT_CODE_1 $200.; FORMAT EVENT_TYPE_1 $200.;
	CELL_LABEL_1=CELL_LABEL; TREATMENT_CODE_1=TREATMENT_CODE; EVENT_TYPE_1=EVENT_TYPE;
	DROP CELL_LABEL TREATMENT_CODE EVENT_TYPE;
	RENAME CELL_LABEL_1=CELL_LABEL;
	RENAME TREATMENT_CODE_1=TREATMENT_CODE;
	RENAME EVENT_TYPE_1=EVENT_TYPE;
   RUN;
   
   DATA &LIBNAME..BF_&SAMPLENAME._COMBINED(DROP=Z);                                                    
    SET &LIBNAME..BF_&SAMPLENAME._COMBINED;                                                            
    ARRAY TESTMISS(*) _NUMERIC_;                                            
    DO Z = 1 TO DIM(TESTMISS);                                              
     IF TESTMISS(Z)=. THEN TESTMISS(Z)=0;                                    
    END;                                                                    
   RUN; 

 %END;

%MEND;

%IMPORT(LIBNAME=DATALIB, INPUTLIB=DATALIB, SAMPLES = 227235 231472 233761 235492 239675 240331);

* 227235 231472 233761 235492 239675 240331;

%MACRO DATES(LIBNAME, SAMPLES, INPUTLIB);

 %LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

 %DO I=1 %TO &SAMPLECOUNT;
   %LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   %PUT &SAMPLENAME;
   
  
   DATA &LIBNAME..BF_&SAMPLENAME._COMBINED;
    FORMAT START_DT_1 DATE9.; FORMAT END_DT_1 DATE9.;
 	SET &LIBNAME..BF_&SAMPLENAME._COMBINED;
 	START_DT_1=DATEPART(START_DT); END_DT_1=DATEPART(END_DT);
 	DROP START_DT END_DT;
 	RENAME START_DT_1=START_DT; RENAME END_DT_1=END_DT;
   RUN;

 %END;

%MEND;

%DATES(LIBNAME=DATALIB, INPUTLIB=DATALIB, SAMPLES= 227235 231472 233761 235492 239675 240331);



*IMPORT THE DATA FROM TA4U1R9 USER SCHEMA IN MDS TO LOCAL DRIVE THROUGH SAS;

%MACRO APPEND(LIBNAME, SAMPLES, INPUTLIB);

 %LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

 %DO I=1 %TO &SAMPLECOUNT;
   %LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   %PUT &SAMPLENAME;
   
   DATA &LIBNAME..BF_&SAMPLENAME._COMBINED;
	SET &LIBNAME..BF_&SAMPLENAME._COMBINED;
	CAMPAIGN="&SAMPLENAME";
   RUN;

   %IF &I=1 %THEN %DO;
    DATA &LIBNAME..BF_ALLCAMPAIGNS_COMBINED;
	 SET &LIBNAME..BF_&SAMPLENAME._COMBINED;
	RUN;
   %END;

   %IF &I>1 %THEN %DO;
    PROC APPEND BASE=&LIBNAME..BF_ALLCAMPAIGNS_COMBINED
				DATA=&LIBNAME..BF_&SAMPLENAME._COMBINED FORCE;
	RUN;
   %END;

 %END;

%MEND;

%APPEND(LIBNAME=DATALIB, INPUTLIB=DATALIB, SAMPLES= 227235 231472 233761 235492 239675 240331);



%MACRO CHECK(LIBNAME, SAMPLES, INPUTLIB);

 %LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

 %DO I=1 %TO &SAMPLECOUNT;
   %LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   %PUT &SAMPLENAME;
   
   PROC SQL UNDO_POLICY=NONE;
    SELECT DISTINCT START_DT, END_DT FROM &LIBNAME..BF_&SAMPLENAME._DM;
   QUIT;
   
   PROC FREQ DATA=&LIBNAME..BF_&SAMPLENAME._COMBINED;
    TABLE RESPONDER;
   RUN;

 %END;

%MEND;

%CHECK(LIBNAME=DATALIB, INPUTLIB=TA4U1R9, SAMPLES= 227235 231472 233761 235492 239675 240331);


%MACRO ALTER(LIBNAME, SAMPLES, INPUTLIB);

 %LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

 %DO I=1 %TO &SAMPLECOUNT;
   %LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   %PUT &SAMPLENAME;
   
   DATA &LIBNAME..BF_&SAMPLENAME._DM;
    DROP CAMPAIGN_LABEL CAMPAIGN_CODE; 
    SET &LIBNAME..BF_&SAMPLENAME._DM;
   RUN;

   DATA &LIBNAME..BF_&SAMPLENAME._COMBINED;
    DROP CAMPAIGN_LABEL CAMPAIGN_CODE; 
    SET &LIBNAME..BF_&SAMPLENAME._COMBINED;
   RUN;
   
  %END;

%MEND;

%ALTER(LIBNAME=DATALIB, INPUTLIB=TA4U1R9, SAMPLES= 227235 231472 233761 235492 239675 240331);


DATA DATALIB.BF_ALLCAMPAIGNS_COMBINED;
SET DATALIB.BF_ALLCAMPAIGNS_COMBINED;

IF CAMPAIGN="227235" THEN CAMPAIGN_CODE="BRFS_DM_20110604_SUMMER";
IF CAMPAIGN="231472" THEN CAMPAIGN_CODE="BRFS_DM_20111202_HOLIDAYDM_2";
IF CAMPAIGN="233761" THEN CAMPAIGN_CODE="BRFS_DM_20120301_SPRING_V2";
IF CAMPAIGN="235492" THEN CAMPAIGN_CODE="BRFS_DM_20120510_SUMMER";
IF CAMPAIGN="239675" THEN CAMPAIGN_CODE="BRFS_DM_20121011_FALL2";
IF CAMPAIGN="240331" THEN CAMPAIGN_CODE="BRFS_DM_20121129_HOLIDAY";

IF CAMPAIGN="227235" THEN CAMPAIGN_LABEL="BRFS_DM_20110604_SUMMER";
IF CAMPAIGN="231472" THEN CAMPAIGN_LABEL="BRFS_DM_20111202_HOLIDAYDM_2";
IF CAMPAIGN="233761" THEN CAMPAIGN_LABEL="BRFS_DM_20120301_SPRING_V2";
IF CAMPAIGN="235492" THEN CAMPAIGN_LABEL="BRFS_DM_20120510_SUMMER";
IF CAMPAIGN="239675" THEN CAMPAIGN_LABEL="BRFS_DM_20121011_FALL2";
IF CAMPAIGN="240331" THEN CAMPAIGN_LABEL="BRFS_DM_20121129_HOLIDAY";

RUN;


DATA DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 SET DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 TREATMENT_GROUP=1;
 IF TREATMENT_CODE EQ LOWCASE("CONTROL") THEN TREATMENT_GROUP=0;
RUN;
*FIND PROPORTION OF RESPONDERS AND NON RESPONDERS IN THE COMBINED SAMPLE AND STORE THE VALUES IN GLOBAL VARIABLES;

PROC SQL;
 SELECT COUNT(*) INTO: RESPONDERS FROM DATALIB.BF_ALLCAMPAIGNS_COMBINED WHERE RESPONDER=1;
 SELECT COUNT(*) INTO: NONRESPONDERS FROM DATALIB.BF_ALLCAMPAIGNS_COMBINED WHERE RESPONDER=0;
QUIT;

%LET PROP_RESPONDERS=%SYSEVALF(&RESPONDERS/%SYSEVALF(&RESPONDERS+&NONRESPONDERS));
%LET PROP_NONRESPONDERS=%SYSEVALF(&NONRESPONDERS/%SYSEVALF(&RESPONDERS+&NONRESPONDERS));
%PUT &PROP_RESPONDERS &PROP_NONRESPONDERS;

*ASSIGN GLOBAL VARIABLES;

DM "OUTPUT" CLEAR;
%LET SEED=3000;
%LET TRAIN_TEST=0.7;

*CREATE TRAINING AND TESTING/VALIDATION DATASETS FROM THE COMBINED SAMPLE. 
 ALSO CREATE THE OFFSET VARIABLE TO ADJUST THE INTERCEPT FOR BALANCING;

DATA DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 SET DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 RANDOM_NO=RANUNI(&SEED);
 TRAINING=0; TESTING=0;
 IF RANDOM_NO<=&TRAIN_TEST THEN TRAINING=1;
 IF RANDOM_NO>&TRAIN_TEST THEN TESTING=1;
RUN;


*CREATE A BALANCED SAMPLE FOR RESPONDERS AND NONRESPONDERS;

DATA DATALIB.BF_ALLCAMPAIGNS_RESPONDERS;
 SET DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 WHERE RESPONDER=1;
 DROP RANDOM_NO;
RUN;

DATA DATALIB.BF_ALLCAMPAIGNS_NONRESPONDERS;
 SET DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 WHERE RESPONDER=0;
 RANDOM_NO=RANUNI(&SEED);
RUN;

PROC SORT DATA=DATALIB.BF_ALLCAMPAIGNS_NONRESPONDERS
		  OUT=BF_ALLCAMPAIGNS_NONRESPONDERS;
 BY RANDOM_NO;
RUN;

DATA BF_ALLCAMPAIGNS_NONRESPONDERS;
 SET BF_ALLCAMPAIGNS_NONRESPONDERS;
 IF _N_<=ROUND(&RESPONDERS);
 DROP RANDOM_NO;
RUN;



DATA DATALIB.BF_ALLCAMPAIGNS_BALANCED;
 SET DATALIB.BF_ALLCAMPAIGNS_RESPONDERS;
RUN;

PROC APPEND BASE=DATALIB.BF_ALLCAMPAIGNS_BALANCED
            DATA=BF_ALLCAMPAIGNS_NONRESPONDERS FORCE;
RUN;

PROC FREQ DATA=DATALIB.BF_ALLCAMPAIGNS_BALANCED;
 TABLE RESPONDER;
RUN;

*FIND PROPORTION OF RESPONDERS AND NON RESPONDERS IN THE BALANCED SAMPLE AND STORE THE VALUES IN GLOBAL VARIABLES;

PROC SQL;
 SELECT COUNT(*) INTO: RESPONDERS_BAL FROM DATALIB.BF_ALLCAMPAIGNS_BALANCED WHERE RESPONDER=1;
 SELECT COUNT(*) INTO: NONRESPONDERS_BAL FROM DATALIB.BF_ALLCAMPAIGNS_BALANCED WHERE RESPONDER=0;
QUIT;

%LET PROP_RESPONDERS_BAL=%SYSEVALF(&RESPONDERS_BAL/%SYSEVALF(&RESPONDERS_BAL+&NONRESPONDERS_BAL));
%LET PROP_NONRESPONDERS_BAL=%SYSEVALF(&NONRESPONDERS_BAL/%SYSEVALF(&RESPONDERS_BAL+&NONRESPONDERS_BAL));
%PUT &PROP_RESPONDERS_BAL &PROP_NONRESPONDERS_BAL;


DATA DATALIB.BF_ALLCAMPAIGNS_RESP_PROP;
 PROP_RESPONDERS = &PROP_RESPONDERS;
 PROP_RESPONDERS_BAL = &PROP_RESPONDERS_BAL;
 PROP_NONRESPONDERS = &PROP_NONRESPONDERS;
 PROP_NONRESPONDERS_BAL = &PROP_NONRESPONDERS_BAL;
RUN;


DATA DATALIB.BF_ALLCAMPAIGNS_RESP_PROP;
 SET DATALIB.BF_ALLCAMPAIGNS_RESP_PROP;
 CALL SYMPUT ("PROP_RESPONDERS", PROP_RESPONDERS);
 CALL SYMPUT ("PROP_RESPONDERS_BAL", PROP_RESPONDERS_BAL);
 CALL SYMPUT ("PROP_NONRESPONDERS", PROP_NONRESPONDERS);
 CALL SYMPUT ("PROP_NONRESPONDERS_BAL", PROP_NONRESPONDERS_BAL);
RUN;

PROC SQL;
 CREATE TABLE TEST AS SELECT DISTINCT UPCASE(TREATMENT_CODE) as TREATMENT_CODE FROM DATALIB.BF_ALLCAMPAIGNS_BALANCED;
QUIT;

PROC EXPORT DATA=TEST
			OUTFILE="Z:\TANUMOY\DATASETS\MODEL REPLICATION\BF_OFFER_DETAILS_TRAIN.TXT"
            DBMS=DLM REPLACE;
     DELIMITER="|";
RUN;


 


*CREATE THE ADDITIONAL METRICS FOR THE BALANCED AND UNBALANCED DATASETS;

DATA DATALIB.BF_ALLCAMPAIGNS_BALANCED;
 SET DATALIB.BF_ALLCAMPAIGNS_BALANCED;

 LENGTH_PROMO=END_DT-START_DT+1;

 IF RESPONDER=1 THEN WT=&PROP_RESPONDERS/&PROP_RESPONDERS_BAL;
 IF RESPONDER=0 THEN WT=&PROP_NONRESPONDERS/&PROP_NONRESPONDERS_BAL;

 NET_SALES_AMT_12MO_SLS=GROSS_SALES_AMT_12MO_SLS+DISCOUNT_AMT_12MO_SLS;
 NET_SALES_AMT_12MO_SLS_CP=GROSS_SALES_AMT_12MO_SLS_CP+DISCOUNT_AMT_12MO_SLS_CP;
 NET_SALES_AMT_12MO_SLS_OTH=NET_SALES_AMT_12MO_SLS_CP-NET_SALES_AMT_12MO_SLS;

 NET_SALES_AMT_12MO_RTN = -(GROSS_SALES_AMT_12MO_RTN+DISCOUNT_AMT_12MO_RTN);
 NET_SALES_AMT_12MO_RTN_CP = -(GROSS_SALES_AMT_12MO_RTN_CP+DISCOUNT_AMT_12MO_RTN_CP);
 NET_SALES_AMT_12MO_RTN_OTH = NET_SALES_AMT_12MO_RTN_CP-NET_SALES_AMT_12MO_RTN;

 UNITS_PER_TXN_12MO_SLS=0;
 IF NUM_TXNS_12MO_SLS NE 0 THEN 
	UNITS_PER_TXN_12MO_SLS=ITEM_QTY_12MO_SLS/NUM_TXNS_12MO_SLS;

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

DATA DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 SET DATALIB.BF_ALLCAMPAIGNS_COMBINED;

 LENGTH_PROMO=END_DT-START_DT+1;

 IF RESPONDER=1 THEN WT=&PROP_RESPONDERS/&PROP_RESPONDERS_BAL;
 IF RESPONDER=0 THEN WT=&PROP_NONRESPONDERS/&PROP_NONRESPONDERS_BAL;

 NET_SALES_AMT_12MO_SLS=GROSS_SALES_AMT_12MO_SLS+DISCOUNT_AMT_12MO_SLS;
 NET_SALES_AMT_12MO_SLS_CP=GROSS_SALES_AMT_12MO_SLS_CP+DISCOUNT_AMT_12MO_SLS_CP;
 NET_SALES_AMT_12MO_SLS_OTH=NET_SALES_AMT_12MO_SLS_CP-NET_SALES_AMT_12MO_SLS;

 NET_SALES_AMT_12MO_RTN = -(GROSS_SALES_AMT_12MO_RTN+DISCOUNT_AMT_12MO_RTN);
 NET_SALES_AMT_12MO_RTN_CP = -(GROSS_SALES_AMT_12MO_RTN_CP+DISCOUNT_AMT_12MO_RTN_CP);
 NET_SALES_AMT_12MO_RTN_OTH = NET_SALES_AMT_12MO_RTN_CP-NET_SALES_AMT_12MO_RTN;

 UNITS_PER_TXN_12MO_SLS=0;
 IF NUM_TXNS_12MO_SLS NE 0 THEN 
	UNITS_PER_TXN_12MO_SLS=ITEM_QTY_12MO_SLS/NUM_TXNS_12MO_SLS;

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

DATA DATALIB.BF_ALLCAMPAIGNS_BALANCED;
 SET DATALIB.BF_ALLCAMPAIGNS_BALANCED;
 DROP RATIO_BR_BRFS;
 NET_SALES_AMT_12MO_SLS_BR = GROSS_SALES_AMT_12MO_SLS_BR + DISCOUNT_AMT_12MO_SLS_BR;
 NET_SALES_AMT_12MO_RTN_BR = -(GROSS_SALES_AMT_12MO_RTN_BR + DISCOUNT_AMT_12MO_RTN_BR);
 RATIO_BR_BF = 0;
 IF NET_SALES_AMT_12MO_SLS NE 0 THEN RATIO_BR_BF = NET_SALES_AMT_12MO_SLS_BR/NET_SALES_AMT_12MO_SLS;
RUN;

DATA DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 SET DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 DROP RATIO_BR_BRFS;
 NET_SALES_AMT_12MO_SLS_BR = GROSS_SALES_AMT_12MO_SLS_BR + DISCOUNT_AMT_12MO_SLS_BR;
 NET_SALES_AMT_12MO_RTN_BR = -(GROSS_SALES_AMT_12MO_RTN_BR + DISCOUNT_AMT_12MO_RTN_BR);
 RATIO_BR_BF = 0;
 IF NET_SALES_AMT_12MO_SLS NE 0 THEN RATIO_BR_BF = NET_SALES_AMT_12MO_SLS_BR/NET_SALES_AMT_12MO_SLS;
RUN;

PROC FREQ DATA=DATALIB.BF_ALLCAMPAIGNS_BALANCED;
 TABLE RESPONDER;
 WEIGHT WT;
RUN;

PROC IMPORT DATAFILE="\\10.8.8.51\LV0\TANUMOY\DATASETS\MODEL REPLICATION\BF_OFFER_DETAILS_TRAIN.TXT"
     DBMS=DLM OUT=DATALIB.BF_OFFER_DETAILS_TRAIN REPLACE; 
DELIMITER="|"; 
GETNAMES=YES;
RUN;



*FIND THE LOWER CUTOFF PERCENTILE, MEDIAN AND UPPER CUTOFF PERCENTILE VALUES FOR THE FEATURES TO BE USED FOR CAPPING LATER ON;

PROC UNIVARIATE DATA=DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 VAR AVG_ORD_SZ_12MO_CP  AVG_ORD_SZ_12MO ONSALE_QTY_12MO 
 	 NET_SALES_AMT_12MO_SLS_BR NET_SALES_AMT_12MO_RTN_BR
	 NET_SALES_AMT_12MO_RTN NET_SALES_AMT_12MO_SLS RATIO_BR_BF
	 AVG_UNT_RTL_CP	AVG_UNT_RTL DISCOUNT_PCT_12MO YEARS_ON_BOOKS 
	 UNITS_PER_TXN_12MO_SLS NUM_TXNS_12MO_SLS  NUM_TXNS_12MO_RTN
     DIV_SHP_BF BF_PROMOTIONS_RECEIVED_12MO ONSALE_QTY_6MO
	 DAYS_LAST_PUR_BF DAYS_LAST_PUR_CP PLCC_TXN_PCT NUM_PLCC_TXNS_12MO_SLS;
     
OUTPUT OUT=DATALIB.BF_ALLCAMPAIGNS_COMBINED_PCTL
	   PCTLPRE = AVG_ORD_SZ_12MO_CP_ AVG_ORD_SZ_12MO_ ONSALE_QTY_12MO_ 
	   			 NET_SALES_AMT_12MO_SLS_BR_ NET_SALES_AMT_12MO_RTN_BR_
				 NET_SALES_AMT_12MO_RTN_ NET_SALES_AMT_12MO_SLS_ RATIO_BR_BF_
				 AVG_UNT_RTL_CP_  AVG_UNT_RTL_ DISCOUNT_PCT_12MO_ YEARS_ON_BOOKS_ 
				 UNITS_PER_TXN_12MO_SLS_ NUM_TXNS_12MO_SLS_ NUM_TXNS_12MO_RTN_
     			 DIV_SHP_BF_ BF_PROMOTIONS_RECEIVED_12MO_ ONSALE_QTY_6MO_
				 DAYS_LAST_PUR_BF_ DAYS_LAST_PUR_CP_ PLCC_TXN_PCT_ NUM_PLCC_TXNS_12MO_SLS_
	   PCTLPTS= 0.3 50 99.7;
RUN;

DATA BF_ALLCAMPAIGNS_BALANCED_1;
 KEEP NET_SALES_AMT AVG_ORD_SZ_12MO_CP AVG_ORD_SZ_12MO CARD_STATUS
 	  NET_SALES_AMT_12MO_SLS_BR NET_SALES_AMT_12MO_RTN_BR
	  ONSALE_QTY_12MO NET_SALES_AMT_12MO_RTN NET_SALES_AMT_12MO_SLS 
	  AVG_UNT_RTL_CP AVG_UNT_RTL DISCOUNT_PCT_12MO YEARS_ON_BOOKS 
	  UNITS_PER_TXN_12MO_SLS NUM_TXNS_12MO_SLS  NUM_TXNS_12MO_RTN
      DIV_SHP_BF BF_PROMOTIONS_RECEIVED_12MO ONSALE_QTY_6MO
	  TREATMENT_GROUP CUSTOMER_KEY RESPONDER TRAINING RATIO_BR_BF
 	  NET_SALES_AMT CAMPAIGN TESTING  OFFSET WT DAYS_LAST_PUR_CP
	  TREATMENT_CODE LENGTH_PROMO DAYS_LAST_PUR_BF RESPONSE_RATE_12MO 
	  PLCC_TXN_PCT NUM_PLCC_TXNS_12MO_SLS BASIC_FLAG SILVER_FLAG SISTER_FLAG; 
 SET DATALIB.BF_ALLCAMPAIGNS_BALANCED;
RUN;

*STORE THE 0.3 PERCENTILE, MEDIAN AND 99.7 PERCENTILE VALUES FOR THE FEATURES IN GLOBAL VARIABLES;

DATA DATALIB.BF_ALLCAMPAIGNS_COMBINED_PCTL;
SET DATALIB.BF_ALLCAMPAIGNS_COMBINED_PCTL;

 CALL SYMPUT ("AVG_ORD_SZ_12MO_CP_LC", AVG_ORD_SZ_12MO_CP_0_3);
 CALL SYMPUT ("AVG_ORD_SZ_12MO_CP_50", AVG_ORD_SZ_12MO_CP_50);
 CALL SYMPUT ("AVG_ORD_SZ_12MO_CP_UC", AVG_ORD_SZ_12MO_CP_99_7);

 CALL SYMPUT ("AVG_ORD_SZ_12MO_LC", AVG_ORD_SZ_12MO_0_3);
 CALL SYMPUT ("AVG_ORD_SZ_12MO_50", AVG_ORD_SZ_12MO_50);
 CALL SYMPUT ("AVG_ORD_SZ_12MO_UC", AVG_ORD_SZ_12MO_99_7);

 CALL SYMPUT ("ONSALE_QTY_12MO_LC", ONSALE_QTY_12MO_0_3);
 CALL SYMPUT ("ONSALE_QTY_12MO_50", ONSALE_QTY_12MO_50);
 CALL SYMPUT ("ONSALE_QTY_12MO_UC", ONSALE_QTY_12MO_99_7);

 CALL SYMPUT ("NET_SALES_AMT_12MO_RTN_LC", NET_SALES_AMT_12MO_RTN_0_3);
 CALL SYMPUT ("NET_SALES_AMT_12MO_RTN_50", NET_SALES_AMT_12MO_RTN_50);
 CALL SYMPUT ("NET_SALES_AMT_12MO_RTN_UC", NET_SALES_AMT_12MO_RTN_99_7);

 CALL SYMPUT ("NET_SALES_AMT_12MO_SLS_LC", NET_SALES_AMT_12MO_SLS_0_3);
 CALL SYMPUT ("NET_SALES_AMT_12MO_SLS_50", NET_SALES_AMT_12MO_SLS_50);
 CALL SYMPUT ("NET_SALES_AMT_12MO_SLS_UC", NET_SALES_AMT_12MO_SLS_99_7);

 CALL SYMPUT ("AVG_UNT_RTL_CP_LC", AVG_UNT_RTL_CP_0_3);
 CALL SYMPUT ("AVG_UNT_RTL_CP_50", AVG_UNT_RTL_CP_50);
 CALL SYMPUT ("AVG_UNT_RTL_CP_UC", AVG_UNT_RTL_CP_99_7);

 CALL SYMPUT ("AVG_UNT_RTL_LC", AVG_UNT_RTL_0_3);
 CALL SYMPUT ("AVG_UNT_RTL_50", AVG_UNT_RTL_50);
 CALL SYMPUT ("AVG_UNT_RTL_UC", AVG_UNT_RTL_99_7);

 CALL SYMPUT ("DISCOUNT_PCT_12MO_LC", DISCOUNT_PCT_12MO_0_3);
 CALL SYMPUT ("DISCOUNT_PCT_12MO_50", DISCOUNT_PCT_12MO_50);
 CALL SYMPUT ("DISCOUNT_PCT_12MO_UC", DISCOUNT_PCT_12MO_99_7);

 CALL SYMPUT ("YEARS_ON_BOOKS_LC", YEARS_ON_BOOKS_0_3);
 CALL SYMPUT ("YEARS_ON_BOOKS_50", YEARS_ON_BOOKS_50);
 CALL SYMPUT ("YEARS_ON_BOOKS_UC", YEARS_ON_BOOKS_99_7);

 CALL SYMPUT ("UNITS_PER_TXN_12MO_SLS_LC", UNITS_PER_TXN_12MO_SLS_0_3);
 CALL SYMPUT ("UNITS_PER_TXN_12MO_SLS_50", UNITS_PER_TXN_12MO_SLS_50);
 CALL SYMPUT ("UNITS_PER_TXN_12MO_SLS_UC", UNITS_PER_TXN_12MO_SLS_99_7);

 CALL SYMPUT ("NUM_TXNS_12MO_SLS_LC", NUM_TXNS_12MO_SLS_0_3);
 CALL SYMPUT ("NUM_TXNS_12MO_SLS_50", NUM_TXNS_12MO_SLS_50);
 CALL SYMPUT ("NUM_TXNS_12MO_SLS_UC", NUM_TXNS_12MO_SLS_99_7); 

 CALL SYMPUT ("NUM_TXNS_12MO_RTN_LC", NUM_TXNS_12MO_RTN_0_3); 
 CALL SYMPUT ("NUM_TXNS_12MO_RTN_50", NUM_TXNS_12MO_RTN_50);
 CALL SYMPUT ("NUM_TXNS_12MO_RTN_UC", NUM_TXNS_12MO_RTN_99_7);

 CALL SYMPUT ("DIV_SHP_BF_LC", DIV_SHP_BF_0_3);
 CALL SYMPUT ("DIV_SHP_BF_50", DIV_SHP_BF_50);
 CALL SYMPUT ("DIV_SHP_BF_UC", DIV_SHP_BF_99_7);

 CALL SYMPUT ("BF_PROMOTIONS_RECEIVED_12MO_LC", BF_PROMOTIONS_RECEIVED_12MO_0_3);
 CALL SYMPUT ("BF_PROMOTIONS_RECEIVED_12MO_50", BF_PROMOTIONS_RECEIVED_12MO_50);
 CALL SYMPUT ("BF_PROMOTIONS_RECEIVED_12MO_UC", BF_PROMOTIONS_RECEIVED_12MO_99_7);

 CALL SYMPUT ("ONSALE_QTY_6MO_LC", ONSALE_QTY_6MO_0_3);
 CALL SYMPUT ("ONSALE_QTY_6MO_50", ONSALE_QTY_6MO_50);
 CALL SYMPUT ("ONSALE_QTY_6MO_UC", ONSALE_QTY_6MO_99_7); 

 CALL SYMPUT ("DAYS_LAST_PUR_BF_LC", DAYS_LAST_PUR_BF_0_3);
 CALL SYMPUT ("DAYS_LAST_PUR_BF_50", DAYS_LAST_PUR_BF_50);
 CALL SYMPUT ("DAYS_LAST_PUR_BF_UC", DAYS_LAST_PUR_BF_99_7);

 CALL SYMPUT ("DAYS_LAST_PUR_CP_LC", DAYS_LAST_PUR_CP_0_3);
 CALL SYMPUT ("DAYS_LAST_PUR_CP_50", DAYS_LAST_PUR_CP_50);
 CALL SYMPUT ("DAYS_LAST_PUR_CP_UC", DAYS_LAST_PUR_CP_99_7); 

 CALL SYMPUT ("PLCC_TXN_PCT_LC", PLCC_TXN_PCT_0_3);
 CALL SYMPUT ("PLCC_TXN_PCT_50", PLCC_TXN_PCT_50);
 CALL SYMPUT ("PLCC_TXN_PCT_UC", PLCC_TXN_PCT_99_7); 

 CALL SYMPUT ("NUM_PLCC_TXNS_12MO_SLS_LC", NUM_PLCC_TXNS_12MO_SLS_0_3);
 CALL SYMPUT ("NUM_PLCC_TXNS_12MO_SLS_50", NUM_PLCC_TXNS_12MO_SLS_50);
 CALL SYMPUT ("NUM_PLCC_TXNS_12MO_SLS_UC", NUM_PLCC_TXNS_12MO_SLS_99_7); 

 CALL SYMPUT ("NET_SALES_AMT_12MO_RTN_BR_LC", NET_SALES_AMT_12MO_RTN_BR_0_3);
 CALL SYMPUT ("NET_SALES_AMT_12MO_RTN_BR_50", NET_SALES_AMT_12MO_RTN_BR_50);
 CALL SYMPUT ("NET_SALES_AMT_12MO_RTN_BR_UC", NET_SALES_AMT_12MO_RTN_BR_99_7);

 CALL SYMPUT ("NET_SALES_AMT_12MO_SLS_BR_LC", NET_SALES_AMT_12MO_SLS_BR_0_3);
 CALL SYMPUT ("NET_SALES_AMT_12MO_SLS_BR_50", NET_SALES_AMT_12MO_SLS_BR_50);
 CALL SYMPUT ("NET_SALES_AMT_12MO_SLS_BR_UC", NET_SALES_AMT_12MO_SLS_BR_99_7);

 CALL SYMPUT ("RATIO_BR_BF_LC", RATIO_BR_BF_0_3);
 CALL SYMPUT ("RATIO_BR_BF_50", RATIO_BR_BF_50);
 CALL SYMPUT ("RATIO_BR_BF_UC", RATIO_BR_BF_99_7);
RUN;

*CAP THE VARIABLES AT THEIR 0.5 PERCENTILE AND 99.5 PERCENTILE VALUES;

DATA BF_ALLCAMPAIGNS_BALANCED_2;
SET BF_ALLCAMPAIGNS_BALANCED_1;

IF AVG_ORD_SZ_12MO_CP > &AVG_ORD_SZ_12MO_CP_UC THEN AVG_ORD_SZ_12MO_CP = &AVG_ORD_SZ_12MO_CP_UC;
IF AVG_ORD_SZ_12MO > &AVG_ORD_SZ_12MO_UC THEN AVG_ORD_SZ_12MO = &AVG_ORD_SZ_12MO_UC;
IF ONSALE_QTY_12MO > &ONSALE_QTY_12MO_UC THEN ONSALE_QTY_12MO = &ONSALE_QTY_12MO_UC;
IF NET_SALES_AMT_12MO_RTN > &NET_SALES_AMT_12MO_RTN_UC THEN NET_SALES_AMT_12MO_RTN = &NET_SALES_AMT_12MO_RTN_UC;
IF NET_SALES_AMT_12MO_SLS > &NET_SALES_AMT_12MO_SLS_UC THEN NET_SALES_AMT_12MO_SLS = &NET_SALES_AMT_12MO_SLS_UC;
IF AVG_UNT_RTL_CP > &AVG_UNT_RTL_CP_UC THEN AVG_UNT_RTL_CP = &AVG_UNT_RTL_CP_UC;
IF AVG_UNT_RTL > &AVG_UNT_RTL_UC THEN AVG_UNT_RTL = &AVG_UNT_RTL_UC;
IF DISCOUNT_PCT_12MO > &DISCOUNT_PCT_12MO_UC THEN DISCOUNT_PCT_12MO = &DISCOUNT_PCT_12MO_UC;
IF YEARS_ON_BOOKS > &YEARS_ON_BOOKS_UC THEN YEARS_ON_BOOKS = &YEARS_ON_BOOKS_UC;
IF UNITS_PER_TXN_12MO_SLS > &UNITS_PER_TXN_12MO_SLS_UC THEN UNITS_PER_TXN_12MO_SLS = &UNITS_PER_TXN_12MO_SLS_UC;
IF NUM_TXNS_12MO_SLS > &NUM_TXNS_12MO_SLS_UC THEN NUM_TXNS_12MO_SLS = &NUM_TXNS_12MO_SLS_UC;
IF NUM_TXNS_12MO_RTN > &NUM_TXNS_12MO_RTN_UC THEN NUM_TXNS_12MO_RTN = &NUM_TXNS_12MO_RTN_UC;
IF DIV_SHP_BF > &DIV_SHP_BF_UC THEN DIV_SHP_BF = &DIV_SHP_BF_UC;
IF BF_PROMOTIONS_RECEIVED_12MO > &BF_PROMOTIONS_RECEIVED_12MO_UC THEN BF_PROMOTIONS_RECEIVED_12MO = &BF_PROMOTIONS_RECEIVED_12MO_UC;
IF ONSALE_QTY_6MO > &ONSALE_QTY_6MO_UC THEN ONSALE_QTY_6MO = &ONSALE_QTY_6MO_UC;
IF DAYS_LAST_PUR_CP > &DAYS_LAST_PUR_CP_UC THEN DAYS_LAST_PUR_CP = &DAYS_LAST_PUR_CP_UC;
IF DAYS_LAST_PUR_BF > &DAYS_LAST_PUR_BF_UC THEN DAYS_LAST_PUR_BF = &DAYS_LAST_PUR_BF_UC;
IF PLCC_TXN_PCT > &PLCC_TXN_PCT_UC THEN PLCC_TXN_PCT = &PLCC_TXN_PCT_UC;
IF NUM_PLCC_TXNS_12MO_SLS > &NUM_PLCC_TXNS_12MO_SLS_UC THEN NUM_PLCC_TXNS_12MO_SLS = &NUM_PLCC_TXNS_12MO_SLS_UC;
IF NET_SALES_AMT_12MO_RTN_BR > &NET_SALES_AMT_12MO_RTN_BR_UC THEN NET_SALES_AMT_12MO_RTN_BR = &NET_SALES_AMT_12MO_RTN_BR_UC;
IF NET_SALES_AMT_12MO_SLS_BR > &NET_SALES_AMT_12MO_SLS_BR_UC THEN NET_SALES_AMT_12MO_SLS_BR = &NET_SALES_AMT_12MO_SLS_BR_UC;
IF RATIO_BR_BF > &RATIO_BR_BF_UC THEN RATIO_BR_BF = &RATIO_BR_BF_UC;

IF AVG_ORD_SZ_12MO_CP < &AVG_ORD_SZ_12MO_CP_LC THEN AVG_ORD_SZ_12MO_CP = &AVG_ORD_SZ_12MO_CP_LC;
IF AVG_ORD_SZ_12MO < &AVG_ORD_SZ_12MO_LC THEN AVG_ORD_SZ_12MO = &AVG_ORD_SZ_12MO_LC;
IF ONSALE_QTY_12MO < &ONSALE_QTY_12MO_LC THEN ONSALE_QTY_12MO = &ONSALE_QTY_12MO_LC;
IF NET_SALES_AMT_12MO_RTN < &NET_SALES_AMT_12MO_RTN_LC THEN NET_SALES_AMT_12MO_RTN = &NET_SALES_AMT_12MO_RTN_LC;
IF NET_SALES_AMT_12MO_SLS < &NET_SALES_AMT_12MO_SLS_LC THEN NET_SALES_AMT_12MO_SLS = &NET_SALES_AMT_12MO_SLS_LC;
IF AVG_UNT_RTL_CP < &AVG_UNT_RTL_CP_LC THEN AVG_UNT_RTL_CP = &AVG_UNT_RTL_CP_LC;
IF AVG_UNT_RTL < &AVG_UNT_RTL_LC THEN AVG_UNT_RTL = &AVG_UNT_RTL_LC;
IF DISCOUNT_PCT_12MO < &DISCOUNT_PCT_12MO_LC THEN DISCOUNT_PCT_12MO = &DISCOUNT_PCT_12MO_LC;
IF YEARS_ON_BOOKS < &YEARS_ON_BOOKS_LC THEN YEARS_ON_BOOKS = &YEARS_ON_BOOKS_LC;
IF UNITS_PER_TXN_12MO_SLS < &UNITS_PER_TXN_12MO_SLS_LC THEN UNITS_PER_TXN_12MO_SLS = &UNITS_PER_TXN_12MO_SLS_LC;
IF NUM_TXNS_12MO_SLS < &NUM_TXNS_12MO_SLS_LC THEN NUM_TXNS_12MO_SLS = &NUM_TXNS_12MO_SLS_LC;
IF NUM_TXNS_12MO_RTN < &NUM_TXNS_12MO_RTN_LC THEN NUM_TXNS_12MO_RTN = &NUM_TXNS_12MO_RTN_LC;
IF DIV_SHP_BF < &DIV_SHP_BF_LC THEN DIV_SHP_BF = &DIV_SHP_BF_LC;
IF BF_PROMOTIONS_RECEIVED_12MO < &BF_PROMOTIONS_RECEIVED_12MO_LC THEN BF_PROMOTIONS_RECEIVED_12MO = &BF_PROMOTIONS_RECEIVED_12MO_LC;
IF ONSALE_QTY_6MO < &ONSALE_QTY_6MO_LC THEN ONSALE_QTY_6MO = &ONSALE_QTY_6MO_LC;
IF DAYS_LAST_PUR_CP < &DAYS_LAST_PUR_CP_LC THEN DAYS_LAST_PUR_CP = &DAYS_LAST_PUR_CP_LC;
IF DAYS_LAST_PUR_BF < &DAYS_LAST_PUR_BF_LC THEN DAYS_LAST_PUR_BF = &DAYS_LAST_PUR_BF_LC;
IF PLCC_TXN_PCT < &PLCC_TXN_PCT_LC THEN PLCC_TXN_PCT = &PLCC_TXN_PCT_LC;
IF NUM_PLCC_TXNS_12MO_SLS < &NUM_PLCC_TXNS_12MO_SLS_LC THEN NUM_PLCC_TXNS_12MO_SLS = &NUM_PLCC_TXNS_12MO_SLS_LC;
IF NET_SALES_AMT_12MO_RTN_BR < &NET_SALES_AMT_12MO_RTN_BR_LC THEN NET_SALES_AMT_12MO_RTN_BR = &NET_SALES_AMT_12MO_RTN_BR_LC;
IF NET_SALES_AMT_12MO_SLS_BR < &NET_SALES_AMT_12MO_SLS_BR_LC THEN NET_SALES_AMT_12MO_SLS_BR = &NET_SALES_AMT_12MO_SLS_BR_LC;
IF RATIO_BR_BF < &RATIO_BR_BF_LC THEN RATIO_BR_BF = &RATIO_BR_BF_LC;

RUN;

*SCALE THE VARIABLES SO THAT THEY RANGE BETWEEN 0 AND 1;

DATA BF_ALLCAMPAIGNS_BALANCED_3;
SET BF_ALLCAMPAIGNS_BALANCED_2;

AVG_ORD_SZ_12MO_CP = (AVG_ORD_SZ_12MO_CP - &AVG_ORD_SZ_12MO_CP_LC) / (&AVG_ORD_SZ_12MO_CP_UC - &AVG_ORD_SZ_12MO_CP_LC);
AVG_ORD_SZ_12MO = (AVG_ORD_SZ_12MO - &AVG_ORD_SZ_12MO_LC) / (&AVG_ORD_SZ_12MO_UC - &AVG_ORD_SZ_12MO_LC);
ONSALE_QTY_12MO = (ONSALE_QTY_12MO - &ONSALE_QTY_12MO_LC) / (&ONSALE_QTY_12MO_UC - &ONSALE_QTY_12MO_LC);
NET_SALES_AMT_12MO_RTN = (NET_SALES_AMT_12MO_RTN - &NET_SALES_AMT_12MO_RTN_LC) / (&NET_SALES_AMT_12MO_RTN_UC - &NET_SALES_AMT_12MO_RTN_LC);
NET_SALES_AMT_12MO_SLS = (NET_SALES_AMT_12MO_SLS - &NET_SALES_AMT_12MO_SLS_LC) / (&NET_SALES_AMT_12MO_SLS_UC - &NET_SALES_AMT_12MO_SLS_LC);
AVG_UNT_RTL_CP = (AVG_UNT_RTL_CP - &AVG_UNT_RTL_CP_LC) / (&AVG_UNT_RTL_CP_UC - &AVG_UNT_RTL_CP_LC);
AVG_UNT_RTL = (AVG_UNT_RTL - &AVG_UNT_RTL_LC) / (&AVG_UNT_RTL_UC - &AVG_UNT_RTL_LC);
DISCOUNT_PCT_12MO = (DISCOUNT_PCT_12MO - &DISCOUNT_PCT_12MO_LC) / (&DISCOUNT_PCT_12MO_UC - &DISCOUNT_PCT_12MO_LC);
YEARS_ON_BOOKS = (YEARS_ON_BOOKS - &YEARS_ON_BOOKS_LC) / (&YEARS_ON_BOOKS_UC - &YEARS_ON_BOOKS_LC);
UNITS_PER_TXN_12MO_SLS = (UNITS_PER_TXN_12MO_SLS - &UNITS_PER_TXN_12MO_SLS_LC) / (&UNITS_PER_TXN_12MO_SLS_UC - &UNITS_PER_TXN_12MO_SLS_LC);
NUM_TXNS_12MO_SLS = (NUM_TXNS_12MO_SLS - &NUM_TXNS_12MO_SLS_LC) / (&NUM_TXNS_12MO_SLS_UC - &NUM_TXNS_12MO_SLS_LC);
NUM_TXNS_12MO_RTN = (NUM_TXNS_12MO_RTN - &NUM_TXNS_12MO_RTN_LC) / (&NUM_TXNS_12MO_RTN_UC - &NUM_TXNS_12MO_RTN_LC);
DIV_SHP_BF = (DIV_SHP_BF - &DIV_SHP_BF_LC) / (&DIV_SHP_BF_UC - &DIV_SHP_BF_LC);
BF_PROMOTIONS_RECEIVED_12MO = (BF_PROMOTIONS_RECEIVED_12MO - &BF_PROMOTIONS_RECEIVED_12MO_LC) / (&BF_PROMOTIONS_RECEIVED_12MO_UC - &BF_PROMOTIONS_RECEIVED_12MO_LC);
ONSALE_QTY_6MO = (ONSALE_QTY_6MO - &ONSALE_QTY_6MO_LC) / (&ONSALE_QTY_6MO_UC - &ONSALE_QTY_6MO_LC);
DAYS_LAST_PUR_BF = (DAYS_LAST_PUR_BF - &DAYS_LAST_PUR_BF_LC) / (&DAYS_LAST_PUR_BF_UC - &DAYS_LAST_PUR_BF_LC);
DAYS_LAST_PUR_CP = (DAYS_LAST_PUR_CP - &DAYS_LAST_PUR_CP_LC) / (&DAYS_LAST_PUR_CP_UC - &DAYS_LAST_PUR_CP_LC);
PLCC_TXN_PCT = (PLCC_TXN_PCT - &PLCC_TXN_PCT_LC) / (&PLCC_TXN_PCT_UC - &PLCC_TXN_PCT_LC);
NUM_PLCC_TXNS_12MO_SLS = (NUM_PLCC_TXNS_12MO_SLS - &NUM_PLCC_TXNS_12MO_SLS_LC) / (&NUM_PLCC_TXNS_12MO_SLS_UC - &NUM_PLCC_TXNS_12MO_SLS_LC);
NET_SALES_AMT_12MO_RTN_BR = (NET_SALES_AMT_12MO_RTN_BR - &NET_SALES_AMT_12MO_RTN_BR_LC) / (&NET_SALES_AMT_12MO_RTN_BR_UC - &NET_SALES_AMT_12MO_RTN_BR_LC);
NET_SALES_AMT_12MO_SLS_BR = (NET_SALES_AMT_12MO_SLS_BR - &NET_SALES_AMT_12MO_SLS_BR_LC) / (&NET_SALES_AMT_12MO_SLS_BR_UC - &NET_SALES_AMT_12MO_SLS_BR_LC);
RATIO_BR_BF = (RATIO_BR_BF - &RATIO_BR_BF_LC) / (&RATIO_BR_BF_UC - &RATIO_BR_BF_LC);

RUN;

DATA DATALIB.BF_ALLCAMPAIGNS_BALANCED_MOD;
 SET BF_ALLCAMPAIGNS_BALANCED_3;
RUN;

PROC EXPORT DATA=DATALIB.BF_ALLCAMPAIGNS_BALANCED_MOD
			OUTFILE="Z:\TANUMOY\DATASETS\MODEL REPLICATION\BF_ALLCAMPAIGNS_BALANCED_MOD.TXT"
            DBMS=DLM REPLACE;
     DELIMITER="|";
RUN;

DM "OUTPUT" CLEAR;

PROC FREQ DATA=DATALIB.BF_ALLCAMPAIGNS_COMBINED;
 TABLE CARD_STATUS*RESPONDER;
RUN;

PROC LOGISTIC DATA=DATALIB.BF_ALLCAMPAIGNS_BALANCED_MOD
			  OUTEST=BF_ALLCAMPAIGNS_BALANCED_PARMS_1
              OUTMODEL=BF_ALLCAMPAIGNS_BALANCED_MODEL_1;
  CLASS CARD_STATUS(REF='3');
  MODEL RESPONDER(EVENT="1")=	NUM_TXNS_12MO_SLS DIV_SHP_BF YEARS_ON_BOOKS CARD_STATUS
								BF_PROMOTIONS_RECEIVED_12MO DAYS_LAST_PUR_BF AVG_ORD_SZ_12MO
								ONSALE_QTY_12MO AVG_UNT_RTL RATIO_BR_BF
								/EXPB LACKFIT CTABLE OFFSET=OFFSET;
  WHERE TREATMENT_GROUP=1 AND CARD_STATUS NE 4;
  OUTPUT OUT=BF_ALLCAMPAIGNS_BALANCED_FITS_1 P=P_FIXED XBETA=L_FIXED;
RUN;

PROC LOGISTIC DATA=DATALIB.BF_ALLCAMPAIGNS_BALANCED_MOD
			  OUTEST=BF_ALLCAMPAIGNS_BALANCED_PARMS_2
              OUTMODEL=BF_ALLCAMPAIGNS_BALANCED_MODEL_2;
  MODEL RESPONDER(EVENT="1")=	NUM_TXNS_12MO_SLS DIV_SHP_BF YEARS_ON_BOOKS
								BF_PROMOTIONS_RECEIVED_12MO DAYS_LAST_PUR_BF
								ONSALE_QTY_12MO AVG_UNT_RTL RATIO_BR_BF AVG_ORD_SZ_12MO
								/EXPB LACKFIT CTABLE OFFSET=OFFSET;
  WHERE TREATMENT_GROUP=1 AND CARD_STATUS EQ 4;
  OUTPUT OUT=BF_ALLCAMPAIGNS_BALANCED_FITS_1 P=P_FIXED XBETA=L_FIXED;
RUN;

DATA DATALIB.BF_ALLCAMPAIGNS_BALANCED_FITS;
 SET DATALIB.BF_ALLCAMPAIGNS_BALANCED_FITS;
 P_1=EXP(L_FIXED)/(1+EXP(L_FIXED));
 POFFSET=LOGISTIC(L_FIXED-OFFSET);
 LABEL L_FIXED = "LOGIT";
 DROP P_FIXED;
RUN;

PROC LOGISTIC DATA=DATALIB.BF_ALLCAMPAIGNS_BALANCED_FITS;
  MODEL RESPONDER(EVENT="1")=	POFFSET
								/EXPB LACKFIT CTABLE;
RUN;

%MACRO CHANGECASE(INPUTLIB, SAMPLES);
%LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

%DO I=1 %TO &SAMPLECOUNT;
   %LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   %PUT &SAMPLENAME;

   PROC SQL;
    SELECT DISTINCT NAME INTO : VARLIST SEPARATED BY " " FROM DICTIONARY.COLUMNS WHERE LIBNAME="&INPUTLIB" AND MEMNAME="BF_&SAMPLENAME._CUSTOM_MODEL_SCORES";
   QUIT;
   
   %PUT &VARLIST;

   %LET VARCOUNT=%SYSFUNC(COUNTW(&VARLIST));
   %DO J=1 %TO &VARCOUNT;
	  %LET VARNAME=%UPCASE(%SCAN(&VARLIST,&J," "));
	  %PUT &VARNAME;

	  DATA DATALIB.BF_&SAMPLENAME._CUSTOM_MODEL_SCORES;
	   SET DATALIB.BF_&SAMPLENAME._CUSTOM_MODEL_SCORES;
	   &VARNAME.1=&VARNAME;
	   DROP &VARNAME;
	   RENAME &VARNAME.1=&VARNAME;
	  RUN;
   %END;
   
   PROC SQL;
    SELECT DISTINCT NAME INTO : VARLIST SEPARATED BY " " FROM DICTIONARY.COLUMNS WHERE LIBNAME="&INPUTLIB" AND MEMNAME="BF_&SAMPLENAME._CUSTOM_MODEL_SCORES";
   QUIT;

%END;
%MEND;
%CHANGECASE(INPUTLIB=DATALIB, SAMPLES= 227235 231472 233761 235492 239675 240331);



%MACRO CHECK(LIBNAME, SAMPLES, INPUTLIB);

 %LET SAMPLECOUNT=%SYSFUNC(COUNTW(&SAMPLES));

 %DO I=1 %TO &SAMPLECOUNT;
   %LET SAMPLENAME=%SCAN(&SAMPLES,&I," ");
   %PUT &SAMPLENAME;

   PROC SQL;
   CREATE TABLE DATALIB.BF_&SAMPLENAME._ORIG_SCORES AS SELECT 
				T1.CUSTOMER_KEY, T1.RESPONDER, T1.NET_SALES_AMT, T2.P_1, T2.OUTLET_FI_RESP_PROB, 
				T2.OUTLET_FI_PROFIT_EXPECTED_PROF, T2.EXP_PROF AS EXP_PROF
	   FROM DATALIB.BF_ALLCAMPAIGNS_BALANCED_MOD T1
	   INNER JOIN DATALIB.BF_&SAMPLENAME._CUSTOM_MODEL_SCORES T2
	   ON T1.CUSTOMER_KEY=T2.CUSTOMER_KEY WHERE T1.CAMPAIGN="&SAMPLENAME" AND T1.TREATMENT_GROUP=1;
   QUIT;
   
   DATA DATALIB.BF_&SAMPLENAME._ORIG_SCORES;
    SET DATALIB.BF_&SAMPLENAME._ORIG_SCORES;
	LABEL P_1 = "ORIG_RESP_PROB";
	CAMPAIGN="&SAMPLENAME";
   RUN;
   
 %END;

%MEND;

%CHECK(LIBNAME=DATALIB, INPUTLIB=DATALIB, SAMPLES= 227235 231472 233761 235492 239675 240331);


DATA DATALIB.BF_BALANCED_ORIG_SCORES;
 SET DATALIB.BF_227235_ORIG_SCORES
	 DATALIB.BF_231472_ORIG_SCORES
	 DATALIB.BF_233761_ORIG_SCORES
	 DATALIB.BF_235492_ORIG_SCORES
	 DATALIB.BF_239675_ORIG_SCORES
	 DATALIB.BF_240331_ORIG_SCORES;
RUN;

PROC FREQ DATA=DATALIB.BF_BALANCED_ORIG_SCORES;
 TABLES CAMPAIGN;
RUN;

PROC SQL;
 CREATE TABLE DATALIB.BF_BALANCED_VALIDATION AS SELECT T1.*, T2.POFFSET 
		FROM DATALIB.BF_BALANCED_ORIG_SCORES T1,
			 DATALIB.BF_ALLCAMPAIGNS_BALANCED_FITS T2
		WHERE T1.CUSTOMER_KEY = T2.CUSTOMER_KEY AND T1.CAMPAIGN=T2.CAMPAIGN;
QUIT;


PROC LOGISTIC DATA=DATALIB.BF_BALANCED_ORIG_SCORES;
  MODEL RESPONDER(EVENT="1")=	P_1
								/EXPB LACKFIT CTABLE;
RUN;

PROC LOGISTIC DATA=DATALIB.BF_BALANCED_ORIG_SCORES;
  MODEL RESPONDER(EVENT="1")=	OUTLET_FI_RESP_PROB
								/EXPB LACKFIT CTABLE;
RUN;

PROC LOGISTIC DATA=DATALIB.BF_BALANCED_ORIG_SCORES;
  MODEL RESPONDER(EVENT="1")=	EXP_PROF
								/EXPB LACKFIT CTABLE;
RUN;


PROC SQL;
 SELECT COUNT(*) INTO: TRAINCOUNT FROM DATALIB.BF_BALANCED_VALIDATION;
QUIT;
 
%LET TRAININTV = %EVAL(&TRAINCOUNT/10);

PROC SORT DATA=DATALIB.BF_BALANCED_VALIDATION;
 BY DESCENDING P_1 DESCENDING NET_SALES_AMT;
RUN;

DATA DATALIB.BF_BALANCED_VALIDATION;
 SET DATALIB.BF_BALANCED_VALIDATION;
 IF _N_ GE 1 + 0 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=1;
 IF _N_ GE 1 + 1 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=2;
 IF _N_ GE 1 + 2 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=3;
 IF _N_ GE 1 + 3 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=4;
 IF _N_ GE 1 + 4 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=5;
 IF _N_ GE 1 + 5 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=6;
 IF _N_ GE 1 + 6 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=7;
 IF _N_ GE 1 + 7 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=8;
 IF _N_ GE 1 + 8 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=9;
 IF _N_ GE 1 + 9 * ROUND(&TRAININTV) THEN ORIG_RESP_PROB_GRP=10;
RUN;

PROC FREQ DATA=DATALIB.BF_BALANCED_VALIDATION;
 TABLE ORIG_RESP_PROB_GRP * RESPONDER;
RUN;

PROC SQL;
 CREATE TABLE TEST1 AS SELECT DISTINCT ORIG_RESP_PROB_GRP, COUNT(CUSTOMER_KEY) AS CUSTOMERS,
 									   SUM(RESPONDER) AS RESPONDERS, SUM(NET_SALES_AMT) AS NET_SALES
	    FROM DATALIB.BF_BALANCED_VALIDATION
		GROUP BY ORIG_RESP_PROB_GRP ORDER BY ORIG_RESP_PROB_GRP;
QUIT;






PROC SQL;
 SELECT COUNT(*) INTO: TRAINCOUNT FROM DATALIB.BF_BALANCED_VALIDATION;
QUIT;
 
%LET TRAININTV = %EVAL(&TRAINCOUNT/10);

PROC SORT DATA=DATALIB.BF_BALANCED_VALIDATION;
 BY DESCENDING POFFSET DESCENDING NET_SALES_AMT;
RUN;


DATA DATALIB.BF_BALANCED_VALIDATION;
 SET DATALIB.BF_BALANCED_VALIDATION;
 IF _N_ GE 1 + 0 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=1;
 IF _N_ GE 1 + 1 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=2;
 IF _N_ GE 1 + 2 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=3;
 IF _N_ GE 1 + 3 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=4;
 IF _N_ GE 1 + 4 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=5;
 IF _N_ GE 1 + 5 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=6;
 IF _N_ GE 1 + 6 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=7;
 IF _N_ GE 1 + 7 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=8;
 IF _N_ GE 1 + 8 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=9;
 IF _N_ GE 1 + 9 * ROUND(&TRAININTV) THEN NEW_RESP_PROB_GRP=10;
RUN;

PROC FREQ DATA=DATALIB.BF_BALANCED_VALIDATION;
 TABLE NEW_RESP_PROB_GRP * RESPONDER;
RUN;


PROC SQL;
 CREATE TABLE TEST2 AS SELECT DISTINCT NEW_RESP_PROB_GRP, COUNT(CUSTOMER_KEY) AS CUSTOMERS,
 									   SUM(RESPONDER) AS RESPONDERS, SUM(NET_SALES_AMT) AS NET_SALES
	    FROM DATALIB.BF_BALANCED_VALIDATION
		GROUP BY NEW_RESP_PROB_GRP ORDER BY NEW_RESP_PROB_GRP;
QUIT;
