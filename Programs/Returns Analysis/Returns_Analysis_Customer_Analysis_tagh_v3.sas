LIBNAME TITANLIB "Z:\TANUMOY\WORKSPACE\DATA\TITAN";


OPTION OBS=MAX;
DATA TITANLIB.MEA_ORD_LN_FCT_4_DECILES;
 RETAIN OMS_ORD_KEY OMS_ORD_LN_NBR FIS_DY_KEY ORDER_DATE TITAN_CUST_ID CUST_ACCT_KEY PRD_BRD_CD
      PROD_BRD_KEY MDSE_SKU_KEY UN_CST_AMT GRS_DMD_AMT NET_DMD_AMT TOT_REV_AMT 
      SHP_REV_AMT SHP_SLS_AMT TOT_MGN_AMT VARIABL_MGN_AMT NET_SLS_AMT NET_RTN_AMT 
      GRS_MERCH_UN_CNT SHP_MERCH_UN_CNT RTN_MERCH_UN_CNT BR_FST_PRCH_DT AT_FST_PRCH_DT
      PL_FST_PRCH_DT GP_FST_PRCH_DT ON_FST_PRCH_DT GID_FST_PRCH_DT; 
 KEEP OMS_ORD_KEY OMS_ORD_LN_NBR FIS_DY_KEY ORDER_DATE TITAN_CUST_ID CUST_ACCT_KEY PRD_BRD_CD
      PROD_BRD_KEY MDSE_SKU_KEY UN_CST_AMT GRS_DMD_AMT NET_DMD_AMT TOT_REV_AMT 
      SHP_REV_AMT SHP_SLS_AMT TOT_MGN_AMT VARIABL_MGN_AMT NET_SLS_AMT NET_RTN_AMT 
      GRS_MERCH_UN_CNT SHP_MERCH_UN_CNT RTN_MERCH_UN_CNT BR_FST_PRCH_DT AT_FST_PRCH_DT
      PL_FST_PRCH_DT GP_FST_PRCH_DT ON_FST_PRCH_DT GID_FST_PRCH_DT;
 SET TITANLIB.MEA_ORD_LN_FCT_4;
RUN;

PROC SORT NODUPKEY DATA=TITANLIB.MEA_ORD_LN_FCT_4_DECILES
     OUT=TITANLIB.MEA_ORD_LN_FCT_4_DECILES;
     BY OMS_ORD_KEY OMS_ORD_LN_NBR;
RUN;

PROC SQL;
CREATE TABLE TITANLIB.MEA_ORD_LN_PURCHASE AS SELECT DISTINCT
       OMS_ORD_KEY, OMS_ORD_LN_NBR, FIS_DY_KEY, ORDER_DATE, TITAN_CUST_ID, CUST_ACCT_KEY, PRD_BRD_CD,
       PROD_BRD_KEY, MDSE_SKU_KEY, UN_CST_AMT, GRS_DMD_AMT, NET_DMD_AMT, TOT_REV_AMT, 
	   SHP_REV_AMT, SHP_SLS_AMT, TOT_MGN_AMT, VARIABL_MGN_AMT, NET_SLS_AMT,GRS_MERCH_UN_CNT, SHP_MERCH_UN_CNT,
	   BR_FST_PRCH_DT, AT_FST_PRCH_DT, PL_FST_PRCH_DT, GP_FST_PRCH_DT, ON_FST_PRCH_DT, GID_FST_PRCH_DT
       FROM TITANLIB.MEA_ORD_LN_FCT_4_DECILES;

CREATE TABLE TITANLIB.MEA_ORD_LN_RETURN AS SELECT 
       OMS_ORD_KEY, OMS_ORD_LN_NBR, FIS_DY_KEY, ORDER_DATE, TITAN_CUST_ID, CUST_ACCT_KEY, PRD_BRD_CD,
       PROD_BRD_KEY, MDSE_SKU_KEY, NET_RTN_AMT, RTN_MERCH_UN_CNT, BR_FST_PRCH_DT, AT_FST_PRCH_DT, 
       PL_FST_PRCH_DT, GP_FST_PRCH_DT, ON_FST_PRCH_DT, GID_FST_PRCH_DT
	   FROM TITANLIB.MEA_ORD_LN_FCT_4_DECILES;
QUIT;


DATA TITANLIB.MEA_ORD_LN_FCT_4_DECILES;
 MERGE TITANLIB.MEA_ORD_LN_FCT_4_DECILES (IN=A)
       TITANLIB.MEA_ORD_LN_FCT_4_PRODUCT (IN=B);
 BY OMS_ORD_KEY OMS_ORD_LN_NBR;
 IF A=1 AND B=1;
