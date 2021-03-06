SET NUM=1; SET CURRENT_COUNTRY=US; SET CURRENT_BRAND=GP; SET RUNDATE=20161101; SET START_DT=2015-11-01; SET END_DT=2016-10-30; 

SET LTVPROCESSINGDATE=2016-11-01; SET ATTPROCESSINGDATE=2016-11-01; SET DIVPROCESSINGDATE = 2016-11-01;

SET mapred.job.queue.name=aa;
SET hive.cli.print.header=true;
SET hive.variable.substitute.depth=100;



DROP DATABASE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP CASCADE;
CREATE DATABASE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP LOCATION '/apps/hive/warehouse/aa_cem/xtghosh/${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.db';

USE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP;
SHOW TABLES;

DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1;	   
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1 AS
SELECT
T1.CUSTOMER_KEY, 
T1.BRAND,
T1.ORDER_STATUS, 
T1.TRANSACTION_NUM,
T1.TRANSACTION_TYPE_CD,
T1.DEMAND_DATE,
T1.SHIP_DATE
FROM MDS_NEW.ODS_ORDERHEADER_T T1 
WHERE 
T1.BRAND='${hiveconf:CURRENT_BRAND}' AND T1.COUNTRY='${hiveconf:CURRENT_COUNTRY}' AND T1.TRANSACTION_TYPE_CD IN ('S','M') AND
(
(T1.ORDER_STATUS='R' AND
 UNIX_TIMESTAMP(T1.SHIP_DATE,'yyyy-MM-dd') BETWEEN
 UNIX_TIMESTAMP('${hiveconf:START_DT}', 'yyyy-MM-dd') AND UNIX_TIMESTAMP('${hiveconf:END_DT}', 'yyyy-MM-dd')
 ) OR
(T1.ORDER_STATUS='O' AND
 UNIX_TIMESTAMP(T1.DEMAND_DATE, 'yyyy-MM-dd') BETWEEN
 UNIX_TIMESTAMP('${hiveconf:START_DT}', 'yyyy-MM-dd') AND UNIX_TIMESTAMP('${hiveconf:END_DT}', 'yyyy-MM-dd')
)
);



DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2
AS SELECT 
T3.*, 
T4.MDSE_DIV_DESC 
FROM
(
SELECT
T2.*, T1.PRODUCT_KEY, T1.LINE_NUM, T1.SALES_AMT, T1.ITEM_QTY
FROM MDS_NEW.ODS_ORDERLINE_T T1
INNER JOIN ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_1 T2
ON T1.CUSTOMER_KEY = T2.CUSTOMER_KEY AND T1.TRANSACTION_NUM = T2.TRANSACTION_NUM AND T1.BRAND = T2.BRAND
WHERE
T2.BRAND = '${hiveconf:CURRENT_BRAND}' AND T2.TRANSACTION_TYPE_CD IN ('S','M') AND T1.SALES_AMT > 0 AND T1.ITEM_QTY > 0
) T3
LEFT OUTER JOIN MDS_NEW.ODS_PRODUCT_T T4
ON T3.PRODUCT_KEY = T4.PRODUCT_KEY;



DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_3;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_3 
AS SELECT 
T1.*
FROM 
(
SELECT T2.*,
(
CASE 
WHEN BRAND = 'BR' AND INSTR(UPPER(MDSE_DIV_DESC), 'ACCESSORIES') > 0 THEN 'ACC'
WHEN BRAND = 'BR' AND INSTR(UPPER(MDSE_DIV_DESC), 'WOMEN') > 0 THEN 'WOMENS'
WHEN BRAND = 'BR' AND INSTR(UPPER(MDSE_DIV_DESC), 'MEN') > 0 THEN 'MENS'
WHEN BRAND = 'BR' AND INSTR(UPPER(MDSE_DIV_DESC), 'SHOE') > 0 THEN 'SHOES'
WHEN BRAND = 'BR' AND INSTR(UPPER(MDSE_DIV_DESC), 'PETITE') > 0 THEN 'PET'
WHEN BRAND = 'BR' AND INSTR(UPPER(MDSE_DIV_DESC), 'LICENSING') > 0 THEN 'LIC'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'ACCESS') > 0 THEN 'ACC'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'BABY') > 0 THEN 'BABY'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'BODY') > 0 THEN 'BODY'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'BOY') > 0 THEN 'BOYS'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'GAP1969') > 0 THEN 'GAP1969'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'WOMEN') > 0 THEN 'WOMENS'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'MEN') > 0 THEN 'MENS'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'GIRL') > 0 THEN 'GIRLS'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'KID') > 0 THEN 'KIDS'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'MATERNITY') > 0 THEN 'MAT'
WHEN BRAND = 'GP' AND INSTR(UPPER(MDSE_DIV_DESC), 'OUTLET') > 0 THEN 'OUTLET'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'ACCESS') > 0 THEN 'ACC'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'ACESS') >0 THEN 'ACC'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'BABY') > 0 THEN 'BABY'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'BOY') > 0 THEN 'BOYS'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'PLUS') > 0 THEN 'PLUSSZ'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'WOMEN') > 0 THEN 'WOMENS'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'MEN') > 0 THEN 'MENS'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'GIRL') > 0 THEN 'GIRLS'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'KID') > 0 THEN 'KIDS'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'MATERNITY') > 0 THEN 'MAT'
WHEN BRAND = 'ON' AND INSTR(UPPER(MDSE_DIV_DESC), 'FUN ZONE') > 0 THEN 'FUNZ'
ELSE 'MISC'
END 
) AS MDSE_DIV_DESC_CORRECTED
FROM ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_2 T2
) T1
;



DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV
AS SELECT
CUSTOMERKEY AS CUSTOMER_KEY,
EXPECTEDLTV12
FROM
EVERGREENATTRIBUTE.LIFETIMEVALUE${hiveconf:CURRENT_BRAND}ATTRIBUTE
WHERE 
YEAR(PROCESSINGDATE)  >= YEAR('${hiveconf:LTVPROCESSINGDATE}') AND
MONTH(PROCESSINGDATE) >= MONTH('${hiveconf:LTVPROCESSINGDATE}') ;


DROP TABLE IF EXISTS ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP;
CREATE TABLE ${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP
AS SELECT
T1.CUSTOMER_KEY,
T1.DIVISION,
T1.SALES_AMT,
T1.ITEM_QTY,
T2.EXPECTEDLTV12
FROM
(
SELECT CUSTOMER_KEY, MDSE_DIV_DESC_CORRECTED AS DIVISION, SUM(SALES_AMT) AS SALES_AMT, SUM(ITEM_QTY) AS ITEM_QTY
FROM
${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.SHOPPERS_${hiveconf:RUNDATE}_GRP_3
GROUP BY CUSTOMER_KEY, MDSE_DIV_DESC_CORRECTED
) T1
INNER JOIN
${hiveconf:CURRENT_BRAND}_${hiveconf:RUNDATE}_DATAPREP.${hiveconf:CURRENT_BRAND}_SHOPPERS_${hiveconf:RUNDATE}_LTV T2
ON
T1.CUSTOMER_KEY = T2.CUSTOMER_KEY;


DROP TABLE IF EXISTS TEST1; DROP TABLE IF EXISTS TEST2; DROP TABLE IF EXISTS TEST3; DROP TABLE IF EXISTS TEST4;
CREATE TABLE TEST1 AS SELECT * FROM SHOPPERS_20161101_GRP WHERE DIVISION='KIDS';
CREATE TABLE TEST2 AS SELECT * FROM SHOPPERS_20161101_GRP WHERE DIVISION='BABY';
CREATE TABLE TEST3 AS SELECT * FROM SHOPPERS_20161101_GRP WHERE DIVISION='MAT' ;

CREATE TABLE TEST4 AS SELECT DISTINCT T1.CUSTOMER_KEY, T1.EXPECTEDLTV12 FROM TEST2 T1 INNER JOIN TEST3 T2 ON T1.CUSTOMER_KEY = T2.CUSTOMER_KEY;


SELECT
COUNT(CUSTOMER_KEY) AS CUSTOMERS, 
CAST(SUM(EXPECTEDLTV12) AS BIGINT) AS EXPECTEDLTV12
FROM TEST4;
