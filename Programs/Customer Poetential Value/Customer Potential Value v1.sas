libname loc "Z:\Saumya\Datasets\";
%let brand=on;
/**/
/*data loc.&brand._mod_rfm;*/
/*infile "Z:\Saumya\Datasets\&brand._transactions1_txt" DELIMITER = '|' MISSOVER DSD LRECL=32767 FIRSTOBS=1;*/
/*informat customer_key best32.;*/
/*informat returns best32.;*/
/*informat sales best32.;*/
/*informat discounts best32.;*/
/*informat net_sales best32.;*/
/*informat frequency best32.;*/
/*informat recency best32.;   */
/*informat items_on_sale best32.;*/
/*informat items_purchased best32.;*/
/*informat emails_clicked_&brand. best32.;*/
/*informat emails_viewed_&brand. best32.;*/
/*informat tenure best32.;*/
/*format customer_key best32.;*/
/*format returns best32.;*/
/*format sales best32.;*/
/*format discounts best32.;*/
/*format net_sales best32.;*/
/*format frequency best32.;*/
/*format recency best32.;   */
/*format items_on_sale best32.;*/
/*format items_purchased best32.;*/
/*format tenure best32.;*/
/*format emails_clicked_&brand. best32.;*/
/*format emails_viewed_&brand. best32.;*/
/*input*/
/*customer_key            */
/*returns                */
/*sales                  */
/*discounts               */
/*net_sales               */
/*frequency             */
/*recency                 */
/*items_on_sale           */
/*items_purchased*/
/*tenure*/
/*emails_clicked_&brand.*/
/*emails_viewed_&brand.;        */
/*run; */
/**/

proc sql;
create table loc.&brand._trans_mail as 
select T1.*,T2.emailable,T3.optout,
T3.card,
T3.demand,
T3.fraud,
T3.mail,
T3.dmable
from 
loc.&brand._mod_rfm T1
left outer join  
loc.&brand._trans_emailable T2
on T1.customer_key =T2.customer_key
left outer join
loc.&brand._trans_dmable T3
on T1.customer_key=T3.customer_key;
quit;


proc sql;
create table loc.&brand._trans_mail_demo as
select T1.*,
T2.IBE1273_POP_DENSITY_IBE_MODEL,
T2.IBE7609_MARITAL_STAT_MARITAL,
T2.IBE7622_CHLDRN_PRES_CHLDRN,
T2.IBE7671_INCOM_100PCT_INCOME,
T2.IBE8626_8626,
T2.IBE8688_8688
from loc.&brand._trans_mail T1
left outer join 
loc.dem T2
on T1.customer_key=T2.customer_key;
quit;
/**/
/**/
/**/
/*data loc.&brand._mod_valid_rfm;*/
/*infile "Z:\Saumya\Datasets\&brand._valid_transactions1_txt" DELIMITER = '|' MISSOVER DSD LRECL=32767 FIRSTOBS=1;*/
/*informat customer_key best32.;*/
/*informat returns_valid best32.;*/
/*informat sales_valid best32.;*/
/*informat discounts_valid best32.;*/
/*informat net_sales_valid best32.;*/
/*informat frequency_valid best32.;*/
/*informat recency_valid best32.;   */
/*informat items_on_sale_valid best32.;*/
/*informat items_purchased_valid best32.;*/
/*informat emails_clicked_&brand._valid best32.;*/
/*informat emails_viewed_&brand._valid best32.;*/
/*format customer_key best32.;*/
/*format returns_valid best32.;*/
/*format sales_valid best32.;*/
/*format discounts_valid best32.;*/
/*format net_sales_valid best32.;*/
/*format frequency_valid best32.;*/
/*format recency_valid best32.;   */
/*format items_on_sale_valid best32.;*/
/*format items_purchased_valid best32.;*/
/*format emails_clicked_&brand._valid best32.;*/
/*format emails_viewed_&brand._valid best32.;*/
/*input*/
/*customer_key            */
/*returns_valid                */
/*sales_valid                  */
/*discounts_valid               */
/*net_sales_valid               */
/*frequency_valid             */
/*recency_valid                 */
/*items_on_sale_valid           */
/*items_purchased_valid*/
/*emails_clicked_&brand._valid*/
/*emails_viewed_&brand._valid;        */
/*run; */
/**/

proc sql;
create table loc.&brand._valid_trans_mail as 
select T1.*,T2.emailable,T3.optout,
T3.card,
T3.demand,
T3.fraud,
T3.mail,
T3.dmable
from 
loc.&brand._mod_valid_rfm T1
left outer join  
loc.&brand._trans_emailable T2
on T1.customer_key =T2.customer_key
left outer join
loc.&brand._trans_dmable T3
on T1.customer_key=T3.customer_key;
quit;


proc sql;
create table loc.&brand._valid_trans_mail_demo as
select T1.*,
T2.IBE1273_POP_DENSITY_IBE_MODEL,
T2.IBE7609_MARITAL_STAT_MARITAL,
T2.IBE7622_CHLDRN_PRES_CHLDRN,
T2.IBE7671_INCOM_100PCT_INCOME,
T2.IBE8626_8626,
T2.IBE8688_8688
from loc.&brand._valid_trans_mail T1
left outer join 
loc.dem T2
on T1.customer_key=T2.customer_key;
quit;
