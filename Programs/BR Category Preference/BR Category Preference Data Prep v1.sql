create database categorypreference location '/apps/hive/warehouse/aa_cem/tghosh/tghosh.db/categorypreference.db';

set hive.exec.max.created.files=150000;
set mapred.job.queue.name=test;

drop table if exists categorypreference.brbrowsehistoryq1window;
create table categorypreference.brbrowsehistoryq1window as 
select 
unk_shop_id,visit_num,visid_high,visid_low,pagename,hier1,prop1,
purchaseid,prop33,country,t_time_info, product_list, click_action_type
from 
omniture.hit_data_t 
where 
date_time between '2014-11-01' and '2015-01-31' and
instr(upper(pagename),'BR:') > 0;



drop table if exists categorypreference.brbrowsehistoryq2window;
create table categorypreference.brbrowsehistoryq2window as 
select 
unk_shop_id,visit_num,visid_high,visid_low,pagename,hier1,prop1,
purchaseid,prop33,country,t_time_info, product_list, click_action_type
from 
omniture.hit_data_t 
where 
date_time between '2015-02-01' and '2015-04-30' and
instr(upper(pagename),'BR:') > 0;


drop table if exists categorypreference.brbrowsehistoryq3window;
create table categorypreference.brbrowsehistoryq3window as 
select 
unk_shop_id,visit_num,visid_high,visid_low,pagename,hier1,prop1,
purchaseid,prop33,country,t_time_info, product_list, click_action_type
from 
omniture.hit_data_t 
where 
date_time between '2015-05-01' and '2015-07-31' and
instr(upper(pagename),'BR:') > 0;


drop table if exists categorypreference.brbrowsehistoryq4window;
create table categorypreference.brbrowsehistoryq4window as 
select 
unk_shop_id,visit_num,visid_high,visid_low,pagename,hier1,prop1,
purchaseid,prop33,country,t_time_info,product_list, click_action_type
from 
omniture.hit_data_t 
where 
date_time between '2015-08-01' and '2015-10-31' and
instr(upper(pagename),'BR:') > 0;


drop table if exists categorypreference.brbrowsehistoryresponsewindow;
create table categorypreference.brbrowsehistoryresponsewindow as 
select 
unk_shop_id,visit_num,visid_high,visid_low,pagename,hier1,prop1,
purchaseid,prop33,country,t_time_info, product_list, click_action_type
from 
omniture.hit_data_t 
where 
date_time between '2015-11-01' and '2016-01-31' and
instr(upper(pagename),'BR:') > 0;

