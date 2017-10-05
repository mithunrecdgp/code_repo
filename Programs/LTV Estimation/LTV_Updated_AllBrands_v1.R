#--------------------------------- Load BTYD (Buy TIll You Die) Package --------------------------------------------
library(BTYD)
library(grt)
library(amap)
library(readr)


#--------------------------------- Import the data for model training and forecasting ------------------------------
GP_LTV_CALIB_DATA <- read_delim(file="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_20150101_LTV_CALIB_TRANSACTION.TXT",
                                delim="|",col_names=FALSE)

colnames(GP_LTV_CALIB_DATA)[1]  <- "customer_key"
colnames(GP_LTV_CALIB_DATA)[2]  <- "acquisition_date"
colnames(GP_LTV_CALIB_DATA)[3]  <- "calib_start_date"
colnames(GP_LTV_CALIB_DATA)[4]  <- "calib_end_date"
colnames(GP_LTV_CALIB_DATA)[5]  <- "min_purchase_date"
colnames(GP_LTV_CALIB_DATA)[6]  <- "max_purchase_date"
colnames(GP_LTV_CALIB_DATA)[7]  <- "transaction_days"
colnames(GP_LTV_CALIB_DATA)[8]  <- "spend"
colnames(GP_LTV_CALIB_DATA)[9]  <- "repeat_transaction_days"
colnames(GP_LTV_CALIB_DATA)[10] <- "repeat_spend"
colnames(GP_LTV_CALIB_DATA)[11] <- "customer_duration"
colnames(GP_LTV_CALIB_DATA)[12] <- "study_duration"
colnames(GP_LTV_CALIB_DATA)[13] <- "trunc_transaction_days"
colnames(GP_LTV_CALIB_DATA)[14] <- "trunc_avg_spend"
colnames(GP_LTV_CALIB_DATA)[15] <- "trunc_repeat_transaction_days"
colnames(GP_LTV_CALIB_DATA)[16] <- "trunc_repeat_avg_spend"

GP_LTV_CALIB_DATA <- na.omit(GP_LTV_CALIB_DATA)

GP_LTV_CALIB_DATA$trunc_repeat_spend <- 
  GP_LTV_CALIB_DATA$trunc_repeat_transaction_days *
  GP_LTV_CALIB_DATA$trunc_repeat_avg_spend


GP_LTV_CALIB_DATA.TRAIN <-
  GP_LTV_CALIB_DATA[as.Date(GP_LTV_CALIB_DATA$acquisition_date) >= 
                      as.Date(GP_LTV_CALIB_DATA$calib_start_date),]


options(scipen=999)

options(warn=-1)

customer_key <- GP_LTV_CALIB_DATA.TRAIN$customer_key

x <- GP_LTV_CALIB_DATA.TRAIN$trunc_repeat_transaction_days

t.x <- GP_LTV_CALIB_DATA.TRAIN$customer_duration

T.cal <- GP_LTV_CALIB_DATA.TRAIN$study_duration

m.x <- GP_LTV_CALIB_DATA.TRAIN$trunc_repeat_avg_spend

rm(GP_LTV_CALIB_DATA.TRAIN)


#--------------------------------- Estimate the avg. spend parameters for the customers -----------------------------
psc<-spend.EstimateParameters(m.x, x, par.start = c(runif(3, 0, 1)),
                              max.param.value = 100000)
print(psc)

