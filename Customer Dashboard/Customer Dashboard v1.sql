hadoop dfs -getmerge '/user/xtghosh/BR_SHOPPERS_20170910_LTV_ATT_AGG_TXT' '/stage_tmp/xtghosh'
hadoop dfs -getmerge '/user/xtghosh/BR_SHOPPERS_20170910_LAST_AGG_TXT' '/stage_tmp/xtghosh'

hadoop dfs -getmerge '/user/xtghosh/GP_SHOPPERS_20170910_LTV_ATT_AGG_TXT' '/stage_tmp/xtghosh'
hadoop dfs -getmerge '/user/xtghosh/GP_SHOPPERS_20170910_LAST_AGG_TXT' '/stage_tmp/xtghosh'

hadoop dfs -getmerge '/user/xtghosh/ON_SHOPPERS_20170910_LTV_ATT_AGG_TXT' '/stage_tmp/xtghosh'
hadoop dfs -getmerge '/user/xtghosh/ON_SHOPPERS_20170910_LAST_AGG_TXT' '/stage_tmp/xtghosh'


SET mapred.job.queue.name=aa;
SET hive.cli.print.header=true;
SET hive.variable.substitute.depth=100;

SET NUM=1; SET CURRENT_COUNTRY=US; SET CURRENT_BRAND=GP; SET RUNDATE=20170910; SET START_DT=2016-09-01; SET END_DT=2017-08-31; 
SET LTVRUNDATE=2017-09-01; SET ATTRUNDATE=2017-09-01; SET DIVRUNDATE = 2017-09-01;


DROP DATABASE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP CASCADE;
CREATE DATABASE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP LOCATION '/apps/hive/warehouse/aa_cem/xtghosh/${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.db';

USE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP;
SHOW TABLES;

DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1;	   
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1 AS
SELECT
T1.CUSTOMER_KEY, 
T1.ORDER_STATUS, 
COUNT(DISTINCT T1.TRANSACTION_NUM) AS DISTINCT_TRANSACTION_NUM, 
COUNT(DISTINCT T1.ORDER_NUM) AS DISTINCT_ORDER_NUM,
SUM(T1.ITEM_QTY) AS ITEM_QTY, 
SUM(T1.GROSS_SALES_AMT) AS GROSS_SALES_AMT, 
SUM(T1.DISCOUNT_AMT) AS DISCOUNT_AMT, 
SUM(T1.TOT_PRD_CST_AMT) AS TOT_PRD_CST_AMT
FROM MDS_NEW.ODS_ORDERHEADER_T T1 
WHERE 
T1.BRAND='${hiveconf:CURRENT_BRAND}' AND T1.COUNTRY='${hiveconf:CURRENT_COUNTRY}' AND T1.TRANSACTION_TYPE_CD IN ('S','M', 'R') AND
(
(T1.ORDER_STATUS='R' AND
 UNIX_TIMESTAMP(T1.SHIP_DATE,'yyyy-MM-dd') BETWEEN
 UNIX_TIMESTAMP('${hiveconf:START_DT}', 'yyyy-MM-dd') AND UNIX_TIMESTAMP('${hiveconf:END_DT}', 'yyyy-MM-dd')
 ) OR
(T1.ORDER_STATUS='O' AND
 UNIX_TIMESTAMP(T1.DEMAND_DATE, 'yyyy-MM-dd') BETWEEN
 UNIX_TIMESTAMP('${hiveconf:START_DT}', 'yyyy-MM-dd') AND UNIX_TIMESTAMP('${hiveconf:END_DT}', 'yyyy-MM-dd')
)
)
GROUP BY T1.CUSTOMER_KEY, T1.ORDER_STATUS;


DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2 AS SELECT
CUSTOMER_KEY, 
ORDER_STATUS, 
ITEM_QTY,
GROSS_SALES_AMT, 
DISCOUNT_AMT, 
TOT_PRD_CST_AMT,
(CASE 
 WHEN ORDER_STATUS = 'R' THEN GROSS_SALES_AMT + COALESCE(DISCOUNT_AMT,0)
 ELSE CAST(0 AS DOUBLE)
 END) AS NET_SALES_AMT_RTL,
(CASE 
 WHEN ORDER_STATUS = 'O' THEN GROSS_SALES_AMT + COALESCE(DISCOUNT_AMT,0)
 ELSE CAST(0 AS DOUBLE)
 END) AS NET_SALES_AMT_ONL,
(CASE 
 WHEN ORDER_STATUS = 'R' THEN DISTINCT_TRANSACTION_NUM 
 ELSE 0L
 END) AS DISTINCT_TRANSACTION_NUM,
