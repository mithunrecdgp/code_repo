proc import datafile="\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_cat_pref_dataprep_normed_full.csv" out=br_data_full   dbms=dlm    replace;
delimiter=',';
getnames=no;
run;

data br_data_full;
set br_data_full;
rename var1 = masterkey;
rename var2 = category;
rename var3 = recency_purch;
rename var4 = recency_click;
rename var5 = recency_abdnbskt;
rename var6 = norm_txn_lastyear;
rename var7 = norm_items_lastyear;
rename var8 = norm_gross_lastyear;
rename var9 = norm_net_lastyear;
rename var10 = norm_txn_lastqtr;
rename var11 = norm_items_lastqtr;
rename var12 = norm_gross_lastqtr;
rename var13 = norm_net_lastqtr;
rename var14 = norm_txn_firstqtr;
rename var15 = norm_items_firstqtr;
rename var16 = norm_gross_firstqtr;
rename var17 = norm_net_firstqtr;
rename var18 = norm_txn_lastmonth;
rename var19 = norm_items_lastmonth;
rename var20 = norm_gross_lastmonth;
rename var21 = norm_net_lastmonth;
rename var22 = norm_clicks_lastqtr;
rename var23 = norm_clicks_lastmonth;
rename var24 = norm_abandon_lastqtr;
rename var25 = norm_abandon_lastmonth;
rename var26 = purchased;
rename var27 = browsed;
rename var28 = norm_items_5mo_pred;
rename var29 = norm_net_5mo_pred;
rename var30 = norm_items_3mo_pred;
rename var31 = norm_net_3mo_pred;
rename var32 = items_5mo_pred_cap;
rename var33 = net_5mo_pred_cap;
rename var34 = items_3mo_pred_cap;
rename var35 = net_3mo_pred_cap;
run;

proc sort data = br_data_cat_pref_norm;
by masterkey category;
run;
 
data br_data_cat_pref_norm;
set br_data_full;
keep
masterkey
category
recency_purch
recency_click
recency_abdnbskt
norm_txn_lastyear
norm_items_lastyear
norm_gross_lastyear
norm_net_lastyear
norm_txn_lastqtr
norm_items_lastqtr
norm_gross_lastqtr
norm_net_lastqtr
norm_txn_firstqtr
norm_items_firstqtr
norm_gross_firstqtr
norm_net_firstqtr
norm_txn_lastmonth
norm_items_lastmonth
norm_gross_lastmonth
norm_net_lastmonth
norm_clicks_lastqtr
norm_clicks_lastmonth
norm_abandon_lastqtr
norm_abandon_lastmonth
items_3mo_pred_cap
;
run;

proc sql;
create table masterkeys as select distinct masterkey from br_data_cat_pref_norm;
quit;

data masterkeys;
set masterkeys;
rand = ranuni(100);
run;

proc sort data = masterkeys;
 by masterkey;
run;

data masterkeystrain masterkeystest;
 set masterkeys;
 if _N_ <= 3000000 then output masterkeystrain;
 if _N_ > 3000000 then output masterkeystest;
 drop rand;
run;

proc sql;
create table br_data_cat_pref_norm_train as select t1.* 
from
br_data_cat_pref_norm t1, masterkeystrain t2
where
t1.masterkey = t2.masterkey;
quit;

proc sql;
create table br_data_cat_pref_norm_test as select t1.* 
from
br_data_cat_pref_norm t1, masterkeystest t2
where
t1.masterkey = t2.masterkey;
quit;

proc export data=br_data_cat_pref_norm
			outfile="\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_data_cat_pref_norm.txt"
            dbms=dlm replace;
     delimiter="|";
run;

proc export data=br_data_cat_pref_norm_train
			outfile="\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_data_cat_pref_norm_train.txt"
            dbms=dlm replace;
     delimiter="|";
run;

proc export data=br_data_cat_pref_norm_test
			outfile="\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_data_cat_pref_norm_test.txt"
            dbms=dlm replace;
     delimiter="|";
run;