save(psc, 
     file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/GP_LTV_Model_Spend",".RData"))


gc()


#--------------------------------- Estimate the Pareto NBD parameters for the customers -----------------------------

cal.cbs.compressed <- pnbd.compress.cbs(cbind(x,t.x,T.cal))
ptc <- pnbd.EstimateParameters(cal.cbs.compressed, par.start = c(runif(4, 0, 1)),
                               max.param.value = 100000)
print(ptc)

gc()

save(ptc, 
     file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/GP_LTV_Model_Trans.RData"))


rm(list=ls())
gc()

#--------------------------------- Load BTYD (Buy TIll You Die) Package --------------------------------------------
library(BTYD)
library(grt)
library(amap)
library(readr)


GP_LTV_CALIB_DATA <- read_delim(file="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_20150101_LTV_CALIB_TRANSACTION.TXT",
                                delim="|",col_names=FALSE)

colnames(GP_LTV_CALIB_DATA)[1]  <- "customer_key"
colnames(GP_LTV_CALIB_DATA)[2]  <- "acquisition_date"
colnames(GP_LTV_CALIB_DATA)[3]  <- "calib_start_date"
colnames(GP_LTV_CALIB_DATA)[4]  <- "calib_end_date"
colnames(GP_LTV_CALIB_DATA)[5]  <- "min_purchase_date"
colnames(GP_LTV_CALIB_DATA)[6]  <- "max_purchase_date"
colnames(GP_LTV_CALIB_DATA)[7]  <- "transaction_days"
colnames(GP_LTV_CALIB_DATA)[8]  <- "spend"
colnames(GP_LTV_CALIB_DATA)[9]  <- "repeat_transaction_days"
colnames(GP_LTV_CALIB_DATA)[10] <- "repeat_spend"
colnames(GP_LTV_CALIB_DATA)[11] <- "customer_duration"
colnames(GP_LTV_CALIB_DATA)[12] <- "study_duration"
colnames(GP_LTV_CALIB_DATA)[13] <- "trunc_transaction_days"
colnames(GP_LTV_CALIB_DATA)[14] <- "trunc_avg_spend"
colnames(GP_LTV_CALIB_DATA)[15] <- "trunc_repeat_transaction_days"
colnames(GP_LTV_CALIB_DATA)[16] <- "trunc_repeat_avg_spend"

GP_LTV_CALIB_DATA <- na.omit(GP_LTV_CALIB_DATA)

GP_LTV_CALIB_DATA$trunc_repeat_spend <- GP_LTV_CALIB_DATA$trunc_repeat_transaction_days * GP_LTV_CALIB_DATA$trunc_repeat_avg_spend

customer_key <- GP_LTV_CALIB_DATA$customer_key

x <- GP_LTV_CALIB_DATA$trunc_repeat_transaction_days

t.x <- GP_LTV_CALIB_DATA$customer_duration

T.cal <- GP_LTV_CALIB_DATA$study_duration

m.x <- GP_LTV_CALIB_DATA$trunc_repeat_avg_spend

acquisition_date <- as.Date(GP_LTV_CALIB_DATA$acquisition_date)

calib_start_date <- as.Date(GP_LTV_CALIB_DATA$calib_start_date)

calib_end_date <- as.Date(GP_LTV_CALIB_DATA$calib_end_date)

rm(GP_LTV_CALIB_DATA)
gc()

mydata <- data.frame(cbind(customer_key,
                           acquisition_date,
                           calib_start_date,
                           calib_end_date))


rm(customer_key, acquisition_date, calib_start_date, calib_end_date)
gc()

load(file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/GP_LTV_Model_Spend.RData"))

load(file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/GP_LTV_Model_Trans.RData"))


#-----------------Forecast the no. of txns and avg spend in next 12 months/52 weeks for the customers ----------------

T.star <- 52

forecasted_txn_12 <- pnbd.ConditionalExpectedTransactions(ptc, T.star, x, t.x, T.cal)

forecasted_avg_spend_12 <- spend.expected.value(psc, m.x, x)

gc()

exp_ltv_12 <- forecasted_txn_12 * forecasted_avg_spend_12

mydata <-    data.frame(cbind(mydata,
                              forecasted_txn_12,
                              forecasted_avg_spend_12,
                              exp_ltv_12))

rm(forecasted_txn_12, forecasted_avg_spend_12, exp_ltv_12)
gc()

#-----------------Forecast the no. of txns and avg spend in next 18 months/78 weeks for the customers ----------------

T.star <- 78

forecasted_txn_18 <- pnbd.ConditionalExpectedTransactions(ptc, T.star, x, t.x, T.cal)

forecasted_avg_spend_18 <- spend.expected.value(psc, m.x, x)

gc()

exp_ltv_18 <- forecasted_txn_18 * forecasted_avg_spend_18


mydata <-    data.frame(cbind(mydata,
                              forecasted_txn_18,
                              forecasted_avg_spend_18,
                              exp_ltv_18))

rm(forecasted_txn_18, forecasted_avg_spend_18, exp_ltv_18)
gc()


write.table(mydata, 
            file = "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/GP_20150101_LTV_SCORED.TXT", sep= "|", row.names= FALSE, col.names= TRUE)





rm(list=ls())
gc()

GP_LTV_VALID_DATA <- read_delim(file="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/GP_20150101_LTV_VALID_TRANSACTION.TXT",
                                delim="|",col_names=FALSE)


colnames(GP_LTV_VALID_DATA)[1] <- "customer_key"
colnames(GP_LTV_VALID_DATA)[2] <- "valid_start_date"
colnames(GP_LTV_VALID_DATA)[3] <- "valid_end_date_12"
colnames(GP_LTV_VALID_DATA)[4] <- "valid_end_date_18"
colnames(GP_LTV_VALID_DATA)[5] <- "min_purchase_date"
colnames(GP_LTV_VALID_DATA)[6] <- "max_purchase_date_12"
colnames(GP_LTV_VALID_DATA)[7] <- "max_purchase_date_18"
colnames(GP_LTV_VALID_DATA)[8] <- "transaction_days_12"
colnames(GP_LTV_VALID_DATA)[9] <- "transactions_12"
colnames(GP_LTV_VALID_DATA)[10] <- "spend_12"
colnames(GP_LTV_VALID_DATA)[11] <- "transaction_days_18"
colnames(GP_LTV_VALID_DATA)[12] <- "transactions_18"
colnames(GP_LTV_VALID_DATA)[13] <- "spend_18"


for (i in 1:ncol(GP_LTV_VALID_DATA))
{
  if (class(GP_LTV_VALID_DATA[,i])=="numeric")
  {
    GP_LTV_VALID_DATA[,i] <- ifelse(is.na(GP_LTV_VALID_DATA[,i]), 0, GP_LTV_VALID_DATA[,i])
  }
  
}



write.table(GP_LTV_VALID_DATA, 
            file = "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/GP_20150101_LTV_VALID.TXT", 
            sep= "|", row.names= FALSE, col.names= TRUE)
