#--------------------------------- Load BTYD (Buy TIll You Die) Package --------------------------------------------
library(BTYD)
library(grt)
library(amap)
#--------------------------------- Import the data for model training and forecasting ------------------------------
ON_LTV_CALIB_DATA <- read.table(file="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_20140101_LTV_CALIB_TRANSACTION.TXT",
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

attach(ON_LTV_CALIB_DATA.TRAIN)

scaled <- scale(cbind(repeat_spend,
                      study_duration, 
                      customer_duration,
                      trunc_repeat_avg_spend, 
                      trunc_repeat_transaction_days))

s.param <- t(attr(scaled,"scaled:scale"))
c.param <- t(attr(scaled,"scaled:center"))

save(s.param, c.param, 
     file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Scale.RData"))


wssplot <- function(data, nc, seed, type)
{
  wss = rep(0,nc); adj.rsq = rep(0,nc);
  for (i in 1:nc)
  {
   set.seed(seed)
   wss[i] <- sum(kmeans(data, centers=i, nstart=30,
                        algorithm = type, iter.max=1000)$withinss)
   adj.rsq[i] = 1-(wss[i]*(nrow(data)-1))/(wss[1]*(nrow(data)-seq(1,nc)))
   
   print(paste(i, adj.rsq[i]))
  }
  plot(1:nc, wss, type="b", xlab="Number of Clusters",
       ylab="Within groups sum of squares")
  plot(1:nc, adj.rsq, type="b", xlab="Number of Clusters",
       ylab="adjusted r-square")
}

wssplot(scaled[,2:ncol(scaled)],
        type="Lloyd", nc=15, seed=1234)

set.seed(1234)
# K-Means Cluster Analysis
fit <- kmeans(scaled[,2:ncol(scaled)], nstart=30, 
              centers=5, algorithm="Lloyd", iter.max=1000) 
cluster<- fit$cluster
prop.table(table(cluster))

# get cluster means 
means <-
(aggregate(scaled[,2:ncol(scaled)],
          by=list(fit$cluster),FUN=mean))
means <- means[,2:ncol(means)]
save(means, 
     file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Clust.RData"))


plot(y=unlist(means[1,]), x=1:ncol(means), type="b", col="red", ylim=c(min(means), max(means)))
lines(y=unlist(means[2,]), x=1:ncol(means), type="b", col="blue", ylim=c(min(means), max(means)))
lines(y=unlist(means[3,]), x=1:ncol(means), type="b", col="green", ylim=c(min(means), max(means)))
lines(y=unlist(means[4,]), x=1:ncol(means), type="b", col="brown", ylim=c(min(means), max(means)))
lines(y=unlist(means[5,]), x=1:ncol(means), type="b", col="magenta", ylim=c(min(means), max(means)))



ON_LTV_CALIB_DATA.TRAIN <- 
  ON_LTV_CALIB_DATA[as.Date(ON_LTV_CALIB_DATA$acquisition_date) >= 
                      as.Date(ON_LTV_CALIB_DATA$calib_start_date),]
ON_LTV_CALIB_DATA.TRAIN <- cbind(ON_LTV_CALIB_DATA.TRAIN, cluster)


options(scipen=999)
for (i in 1:5)
{
  
  options(warn=-1)
  
  print(i)
  
  mydata <- ON_LTV_CALIB_DATA.TRAIN[ON_LTV_CALIB_DATA.TRAIN$cluster==i, ]
  
  customer_key <- mydata$customer_key
  
  x <- mydata$trunc_repeat_transaction_days
  
  t.x <- mydata$customer_duration
  
  T.cal <- mydata$study_duration
  
  m.x <- mydata$trunc_repeat_avg_spend
  
  summary(mydata)
  
  #--------------------------------- Estimate the avg. spend parameters for the customers -----------------------------
  psc<-spend.EstimateParameters(m.x, x, par.start = c(runif(3, 0, 1)),
                                max.param.value = 100000)
  print(psc)
  
  save(psc, 
       file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Spend",i,".RData"))

  
  gc()
  
}

#--------------------------------- Estimate the Pareto NBD parameters for the customers -----------------------------

cal.cbs.compressed <- pnbd.compress.cbs(cbind(x,t.x,T.cal))
ptc <- pnbd.EstimateParameters(cal.cbs.compressed, par.start = c(runif(4, 0, 1)),
                               max.param.value = 100000)
print(ptc)

gc()

save(ptc, 
     file=paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Trans.RData"))


#-----------------------------Prepare the data for scoring the customers -------------------------------
rm(list=ls())


library(BTYD)
library(grt)
library(amap)


ON_LTV_CALIB_DATA <- read.table(file="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_20140101_LTV_CALIB_TRANSACTION.TXT",
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

ON_LTV_CALIB_DATA <- 
  ON_LTV_CALIB_DATA[as.Date(ON_LTV_CALIB_DATA$acquisition_date) >= 
                      as.Date(ON_LTV_CALIB_DATA$calib_start_date),]

ON_LTV_CALIB_DATA$trunc_repeat_spend <- 
                    ON_LTV_CALIB_DATA$trunc_repeat_transaction_days *
                    ON_LTV_CALIB_DATA$trunc_repeat_avg_spend


attach(ON_LTV_CALIB_DATA)

calib.for.scoring <- cbind(repeat_spend,
                           study_duration,
                           customer_duration,
                           trunc_repeat_avg_spend,
                           trunc_repeat_transaction_days)

summary(calib.for.scoring)

load(paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Scale.RData"))

calib.for.scoring <- calib.for.scoring - t(matrix(c.param, length(c.param), nrow(calib.for.scoring)))
calib.for.scoring <- calib.for.scoring / t(matrix(s.param, length(s.param), nrow(calib.for.scoring)))
summary(calib.for.scoring)

calib.for.scoring <- calib.for.scoring[,2:ncol(calib.for.scoring)]
load(paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Clust.RData"))
dist <- matrix(0, nrow(calib.for.scoring), nrow(means))
library(matrixStats)
for (i in 1:nrow(means))
{
  clust <- t(matrix(as.numeric(rep(means[i,], nrow(calib.for.scoring))), 
                    length(means), nrow(calib.for.scoring)))
  
  
  dist[,i] <- sqrt(rowSums((calib.for.scoring - clust)**2))
  
}


inds = which(dist == rowMins(dist), arr.ind=TRUE)
inds <- data.frame(inds[order(inds[,1]),])


load(paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Trans.RData"))

for (i in 1:nrow(means))
{  
  
  load(paste0("//10.8.8.51/lv0/Tanumoy/Datasets/LTV_Updates/ON_LTV_Model_Spend",i,".RData"))
  
  ON_LTV_CALIB_DATA.TRAIN <- ON_LTV_CALIB_DATA[inds[,2]==i, ]
  
  clusterno <- matrix(rep(i, nrow(ON_LTV_CALIB_DATA.TRAIN)))
  
  customer_key <- ON_LTV_CALIB_DATA.TRAIN$customer_key
  
  x <- ON_LTV_CALIB_DATA.TRAIN$trunc_repeat_transaction_days
  
  t.x <- ON_LTV_CALIB_DATA.TRAIN$customer_duration
  
  T.cal <- ON_LTV_CALIB_DATA.TRAIN$study_duration
  
  m.x <- ON_LTV_CALIB_DATA.TRAIN$trunc_repeat_avg_spend
  
  acquisition_date <- as.Date(ON_LTV_CALIB_DATA.TRAIN$acquisition_date)
  
  calib_start_date <- as.Date(ON_LTV_CALIB_DATA.TRAIN$calib_start_date)
  
  calib_end_date <- as.Date(ON_LTV_CALIB_DATA.TRAIN$calib_end_date)
  
  gc()
  
  #-----------------Forecast the no. of txns and avg spend in next 12 months/52 weeks for the customers ----------------
  
  T.star <- 52
  
  forecasted_txn_12 <- pnbd.ConditionalExpectedTransactions(ptc, T.star, x, t.x, T.cal)
  
  forecasted_avg_spend_12 <- spend.expected.value(psc, m.x, x)
  
  gc()
  
  exp_ltv_12 <- forecasted_txn_12 * forecasted_avg_spend_12
  
  
  #-----------------Forecast the no. of txns and avg spend in next 15 months/65 weeks for the customers ----------------
  
  T.star <- 65
  
  forecasted_txn_15 <- pnbd.ConditionalExpectedTransactions(ptc, T.star, x, t.x, T.cal)
  
  forecasted_avg_spend_15 <- spend.expected.value(psc, m.x, x)
  
  gc()
  
  exp_ltv_15 <- forecasted_txn_15 * forecasted_avg_spend_15
  
  
  mydata <-    data.frame(cbind(customer_key,
                                clusterno,
                                acquisition_date,
                                calib_start_date,
                                calib_end_date,
                                forecasted_txn_12,
                                forecasted_avg_spend_12,
                                exp_ltv_12,
                                forecasted_txn_15, 
                                forecasted_avg_spend_15,
                                exp_ltv_15))
  if (i==1)
  {
    scored_file <- mydata
  }
  if (i>1)
  {
    scored_file <- rbind(scored_file, mydata)
  }
  
}


ON_LTV_VALID_DATA <- read.table(file="//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/ON_20140101_LTV_VALID_TRANSACTION.TXT",
                                    sep="|",head=FALSE)

colnames(ON_LTV_VALID_DATA)[1]  <- "customer_key"
colnames(ON_LTV_VALID_DATA)[2]  <- "valid_start_date"
colnames(ON_LTV_VALID_DATA)[3]  <- "valid_end_date_12"
colnames(ON_LTV_VALID_DATA)[4]  <- "valid_end_date_15"
colnames(ON_LTV_VALID_DATA)[5]  <- "min_purchase_date"
colnames(ON_LTV_VALID_DATA)[6]  <- "max_purchase_date_12"
colnames(ON_LTV_VALID_DATA)[7]  <- "max_purchase_date_15"
colnames(ON_LTV_VALID_DATA)[8]  <- "transaction_days_12"
colnames(ON_LTV_VALID_DATA)[9]  <- "transactions_12"
colnames(ON_LTV_VALID_DATA)[10] <- "spend_12"
colnames(ON_LTV_VALID_DATA)[11] <- "transaction_days_15"
colnames(ON_LTV_VALID_DATA)[12] <- "transactions_15"
colnames(ON_LTV_VALID_DATA)[13] <- "spend_15"

customer_key <- ON_LTV_VALID_DATA$customer_key
spend_12 <- ON_LTV_VALID_DATA$spend_12
spend_15 <- ON_LTV_VALID_DATA$spend_15
transactions_12 <- ON_LTV_VALID_DATA$transactions_12
transactions_15 <- ON_LTV_VALID_DATA$transactions_15

valid_data <- cbind(customer_key, transactions_12, spend_12, transactions_15, spend_15)

scored_file_valid <- merge(scored_file, valid_data, by="customer_key")
scored_file_valid <- na.omit (scored_file_valid)

write.table(scored_file_valid, 
            file = "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/ON_20140101_LTV_SCORED_VALID.TXT", sep= "|", row.names= FALSE, col.names= TRUE)
rm(T.star)

#save.image("//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/BR LTV Model.RData")

gc();


