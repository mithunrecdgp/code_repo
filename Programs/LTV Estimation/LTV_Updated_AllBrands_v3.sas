
%let brand=on; %let monthindex=20150601;

proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._&monthindex._ltv_scored.txt"
     out=&brand._&monthindex._ltv_scored
     dbms=dlm
     replace;
     getnames=yes;
     delimiter="|";
run;


proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\attrition scores\&brand._&monthindex._attrition_scores.txt"
     out=&brand._&monthindex._attrition_scores
     dbms=dlm
     replace;
     getnames=yes;
     delimiter=",";
run;


proc import datafile="\\10.8.8.51\lv0\tanumoy\datasets\model replication\&brand._&monthindex._combined_score.txt"
     out=&brand._&monthindex._combined_score
     dbms=dlm
     replace;
     getnames=yes;
     delimiter="|";
run;

proc sort data=&brand._&monthindex._ltv_scored;
by customer_key;
run;

proc sort data=&brand._&monthindex._attrition_scores;
by customer_key;
run;

proc sort data=&brand._&monthindex._combined_score;
by customer_key;
run;


data &brand._&monthindex._ltv_scored_file;
merge &brand._&monthindex._ltv_scored (in=a)
	  &brand._&monthindex._combined_score (in=b)
      &brand._&monthindex._attrition_scores (in=c);
by customer_key;
if a=1 and  b=1 and c=1;
run;

data &brand._&monthindex._ltv_scored_file;
set &brand._&monthindex._ltv_scored_file;
forecasted_txn_12_poffset = uncond_txn_12 * (1 - poffset);
exp_ltv_12_poffset = forecasted_txn_12_poffset * forecasted_avg_spend_12;
forecasted_txn_12_palive = uncond_txn_12 * palive_12;
exp_ltv_12_palive = forecasted_txn_12_palive * forecasted_avg_spend_12;
eq_wtd_exp_ltv_12 = exp_ltv_12_palive*0.50 + exp_ltv_12_poffset*0.50;
rename poffset_1 = dm_resp_prob;
run;

data &brand._&monthindex._ltv_scored_file;
keep customer_key palive_12 poffset exp_ltv_12_poffset exp_ltv_12_palive eq_wtd_exp_ltv_12 dm_resp_prob;
set &brand._&monthindex._ltv_scored_file;
run;

