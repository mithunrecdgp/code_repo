SET START_DATE_PURCH=2013-01-01;
SET START_DATE_PURCH_FILTER=2012-12-01;
SET END_DATE=2014-06-30;
SET end_date_train=2013-12-31;
SET START_DATE_CLICK=2013-10-01;

DROP TABLE IF EXISTS purchases_prod;
CREATE TABLE purchases_prod AS SELECT d.customer_key,d.transaction_date,d.item_qty,d.order_status,d.line_num,d.transaction_num,d.sales_amt,c.mdse_div_desc,c.mdse_class_desc,c.mdse_dept_desc,c.style_cd,c.size_model_cd,d.product_size_cd,d.product_size_desc,CONCAT_WS('_',UPPER(c.mdse_div_desc),UPPER(c.mdse_dept_desc),UPPER(c.mdse_class_desc)) as prod_hier,c.prod_desc
FROM (SELECT * FROM MDS.ods_orderline_t WHERE upper(brand)=upper('GP') AND order_status IN ('O','R')
AND transaction_date between '${hiveconf:START_DATE_PURCH}' AND '${hiveconf:END_DATE}'
AND sales_amt>0 and item_qty>0 AND country='US') d INNER JOIN (SELECT DISTINCT a.prod_desc,b.product_key,b.mdse_div_desc,b.mdse_dept_desc,b.mdse_class_desc,b.style_cd,b.size_model_cd FROM (SELECT min(prod_desc) AS prod_desc,product_key FROM MDS.ods_product_t where mdse_corp_desc in ('GAP DIR','THE GAP') GROUP BY product_key) a INNER JOIN (SELECT DISTINCT prod_desc,product_key,mdse_div_desc,mdse_dept_desc,mdse_class_desc,style_cd,size_model_cd FROM MDS.ods_product_t where mdse_corp_desc in ('GAP DIR','THE GAP')) b ON a.product_key=b.product_key AND a.prod_desc=b.prod_desc) c ON d.product_key=c.product_key;

--Join to customer resolution (want to sum over masterkeys)
DROP TABLE IF EXISTS purchases_res;
CREATE TABLE purchases_res AS SELECT a.*,(CASE WHEN b.masterkey IS NULL THEN CAST(a.customer_key AS STRING) ELSE b.masterkey END) AS masterkey FROM purchases_prod a LEFT OUTER JOIN (SELECT DISTINCT customerkey,masterkey FROM crmanalytics.customerresolution) b ON a.customer_key=b.customerkey;


select count(distinct customer_key) from purchases_prod;
--10160804

select count(distinct masterkey) from purchases_res;
--9375687

--Get venus size info
DROP TABLE gp_venus_size;
CREATE TABLE gp_venus_size AS SELECT a.*,b.long_sz_desc FROM purchases_res a LEFT OUTER JOIN (SELECT DISTINCT opr_sty_cd,UPPER(long_sz_desc) AS long_sz_desc,sz_mdl_cd,opr_sz_cd FROM venus.sku_dim) b ON a.style_cd=b.opr_sty_cd and a.size_model_cd=b.sz_mdl_cd and a.product_size_cd=b.opr_sz_cd;


--Get EDW size info
DROP TABLE gp_order_header_info;
CREATE TABLE gp_order_header_info AS SELECT a.*,b.order_num,b.str_nbr,b.regr_nbr,b.txn_nbr,substr(b.txn_dt,1,10) AS txn_dt FROM gp_venus_size a INNER JOIN (SELECT DISTINCT order_num,str_nbr,regr_nbr,txn_nbr,txn_dt,transaction_num FROM mds.ods_orderheader_t WHERE ship_date>'${hiveconf:START_DATE_PURCH_FILTER}') b ON a.transaction_num=b.transaction_num;

DROP TABLE gp_edw_line;
CREATE TABLE gp_edw_line AS SELECT a.*,b.Tot_Sls_Amt AS Gross_Sales,b.DNRM_NET_DSCT_UN_PRC_AMT,b.ITM_QTY,b.brd_sku_id,b.txn_ln_seq_nbr,b.DNRM_WAC_CST_AMT FROM gp_order_header_info a 
LEFT OUTER JOIN (SELECT c.*,d.opr_loc_nbr FROM (SELECT * FROM edw_viewsls.TSTIW_SLS_TXN_LN_ITM_FCT where txn_dt>'${hiveconf:START_DATE_PURCH_FILTER}' and VD_IND='N' and SLS_RTN_IND!='Y') c INNER JOIN edw_viewfndt.TFNLD_FIN_LOC_FLATTENED_DIM d ON c.loc_key=d.loc_key) b ON a.regr_nbr=b.regr_nbr and a.txn_nbr=b.txn_nbr and a.txn_dt=b.txn_dt and a.str_nbr=b.opr_loc_nbr and a.line_num=b.txn_ln_seq_nbr;

drop table edw_check;
create table edw_check AS select customer_key,count(*) from gp_edw_line group by customer_key;
select * from gp_edw_line order by customer_key limit 20;

drop table mds_check;
create table mds_check as select customer_key,count(*) from gp_order_header_info group by customer_key;
select * from mds_check order by customer_key limit 20;

--Join to edw_viewfndt.tskud_brd_sku_dim to get sz_key
DROP TABLE gp_edw_line_szkey;
CREATE TABLE gp_edw_line_szkey AS SELECT a.*,b.sz_key FROM gp_edw_line a LEFT OUTER JOIN (SELECT CAST(brd_sku_key AS BIGINT) AS brd_sku_key,sz_key FROM edw_viewfndt.tskud_brd_sku_dim) b ON a.brd_sku_id=b.brd_sku_key;

--Join to tszdl_sz_grp_def_lookup
DROP TABLE gp_edw_size_desc;
CREATE TABLE gp_edw_size_desc AS SELECT a.*,UPPER(b.sz_desc) AS sz_desc,(CASE WHEN order_status='O' THEN UPPER(long_sz_desc) ELSE UPPER(sz_desc) END) AS new_sz_desc FROM gp_edw_line_szkey a LEFT OUTER JOIN edw_viewfndt.tszdl_sz_grp_def_lookup b ON a.sz_key=b.sz_key;


select * from gp_edw_size_desc where order_status='O' limit 10;

select transaction_date,transaction_num,line_num,product_size_desc,long_sz_desc from gp_edw_size_desc where order_status='O' and upper(product_size_desc)!=upper(long_sz_desc) limit 10;

select count(*) from gp_edw_size_desc where order_status='O' and upper(product_size_desc)!=upper(long_sz_desc);
select count(*) from gp_edw_size_desc where order_status='O';

select transaction_date,transaction_num,line_num,product_size_desc,long_sz_desc from gp_edw_size_desc where order_status='R' and upper(product_size_desc)!=upper(long_sz_desc) limit 10;

select count(*) from gp_edw_size_desc where order_status='R' and upper(product_size_desc)!=upper(long_sz_desc);
select count(*) from gp_edw_size_desc where order_status='R';


