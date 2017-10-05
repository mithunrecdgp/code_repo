library(readr)
library(ffbase)
library(ff)


readdata = function(inputfile, outputdirectory)
{
  gp.data <- read.table.ffdf(file=inputfile, header = F, sep=",", VERBOSE = T)
  
  save.ffdf(dir=outputdirectory, gp.data, overwrite = T)  
}

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1679576_COMBINED_RTL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1679576_COMBINED_RTL")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1714234_COMBINED_RTL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1714234_COMBINED_RTL")

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1876838_COMBINED_RTL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1876838_COMBINED_RTL")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1897094_COMBINED_RTL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1897094_COMBINED_RTL")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1933662_COMBINED_RTL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1933662_COMBINED_RTL")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1943469_COMBINED_RTL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1943469_COMBINED_RTL")


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
                        "_COMBINED_RTL")
  
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

save.ffdf(dir="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_ALLCAMPAIGNS_COMBINED_RTL", 
          gp.data.append, overwrite = T)  

rm(list=ls())
gc()


#------------------------ Start from Here --------------------------------------

library(readr)
library(ffbase)
library(ff)

load.ffdf("//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_ALLCAMPAIGNS_COMBINED_RTL")

colnames(gp.data.append)  <- c('campaign_version',
                               'customer_key',
                               'event_date',
                               'emailopenflag',
                               'emailclickflag',
                               'rtl_responder',
                               'num_txns_rtl',
                               'item_qty_rtl',
                               'gross_sales_amt_rtl',
                               'discount_amt_rtl',
                               'tot_prd_cst_amt_rtl',
                               'net_sales_amt_rtl',
                               'net_margin_rtl',
                               'net_sales_amt_6mo_sls_rtl',
                               'net_sales_amt_12mo_sls_rtl',
                               'net_sales_amt_plcc_6mo_sls_rtl',
                               'net_sales_amt_plcc_12mo_sls_rtl',
                               'discount_amt_6mo_sls_rtl',
                               'discount_amt_12mo_sls_rtl',
                               'net_margin_6mo_sls_rtl',
                               'net_margin_12mo_sls_rtl',
                               'item_qty_6mo_sls_rtl',
                               'item_qty_12mo_sls_rtl',
                               'item_qty_onsale_6mo_sls_rtl',
                               'item_qty_onsale_12mo_sls_rtl',
                               'num_txns_6mo_sls_rtl',
                               'num_txns_12mo_sls_rtl',
                               'num_txns_plcc_6mo_sls_rtl',
                               'num_txns_plcc_12mo_sls_rtl',
                               'net_sales_amt_6mo_rtn_rtl',
                               'net_sales_amt_12mo_rtn_rtl',
                               'item_qty_6mo_rtn_rtl',
                               'item_qty_12mo_rtn_rtl',
                               'num_txns_6mo_rtn_rtl',
                               'num_txns_12mo_rtn_rtl',
                               'net_sales_amt_6mo_sls_rtl_cp',
                               'net_sales_amt_12mo_sls_rtl_cp',
                               'net_sales_amt_plcc_6mo_sls_rtl_cp',
                               'net_sales_amt_plcc_12mo_sls_rtl_cp',
                               'item_qty_6mo_sls_rtl_cp',
                               'item_qty_12mo_sls_rtl_cp',
                               'item_qty_onsale_6mo_sls_rtl_cp',
                               'item_qty_onsale_12mo_sls_rtl_cp',
                               'num_txns_6mo_sls_rtl_cp',
                               'num_txns_12mo_sls_rtl_cp',
                               'num_txns_plcc_6mo_sls_rtl_cp',
                               'num_txns_plcc_12mo_sls_rtl_cp',
                               'net_sales_amt_6mo_rtn_cp_rtl',
                               'net_sales_amt_12mo_rtn_cp_rtl',
                               'item_qty_6mo_rtn_cp_rtl',
                               'item_qty_12mo_rtn_cp_rtl',
                               'num_txns_6mo_rtn_cp_rtl',
                               'num_txns_12mo_rtn_cp_rtl',
                               'visasig_flag',
                               'basic_flag',
                               'silver_flag',
                               'sister_flag',
                               'card_status',
                               'days_last_pur_rtl',
                               'days_last_pur_cp_rtl',
                               'days_on_books',
                               'days_on_books_cp',
                               'div_shp_rtl',
                               'div_shp_cp_rtl',
                               'emails_clicked',
                               'emails_clicked_cp',
                               'emails_opened',
                               'emails_opened_cp')
      

#--------------------------------------------------------------------------------------------------------------------------------------

readdata = function(inputfile, outputdirectory)
{
  gp.data <- read.table.ffdf(file=inputfile, header = F, sep="|", VERBOSE = T)
  
  save.ffdf(dir=outputdirectory, gp.data, overwrite = T)  
}


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1959767_COMBINED_RTL.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1959767_COMBINED_RTL")

#--------------------------------------------------------------------------------------------------------------------------------------
