library(readr)
library(ffbase)
library(ff)


readdata = function(inputfile, outputdirectory)
{
  gp.data <- read.table.ffdf(file=inputfile, header = F, sep=",", VERBOSE = T)
  
  save.ffdf(dir=outputdirectory, gp.data, overwrite = T)  
}

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1679576_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1679576_COMBINED")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1714234_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1714234_COMBINED")

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1876838_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1876838_COMBINED")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1897094_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1897094_COMBINED")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1933662_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1933662_COMBINED")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1943469_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1943469_COMBINED")



campaignvserionlist <- c(1679576,
                         1714234,
                         1876838,
                         1897094,
                         1933662,
                         1943469
                         )


for (i in 1:length(campaignvserionlist))
{
  ffdf.object <- paste0("//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_",
                        campaignvserionlist[i],
                        "_COMBINED")
  
  load.ffdf(ffdf.object)  
  
  if (i == 1)
  {
    gp.data.append <- gp.data 
  }
  
  print(sum(gp.data[,6]))
  
  if (i > 1)
  {
   gp.data.append <- ffdfrbind.fill(gp.data.append, gp.data) 
  }  
  
}

save.ffdf(dir="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_ALLCAMPAIGNS_COMBINED", 
          gp.data.append, overwrite = T)  

rm(list=ls())
gc()


#------------------------ Start from Here --------------------------------------

library(readr)
library(ffbase)
library(ff)

load.ffdf("//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_ALLCAMPAIGNS_COMBINED")

