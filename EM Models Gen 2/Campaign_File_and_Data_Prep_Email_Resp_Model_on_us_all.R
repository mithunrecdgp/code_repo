library(readr)
library(ffbase)
library(ff)


readdata = function(inputfile, outputdirectory)
{
  ON.data <- read.table.ffdf(file=inputfile, header = F, sep="|", VERBOSE = T)
  
  save.ffdf(dir=outputdirectory, ON.data, overwrite = T)  
}

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1817402_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1817402_COMBINED")

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1914405_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1914405_COMBINED")

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1941732_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1941732_COMBINED")

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1942814_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1942814_COMBINED")

readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1953954_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1953954_COMBINED")


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1998486_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_1998486_COMBINED")



campaignvserionlist <- c(1941732,
                         1914405,
                         1817402,
                         1942814,
                         1953954,
                         1998486
                         )


for (i in 1:length(campaignvserionlist))
{
  ffdf.object <- paste0("//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_",
                        campaignvserionlist[i],
                        "_COMBINED")
  
  load.ffdf(ffdf.object)  
  
  if (i == 1)
  {
    ON.data.append <- ON.data 
  }
  
  print(sum(ON.data[,6]))
  
  if (i > 1)
  {
   ON.data.append <- ffdfrbind.fill(ON.data.append, ON.data) 
  }  
  
}

save.ffdf(dir="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_ALLCAMPAIGNS_COMBINED", 
          ON.data.append, overwrite = T)  

rm(list=ls())
gc()


#------------------------ Start from Here --------------------------------------

library(readr)
library(ffbase)
library(ff)

load.ffdf("//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_ALLCAMPAIGNS_COMBINED")

colnames(ON.data.append)  <- c('campaign_version',
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
  ON.data <- read.table.ffdf(file=inputfile, header = F, sep="|", VERBOSE = T)
  
  save.ffdf(dir=outputdirectory, ON.data, overwrite = T)  
}


readdata(inputfile = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_2011390_COMBINED.TXT",
         outputdirectory="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_2011390_COMBINED")

#--------------------------------------------------------------------------------------------------------------------------------------


#---------- create a balanced dataset by taking all responders and sampling equal number of nonresponders -------------

ON.data.responders <- ON.data.append[ON.data.append[ ,6] == 1, ]

ON.data.responders.index <- which(ON.data.append[ ,6] == 1)

ON.data.nonresponders.index <- which(ON.data.append[ ,6] != 1)


ON.data.nonresponders <- ON.data.append[ bigsample(ON.data.nonresponders.index, dim(ON.data.responders)[1], replace = F), ] 

ON.data.balanced <- rbind(ON.data.responders, ON.data.nonresponders)


#------------------------------ create additional predictors from the primary list -------------------------------------

attach(ON.data.balanced)
  
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



ON.data.balanced <- cbind(ON.data.balanced,
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

detach(ON.data.balanced)

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
write.table(headers1, '//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_us_em_allcampaigns_combined_pctl.txt', 
            append=F, sep=",", row.names=F, col.names=F)

for (i in 1:length(continuous.predvars))
{
  varindex <- match(continuous.predvars[i], colnames(ON.data.balanced))
  pctls <- quantile(ON.data.balanced[,varindex], probs=c(0.001, 0.003, 0.005, 0.995, 0.997, 0.999))
  print(paste(continuous.predvars[i], pctls))
  
  headers1<-cbind(continuous.predvars[i], pctls[1], pctls[2], pctls[3], pctls[4], pctls[5], pctls[6])
  write.table(headers1, '//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_us_em_allcampaigns_combined_pctl.txt', 
              append=T, sep=",", row.names=F, col.names=F)
  
}



#-------------------------------- truncating outliers based on percentile cutoffs --------------------------------------

pctls.grid <- read_delim('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_us_em_allcampaigns_combined_pctl.txt',
                         delim=',', col_names = T)


ON.data.balanced.truncated <- ON.data.balanced

for (i in 1:length(continuous.predvars))
{
  varindex <- match(continuous.predvars[i], colnames(ON.data.balanced))
  print(colnames(ON.data.balanced)[varindex])
  print(summary(ON.data.balanced.truncated[,varindex]))
  toreplace.index <- which(ON.data.balanced[,varindex] <= rep(pctls.grid[i,4], length(ON.data.balanced[,varindex])))
  ON.data.balanced.truncated[toreplace.index,varindex] <- pctls.grid[i,4]  
  toreplace.index <- which(ON.data.balanced.truncated[,varindex] >= rep(pctls.grid[i,5], length(ON.data.balanced.truncated[,varindex])))
  ON.data.balanced.truncated[toreplace.index,varindex] <- pctls.grid[i,5]      
  print(summary(ON.data.balanced.truncated[,varindex]))
}


#------------------------------- scaling of variables based on min and max values --------------------------------------

pctls.grid <- read_delim('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_us_em_allcampaigns_combined_pctl.txt',
                         delim=',', col_names = T)

ON.data.balanced.scaled <- ON.data.balanced.truncated
  
for (i in 1:length(continuous.predvars))
{
  varindex <- match(continuous.predvars[i], colnames(ON.data.balanced))
  print(colnames(ON.data.balanced)[varindex])
  temp <- (ON.data.balanced.truncated[,varindex] - as.numeric(rep(pctls.grid[i,4], nrow(ON.data.balanced.truncated))))
  temp <- temp / as.numeric((pctls.grid[i,5] - pctls.grid[i,4]))   
  ON.data.balanced.scaled[,varindex] <-  temp
  print(summary(ON.data.balanced.scaled[,varindex]))
  rm(temp)
}

rm(list = c("continuous.predvars", "headers1", "i", "pctls", "pctls.grid", "toreplace.index", "varindex", "ON.data.append"))
 
save.image("//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_us_em_allcampaigns_combined.RData")


load("//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_us_em_allcampaigns_combined.RData")

write_delim(x=ON.data.balanced.truncated, 
            "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_us_em_allcampaigns_truncated.txt", 
            delim = '|',      col_names = T)