RUN;

PROC SQL UNDO_POLICY=NONE;
 CREATE TABLE TITANLIB.DECILES_AGG AS SELECT DISTINCT TITAN_CUST_ID,
              SUM(GRS_DMD_AMT) AS GRS_DMD_AMT, SUM(NET_DMD_AMT) AS NET_DMD_AMT,
			  SUM(TOT_REV_AMT) AS TOT_REV_AMT, SUM(TOT_MGN_AMT) AS TOT_MGN_AMT,
			  SUM(VARIABL_MGN_AMT) AS VAR_MGN_AMT, SUM(SHP_MERCH_UN_CNT) AS SHP_UN_CNT,
			  SUM(NET_SLS_AMT) AS NET_SLS_AMT, SUM(NET_RTN_AMT) AS NET_RTN_AMT, 
			  SUM(RTN_MERCH_UN_CNT) AS RTN_UN_CNT, SUM(SHP_SLS_AMT) AS SHP_SLS_AMT,
			  COUNT(DISTINCT OMS_ORD_KEY) AS NUM_TXNS,
			  COUNT(DISTINCT MDSE_DIV_DESC) AS DIVISIONS_SHOPPED,
			  COUNT(DISTINCT PRD_BRD_CD) AS BRANDS_SHOPPED,
			  PUT(MIN(BR_FST_PRCH_DT), DATE9.) AS BR_FST_PRCH_DT,
		      PUT(MIN(GP_FST_PRCH_DT), DATE9.) AS GP_FST_PRCH_DT, 
			  PUT(MIN(ON_FST_PRCH_DT), DATE9.) AS ON_FST_PRCH_DT,
			  PUT(MIN(AT_FST_PRCH_DT), DATE9.) AS AT_FST_PRCH_DT,
			  PUT(MIN(PL_FST_PRCH_DT), DATE9.) AS PL_FST_PRCH_DT,
			  PUT(MIN(GID_FST_PRCH_DT), DATE9.) AS GID_FST_PRCH_DT,
			  PUT(MIN(ORDER_DATE), DATE9.) AS FST_ORD_DT, 
			  PUT(MAX(ORDER_DATE), DATE9.) AS LAST_ORD_DT
        FROM TITANLIB.MEA_ORD_LN_FCT_4_DECILES 
		WHERE SHP_MERCH_UN_CNT>0 AND ORDER_DATE<=INPUT('19MAY2010',DATE9.)
	    GROUP BY TITAN_CUST_ID ORDER BY TITAN_CUST_ID;

 CREATE TABLE TITANLIB.DECILES_AGG AS SELECT *, 
              INPUT(LAST_ORD_DT,DATE9.)-INPUT(GID_FST_PRCH_DT,DATE9.) AS DAYS_GID_CUST,
              INPUT(LAST_ORD_DT,DATE9.)-INPUT(GP_FST_PRCH_DT,DATE9.) AS DAYS_GP_CUST,
			  INPUT(LAST_ORD_DT,DATE9.)-INPUT(BR_FST_PRCH_DT,DATE9.) AS DAYS_BR_CUST,
			  INPUT(LAST_ORD_DT,DATE9.)-INPUT(ON_FST_PRCH_DT,DATE9.) AS DAYS_ON_CUST,
			  INPUT(LAST_ORD_DT,DATE9.)-INPUT(AT_FST_PRCH_DT,DATE9.) AS DAYS_AT_CUST,
			  INPUT(LAST_ORD_DT,DATE9.)-INPUT(PL_FST_PRCH_DT,DATE9.) AS DAYS_PL_CUST
		FROM TITANLIB.DECILES_AGG;

 CREATE TABLE TITANLIB.DECILES_BRD AS SELECT DISTINCT PRD_BRD_CD, TITAN_CUST_ID,
              SUM(GRS_DMD_AMT) AS GRS_DMD_AMT, SUM(NET_DMD_AMT) AS NET_DMD_AMT,
			  SUM(TOT_REV_AMT) AS TOT_REV_AMT, SUM(TOT_MGN_AMT) AS TOT_MGN_AMT,
			  SUM(VARIABL_MGN_AMT) AS VAR_MGN_AMT, SUM(SHP_MERCH_UN_CNT) AS SHP_UN_CNT,
			  SUM(NET_SLS_AMT) AS NET_SLS_AMT, SUM(NET_RTN_AMT) AS NET_RTN_AMT, 
			  SUM(RTN_MERCH_UN_CNT) AS RTN_UN_CNT, SUM(SHP_SLS_AMT) AS SHP_SLS_AMT,
			  COUNT(DISTINCT OMS_ORD_KEY) AS NUM_TXNS,
			  COUNT(DISTINCT MDSE_DIV_DESC) AS DIVISIONS_SHOPPED,
			  PUT(MIN(BR_FST_PRCH_DT), DATE9.) AS BR_FST_PRCH_DT,
		      PUT(MIN(GP_FST_PRCH_DT), DATE9.) AS GP_FST_PRCH_DT, 
			  PUT(MIN(ON_FST_PRCH_DT), DATE9.) AS ON_FST_PRCH_DT,
			  PUT(MIN(AT_FST_PRCH_DT), DATE9.) AS AT_FST_PRCH_DT,
			  PUT(MIN(PL_FST_PRCH_DT), DATE9.) AS PL_FST_PRCH_DT,
			  PUT(MIN(GID_FST_PRCH_DT), DATE9.) AS GID_FST_PRCH_DT,
			  PUT(MIN(ORDER_DATE), DATE9.) AS FST_ORD_DT, 
			  PUT(MAX(ORDER_DATE), DATE9.) AS LAST_ORD_DT
        FROM TITANLIB.MEA_ORD_LN_FCT_4_DECILES 
		WHERE SHP_MERCH_UN_CNT>0  AND ORDER_DATE<=INPUT('19MAY2010',DATE9.)
	    GROUP BY PRD_BRD_CD, TITAN_CUST_ID ORDER BY PRD_BRD_CD, TITAN_CUST_ID;

 CREATE TABLE TITANLIB.DECILES_BRD AS SELECT *, 
              INPUT(LAST_ORD_DT,DATE9.)-INPUT(GID_FST_PRCH_DT,DATE9.) AS DAYS_GID_CUST,
              INPUT(LAST_ORD_DT,DATE9.)-INPUT(GP_FST_PRCH_DT,DATE9.) AS DAYS_GP_CUST,
			  INPUT(LAST_ORD_DT,DATE9.)-INPUT(BR_FST_PRCH_DT,DATE9.) AS DAYS_BR_CUST,
			  INPUT(LAST_ORD_DT,DATE9.)-INPUT(ON_FST_PRCH_DT,DATE9.) AS DAYS_ON_CUST,
			  INPUT(LAST_ORD_DT,DATE9.)-INPUT(AT_FST_PRCH_DT,DATE9.) AS DAYS_AT_CUST,
			  INPUT(LAST_ORD_DT,DATE9.)-INPUT(PL_FST_PRCH_DT,DATE9.) AS DAYS_PL_CUST
		FROM TITANLIB.DECILES_BRD;

