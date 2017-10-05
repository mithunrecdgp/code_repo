#--------------------------------- Load BTYD (Buy TIll You Die) Package --------------------------------------------
library(BTYD)
library(grt)
library(amap)

pnbd.UnconditionalTransactions = 
function (params, T.star, x, t.x, T.cal) 
{
  max.length <- max(length(T.star), length(x), length(t.x), 
                    length(T.cal))
  if (max.length%%length(T.star)) 
    warning("Maximum vector length not a multiple of the length of T.star")
  if (max.length%%length(x)) 
    warning("Maximum vector length not a multiple of the length of x")
  if (max.length%%length(t.x)) 
    warning("Maximum vector length not a multiple of the length of t.x")
  if (max.length%%length(T.cal)) 
    warning("Maximum vector length not a multiple of the length of T.cal")
  dc.check.model.params(c("r", "alpha", "s", "beta"), params, 
                        "pnbd.ConditionalExpectedTransactions")
  if (any(T.star < 0) || !is.numeric(T.star)) 
    stop("T.star must be numeric and may not contain negative numbers.")
  if (any(x < 0) || !is.numeric(x)) 
    stop("x must be numeric and may not contain negative numbers.")
  if (any(t.x < 0) || !is.numeric(t.x)) 
    stop("t.x must be numeric and may not contain negative numbers.")
  if (any(T.cal < 0) || !is.numeric(T.cal)) 
    stop("T.cal must be numeric and may not contain negative numbers.")
  T.star <- rep(T.star, length.out = max.length)
  x <- rep(x, length.out = max.length)
  t.x <- rep(t.x, length.out = max.length)
  T.cal <- rep(T.cal, length.out = max.length)
  r <- params[1]
  alpha <- params[2]
  s <- params[3]
  beta <- params[4]
  P1 <- (r + x) * (beta + T.cal)/((alpha + T.cal) * (s - 1))
  P2 <- (1 - ((beta + T.cal)/(beta + T.cal + T.star))^(s - 1))
  
  return(P1 * P2)
}


#--------------------------------- Import the data for model training and forecasting ------------------------------
ON_LTV_CALIB_DATA <- read.table(file="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_20150601_LTV_CALIB_TRANSACTION.TXT",
                                sep="|",head=FALSE)

colnames(ON_LTV_CALIB_DATA)[1]  <- "customer_key"
colnames(ON_LTV_CALIB_DATA)[2]  <- "acquisition_date"
colnames(ON_LTV_CALIB_DATA)[3]  <- "calib_start_date"
colnames(ON_LTV_CALIB_DATA)[4]  <- "calib_end_date"
colnames(ON_LTV_CALIB_DATA)[5]  <- "min_purchase_date"
colnames(ON_LTV_CALIB_DATA)[6]  <- "max_purchase_date"
colnames(ON_LTV_CALIB_DATA)[7]  <- "transaction_days"
colnames(ON_LTV_CALIB_DATA)[8]  <- "spend"
colnames(ON_LTV_CALIB_DATA)[9]  <- "repeat_transaction_days"
colnames(ON_LTV_CALIB_DATA)[10] <- "repeat_spend"
colnames(ON_LTV_CALIB_DATA)[11] <- "customer_duration"
colnames(ON_LTV_CALIB_DATA)[12] <- "study_duration"
colnames(ON_LTV_CALIB_DATA)[13] <- "trunc_transaction_days"
colnames(ON_LTV_CALIB_DATA)[14] <- "trunc_avg_spend"
colnames(ON_LTV_CALIB_DATA)[15] <- "trunc_repeat_transaction_days"
colnames(ON_LTV_CALIB_DATA)[16] <- "trunc_repeat_avg_spend"

ON_LTV_CALIB_DATA <- na.omit(ON_LTV_CALIB_DATA)

ON_LTV_CALIB_DATA$trunc_repeat_spend <- 
  ON_LTV_CALIB_DATA$trunc_repeat_transaction_days *
  ON_LTV_CALIB_DATA$trunc_repeat_avg_spend


ON_LTV_CALIB_DATA.TRAIN <-
  ON_LTV_CALIB_DATA[as.Date(ON_LTV_CALIB_DATA$acquisition_date) >= 
                      as.Date(ON_LTV_CALIB_DATA$calib_start_date),]


options(scipen=999)

options(warn=-1)

customer_key <- ON_LTV_CALIB_DATA.TRAIN$customer_key

x <- ON_LTV_CALIB_DATA.TRAIN$trunc_repeat_transaction_days

t.x <- ON_LTV_CALIB_DATA.TRAIN$customer_duration

T.cal <- ON_LTV_CALIB_DATA.TRAIN$study_duration

m.x <- ON_LTV_CALIB_DATA.TRAIN$trunc_repeat_avg_spend

rm(ON_LTV_CALIB_DATA.TRAIN)


#--------------------------------- Estimate the avg. spend parameters for the customers -----------------------------
psc<-spend.EstimateParameters(m.x, x, par.start = c(runif(3, 0, 1)),
                              max.param.value = 100000)
print(psc)