DROP TABLE IF EXISTS divflags1;
CREATE TABLE divflags1 AS SELECT *,
        (CASE WHEN (product_size_desc IN ('0-6m','0-3m','0-3 m','upto 3m','up to3m','upto5lb','upto7lb','0-3mo','0-3 mo','0-3mos','premie',
 'newborn','3-6m','3-6 m','3-6mo','3-6 mo','3-6mos','3-6 mos','6-12m','6-12 m','6-12mo','6-12 mo','6-12 mos','6-12mos',
 '6-9m','6-9 m','6-9mo','6-9 mo','6-9mos','6-9 mos','12-18m','12-18 m','12-18mo','12-18 mo','12-18mos','12-18 mos','1t/2t','18-24m','18-24 m','18-24mo','18-24 mo','18-24mos','18-24 mos','12-24mos','12-24m','onesize') or (product_size_desc='0' and mdse_div_desc='BABY') or  (product_size_desc in ('5','6','7') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') OR mdse_dept_desc='NEWBORN' OR mdse_class_desc RLIKE 'BABY') AND prod_hier RLIKE 'GIRL' THEN 'BABYGIRL'
        WHEN (product_size_desc IN ('0-6m','0-3m','0-3 m','upto 3m','up to3m','upto5lb','upto7lb','0-3mo','0-3 mo','0-3mos','premie',
 'newborn','3-6m','3-6 m','3-6mo','3-6 mo','3-6mos','3-6 mos','6-12m','6-12 m','6-12mo','6-12 mo','6-12 mos','6-12mos',
 '6-9m','6-9 m','6-9mo','6-9 mo','6-9mos','6-9 mos','12-18m','12-18 m','12-18mo','12-18 mo','12-18mos','12-18 mos','1t/2t','18-24m','18-24 m','18-24mo','18-24 mo','18-24mos','18-24 mos','12-24mos','12-24m','onesize') or (product_size_desc='0' and mdse_div_desc='BABY') or  (product_size_desc in ('5','6','7') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') OR mdse_dept_desc='NEWBORN' OR mdse_class_desc RLIKE 'BABY') AND prod_hier RLIKE 'BOY' THEN 'BABYBOY'
               WHEN (UPPER(product_size_desc) IN ('0-6M','0-3M','0-3 M','upto 3M','up to3M','upto5LB','upto7LB','0-3MO','0-3 MO','0-3MOS','PREMIE',
 'NEWBORN','3-6M','3-6 M','3-6MO','3-6 MO','3-6MOS','3-6 MOS','6-12M','6-12 M','6-12MO','6-12 MO','6-12 MOS','6-12MOS',
 '6-9M','6-9 M','6-9MO','6-9 MO','6-9MOS','6-9 MOS','12-18M','12-18 M','12-18MO','12-18 MO','12-18MOS','12-18 MOS','1T/2T','18-24M','18-24 M','18-24MO','18-24 MO','18-24MOS','18-24 MOS','12-24MOS','12-24M','ONESIZE') or (product_size_desc='0' and mdse_div_desc='BABY') or  (product_size_desc in ('5','6') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') OR mdse_dept_desc='NEWBORN' OR mdse_class_desc RLIKE 'BABY')  THEN 'BABYUNISEX'       
        WHEN (prod_hier RLIKE 'GIRL' and (
product_size_desc IN ('2t','2 yrs','2yrs','2 1/2t','2t/3t','2-3 yrs','3t','3 yrs','3yrs','3t/4t','3-4 yrs','4t','4t/5t','4-5 yrs','4toddlr','4 yrs','4yrs','4','5t','5t/6t','5t','5 yrs','5yrs') OR product_size_desc RLIKE '^5' OR (product_size_desc IN ('8','9','10','11') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') or ((split(prod_hier, '[_]')[0] RLIKE 'GIRL' or split(prod_hier, '[_]')[0] RLIKE 'KID') and  (product_size_desc='xxs/xs' or product_size_desc = 'xs')) or prod_hier RLIKE 'TODDLER')) or (substr(prod_desc,1,2)='G ' and mdse_div_desc='BABY') THEN 'TODDLERGIRL'
        WHEN (prod_hier RLIKE 'BOY' and (
product_size_desc IN ('2t','2 yrs','2yrs','2 1/2t','2t/3t','2-3 yrs','3t','3 yrs','3yrs','3t/4t','3-4 yrs','4t','4t/5t','4-5 yrs','4toddlr','4 yrs','4yrs','4','5t','5t/6t','5t','5 yrs','5yrs') OR product_size_desc RLIKE '^5' OR (product_size_desc IN ('8','9','10','11') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') or ((split(prod_hier, '[_]')[0] RLIKE 'BOY'  or split(prod_hier, '[_]')[0] RLIKE 'KID') and  (product_size_desc='xxs/xs' or product_size_desc = 'xs')) or prod_hier RLIKE 'TODDLER')) or (substr(prod_desc,1,2)='B ' and mdse_div_desc='BABY') THEN 'TODDLERBOY'
        WHEN mdse_div_desc='GIRLS' or mdse_dept_desc in ('GIRLS ACCESSORIES') THEN 'GIRL'
        WHEN mdse_div_desc in ('BOYS') or mdse_dept_desc in ('BOYS ACCESSORIES')  THEN 'BOY'
        WHEN mdse_div_desc in ('GAP WOMENS','GAPBODY') or mdse_dept_desc in ('WOMENS ACCESSORIES','JEWELRY')  THEN 'WOMEN'
        WHEN mdse_div_desc in ('GAP MENS') or mdse_dept_desc in ('MENS ACCESSORIES','MENS BODY')  THEN 'MEN'
        WHEN mdse_div_desc in ('MATERNITY','MATERNITY IN STORE') THEN 'MATERNITY'
        ELSE 'NONE' END) AS division 
 FROM purchases_res;
--preprocessing ends


DROP TABLE IF EXISTS divflags2;
CREATE TABLE divflags2 AS SELECT *,
        (CASE WHEN (UPPER(new_sz_desc) IN ('0-6M','0-3M','0-3 M','upto 3M','up to3M','upto5LB','upto7LB','0-3MO','0-3 MO','0-3MOS','PREMIE',
 'NEWBORN','3-6M','3-6 M','3-6MO','3-6 MO','3-6MOS','3-6 MOS','6-12M','6-12 M','6-12MO','6-12 MO','6-12 MOS','6-12MOS',
 '6-9M','6-9 M','6-9MO','6-9 MO','6-9MOS','6-9 MOS','12-18M','12-18 M','12-18MO','12-18 MO','12-18MOS','12-18 MOS','1T/2T','18-24M','18-24 M','18-24MO','18-24 MO','18-24MOS','18-24 MOS','12-24MOS','12-24M','ONESIZE') or (new_sz_desc='0' and mdse_div_desc='BABY') or  (new_sz_desc in ('5','6','7') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') OR mdse_dept_desc='NEWBORN' OR mdse_class_desc RLIKE 'BABY') AND prod_hier RLIKE 'GIRL' THEN 'BABYGIRL'
        WHEN (UPPER(new_sz_desc) IN ('0-6M','0-3M','0-3 M','upto 3M','up to3M','upto5LB','upto7LB','0-3MO','0-3 MO','0-3MOS','PREMIE',
 'NEWBORN','3-6M','3-6 M','3-6MO','3-6 MO','3-6MOS','3-6 MOS','6-12M','6-12 M','6-12MO','6-12 MO','6-12 MOS','6-12MOS',
 '6-9M','6-9 M','6-9MO','6-9 MO','6-9MOS','6-9 MOS','12-18M','12-18 M','12-18MO','12-18 MO','12-18MOS','12-18 MOS','1T/2T','18-24M','18-24 M','18-24MO','18-24 MO','18-24MOS','18-24 MOS','12-24MOS','12-24M','ONESIZE') or (new_sz_desc='0' and mdse_div_desc='BABY') or  (new_sz_desc in ('5','6','7') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') OR mdse_dept_desc='NEWBORN' OR mdse_class_desc RLIKE 'BABY') AND prod_hier RLIKE 'BOY' THEN 'BABYBOY'
         WHEN (UPPER(new_sz_desc) IN ('0-6M','0-3M','0-3 M','upto 3M','up to3M','upto5LB','upto7LB','0-3MO','0-3 MO','0-3MOS','PREMIE',
 'NEWBORN','3-6M','3-6 M','3-6MO','3-6 MO','3-6MOS','3-6 MOS','6-12M','6-12 M','6-12MO','6-12 MO','6-12 MOS','6-12MOS',
 '6-9M','6-9 M','6-9MO','6-9 MO','6-9MOS','6-9 MOS','12-18M','12-18 M','12-18MO','12-18 MO','12-18MOS','12-18 MOS','1T/2T','18-24M','18-24 M','18-24MO','18-24 MO','18-24MOS','18-24 MOS','12-24MOS','12-24M','ONESIZE') or (product_size_desc='0' and mdse_div_desc='BABY') or  (product_size_desc in ('5','6') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') OR mdse_dept_desc='NEWBORN' OR mdse_class_desc RLIKE 'BABY')  THEN 'BABYUNISEX'       
        WHEN (prod_hier RLIKE 'GIRL' and (
UPPER(new_sz_desc) IN ('2T','2 YRS','2YRS','2 1/2T','2T/3T','2-3 YRS','3T','3 YRS','3YRS','3T/4T','3-4 YRS','4T','4T/5T','4-5 YRS','4TODDLR','4 YRS','4YRS','4','5T','5T/6T','5T','5 YRS','5YRS') OR new_sz_desc RLIKE '^5' OR (new_sz_desc IN ('8','9','10','11') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') or ((split(prod_hier, '[_]')[0] RLIKE 'GIRL' or split(prod_hier, '[_]')[0] RLIKE 'KID') and  (UPPER(new_sz_desc)='XXS/XS' or UPPER(new_sz_desc) = 'XS')) or prod_hier RLIKE 'TODDLER')) or (substr(prod_desc,1,2)='G ' and mdse_div_desc='BABY') THEN 'TODDLERGIRL'
        WHEN (prod_hier RLIKE 'BOY' and (
UPPER(new_sz_desc) IN ('2T','2 YRS','2YRS','2 1/2T','2T/3T','2-3 YRS','3T','3 YRS','3YRS','3T/4T','3-4 YRS','4T','4T/5T','4-5 YRS','4TODDLR','4 YRS','4YRS','4','5T','5T/6T','5T','5 YRS','5YRS') OR new_sz_desc RLIKE '^5' OR (new_sz_desc IN ('8','9','10','11') and split(prod_hier, '[_]')[2] RLIKE 'SHOES') or ((split(prod_hier, '[_]')[0] RLIKE 'BOY'  or split(prod_hier, '[_]')[0] RLIKE 'KID') and  (UPPER(new_sz_desc)='XXS/XS' or UPPER(new_sz_desc) = 'XS')) or prod_hier RLIKE 'TODDLER')) or (substr(prod_desc,1,2)='B ' and mdse_div_desc='BABY') THEN 'TODDLERBOY'
        WHEN mdse_div_desc='GIRLS' or mdse_dept_desc in ('GIRLS ACCESSORIES') or (mdse_div_desc='ACCESSORIES' and (substr(prod_desc,1,2)='G ' or prod_desc RLIKE 'GIRL')) THEN 'GIRL'
        WHEN mdse_div_desc in ('BOYS') or mdse_dept_desc in ('BOYS ACCESSORIES') or (mdse_div_desc='ACCESSORIES' and (substr(prod_desc,1,2)='B ' or prod_desc RLIKE 'BOY')) THEN 'BOY'
        WHEN mdse_div_desc in ('GAP WOMENS','GAPBODY') or mdse_dept_desc in ('WOMENS ACCESSORIES','JEWELRY')  or (mdse_div_desc='ACCESSORIES' and substr(prod_desc,1,2)='W ') THEN 'WOMEN'
        WHEN mdse_div_desc in ('GAP MENS') or mdse_dept_desc in ('MENS ACCESSORIES','MENS BODY') or (mdse_div_desc='ACCESSORIES' and substr(prod_desc,1,2)='M ') THEN 'MEN'
        WHEN mdse_div_desc in ('MATERNITY','MATERNITY IN STORE') THEN 'MATERNITY'
        ELSE 'NONE' END) AS division
 FROM gp_edw_size_desc;

select prod_desc,new_sz_desc,mdse_div_desc,count(*) as cnt_sz from divflags2 where division='NONE' and mdse_div_desc='BABY' group by prod_desc,new_sz_desc,mdse_div_desc order by cnt_sz DESC;

select mdse_div_desc,count(*) as cnt_sz from divflags2 where division='NONE' group by mdse_div_desc order by cnt_sz DESC;


DROP TABLE comparesize;
CREATE TABLE comparesize AS SELECT a.masterkey,a.division AS division_old,b.division AS division_new,b.mdse_div_desc,b.mdse_dept_desc,b.mdse_class_desc,b.prod_desc,b.prod_hier,b.new_sz_desc,b.product_size_desc FROM divflags1 a INNER JOIN divflags2 b ON a.masterkey=b.masterkey AND a.transaction_num=b.transaction_num and a.line_num=b.line_num;

select count(*) from divflags2 where division='NONE';
--1263749

select count(*) from divflags1 where division='NONE';
--3015864

select count(*) from comparesize;
--118537027

select count(*) from divflags2;
--118537027

select count(*) from divflags1;
--118537028

select count(*) from comparesize where division_old!=division_new;
--3582193

select count(*) from comparesize where division_old!=division_new and division_new!='NONE';
--3436621

select count(*) from comparesize where division_old!=division_new and division_new='BABYGIRL';
--17740

select count(*) from comparesize where division_old!=division_new and division_new='BABYUNISEX';
--6017

select count(*) from comparesize where division_old!=division_new and division_new='BABYBOY';
--17058

select count(*) from comparesize where division_old!=division_new and division_new='TODDLERGIRL';
--394041

select count(*) from comparesize where division_new='TODDLERGIRL';
--10189696

select count(*) from comparesize where division_old!=division_new and division_new='TODDLERBOY';
--510157

select count(*) from comparesize where division_new='TODDLERBOY';
--9960952

select count(*) from comparesize where division_old!=division_new and division_new='GIRL';
--938567

select count(*) from comparesize where division_new='GIRL';
--12712820

SET end_date_train=2015-06-08;

-- aggregattion- create seperate tables for each divisions
DROP TABLE IF EXISTS babygirltrain;
CREATE TABLE babygirltrain AS SELECT masterkey,sum(item_qty) AS cnt_babygirl,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_babygirl,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_babygirl FROM divflags2 WHERE division='BABYGIRL' GROUP BY masterkey;

DROP TABLE IF EXISTS babyboytrain;
CREATE TABLE babyboytrain AS SELECT masterkey,sum(item_qty) AS cnt_babyboy,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_babyboy,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_babyboy  FROM divflags2 WHERE division='BABYBOY' GROUP BY masterkey;

DROP TABLE IF EXISTS babyutrain;
CREATE TABLE babyutrain AS SELECT masterkey,sum(item_qty) AS cnt_babyunisex,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_babyunisex,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_babyu FROM divflags2 WHERE division='BABYUNISEX' GROUP BY masterkey;

DROP TABLE IF EXISTS toddlergirltrain;
CREATE TABLE toddlergirltrain AS SELECT masterkey,sum(item_qty) AS cnt_toddlergirl,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_toddlergirl,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_toddlergirl FROM divflags2 WHERE division='TODDLERGIRL' GROUP BY masterkey;

DROP TABLE IF EXISTS toddlerboytrain;
CREATE TABLE toddlerboytrain AS SELECT masterkey,sum(item_qty) AS cnt_toddlerboy,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_toddlerboy,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_toddlerboy FROM divflags2 WHERE division='TODDLERBOY'  GROUP BY masterkey;

DROP TABLE IF EXISTS girltrain;
CREATE TABLE girltrain AS SELECT masterkey,sum(item_qty) AS cnt_girl,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_girl,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_girl FROM divflags2 WHERE division='GIRL' GROUP BY masterkey;

DROP TABLE IF EXISTS boytrain;
CREATE TABLE boytrain AS SELECT masterkey,sum(item_qty) AS cnt_boy,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_boy,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_boy FROM divflags2 WHERE division='BOY' GROUP BY masterkey;

DROP TABLE IF EXISTS womentrain;
CREATE TABLE womentrain AS SELECT masterkey,sum(item_qty) AS cnt_women,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_women,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_women FROM divflags2 WHERE division='WOMEN' GROUP BY masterkey;

DROP TABLE IF EXISTS mentrain;
CREATE TABLE mentrain AS SELECT masterkey,sum(item_qty) AS cnt_men,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_men,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_men FROM divflags2 WHERE division='MEN' GROUP BY masterkey;

DROP TABLE IF EXISTS maternitytrain;
CREATE TABLE maternitytrain AS SELECT masterkey,sum(item_qty) AS cnt_maternity,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_maternity,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_maternity FROM divflags2 WHERE division='MATERNITY' GROUP BY masterkey;

-- aggregation ends
--denorm-- colasse all the above tables
--Outer join in single step breaks after more than 2 tables so break up join

DROP TABLE IF EXISTS purch_all_train00;
CREATE TABLE purch_all_train00 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.cnt_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(b.cnt_babyboy,0) AS count_purch_babyboy,
        COALESCE(b.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(b.study_duration_babyboy,0) AS study_duration_babyboy
FROM babygirltrain a FULL OUTER JOIN
        babyboytrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train0;
CREATE TABLE purch_all_train0 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(b.cnt_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(b.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(b.study_duration_toddlergirl,0) AS study_duration_toddlergirl
FROM purch_all_train00 a FULL OUTER JOIN
        toddlergirltrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train1;
CREATE TABLE purch_all_train1 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(b.cnt_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(b.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(b.study_duration_toddlerboy,0) AS study_duration_toddlerboy
FROM purch_all_train0 a FULL OUTER JOIN
        toddlerboytrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train2;
CREATE TABLE purch_all_train2 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(b.cnt_girl,0) AS count_purch_girl,
        COALESCE(b.days_since_girl,0) AS days_since_girl,
        COALESCE(b.study_duration_girl,0) AS study_duration_girl
FROM purch_all_train1 a FULL OUTER JOIN
        girltrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train3;
CREATE TABLE purch_all_train3 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(b.cnt_boy,0) AS count_purch_boy,
        COALESCE(b.days_since_boy,0) AS days_since_boy,
        COALESCE(b.study_duration_boy,0) AS study_duration_boy
FROM purch_all_train2 a FULL OUTER JOIN
        boytrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train4;
CREATE TABLE purch_all_train4 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.count_purch_boy,0) AS count_purch_boy,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.days_since_boy,0) AS days_since_boy,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(a.study_duration_boy,0) AS study_duration_boy,
        COALESCE(b.cnt_women,0) AS count_purch_women,
        COALESCE(b.days_since_women,0) AS days_since_women,
        COALESCE(b.study_duration_women,0) AS study_duration_women
FROM purch_all_train3 a FULL OUTER JOIN
        womentrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train5;
CREATE TABLE purch_all_train5 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.count_purch_boy,0) AS count_purch_boy,
        COALESCE(a.count_purch_women,0) AS count_purch_women,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.days_since_boy,0) AS days_since_boy,
        COALESCE(a.days_since_women,0) AS days_since_women,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(a.study_duration_boy,0) AS study_duration_boy,
        COALESCE(a.study_duration_women,0) AS study_duration_women,
        COALESCE(b.cnt_men,0) AS count_purch_men,
        COALESCE(b.days_since_men,0) AS days_since_men,
        COALESCE(b.study_duration_men,0) AS study_duration_men
FROM purch_all_train4 a FULL OUTER JOIN
        mentrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train6;
CREATE TABLE purch_all_train6 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.count_purch_boy,0) AS count_purch_boy,
        COALESCE(a.count_purch_men,0) AS count_purch_men,
        COALESCE(a.count_purch_women,0) AS count_purch_women,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.days_since_boy,0) AS days_since_boy,
        COALESCE(a.days_since_women,0) AS days_since_women,
        COALESCE(a.days_since_men,0) AS days_since_men,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(a.study_duration_boy,0) AS study_duration_boy,
        COALESCE(a.study_duration_women,0) AS study_duration_women,
        COALESCE(a.study_duration_men,0) AS study_duration_men,
        COALESCE(b.cnt_babyunisex,0) AS count_purch_babyunisex,
        COALESCE(b.days_since_babyunisex,0) AS days_since_babyunisex,
        COALESCE(b.study_duration_babyu,0) AS study_duration_babyu
FROM purch_all_train5 a FULL OUTER JOIN
        babyutrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train;
CREATE TABLE purch_all_train AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.count_purch_boy,0) AS count_purch_boy,
        COALESCE(a.count_purch_women,0) AS count_purch_women,
        COALESCE(a.count_purch_men,0) AS count_purch_men,
        COALESCE(a.count_purch_babyunisex,0) AS count_purch_babyunisex,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.days_since_boy,0) AS days_since_boy,
        COALESCE(a.days_since_women,0) AS days_since_women,
        COALESCE(a.days_since_men,0) AS days_since_men,
        COALESCE(a.days_since_babyunisex,0) AS days_since_babyunisex,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(a.study_duration_boy,0) AS study_duration_boy,
        COALESCE(a.study_duration_women,0) AS study_duration_women,
        COALESCE(a.study_duration_men,0) AS study_duration_men,
        COALESCE(a.study_duration_babyu,0) AS study_duration_babyu,
        COALESCE(b.cnt_maternity,0) AS count_purch_maternity,
        COALESCE(b.days_since_maternity,0) AS days_since_maternity,
        COALESCE(b.study_duration_maternity,0) AS study_duration_maternity
FROM purch_all_train6 a FULL OUTER JOIN
        maternitytrain b
ON a.masterkey=b.masterkey;





DROP TABLE IF EXISTS babygirltrain;
CREATE TABLE babygirltrain AS SELECT masterkey,sum(item_qty) AS cnt_babygirl,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_babygirl,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_babygirl FROM divflags1 WHERE division='BABYGIRL' GROUP BY masterkey;

DROP TABLE IF EXISTS babyboytrain;
CREATE TABLE babyboytrain AS SELECT masterkey,sum(item_qty) AS cnt_babyboy,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_babyboy,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_babyboy  FROM divflags1 WHERE division='BABYBOY' GROUP BY masterkey;

DROP TABLE IF EXISTS babyutrain;
CREATE TABLE babyutrain AS SELECT masterkey,sum(item_qty) AS cnt_babyunisex,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_babyunisex,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_babyu FROM divflags1 WHERE division='BABYUNISEX' GROUP BY masterkey;

DROP TABLE IF EXISTS toddlergirltrain;
CREATE TABLE toddlergirltrain AS SELECT masterkey,sum(item_qty) AS cnt_toddlergirl,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_toddlergirl,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_toddlergirl FROM divflags1 WHERE division='TODDLERGIRL' GROUP BY masterkey;

DROP TABLE IF EXISTS toddlerboytrain;
CREATE TABLE toddlerboytrain AS SELECT masterkey,sum(item_qty) AS cnt_toddlerboy,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_toddlerboy,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_toddlerboy FROM divflags1 WHERE division='TODDLERBOY'  GROUP BY masterkey;

DROP TABLE IF EXISTS girltrain;
CREATE TABLE girltrain AS SELECT masterkey,sum(item_qty) AS cnt_girl,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_girl,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_girl FROM divflags1 WHERE division='GIRL' GROUP BY masterkey;

DROP TABLE IF EXISTS boytrain;
CREATE TABLE boytrain AS SELECT masterkey,sum(item_qty) AS cnt_boy,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_boy,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_boy FROM divflags1 WHERE division='BOY' GROUP BY masterkey;

DROP TABLE IF EXISTS womentrain;
CREATE TABLE womentrain AS SELECT masterkey,sum(item_qty) AS cnt_women,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_women,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_women FROM divflags1 WHERE division='WOMEN' GROUP BY masterkey;

DROP TABLE IF EXISTS mentrain;
CREATE TABLE mentrain AS SELECT masterkey,sum(item_qty) AS cnt_men,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_men,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_men FROM divflags1 WHERE division='MEN' GROUP BY masterkey;

DROP TABLE IF EXISTS maternitytrain;
CREATE TABLE maternitytrain AS SELECT masterkey,sum(item_qty) AS cnt_maternity,datediff('${hiveconf:end_date_train}',max(transaction_date))+1 AS days_since_maternity,datediff('${hiveconf:end_date_train}',min(transaction_date)) AS study_duration_maternity FROM divflags1 WHERE division='MATERNITY' GROUP BY masterkey;

-- aggregation ends
--denorm-- colasse all the above tables
--Outer join in single step breaks after more than 2 tables so break up join

DROP TABLE IF EXISTS purch_all_train00;
CREATE TABLE purch_all_train00 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.cnt_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(b.cnt_babyboy,0) AS count_purch_babyboy,
        COALESCE(b.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(b.study_duration_babyboy,0) AS study_duration_babyboy
FROM babygirltrain a FULL OUTER JOIN
        babyboytrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train0;
CREATE TABLE purch_all_train0 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(b.cnt_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(b.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(b.study_duration_toddlergirl,0) AS study_duration_toddlergirl
FROM purch_all_train00 a FULL OUTER JOIN
        toddlergirltrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train1;
CREATE TABLE purch_all_train1 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(b.cnt_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(b.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(b.study_duration_toddlerboy,0) AS study_duration_toddlerboy
FROM purch_all_train0 a FULL OUTER JOIN
        toddlerboytrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train2;
CREATE TABLE purch_all_train2 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(b.cnt_girl,0) AS count_purch_girl,
        COALESCE(b.days_since_girl,0) AS days_since_girl,
        COALESCE(b.study_duration_girl,0) AS study_duration_girl
FROM purch_all_train1 a FULL OUTER JOIN
        girltrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train3;
CREATE TABLE purch_all_train3 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(b.cnt_boy,0) AS count_purch_boy,
        COALESCE(b.days_since_boy,0) AS days_since_boy,
        COALESCE(b.study_duration_boy,0) AS study_duration_boy
FROM purch_all_train2 a FULL OUTER JOIN
        boytrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train4;
CREATE TABLE purch_all_train4 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.count_purch_boy,0) AS count_purch_boy,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.days_since_boy,0) AS days_since_boy,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(a.study_duration_boy,0) AS study_duration_boy,
        COALESCE(b.cnt_women,0) AS count_purch_women,
        COALESCE(b.days_since_women,0) AS days_since_women,
        COALESCE(b.study_duration_women,0) AS study_duration_women
FROM purch_all_train3 a FULL OUTER JOIN
        womentrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train5;
CREATE TABLE purch_all_train5 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.count_purch_boy,0) AS count_purch_boy,
        COALESCE(a.count_purch_women,0) AS count_purch_women,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.days_since_boy,0) AS days_since_boy,
        COALESCE(a.days_since_women,0) AS days_since_women,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(a.study_duration_boy,0) AS study_duration_boy,
        COALESCE(a.study_duration_women,0) AS study_duration_women,
        COALESCE(b.cnt_men,0) AS count_purch_men,
        COALESCE(b.days_since_men,0) AS days_since_men,
        COALESCE(b.study_duration_men,0) AS study_duration_men
FROM purch_all_train4 a FULL OUTER JOIN
        mentrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train6;
CREATE TABLE purch_all_train6 AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.count_purch_boy,0) AS count_purch_boy,
        COALESCE(a.count_purch_men,0) AS count_purch_men,
        COALESCE(a.count_purch_women,0) AS count_purch_women,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.days_since_boy,0) AS days_since_boy,
        COALESCE(a.days_since_women,0) AS days_since_women,
        COALESCE(a.days_since_men,0) AS days_since_men,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(a.study_duration_boy,0) AS study_duration_boy,
        COALESCE(a.study_duration_women,0) AS study_duration_women,
        COALESCE(a.study_duration_men,0) AS study_duration_men,
        COALESCE(b.cnt_babyunisex,0) AS count_purch_babyunisex,
        COALESCE(b.days_since_babyunisex,0) AS days_since_babyunisex,
        COALESCE(b.study_duration_babyu,0) AS study_duration_babyu
FROM purch_all_train5 a FULL OUTER JOIN
        babyutrain b
ON a.masterkey=b.masterkey;

DROP TABLE IF EXISTS purch_all_train_old;
CREATE TABLE purch_all_train_old AS SELECT
        COALESCE(a.masterkey,b.masterkey) AS masterkey,
        COALESCE(a.count_purch_babygirl,0) AS count_purch_babygirl,
        COALESCE(a.count_purch_babyboy,0) AS count_purch_babyboy,
        COALESCE(a.count_purch_toddlergirl,0) AS count_purch_toddlergirl,
        COALESCE(a.count_purch_toddlerboy,0) AS count_purch_toddlerboy,
        COALESCE(a.count_purch_girl,0) AS count_purch_girl,
        COALESCE(a.count_purch_boy,0) AS count_purch_boy,
        COALESCE(a.count_purch_women,0) AS count_purch_women,
        COALESCE(a.count_purch_men,0) AS count_purch_men,
        COALESCE(a.count_purch_babyunisex,0) AS count_purch_babyunisex,
        COALESCE(a.days_since_babygirl,0) AS days_since_babygirl,
        COALESCE(a.days_since_babyboy,0) AS days_since_babyboy,
        COALESCE(a.days_since_toddlergirl,0) AS days_since_toddlergirl,
        COALESCE(a.days_since_toddlerboy,0) AS days_since_toddlerboy,
        COALESCE(a.days_since_girl,0) AS days_since_girl,
        COALESCE(a.days_since_boy,0) AS days_since_boy,
        COALESCE(a.days_since_women,0) AS days_since_women,
        COALESCE(a.days_since_men,0) AS days_since_men,
        COALESCE(a.days_since_babyunisex,0) AS days_since_babyunisex,
        COALESCE(a.study_duration_babygirl,0) AS study_duration_babygirl,
        COALESCE(a.study_duration_babyboy,0) AS study_duration_babyboy,
        COALESCE(a.study_duration_toddlergirl,0) AS study_duration_toddlergirl,
        COALESCE(a.study_duration_toddlerboy,0) AS study_duration_toddlerboy,
        COALESCE(a.study_duration_girl,0) AS study_duration_girl,
        COALESCE(a.study_duration_boy,0) AS study_duration_boy,
        COALESCE(a.study_duration_women,0) AS study_duration_women,
        COALESCE(a.study_duration_men,0) AS study_duration_men,
        COALESCE(a.study_duration_babyu,0) AS study_duration_babyu,
        COALESCE(b.cnt_maternity,0) AS count_purch_maternity,
        COALESCE(b.days_since_maternity,0) AS days_since_maternity,
        COALESCE(b.study_duration_maternity,0) AS study_duration_maternity
FROM purch_all_train6 a FULL OUTER JOIN
        maternitytrain b
ON a.masterkey=b.masterkey;


DROP TABLE IF EXISTS purch_all_train_old_ext;
CREATE EXTERNAL TABLE purch_all_train_old_ext(
masterkey STRING,
count_purch_baby    bigint,            
count_purch_toddlergirl bigint,       
count_purch_toddlerboy  bigint,            
count_purch_girl        bigint,            
count_purch_boy         bigint,                
count_purch_women       bigint,            
count_purch_men         bigint,           
count_purch_maternity   bigint)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/ke6t4io/comparesize/old';

INSERT OVERWRITE TABLE purch_all_train_old_ext
        SELECT masterkey,count_purch_babygirl+count_purch_babyboy+count_purch_babyunisex,count_purch_toddlergirl,count_purch_toddlerboy,count_purch_girl,count_purch_boy,count_purch_women,count_purch_men,count_purch_maternity
FROM purch_all_train_old;        

DROP TABLE IF EXISTS purch_all_train_new_ext;
CREATE EXTERNAL TABLE purch_all_train_new_ext(
masterkey STRING,
count_purch_baby    bigint,            
count_purch_toddlergirl bigint,       
count_purch_toddlerboy  bigint,            
count_purch_girl        bigint,            
count_purch_boy         bigint,                
count_purch_women       bigint,            
count_purch_men         bigint,           
count_purch_maternity   bigint)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/ke6t4io/comparesize/new';

INSERT OVERWRITE TABLE purch_all_train_new_ext
        SELECT masterkey,count_purch_babygirl+count_purch_babyboy+count_purch_babyunisex,count_purch_toddlergirl,count_purch_toddlerboy,count_purch_girl,count_purch_boy,count_purch_women,count_purch_men,count_purch_maternity
FROM purch_all_train;  


---Run python script to compute ranked divisions
DROP TABLE IF EXISTS rankedold;
CREATE EXTERNAL TABLE rankedold(
    masterkey STRING,
    topdiv STRING,
    rankeddivs STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/ke6t4io/comparesize/maxold';


DROP TABLE IF EXISTS rankednew;
CREATE EXTERNAL TABLE rankednew(
    masterkey STRING,
    topdiv STRING,
    rankeddivs STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/ke6t4io/comparesize/maxnew';

select topdiv,count(*) from rankednew group by topdiv;
select topdiv,count(*) from rankedold group by topdiv;



select count(distinct masterkey) from purch_all;
--9301067

DROP TABLE IF EXISTS purch_all_score;
CREATE TABLE purch_all_score  AS SELECT * FROM purch_all WHERE (count_purch_babygirl+count_purch_babyboy+count_purch_toddlergirl+count_purch_toddlerboy+count_purch_girl+count_purch_boy+count_purch_women+count_purch_men+count_purch_maternity)>=2;

select count(distinct masterkey) from purch_all_score;
--7931419

drop table numscored;
create table numscored as select distinct b.customer_key FROM purch_all_score a INNER JOIN (SELECT DISTINCT masterkey,customer_key FROM purchases_res) b ON a.masterkey=b.masterkey;


select count(distinct customer_key) from numscored;
--8715581


--10160804


-- ***********************************************************************************

-- aggregation on omniture hit data for a date range
-- Get clickstream data
DROP TABLE IF EXISTS GPclicksdiv;
CREATE TABLE GPclicksdiv AS SELECT a.unk_shop_id,
        sum(a.babygirl) AS count_clicks_babygirl,
        sum(a.babyboy) AS count_clicks_babyboy,
        sum(a.toddlergirls) AS count_clicks_toddlergirls,
        sum(a.toddlerboys) AS count_clicks_toddlerboys,
        sum(a.girls) AS count_clicks_girls,
        sum(a.boys) AS count_clicks_boys,
        sum(a.women) count_clicks_women,
        sum(a.men) AS count_clicks_men,
        sum(a.womenmaternity) AS count_clicks_maternity,
        count(a.unk_shop_id) AS totalclicks,
        count(DISTINCT a.visit_num) AS numsessions
FROM (SELECT unk_shop_id,visit_num,
       (CASE WHEN substr(pagename,1,48)='gp:browse:babyGap:Baby Girl (0-24 mos):Baby Girl' OR pagename RLIKE 'mobile:gp:Baby:Baby Girl:Baby Girl' THEN 1 ELSE 0 END) AS babygirl,
        (CASE WHEN substr(pagename,1,47)='gp:browse:babyGap:Baby Girl (0-24 mos):Baby Boy' OR pagename RLIKE 'mobile:gp:Baby:Baby Boy:Baby Boy' THEN 1 ELSE 0 END) AS babyboy,
        (CASE WHEN pagename RLIKE 'gp:browse:babyGap:Toddler Girl' or pagename RLIKE 'mobile:gp:Toddler Girl' THEN 1 ELSE 0 END) AS toddlergirls,
        (CASE WHEN pagename RLIKE 'gp:browse:babyGap:Toddler Boy' or pagename RLIKE 'mobile:gp:Toddler Boy' THEN 1 ELSE 0 END) AS toddlerboys,
        (CASE WHEN pagename RLIKE 'gp:browse:GapKids:Girls' or pagename RLIKE 'mobile:gp:Girls' THEN 1 ELSE 0 END) AS girls,
        (CASE WHEN pagename RLIKE 'gp:browse:GapKids:Boys' or pagename RLIKE 'gp:browse:GapKids:Boys' THEN 1 ELSE 0 END) AS boys,
        (CASE WHEN pagename RLIKE 'gp:browse:Women:Womens' or pagename RLIKE 'gp:browse:GapBody:GapBody' or pagename RLIKE 'gp:browse:GapFit:GapFit' or pagename RLIKE 'mobile:gp:Women' or pagename RLIKE 'mobile:gp:Body' or pagename RLIKE 'mobile:gp:GapFit' THEN 1 ELSE 0 END) AS women,
        (CASE WHEN pagename RLIKE 'gp:browse:Men:Men' or pagename RLIKE 'mobile:gp:Men' THEN 1 ELSE 0 END) AS men,
        (CASE WHEN pagename RLIKE 'gp:browse:GapMaternity' or pagename RLIKE 'mobile:gp:Maternity' THEN 1 ELSE 0 END) AS womenmaternity
 FROM omniture.hit_data_t where date_time between '${hitDataStartDate}' AND '${hitDataEndDate}' and unk_shop_id != "") a GROUP BY a.unk_shop_id;
-- aggr ends
-- denorm starts
--Join to customerresolution
DROP TABLE IF EXISTS GPclicks_res;
CREATE TABLE GPclicks_res AS SELECT a.*,(CASE WHEN b.masterkey IS NULL THEN a.unk_shop_id ELSE b.masterkey END) AS masterkey FROM GPclicksdiv a LEFT OUTER JOIN crmanalytics.customerresolution b ON a.unk_shop_id=b.unknownshopperid;
--denorm ends
--aggregation over the GPclicks_res
--Sum over masterkey
DROP TABLE IF EXISTS GPclicks_mk;
CREATE TABLE GPclicks_mk AS SELECT a.masterkey,
        sum(a.count_clicks_babygirl) AS count_clicks_babygirl,
        sum(a.count_clicks_babyboy) AS count_clicks_babyboy,
        sum(a.count_clicks_toddlergirls) AS count_clicks_toddlergirls,
        sum(a.count_clicks_toddlerboys) AS count_clicks_toddlerboys,
        sum(a.count_clicks_girls) AS count_clicks_girls,
        sum(a.count_clicks_boys) AS count_clicks_boys,
        sum(a.count_clicks_women) AS count_clicks_women,
        sum(a.count_clicks_men) AS count_clicks_men,
        sum(a.count_clicks_maternity) AS count_clicks_maternity,
        count(a.totalclicks) AS totalclicks,
        count(a.numsessions) AS numsessions
FROM GPclicks_res a GROUP BY a.masterkey;


-- ***********************************************************************************
--Basket data
--pre processing- select some entries from omniture hit data for a date

DROP TABLE IF EXISTS abandon_basket_visits;
CREATE TABLE abandon_basket_visits AS SELECT a.unk_shop_id,a.visit_num FROM (SELECT DISTINCT unk_shop_id,visit_num,PurchaseID FROM omniture.hit_data_t where date_time between '2014-05-10' AND '2014-08-10' and unk_shop_id != "") a WHERE a.PurchaseID IS NULL or a.PurchaseID=='' or a.PurchaseID==' ';

--Code for all products added to cart
--NO SIZE INFO IN BASKET SO CANNOT DETERMINE DIVISION VIA THE SHOPPING CART - USE DIVISION OF PAGE WHEN ITEM WAS ADDED
DROP TABLE IF EXISTS product_basket;
CREATE TABLE product_basket AS SELECT unk_shop_id,
	visit_num,
	(CASE WHEN substr(pagename,1,48)='gp:browse:babyGap:Baby Girl (0-24 mos):Baby Girl' OR pagename RLIKE 'mobile:gp:Baby:Baby Girl:Baby Girl' THEN 1 ELSE 0 END) AS babygirl,
        (CASE WHEN substr(pagename,1,47)='gp:browse:babyGap:Baby Girl (0-24 mos):Baby Boy' OR pagename RLIKE 'mobile:gp:Baby:Baby Boy:Baby Boy' THEN 1 ELSE 0 END) AS babyboy,
        (CASE WHEN pagename RLIKE 'gp:browse:babyGap:Toddler Girl' or pagename RLIKE 'mobile:gp:Toddler Girl' THEN 1 ELSE 0 END) AS toddlergirls,
        (CASE WHEN pagename RLIKE 'gp:browse:babyGap:Toddler Boy' or pagename RLIKE 'mobile:gp:Toddler Boy' THEN 1 ELSE 0 END) AS toddlerboys,
        (CASE WHEN pagename RLIKE 'gp:browse:GapKids:Girls' or pagename RLIKE 'mobile:gp:Girls' THEN 1 ELSE 0 END) AS girls,
        (CASE WHEN pagename RLIKE 'gp:browse:GapKids:Boys' or pagename RLIKE 'gp:browse:GapKids:Boys' THEN 1 ELSE 0 END) AS boys,
        (CASE WHEN pagename RLIKE 'gp:browse:Women:Womens' or pagename RLIKE 'gp:browse:GapBody:GapBody' or pagename RLIKE 'gp:browse:GapFit:GapFit' or pagename RLIKE 'mobile:gp:Women' or pagename RLIKE 'mobile:gp:Body' or pagename RLIKE 'mobile:gp:GapFit' THEN 1 ELSE 0 END) AS women,
        (CASE WHEN pagename RLIKE 'gp:browse:Men:Men' or pagename RLIKE 'mobile:gp:Men' THEN 1 ELSE 0 END) AS men,
        (CASE WHEN pagename RLIKE 'gp:browse:GapMaternity' or pagename RLIKE 'mobile:gp:Maternity' THEN 1 ELSE 0 END) AS womenmaternity
 FROM omniture.hit_data_t where date_time between '${hitDataStartDate}' AND '${hitDataEndDate}' and unk_shop_id != "" and prop33='inlineBagAdd' and upper(substr(product_list,1,3))='GAP';
-- preprocessing ends
--denorm join the above two tables
--Join the visits that did not result in a purchase to the visits where items where added to the basket
DROP TABLE IF EXISTS abandon_basket;
CREATE TABLE abandon_basket AS SELECT a.* FROM product_basket a INNER JOIN abandon_basket_visits b ON a.unk_shop_id=b.unk_shop_id AND a.visit_num=b.visit_num;

--Join to customerresolution
DROP TABLE IF EXISTS abandon_basket_res;
CREATE TABLE abandon_basket_res AS SELECT a.*,(CASE WHEN b.masterkey IS NULL THEN a.unk_shop_id ELSE b.masterkey END) AS masterkey FROM abandon_basket a LEFT OUTER JOIN crmanalytics.customerresolution b ON a.unk_shop_id=b.unknownshopperid;
--denorm ends
-- aggr starts 
--Sum over masterkey over abandon_basket_res
DROP TABLE IF EXISTS basket_all;
CREATE TABLE basket_all AS SELECT masterkey,
        sum(babygirl) AS count_basket_babygirl,
        sum(babyboy) AS count_basket_babyboy,
        sum(toddlergirls) AS count_basket_toddlergirls,
        sum(toddlerboys) AS count_basket_toddlerboys,
        sum(girls) AS count_basket_girls,
        sum(boys) AS count_basket_boys,
        sum(women) count_basket_women,
        sum(men) AS count_basket_men,
        sum(womenmaternity) AS count_basket_maternity
FROM abandon_basket_res GROUP BY masterkey;

--#######################################################
-- denorm join GPclicks_mk, basket_all and clicks_basket
--Join clicks,basket and purchase datasets

--JOIN Basket back to clicks
DROP TABLE IF EXISTS clicks_basket;
CREATE TABLE clicks_basket AS SELECT a.*,
        COALESCE(b.count_basket_babygirl,0) AS count_basket_babygirl,
        COALESCE(b.count_basket_babyboy,0) AS count_basket_babyboy,
        COALESCE(b.count_basket_toddlergirls,0) AS count_basket_toddlergirls,
        COALESCE(b.count_basket_toddlerboys,0) AS count_basket_toddlerboys,
        COALESCE(b.count_basket_girls,0) AS count_basket_girls,
        COALESCE(b.count_basket_boys,0) AS count_basket_boys,
        COALESCE(b.count_basket_women,0) AS count_basket_women,
        COALESCE(b.count_basket_men,0) AS count_basket_men,
        COALESCE(b.count_basket_maternity,0) AS count_basket_maternity
 FROM GPclicks_mk a LEFT OUTER JOIN basket_all b ON a.masterkey=b.masterkey;


--JOIN Purchases back to clicks_basket
--All purchasers
DROP TABLE IF EXISTS clicks_basket_purch;
CREATE TABLE clicks_basket_purch AS SELECT a.*,
        COALESCE(b.count_basket_babygirl,0) AS count_basket_babygirl,
        COALESCE(b.count_basket_babyboy,0) AS count_basket_babyboy,
        COALESCE(b.count_basket_toddlergirls,0) AS count_basket_toddlergirl,
        COALESCE(b.count_basket_toddlerboys,0) AS count_basket_toddlerboy,
        COALESCE(b.count_basket_girls,0) AS count_basket_girl,
        COALESCE(b.count_basket_boys,0) AS count_basket_boy,
        COALESCE(b.count_basket_women,0) AS count_basket_women,
        COALESCE(b.count_basket_men,0) AS count_basket_men,
        COALESCE(b.count_basket_maternity,0) AS count_basket_maternity,
        COALESCE(b.count_clicks_babygirl,0) AS count_clicks_babygirl,
        COALESCE(b.count_clicks_babyboy,0) AS count_clicks_babyboy,
        COALESCE(b.count_clicks_toddlergirls,0) AS count_clicks_toddlergirl,
        COALESCE(b.count_clicks_toddlerboys,0) AS count_clicks_toddlerboy,
        COALESCE(b.count_clicks_girls,0) AS count_clicks_girl,
        COALESCE(b.count_clicks_boys,0) AS count_clicks_boy,
        COALESCE(b.count_clicks_women,0) AS count_clicks_women,
        COALESCE(b.count_clicks_men,0) AS count_clicks_men,
        COALESCE(b.count_clicks_maternity,0) AS count_clicks_maternity
FROM purch_all a LEFT OUTER JOIN clicks_basket b ON a.masterkey=b.masterkey;

-- denorm for browse only case
--Browse only
DROP TABLE IF EXISTS browse_only;
CREATE TABLE browse_only AS SELECT b.masterkey,
        COALESCE(b.count_basket_babygirl,0) AS count_basket_babygirl,
        COALESCE(b.count_basket_babyboy,0) AS count_basket_babyboy,
        COALESCE(b.count_basket_toddlergirls,0) AS count_basket_toddlergirl,
        COALESCE(b.count_basket_toddlerboys,0) AS count_basket_toddlerboy,
        COALESCE(b.count_basket_girls,0) AS count_basket_girl,
        COALESCE(b.count_basket_boys,0) AS count_basket_boy,
        COALESCE(b.count_basket_women,0) AS count_basket_women,
        COALESCE(b.count_basket_men,0) AS count_basket_men,
        COALESCE(b.count_basket_maternity,0) AS count_basket_maternity,
        COALESCE(b.count_clicks_babygirl,0) AS count_clicks_babygirl,
        COALESCE(b.count_clicks_babyboy,0) AS count_clicks_babyboy,
        COALESCE(b.count_clicks_toddlergirls,0) AS count_clicks_toddlergirl,
        COALESCE(b.count_clicks_toddlerboys,0) AS count_clicks_toddlerboy,
        COALESCE(b.count_clicks_girls,0) AS count_clicks_girl,
        COALESCE(b.count_clicks_boys,0) AS count_clicks_boy,
        COALESCE(b.count_clicks_women,0) AS count_clicks_women,
        COALESCE(b.count_clicks_men,0) AS count_clicks_men,
        COALESCE(b.count_clicks_maternity,0) AS count_clicks_maternity
FROM purch_all a RIGHT OUTER JOIN clicks_basket b ON a.masterkey=b.masterkey WHERE a.masterkey IS NULL;
-- denorm ends

-- data prep for scoring
-- compute ratios for each divisions
-- for clicks, basket purchase combined
DROP TABLE IF EXISTS clicks_basket_purch_2;
CREATE TABLE clicks_basket_purch_2 AS SELECT *,
(CASE WHEN sum_purch=0 THEN CAST(0 AS DOUBLE) ELSE count_purch_babygirl/sum_purch END) AS prop_purch_babygirl,
(CASE WHEN sum_purch=0 THEN CAST(0 AS DOUBLE) ELSE count_purch_babyboy/sum_purch END) AS prop_purch_babyboy,
(CASE WHEN sum_purch=0 THEN CAST(0 AS DOUBLE) ELSE count_purch_toddlergirl/sum_purch END) AS prop_purch_toddlergirl,
(CASE WHEN sum_purch=0 THEN CAST(0 AS DOUBLE) ELSE count_purch_toddlerboy/sum_purch END) AS prop_purch_toddlerboy,
(CASE WHEN sum_purch=0 THEN CAST(0 AS DOUBLE) ELSE count_purch_girl/sum_purch END) AS prop_purch_girl,
(CASE WHEN sum_purch=0 THEN CAST(0 AS DOUBLE) ELSE count_purch_boy/sum_purch END) AS prop_purch_boy,
(CASE WHEN sum_purch=0 THEN CAST(0 AS DOUBLE) ELSE count_purch_women/sum_purch END) AS prop_purch_women,
(CASE WHEN sum_purch=0 THEN CAST(0 AS DOUBLE) ELSE count_purch_men/sum_purch END)  AS prop_purch_men,
(CASE WHEN sum_purch=0 THEN CAST(0 AS DOUBLE) ELSE count_purch_maternity/sum_purch END) AS prop_purch_maternity,
(CASE WHEN sum_basket=0 THEN CAST(0 AS DOUBLE) ELSE count_basket_babygirl/sum_basket END) AS prop_basket_babygirl,
(CASE WHEN sum_basket=0 THEN CAST(0 AS DOUBLE) ELSE count_basket_babyboy/sum_basket END) AS prop_basket_babyboy,
(CASE WHEN sum_basket=0 THEN CAST(0 AS DOUBLE) ELSE count_basket_toddlergirl/sum_basket END) AS prop_basket_toddlergirl,
(CASE WHEN sum_basket=0 THEN CAST(0 AS DOUBLE) ELSE count_basket_toddlerboy/sum_basket END) AS prop_basket_toddlerboy,
(CASE WHEN sum_basket=0 THEN CAST(0 AS DOUBLE) ELSE count_basket_girl/sum_basket END) AS prop_basket_girl,
(CASE WHEN sum_basket=0 THEN CAST(0 AS DOUBLE) ELSE count_basket_boy/sum_basket END) AS prop_basket_boy,
(CASE WHEN sum_basket=0 THEN CAST(0 AS DOUBLE) ELSE count_basket_women/sum_basket END) AS prop_basket_women,
(CASE WHEN sum_basket=0 THEN CAST(0 AS DOUBLE) ELSE count_basket_men/sum_basket END) AS prop_basket_men,
(CASE WHEN sum_basket=0 THEN CAST(0 AS DOUBLE) ELSE count_basket_maternity/sum_basket END) AS prop_basket_maternity,
(CASE WHEN sum_clicks=0 THEN CAST(0 AS DOUBLE) ELSE count_clicks_babygirl/sum_clicks END ) AS prop_clicks_babygirl,
(CASE WHEN sum_clicks=0 THEN CAST(0 AS DOUBLE) ELSE count_clicks_babyboy/sum_clicks END) AS prop_clicks_babyboy,
(CASE WHEN sum_clicks=0 THEN CAST(0 AS DOUBLE) ELSE count_clicks_toddlergirl/sum_clicks END) AS prop_clicks_toddlergirl,
(CASE WHEN sum_clicks=0 THEN CAST(0 AS DOUBLE) ELSE count_clicks_toddlerboy/sum_clicks END) AS prop_clicks_toddlerboy,
(CASE WHEN sum_clicks=0 THEN CAST(0 AS DOUBLE) ELSE count_clicks_girl/sum_clicks END) AS prop_clicks_girl,
(CASE WHEN sum_clicks=0 THEN CAST(0 AS DOUBLE) ELSE count_clicks_boy/sum_clicks END) AS prop_clicks_boy,
(CASE WHEN sum_clicks=0 THEN CAST(0 AS DOUBLE) ELSE count_clicks_women/sum_clicks END) AS prop_clicks_women,
(CASE WHEN sum_clicks=0 THEN CAST(0 AS DOUBLE) ELSE count_clicks_men/sum_clicks END) AS prop_clicks_men,
(CASE WHEN sum_clicks=0 THEN CAST(0 AS DOUBLE) ELSE count_clicks_maternity/sum_clicks END) AS prop_clicks_maternity
FROM (SELECT *,(count_clicks_babygirl+count_clicks_babyboy+count_clicks_toddlergirl+count_clicks_toddlerboy+count_clicks_girl+count_clicks_boy+count_clicks_women+count_clicks_men+count_clicks_maternity) AS sum_clicks,(count_basket_babygirl+count_basket_babyboy+count_basket_toddlergirl+count_basket_toddlerboy+count_basket_girl+count_basket_boy+count_basket_women+count_basket_men+count_basket_maternity) AS sum_basket,(count_purch_babygirl+count_purch_babyboy+count_purch_toddlergirl+count_purch_toddlerboy+count_purch_girl+count_purch_boy+count_purch_women+count_purch_men+count_purch_maternity) AS sum_purch FROM clicks_basket_purch) a;


-- write the ratios for basket, puchase, clicks combined if above a threshold
DROP TABLE IF EXISTS clicks_basket_purch_score;
CREATE TABLE clicks_basket_purch_score  AS SELECT * FROM clicks_basket_purch_2 WHERE (count_purch_babygirl+count_purch_babyboy+count_purch_toddlergirl+count_purch_toddlerboy+count_purch_girl+count_purch_boy+count_purch_women+count_purch_men+count_purch_maternity)>=2;