QUIT;

DATA TITANLIB.DECILES_AGG;
 SET TITANLIB.DECILES_AGG;
 NET_RTN_PCT=NET_RETN_AMT/SHP_SLS_AMT * 100;
RUN;


DATA TITANLIB.DECILES_BRD;
 SET TITANLIB.DECILES_BRD;
 NET_RTN_PCT=NET_RETN_AMT/SHP_SLS_AMT * 100;
RUN;


PROC RANK DATA=TITANLIB.DECILES_AGG OUT=TITANLIB.DECILES_AGG GROUPS=10; 
     VAR VAR_MGN_AMT; RANKS DECILES; RUN;

DATA TITANLIB.DECILES_AGG; SET TITANLIB.DECILES_AGG; DECILES=DECILES+1; RUN;

PROC RANK DATA=TITANLIB.DECILES_BRD OUT=TITANLIB.DECILES_BRD GROUPS=10; 
     BY PRD_BRD_CD; VAR VAR_MGN_AMT; RANKS DECILES; RUN;

DATA TITANLIB.DECILES_BRD; SET TITANLIB.DECILES_BRD; DECILES=DECILES+1; RUN;


PROC UNIVARIATE DATA=TITANLIB.DECILES_BRD NOPRINT;
	 CLASS PRD_BRD_CD DECILES;
 	 VAR GRS_DMD_AMT;
	 OUTPUT OUT=TITANLIB.TEST SUM= MEAN= MIN= PCTLPTS=25 50 75 MAX=
	 PCTLPRE=P_ ;
RUN;

DATA TITANLIB.TEST;
 SET TITANLIB.TEST;
 METRIC="GRS_DMD_AMT";
RUN;

PROC TRANSPOSE DATA=TITANLIB.TEST OUT=TITANLIB.TEMP;
 BY PRD_BRD_CD DECILES METRIC;
RUN;

DATA TITANLIB.TEMP;
 SET TITANLIB.TEMP;
 RENAME _NAME_=STATISTIC;
 DROP _LABEL_;
RUN;