save(psc, 
     file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Spend",".RData"))


gc()


#--------------------------------- Estimate the Pareto NBD parameters for the customers -----------------------------

cal.cbs.compressed <- pnbd.compress.cbs(cbind(x,t.x,T.cal))
ptc <- pnbd.EstimateParameters(cal.cbs.compressed, par.start = c(runif(4, 0, 1)),
                               max.param.value = 100000)
print(ptc)

gc()

save(ptc, 
     file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Trans.RData"))


rm(list=ls())
gc()



ON_LTV_CALIB_DATA <- read.table(file="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_20150601_LTV_CALIB_TRANSACTION.TXT",
                                sep="|",head=FALSE)

colnames(ON_LTV_CALIB_DATA)[1]  <- "customer_key"
colnames(ON_LTV_CALIB_DATA)[2]  <- "acquisition_date"
colnames(ON_LTV_CALIB_DATA)[3]  <- "calib_start_date"
colnames(ON_LTV_CALIB_DATA)[4]  <- "calib_end_date"
colnames(ON_LTV_CALIB_DATA)[5]  <- "min_purchase_date"
colnames(ON_LTV_CALIB_DATA)[6]  <- "max_purchase_date"
colnames(ON_LTV_CALIB_DATA)[7]  <- "transaction_days"
colnames(ON_LTV_CALIB_DATA)[8]  <- "spend"
colnames(ON_LTV_CALIB_DATA)[9]  <- "repeat_transaction_days"
colnames(ON_LTV_CALIB_DATA)[10] <- "repeat_spend"
colnames(ON_LTV_CALIB_DATA)[11] <- "customer_duration"
colnames(ON_LTV_CALIB_DATA)[12] <- "study_duration"
colnames(ON_LTV_CALIB_DATA)[13] <- "trunc_transaction_days"
colnames(ON_LTV_CALIB_DATA)[14] <- "trunc_avg_spend"
colnames(ON_LTV_CALIB_DATA)[15] <- "trunc_repeat_transaction_days"
colnames(ON_LTV_CALIB_DATA)[16] <- "trunc_repeat_avg_spend"

ON_LTV_CALIB_DATA <- na.omit(ON_LTV_CALIB_DATA)

ON_LTV_CALIB_DATA$trunc_repeat_spend <- 
  ON_LTV_CALIB_DATA$trunc_repeat_transaction_days *
  ON_LTV_CALIB_DATA$trunc_repeat_avg_spend

customer_key <- ON_LTV_CALIB_DATA$customer_key

x <- ON_LTV_CALIB_DATA$trunc_repeat_transaction_days

t.x <- ON_LTV_CALIB_DATA$customer_duration

T.cal <- ON_LTV_CALIB_DATA$study_duration

m.x <- ON_LTV_CALIB_DATA$trunc_repeat_avg_spend

acquisition_date <- as.Date(ON_LTV_CALIB_DATA$acquisition_date)

calib_start_date <- as.Date(ON_LTV_CALIB_DATA$calib_start_date)

calib_end_date <- as.Date(ON_LTV_CALIB_DATA$calib_end_date)

rm(ON_LTV_CALIB_DATA)
gc()

mydata <- data.frame(cbind(customer_key,
                           acquisition_date,
                           calib_start_date,
                           calib_end_date))


rm(customer_key, acquisition_date, calib_start_date, calib_end_date)
gc()

load(file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Spend.RData"))

load(file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Trans.RData"))


#-----------------Forecast the no. of txns and avg spend in next 12 months/52 weeks for the customers ----------------

T.star <- 52

uncond_txn_12 <- pnbd.UnconditionalTransactions(ptc, T.star, x, t.x, T.cal)

PAlive_12 <- pnbd.PAlive(ptc, x, t.x, T.cal)

forecasted_avg_spend_12 <- spend.expected.value(psc, m.x, x)

mydata <-    data.frame(cbind(mydata,
                              uncond_txn_12,
                              PAlive_12,
                              forecasted_avg_spend_12))

rm(uncond_txn_12, PAlive_12, forecasted_avg_spend_12)
gc()

#-----------------Forecast the no. of txns and avg spend in next 17 months/74 weeks for the customers ----------------

T.star <- 74

uncond_txn_17 <- pnbd.UnconditionalTransactions(ptc, T.star, x, t.x, T.cal)

PAlive_17 <- pnbd.PAlive(ptc, x, t.x, T.cal)

forecasted_avg_spend_17 <- spend.expected.value(psc, m.x, x)

mydata <-    data.frame(cbind(mydata,
                              uncond_txn_17,
                              PAlive_17,
                              forecasted_avg_spend_17))

rm(uncond_txn_17, PAlive_17, forecasted_avg_spend_17)
gc()


write.table(mydata, 
            file = "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_20150601_LTV_SCORED.TXT", sep= "|", row.names= FALSE, col.names= TRUE)





rm(list=ls())
gc()

ON_LTV_VALID_DATA <- read.table(file="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_20150601_LTV_VALID_TRANSACTION.TXT",
                                sep="|",head=FALSE)


colnames(ON_LTV_VALID_DATA)[1] <- "customer_key"
colnames(ON_LTV_VALID_DATA)[2] <- "valid_start_date"
colnames(ON_LTV_VALID_DATA)[3] <- "valid_end_date_12"
colnames(ON_LTV_VALID_DATA)[4] <- "valid_end_date_17"
colnames(ON_LTV_VALID_DATA)[5] <- "min_purchase_date"
colnames(ON_LTV_VALID_DATA)[6] <- "max_purchase_date_12"
colnames(ON_LTV_VALID_DATA)[7] <- "max_purchase_date_17"
colnames(ON_LTV_VALID_DATA)[8] <- "transaction_days_12"
colnames(ON_LTV_VALID_DATA)[9] <- "transactions_12"
colnames(ON_LTV_VALID_DATA)[10] <- "spend_12"
colnames(ON_LTV_VALID_DATA)[11] <- "transaction_days_17"
colnames(ON_LTV_VALID_DATA)[12] <- "transactions_17"
colnames(ON_LTV_VALID_DATA)[13] <- "spend_17"

ON_LTV_VALID_DATA[is.na(ON_LTV_VALID_DATA)] <- 0

write.table(ON_LTV_VALID_DATA, 
            file = "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_20150601_LTV_VALID.TXT", 
            sep= "|", row.names= FALSE, col.names= TRUE)
