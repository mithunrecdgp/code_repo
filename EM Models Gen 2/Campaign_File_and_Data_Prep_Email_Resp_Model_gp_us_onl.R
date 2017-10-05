library(readr)
library(ffbase)
library(ff)


readdata = function(inputfile, outputdirectory)
{
  gp.data <- read.table.ffdf(file=inputfile, header = F, sep=",", VERBOSE = T)
  
  save.ffdf(dir=outputdirectory, gp.data, overwrite = T)  
}

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1679576_COMBINED_ONL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1679576_COMBINED_ONL")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1714234_COMBINED_ONL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1714234_COMBINED_ONL")

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1876838_COMBINED_ONL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1876838_COMBINED_ONL")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1897094_COMBINED_ONL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1897094_COMBINED_ONL")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1933662_COMBINED_ONL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1933662_COMBINED_ONL")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1943469_COMBINED_ONL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1943469_COMBINED_ONL")



campaignvserionlist <- c(1679576,
                         1714234,
                         1876838,
                         1897094,
                         1933662,
                         1943469)


for (i in 1:length(campaignvserionlist))
{
  ffdf.object <- paste0("//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_",
                        campaignvserionlist[i],
                        "_COMBINED_ONL")
  
  load.ffdf(ffdf.object)  
  
  colnames(gp.data)
  
  if (i == 1)
  {
    gp.data.append <- gp.data 
  }
  
  if (i > 1)
  {
    gp.data.append <- ffdfrbind.fill(gp.data.append, gp.data) 
  }  
  
}

save.ffdf(dir="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_ALLCAMPAIGNS_COMBINED_ONL", 
          gp.data.append, overwrite = T)  

rm(list=ls())
gc()


#------------------------ Start from Here --------------------------------------

library(readr)
library(ffbase)
library(ff)

load.ffdf("//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_ALLCAMPAIGNS_COMBINED_ONL")

colnames(gp.data.append)  <- c('campaign_version',
                               'customer_key',
                               'event_date',
                               'emailopenflag',
                               'emailclickflag',
                               'onl_responder',
                               'num_txns_onl',
                               'item_qty_onl',
                               'gross_sales_amt_onl',
                               'discount_amt_onl',
                               'tot_prd_cst_amt_onl',
                               'net_sales_amt_onl',
                               'net_margin_onl',
                               'net_sales_amt_6mo_sls_onl',
                               'net_sales_amt_12mo_sls_onl',
                               'net_sales_amt_plcc_6mo_sls_onl',
                               'net_sales_amt_plcc_12mo_sls_onl',
                               'discount_amt_6mo_sls_onl',
                               'discount_amt_12mo_sls_onl',
                               'net_margin_6mo_sls_onl',
                               'net_margin_12mo_sls_onl',
                               'item_qty_6mo_sls_onl',
                               'item_qty_12mo_sls_onl',
                               'item_qty_onsale_6mo_sls_onl',
                               'item_qty_onsale_12mo_sls_onl',
                               'num_txns_6mo_sls_onl',
                               'num_txns_12mo_sls_onl',
                               'num_txns_plcc_6mo_sls_onl',
                               'num_txns_plcc_12mo_sls_onl',
                               'net_sales_amt_6mo_rtn_onl',
                               'net_sales_amt_12mo_rtn_onl',
                               'item_qty_6mo_rtn_onl',
                               'item_qty_12mo_rtn_onl',
                               'num_txns_6mo_rtn_onl',
                               'num_txns_12mo_rtn_onl',
                               'net_sales_amt_6mo_sls_onl_cp',
                               'net_sales_amt_12mo_sls_onl_cp',
                               'net_sales_amt_plcc_6mo_sls_onl_cp',
                               'net_sales_amt_plcc_12mo_sls_onl_cp',
                               'item_qty_6mo_sls_onl_cp',
                               'item_qty_12mo_sls_onl_cp',
                               'item_qty_onsale_6mo_sls_onl_cp',
                               'item_qty_onsale_12mo_sls_onl_cp',
                               'num_txns_6mo_sls_onl_cp',
                               'num_txns_12mo_sls_onl_cp',
                               'num_txns_plcc_6mo_sls_onl_cp',
                               'num_txns_plcc_12mo_sls_onl_cp',
                               'net_sales_amt_6mo_rtn_cp_onl',
                               'net_sales_amt_12mo_rtn_cp_onl',
                               'item_qty_6mo_rtn_cp_onl',
                               'item_qty_12mo_rtn_cp_onl',
                               'num_txns_6mo_rtn_cp_onl',
                               'num_txns_12mo_rtn_cp_onl',
                               'visasig_flag',
                               'basic_flag',
                               'silver_flag',
                               'sister_flag',
                               'card_status',
                               'days_last_pur_onl',
                               'days_last_pur_cp_onl',
                               'days_on_books',
                               'days_on_books_cp',
                               'div_shp_onl',
                               'div_shp_cp_onl',
                               'emails_clicked',
                               'emails_clicked_cp',
                               'emails_opened',
                               'emails_opened_cp')
      

gp.data <- gp.data.append[gp.data.append[,1]==1679576, ]



#--------------------------------------------------------------------------------------------------------------------------------------

readdata = function(inputfile, outputdirectory)
{
  gp.data <- read.table.ffdf(file=inputfile, header = F, sep="|", VERBOSE = T)
  
  save.ffdf(dir=outputdirectory, gp.data, overwrite = T)  
}


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1959767_COMBINED_ONL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1959767_COMBINED_ONL")

#--------------------------------------------------------------------------------------------------------------------------------------