colnames(gp.data.append)  <- c('campaign_version',
                               'customer_key',
                               'event_date',
                               'emailopenflag',
                               'emailclickflag',
                               'responder',
                               'num_txns',
                               'item_qty',
                               'gross_sales_amt',
                               'discount_amt',
                               'tot_prd_cst_amt',
                               'net_sales_amt',
                               'net_margin',
                               'net_sales_amt_6mo_sls',
                               'net_sales_amt_12mo_sls',
                               'net_sales_amt_plcc_6mo_sls',
                               'net_sales_amt_plcc_12mo_sls',
                               'discount_amt_6mo_sls',
                               'discount_amt_12mo_sls',
                               'net_margin_6mo_sls',
                               'net_margin_12mo_sls',
                               'item_qty_6mo_sls',
                               'item_qty_12mo_sls',
                               'item_qty_onsale_6mo_sls',
                               'item_qty_onsale_12mo_sls',
                               'num_txns_6mo_sls',
                               'num_txns_12mo_sls',
                               'num_txns_plcc_6mo_sls',
                               'num_txns_plcc_12mo_sls',
                               'net_sales_amt_6mo_rtn',
                               'net_sales_amt_12mo_rtn',
                               'item_qty_6mo_rtn',
                               'item_qty_12mo_rtn',
                               'num_txns_6mo_rtn',
                               'num_txns_12mo_rtn',
                               'net_sales_amt_6mo_sls_cp',
                               'net_sales_amt_12mo_sls_cp',
                               'net_sales_amt_plcc_6mo_sls_cp',
                               'net_sales_amt_plcc_12mo_sls_cp',
                               'item_qty_6mo_sls_cp',
                               'item_qty_12mo_sls_cp',
                               'item_qty_onsale_6mo_sls_cp',
                               'item_qty_onsale_12mo_sls_cp',
                               'num_txns_6mo_sls_cp',
                               'num_txns_12mo_sls_cp',
                               'num_txns_plcc_6mo_sls_cp',
                               'num_txns_plcc_12mo_sls_cp',
                               'net_sales_amt_6mo_rtn_cp',
                               'net_sales_amt_12mo_rtn_cp',
                               'item_qty_6mo_rtn_cp',
                               'item_qty_12mo_rtn_cp',
                               'num_txns_6mo_rtn_cp',
                               'num_txns_12mo_rtn_cp',
                               'visasig_flag',
                               'basic_flag',
                               'silver_flag',
                               'sister_flag',
                               'card_status',
                               'days_last_pur',
                               'days_last_pur_cp',
                               'days_on_books',
                               'days_on_books_cp',
                               'div_shp',
                               'div_shp_cp',
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


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1959767_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_1959767_COMBINED")

#--------------------------------------------------------------------------------------------------------------------------------------


#---------- create a balanced dataset by taking all responders and sampling equal number of nonresponders -------------

gp.data.responders <- gp.data.append[gp.data.append[ ,6] == 1, ]

gp.data.responders.index <- which(gp.data.append[ ,6] == 1)

gp.data.nonresponders.index <- which(gp.data.append[ ,6] != 1)


gp.data.nonresponders <- gp.data.append[ bigsample(gp.data.nonresponders.index, dim(gp.data.responders)[1], replace = F), ] 

gp.data.balanced <- rbind(gp.data.responders, gp.data.nonresponders)


#------------------------------ create additional predictors from the primary list -------------------------------------

attach(gp.data.balanced)
  
discount_pct_12mo_sls <- ifelse(net_sales_amt_12mo_sls - discount_amt_12mo_sls > 0, 
                                -discount_amt_12mo_sls/(net_sales_amt_12mo_sls - discount_amt_12mo_sls), 0)

discount_pct_6mo_sls <- ifelse(net_sales_amt_6mo_sls - discount_amt_6mo_sls > 0, 
                                -discount_amt_6mo_sls/(net_sales_amt_6mo_sls - discount_amt_6mo_sls), 0)

avg_ord_size_12mo_sls <- ifelse(num_txns_12mo_sls > 0, net_sales_amt_12mo_sls / num_txns_12mo_sls, 0)

avg_ord_size_6mo_sls <- ifelse(num_txns_6mo_sls > 0, net_sales_amt_6mo_sls / num_txns_6mo_sls, 0)


avg_unit_retail_12mo_sls <- ifelse(item_qty_12mo_sls > 0, net_sales_amt_12mo_sls / item_qty_12mo_sls, 0)

avg_unit_retail_6mo_sls <- ifelse(item_qty_6mo_sls > 0, net_sales_amt_6mo_sls / item_qty_6mo_sls, 0)


net_sales_amt_plcc_pct_12mo_sls <- ifelse(net_sales_amt_12mo_sls > 0, net_sales_amt_plcc_12mo_sls / net_sales_amt_12mo_sls, 0)

net_sales_amt_plcc_pct_6mo_sls <- ifelse(net_sales_amt_6mo_sls > 0, net_sales_amt_plcc_6mo_sls / net_sales_amt_6mo_sls, 0)


num_txns_plcc_pct_12mo_sls <- ifelse(num_txns_12mo_sls > 0, num_txns_plcc_12mo_sls / num_txns_12mo_sls, 0)

num_txns_plcc_pct_6mo_sls <- ifelse(num_txns_6mo_sls > 0, num_txns_plcc_6mo_sls / num_txns_6mo_sls, 0)


item_qty_onsale_pct_12mo_sls <- ifelse(item_qty_12mo_sls > 0,  item_qty_onsale_12mo_sls/item_qty_12mo_sls, 0)

item_qty_onsale_pct_6mo_sls <- ifelse(item_qty_6mo_sls > 0,  item_qty_onsale_6mo_sls/item_qty_6mo_sls, 0)



net_sales_amt_pct_12mo_rtn <- ifelse(net_sales_amt_12mo_sls > 0, net_sales_amt_12mo_rtn / net_sales_amt_12mo_sls, 0)

net_sales_amt_pct_6mo_rtn <- ifelse(net_sales_amt_6mo_sls > 0, net_sales_amt_6mo_rtn / net_sales_amt_6mo_sls, 0)


num_txns_pct_12mo_rtn <- ifelse(num_txns_12mo_sls > 0, num_txns_12mo_rtn / num_txns_12mo_sls, 0)

num_txns_pct_6mo_rtn <- ifelse(num_txns_6mo_sls > 0, num_txns_6mo_rtn / num_txns_6mo_sls, 0)


item_qty_pct_12mo_rtn <- ifelse(item_qty_12mo_sls > 0,  item_qty_12mo_rtn/item_qty_12mo_sls, 0)

item_qty_pct_6mo_rtn <- ifelse(item_qty_6mo_sls > 0,  item_qty_6mo_rtn/item_qty_6mo_sls, 0)



gp.data.balanced <- cbind(gp.data.balanced,
                          discount_pct_12mo_sls,
                          discount_pct_6mo_sls,
                          avg_ord_size_12mo_sls,
                          avg_ord_size_6mo_sls,
                          avg_unit_retail_12mo_sls,
                          avg_unit_retail_6mo_sls,
                          net_sales_amt_plcc_pct_12mo_sls,
                          net_sales_amt_plcc_pct_6mo_sls,
                          num_txns_plcc_pct_12mo_sls,
                          num_txns_plcc_pct_6mo_sls,
                          item_qty_onsale_pct_12mo_sls,
                          item_qty_onsale_pct_6mo_sls,
                          net_sales_amt_pct_12mo_rtn,
                          net_sales_amt_pct_6mo_rtn,
                          num_txns_pct_12mo_rtn,
                          num_txns_pct_6mo_rtn,
                          item_qty_pct_12mo_rtn,
                          item_qty_pct_6mo_rtn)


rm(discount_pct_12mo_sls,
   discount_pct_6mo_sls,
   avg_ord_size_12mo_sls,
   avg_ord_size_6mo_sls,
   avg_unit_retail_12mo_sls,
   avg_unit_retail_6mo_sls,
   net_sales_amt_plcc_pct_12mo_sls,
   net_sales_amt_plcc_pct_6mo_sls,
   num_txns_plcc_pct_12mo_sls,
   num_txns_plcc_pct_6mo_sls,
   item_qty_onsale_pct_12mo_sls,
   item_qty_onsale_pct_6mo_sls,
   net_sales_amt_pct_12mo_rtn,
   net_sales_amt_pct_6mo_rtn,
   num_txns_pct_12mo_rtn,
   num_txns_pct_6mo_rtn,
   item_qty_pct_12mo_rtn,
   item_qty_pct_6mo_rtn
   )

gc()

detach(gp.data.balanced)

continuous.predvars <- c('net_sales_amt_6mo_sls',
                         'net_sales_amt_12mo_sls',
                         'net_sales_amt_plcc_6mo_sls',
                         'net_sales_amt_plcc_12mo_sls',
                         'discount_amt_6mo_sls',
                         'discount_amt_12mo_sls',
                         'net_margin_6mo_sls',
                         'net_margin_12mo_sls',
                         'item_qty_6mo_sls',
                         'item_qty_12mo_sls',
                         'item_qty_onsale_6mo_sls',
                         'item_qty_onsale_12mo_sls',
                         'num_txns_6mo_sls',
                         'num_txns_12mo_sls',
                         'num_txns_plcc_6mo_sls',
                         'num_txns_plcc_12mo_sls',
                         'net_sales_amt_6mo_rtn',
                         'net_sales_amt_12mo_rtn',
                         'item_qty_6mo_rtn',
                         'item_qty_12mo_rtn',
                         'num_txns_6mo_rtn',
                         'num_txns_12mo_rtn',
                         'net_sales_amt_6mo_sls_cp',
                         'net_sales_amt_12mo_sls_cp',
                         'net_sales_amt_plcc_6mo_sls_cp',
                         'net_sales_amt_plcc_12mo_sls_cp',
                         'item_qty_6mo_sls_cp',
                         'item_qty_12mo_sls_cp',
                         'item_qty_onsale_6mo_sls_cp',
                         'item_qty_onsale_12mo_sls_cp',
                         'num_txns_6mo_sls_cp',
                         'num_txns_12mo_sls_cp',
                         'num_txns_plcc_6mo_sls_cp',
                         'num_txns_plcc_12mo_sls_cp',
                         'net_sales_amt_6mo_rtn_cp',
                         'net_sales_amt_12mo_rtn_cp',
                         'item_qty_6mo_rtn_cp',
                         'item_qty_12mo_rtn_cp',
                         'num_txns_6mo_rtn_cp',
                         'num_txns_12mo_rtn_cp',
                         'days_last_pur',
                         'days_last_pur_cp',
                         'days_on_books',
                         'div_shp',
                         'div_shp_cp',
                         'emails_clicked',
                         'emails_clicked_cp',
                         'emails_opened',
                         'emails_opened_cp',
                         'discount_pct_12mo_sls',
                         'discount_pct_6mo_sls',
                         'avg_ord_size_12mo_sls',
                         'avg_ord_size_6mo_sls',
                         'avg_unit_retail_12mo_sls',
                         'avg_unit_retail_6mo_sls',
                         'net_sales_amt_plcc_pct_12mo_sls',
                         'net_sales_amt_plcc_pct_6mo_sls',
                         'num_txns_plcc_pct_12mo_sls',
                         'num_txns_plcc_pct_6mo_sls',
                         'item_qty_onsale_pct_12mo_sls',
                         'item_qty_onsale_pct_6mo_sls',
                         'net_sales_amt_pct_12mo_rtn',
                         'net_sales_amt_pct_6mo_rtn',
                         'num_txns_pct_12mo_rtn',
                         'num_txns_pct_6mo_rtn',
                         'item_qty_pct_12mo_rtn',
                         'item_qty_pct_6mo_rtn')



#--------------------- obtain the percentile values and export the values to a text file --------------------------

headers1<-cbind('variablename', 'p001', 'p003', 'p005', 'p995', 'p997', 'p999')
write.table(headers1, '//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/gp_us_em_allcampaigns_combined_pctl.txt', 
            append=F, sep=",", row.names=F, col.names=F)

for (i in 1:length(continuous.predvars))
{
  varindex <- match(continuous.predvars[i], colnames(gp.data.balanced))
  pctls <- quantile(gp.data.balanced[,varindex], probs=c(0.001, 0.003, 0.005, 0.995, 0.997, 0.999))
  print(paste(continuous.predvars[i], pctls))
  
  headers1<-cbind(continuous.predvars[i], pctls[1], pctls[2], pctls[3], pctls[4], pctls[5], pctls[6])
  write.table(headers1, '//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/gp_us_em_allcampaigns_combined_pctl.txt', 
              append=T, sep=",", row.names=F, col.names=F)
  
}



#-------------------------------- truncating outliers based on percentile cutoffs --------------------------------------

pctls.grid <- read_delim('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/gp_us_em_allcampaigns_combined_pctl.txt',
                         delim=',', col_names = T)


gp.data.balanced.truncated <- gp.data.balanced

for (i in 1:length(continuous.predvars))
{
  varindex <- match(continuous.predvars[i], colnames(gp.data.balanced))
  print(colnames(gp.data.balanced)[varindex])
  print(summary(gp.data.balanced.truncated[,varindex]))
  toreplace.index <- which(gp.data.balanced[,varindex] <= rep(pctls.grid[i,4], length(gp.data.balanced[,varindex])))
  gp.data.balanced.truncated[toreplace.index,varindex] <- pctls.grid[i,4]  
  toreplace.index <- which(gp.data.balanced.truncated[,varindex] >= rep(pctls.grid[i,5], length(gp.data.balanced.truncated[,varindex])))
  gp.data.balanced.truncated[toreplace.index,varindex] <- pctls.grid[i,5]      
  print(summary(gp.data.balanced.truncated[,varindex]))
}


#------------------------------- scaling of variables based on min and max values --------------------------------------

pctls.grid <- read_delim('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/gp_us_em_allcampaigns_combined_pctl.txt',
                         delim=',', col_names = T)

gp.data.balanced.scaled <- gp.data.balanced.truncated
  
for (i in 1:length(continuous.predvars))
{
  varindex <- match(continuous.predvars[i], colnames(gp.data.balanced))
  print(colnames(gp.data.balanced)[varindex])
  temp <- (gp.data.balanced.truncated[,varindex] - as.numeric(rep(pctls.grid[i,4], nrow(gp.data.balanced.truncated))))
  temp <- temp / as.numeric((pctls.grid[i,5] - pctls.grid[i,4]))   
  gp.data.balanced.scaled[,varindex] <-  temp
  print(summary(gp.data.balanced.scaled[,varindex]))
  rm(temp)
}

rm(list = c("continuous.predvars", "headers1", "i", "pctls", "pctls.grid", "toreplace.index", "varindex", "gp.data.append"))
 
save.image("//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/gp_us_em_allcampaigns_combined.RData")


load("//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/gp_us_em_allcampaigns_combined.RData")

write_delim(x=gp.data.balanced.truncated, 
            "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/gp_us_em_allcampaigns_truncated.txt", 
            delim = '|',      col_names = T)

