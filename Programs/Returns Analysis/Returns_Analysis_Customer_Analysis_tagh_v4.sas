LIBNAME TITANLIB "Z:\TANUMOY\WORKSPACE\DATA\TITAN\REFINED MODEL";
OPTIONS MACROGEN SYMBOLGEN MLOGIC MPRINT;


DATA TITANLIB.DECILES_AGG_GRP_MODEL;
 SET TITANLIB.DECILES_AGG_GRP;
 DROP DECILES;
 WHERE NET_DMD_AMT NE 0;
 NET_RTN_PCT=NET_RTN_AMT/NET_DMD_AMT * 100;
RUN;


DATA TITANLIB.DECILES_BRD_GRP_MODEL;
 SET TITANLIB.DECILES_BRD_GRP;
 WHERE NET_DMD_AMT NE 0;
 DROP DECILES;
 NET_RTN_PCT=NET_RTN_AMT/NET_DMD_AMT * 100;
RUN;



PROC RANK DATA=TITANLIB.DECILES_AGG_GRP_MODEL OUT=TITANLIB.DECILES_AGG_GRP_MODEL_TEST GROUPS=10; 
     VAR NET_RTN_PCT; RANKS DECILES; RUN;
DATA TITANLIB.DECILES_AGG_GRP_MODEL; SET TITANLIB.DECILES_AGG_GRP_MODEL; DECILES=DECILES+1; RUN;


PROC RANK DATA=TITANLIB.DECILES_BRD_GRP_MODEL OUT=TITANLIB.DECILES_BRD_GRP_MODEL GROUPS=10; 
     BY PRD_BRD_CD; VAR NET_RTN_PCT; RANKS DECILES; RUN;
DATA TITANLIB.DECILES_BRD_GRP_MODEL; SET TITANLIB.DECILES_BRD_GRP_MODEL; DECILES=DECILES+1; RUN;


DATA TITANLIB.DECILES_BRD_GRP_MODEL;
 SET TITANLIB.DECILES_BRD_GRP_MODEL;
 AVG_GRS_DMD_TXN=GRS_DMD_AMT/NUM_TXNS;
 AVG_NET_DMD_TXN=NET_DMD_AMT/NUM_TXNS;
 AVG_TOT_REV_TXN=TOT_REV_AMT/NUM_TXNS;
 AVG_VAR_MGN_TXN=VAR_MGN_AMT/NUM_TXNS;
 AVG_SHP_UNT_TXN=SHP_UN_CNT/NUM_TXNS;
 AVG_GRS_DMD_UNT=GRS_DMD_AMT/SHP_UN_CNT;
 AVG_NET_DMD_UNT=NET_DMD_AMT/SHP_UN_CNT;
 AVG_TOT_REV_UNT=TOT_REV_AMT/SHP_UN_CNT;
 AVG_VAR_MGN_UNT=VAR_MGN_AMT/SHP_UN_CNT;
 AVG_NET_RTN_TXN=NET_RTN_AMT/NUM_TXNS;
 DISCOUNT=GRS_DMD_AMT-NET_DMD_AMT;
 DISCOUNT_PCT=(GRS_DMD_AMT-NET_DMD_AMT)/GRS_DMD_AMT*100;
 AVG_DISCOUNT_TXN=DISCOUNT/NUM_TXNS;
 AVG_ORD_SZ_UN=NET_DMD_AMT/SHP_UN_CNT;
 RTN_GRP=0;
 IF NET_RTN_AMT>0 THEN RTN_GRP=1;
 RENAME DAYS_BR_CUST=DAYS_BROL_CUST;
 RENAME DAYS_GP_CUST=DAYS_GOL_CUST;
 RENAME DAYS_ON_CUST=DAYS_ONOL_CUST;
 RENAME DAYS_PL_CUST=DAYS_GPSV_CUST;
 RENAME DAYS_AT_CUST=DAYS_ATOL_CUST;
RUN;
PROC FREQ DATA=TITANLIB.DECILES_BRD_GRP_MODEL;
 TABLE CUST_TYP*CUST_GRP/MISSING;
RUN;
DATA TITANLIB.DECILES_BRD_GRP_MODEL;
 SET TITANLIB.DECILES_BRD_GRP_MODEL;
 CUST_GRP=3;
 IF CUST_TYP="Active" THEN CUST_GRP=1;
 ELSE IF CUST_TYP="New" THEN CUST_GRP=2;
 ACTIVE_FLAG=0; NEW_FLAG=0;
 IF CUST_GRP=1 THEN ACTIVE_FLAG=1;
 IF CUST_GRP=2 THEN NEW_FLAG=1;

RUN;

PROC SORT DATA=TITANLIB.DECILES_BRD_GRP_MODEL;
 BY PRD_BRD_CD TITAN_CUST_ID;
RUN;

DATA TITANLIB.DECILES_BRD_GRP_MODEL;
 MERGE TITANLIB.DECILES_BRD_GRP_MODEL (IN=A) TITANLIB.DIVISIONS_BY_BRD (IN=B);
 BY PRD_BRD_CD TITAN_CUST_ID;
 IF A=1 AND B=1;
RUN;

ODS GRAPHICS OFF;