(CASE
 WHEN ORDER_STATUS = 'O' THEN DISTINCT_ORDER_NUM 
 ELSE 0L
 END) AS DISTINCT_ORDER_NUM
FROM ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1;


DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_AGG;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_AGG AS 
SELECT
CUSTOMER_KEY, 
SUM(ITEM_QTY) AS ITEM_QTY,
SUM(GROSS_SALES_AMT) AS GROSS_SALES_AMT, 
SUM(DISCOUNT_AMT) AS DISCOUNT_AMT, 
SUM(TOT_PRD_CST_AMT) AS TOT_PRD_CST_AMT,
SUM(GROSS_SALES_AMT + COALESCE(DISCOUNT_AMT,0)) AS NET_SALES_AMT,
SUM(GROSS_SALES_AMT + COALESCE(DISCOUNT_AMT,0) - COALESCE(TOT_PRD_CST_AMT,0)) AS NET_MARGIN,
SUM(NET_SALES_AMT_RTL) AS NET_SALES_AMT_RTL,
SUM(NET_SALES_AMT_ONL) AS NET_SALES_AMT_ONL, 
SUM(DISTINCT_TRANSACTION_NUM) AS NUM_TXNS_RTL,
SUM(DISTINCT_ORDER_NUM) AS NUM_TXNS_ONL,
SUM(DISTINCT_TRANSACTION_NUM + DISTINCT_ORDER_NUM) AS NUM_TXNS
FROM ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2
GROUP BY CUSTOMER_KEY;
  
SELECT * FROM ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_AGG LIMIT 10;


 
DROP TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1;
DROP TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2;



DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.PLCC_CARDHOLDER_${hiveconf:RUNDATE}_FLAG;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.PLCC_CARDHOLDER_${hiveconf:RUNDATE}_FLAG
AS
SELECT
DISTINCT 
T1.CUSTOMER_KEY,
T2.PLCC
FROM
${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_AGG T1
LEFT OUTER JOIN
(
SELECT DISTINCT
CUSTOMER_KEY,
(
CASE WHEN CUSTOMER_KEY > 0 THEN 1L ELSE 0L END 
) AS PLCC
FROM 
MDS_NEW.ODS_PLCC_CARDHOLDER_T
WHERE 
ACCOUNT_MARKET_STATUS = 3 AND COUNTRY='US'
) T2
ON 
T1.CUSTOMER_KEY = T2.CUSTOMER_KEY;







DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1;	   
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1 AS
SELECT
T1.CUSTOMER_KEY, 
T1.ORDER_STATUS, 
COUNT(DISTINCT T1.TRANSACTION_NUM) AS DISTINCT_TRANSACTION_NUM, 
COUNT(DISTINCT T1.ORDER_NUM) AS DISTINCT_ORDER_NUM,
SUM(T1.ITEM_QTY) AS ITEM_QTY, 
SUM(T1.GROSS_SALES_AMT) AS GROSS_SALES_AMT, 
SUM(T1.DISCOUNT_AMT) AS DISCOUNT_AMT, 
SUM(T1.TOT_PRD_CST_AMT) AS TOT_PRD_CST_AMT
FROM MDS_NEW.ODS_ORDERHEADER_T T1 
WHERE 
T1.BRAND='${hiveconf:CURRENT_BRAND}' AND T1.COUNTRY='${hiveconf:CURRENT_COUNTRY}' AND T1.TRANSACTION_TYPE_CD IN ('S','M', 'R') AND
(
(T1.ORDER_STATUS='R' AND
 UNIX_TIMESTAMP(T1.SHIP_DATE,'yyyy-MM-dd') BETWEEN
 UNIX_TIMESTAMP(DATE_ADD('${hiveconf:START_DT}', -365), 'yyyy-MM-dd') AND UNIX_TIMESTAMP(DATE_ADD('${hiveconf:END_DT}', -365), 'yyyy-MM-dd')
 ) OR
(T1.ORDER_STATUS='O' AND
 UNIX_TIMESTAMP(T1.DEMAND_DATE, 'yyyy-MM-dd') BETWEEN
 UNIX_TIMESTAMP(DATE_ADD('${hiveconf:START_DT}', -365), 'yyyy-MM-dd') AND UNIX_TIMESTAMP(DATE_ADD('${hiveconf:END_DT}', -365), 'yyyy-MM-dd')
)
)
GROUP BY T1.CUSTOMER_KEY, T1.ORDER_STATUS;


DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2 AS SELECT
CUSTOMER_KEY, 
ORDER_STATUS, 
ITEM_QTY,
GROSS_SALES_AMT, 
DISCOUNT_AMT, 
TOT_PRD_CST_AMT,
(CASE 
 WHEN ORDER_STATUS = 'R' THEN GROSS_SALES_AMT + COALESCE(DISCOUNT_AMT,0)
 ELSE CAST(0 AS DOUBLE)
 END) AS NET_SALES_AMT_RTL,
(CASE 
 WHEN ORDER_STATUS = 'O' THEN GROSS_SALES_AMT + COALESCE(DISCOUNT_AMT,0)
 ELSE CAST(0 AS DOUBLE)
 END) AS NET_SALES_AMT_ONL,
(CASE 
 WHEN ORDER_STATUS = 'R' THEN DISTINCT_TRANSACTION_NUM 
 ELSE 0L
 END) AS DISTINCT_TRANSACTION_NUM,
(CASE
 WHEN ORDER_STATUS = 'O' THEN DISTINCT_ORDER_NUM 
 ELSE 0L
 END) AS DISTINCT_ORDER_NUM
FROM ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1;

DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LAST_AGG;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LAST_AGG AS 
SELECT
CUSTOMER_KEY, 
SUM(ITEM_QTY) AS ITEM_QTY,
SUM(GROSS_SALES_AMT) AS GROSS_SALES_AMT, 
SUM(DISCOUNT_AMT) AS DISCOUNT_AMT, 
SUM(TOT_PRD_CST_AMT) AS TOT_PRD_CST_AMT,
SUM(GROSS_SALES_AMT + COALESCE(DISCOUNT_AMT,0)) AS NET_SALES_AMT,
SUM(GROSS_SALES_AMT + COALESCE(DISCOUNT_AMT,0) - COALESCE(TOT_PRD_CST_AMT,0)) AS NET_MARGIN,
SUM(NET_SALES_AMT_RTL) AS NET_SALES_AMT_RTL,
SUM(NET_SALES_AMT_ONL) AS NET_SALES_AMT_ONL,
SUM(DISTINCT_TRANSACTION_NUM) AS NUM_TXNS_RTL,
SUM(DISTINCT_ORDER_NUM) AS NUM_TXNS_ONL,
SUM(DISTINCT_TRANSACTION_NUM + DISTINCT_ORDER_NUM) AS NUM_TXNS
FROM ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2
GROUP BY CUSTOMER_KEY;
  
SELECT * FROM ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LAST_AGG LIMIT 10;


 
DROP TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1;
DROP TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2;


DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV
AS SELECT
CUSTOMERKEY AS CUSTOMER_KEY,
EXPECTEDLTV12
FROM
EVERGREENATTRIBUTE.LIFETIMEVALUE${hiveconf:CURRENT_BRAND}ATTRIBUTE
WHERE 
YEAR(RUNDATE)  >= YEAR('${hiveconf:LTVRUNDATE}') AND
MONTH(RUNDATE) >= MONTH('${hiveconf:LTVRUNDATE}') ;



DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_ATT;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_ATT
AS SELECT
MYTABLE.CUSTOMER_KEY,
MEDIANSCORE AS ATTRITIONPROB
FROM
EVERGREENATTRIBUTE.${hiveconf:CURRENT_BRAND}ATTRITIONATTRIBUTE
LATERAL VIEW
explode(CUSTOMERKEY) MYTABLE AS CUSTOMER_KEY;
	
WHERE 
YEAR(PROCESSINGDATE)  >= YEAR('${hiveconf:ATTRUNDATE}') AND
MONTH(PROCESSINGDATE) >= MONTH('${hiveconf:ATTRUNDATE}');



--DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_DIV;
--CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_DIV
--AS SELECT
--MYTABLE.CUSTOMER_KEY,
--ATTRIBUTE AS DIVISIONPREFERENCE
--FROM
--EVERGREENATTRIBUTE.${hiveconf:CURRENT_BRAND}DIVISIONPREFERENCESATTRIBUTEHISTORY
--LATERAL VIEW
--explode(CUSTOMERKEY) MYTABLE AS CUSTOMER_KEY	
--WHERE 
--YEAR(PROCESSINGDATE)  = YEAR('${hiveconf:ATTPROCESSINGDATE}') AND
--MONTH(PROCESSINGDATE) = MONTH('${hiveconf:ATTPROCESSINGDATE}');


DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV_ATT_AGG;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV_ATT_AGG AS SELECT
T1.CUSTOMER_KEY,
COALESCE(T1.ITEM_QTY, 0) AS ITEM_QTY,
COALESCE(T1.GROSS_SALES_AMT, 0) AS GROSS_SALES_AMT,
COALESCE(T1.DISCOUNT_AMT, 0) AS DISCOUNT_AMT,
COALESCE(T1.TOT_PRD_CST_AMT, 0) AS TOT_PRD_CST_AMT,
COALESCE(T1.NET_SALES_AMT, 0) AS NET_SALES_AMT,
COALESCE(T1.NET_MARGIN, 0) AS NET_MARGIN,
COALESCE(T1.NET_SALES_AMT_RTL, 0) AS NET_SALES_AMT_RTL,
COALESCE(T1.NET_SALES_AMT_ONL, 0) AS NET_SALES_AMT_ONL,
COALESCE(T1.NUM_TXNS_RTL, 0) AS NUM_TXNS_RTL,
COALESCE(T1.NUM_TXNS_ONL, 0) AS NUM_TXNS_ONL,
COALESCE(T1.NUM_TXNS, 0) AS NUM_TXNS,
COALESCE(T4.PLCC, 0) AS PLCC,
COALESCE(T2.EXPECTEDLTV12, 0) AS EXPECTEDLTV12,
COALESCE(T3.ATTRITIONPROB, 0) AS ATTRITIONPROB
FROM
${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_AGG T1
LEFT OUTER JOIN
${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV T2
ON
T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
LEFT OUTER JOIN
${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_ATT T3
ON
T1.CUSTOMER_KEY = T3.CUSTOMER_KEY
LEFT OUTER JOIN
${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.PLCC_CARDHOLDER_${hiveconf:RUNDATE}_FLAG T4
ON
T1.CUSTOMER_KEY = T4.CUSTOMER_KEY
;





DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV_ATT_AGG_TXT;
CREATE EXTERNAL TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV_ATT_AGG_TXT
(
CUSTOMER_KEY BIGINT,
ITEM_QTY BIGINT,
GROSS_SALES_AMT DOUBLE,
DISCOUNT_AMT DOUBLE,
TOT_PRD_CST_AMT DOUBLE,
NET_SALES_AMT DOUBLE,
NET_MARGIN DOUBLE,
NET_SALES_AMT_RTL DOUBLE,
NET_SALES_AMT_ONL DOUBLE,
NUM_TXNS_RTL BIGINT,
NUM_TXNS_ONL BIGINT,
NUM_TXNS BIGINT,
PLCC BIGINT,
EXPECTEDLTV12 DOUBLE,
ATTRITIONPROB DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
COLLECTION ITEMS TERMINATED BY ','
LINES TERMINATED BY '\n'
LOCATION '/user/xtghosh/${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV_ATT_AGG_TXT'
TBLPROPERTIES ('serialization.null.format' = '')
;


INSERT OVERWRITE TABLE  ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV_ATT_AGG_TXT
SELECT
CUSTOMER_KEY,
ITEM_QTY,
GROSS_SALES_AMT,
DISCOUNT_AMT,
TOT_PRD_CST_AMT,
NET_SALES_AMT,
NET_MARGIN,
NET_SALES_AMT_RTL,
NET_SALES_AMT_ONL,
NUM_TXNS_RTL,
NUM_TXNS_ONL,
NUM_TXNS,
PLCC,
EXPECTEDLTV12,
ATTRITIONPROB
FROM  ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV_ATT_AGG;



DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LAST_AGG_TXT;
CREATE EXTERNAL TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LAST_AGG_TXT
(
CUSTOMER_KEY BIGINT,
ITEM_QTY BIGINT,
GROSS_SALES_AMT DOUBLE,
DISCOUNT_AMT DOUBLE,
TOT_PRD_CST_AMT DOUBLE,
NET_SALES_AMT DOUBLE,
NET_MARGIN DOUBLE,
NET_SALES_AMT_RTL DOUBLE,
NET_SALES_AMT_ONL DOUBLE,
NUM_TXNS_RTL BIGINT,
NUM_TXNS_ONL BIGINT,
NUM_TXNS BIGINT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
COLLECTION ITEMS TERMINATED BY ','
LINES TERMINATED BY '\n'
LOCATION '/user/xtghosh/${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LAST_AGG_TXT'
TBLPROPERTIES ('serialization.null.format' = '')
;


INSERT OVERWRITE TABLE  ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LAST_AGG_TXT
SELECT
CUSTOMER_KEY,
ITEM_QTY,
GROSS_SALES_AMT,
DISCOUNT_AMT,
TOT_PRD_CST_AMT,
NET_SALES_AMT,
NET_MARGIN,
NET_SALES_AMT_RTL,
NET_SALES_AMT_ONL,
NUM_TXNS_RTL,
NUM_TXNS_ONL,
NUM_TXNS
FROM  ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LAST_AGG;


