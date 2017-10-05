library(ff)
library(ffbase)
library(ada)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)
library(verification)
library(ROCR)
library(pROC)
library(chron)
library(xgboost)
library(matrixStats)
library(modeest)



OptimisedConc=function(indvar,fittedvalues)
{
  x<-matrix(fittedvalues, length(fittedvalues), 1)
  y<-matrix(indvar, length(indvar), 1)
  z<-cbind(x,y)
  zeroes <- z[ which(y==0), ]
  ones <- z[ which(y==1), ]
  loopi<-nrow(ones)
  
  concordant<-0
  discordant<-0
  ties<-0
  totalpairs<- nrow(zeroes) * nrow(ones)
  
  
  for (k in 1:loopi)
  {
    
    diffx <- as.numeric(matrix(rep(ones[k,1], nrow(zeroes)),ncol=1)) - as.numeric(matrix(zeroes[,1],ncol=1))
    concordant<-concordant+length(subset(diffx,sign(diffx) == 1))
    discordant<-discordant+length(subset(diffx,sign(diffx) ==-1))
    ties<-ties+length(subset(diffx,sign(diffx) == 0))
  }
  
  concordance<-concordant/totalpairs
  discordance<-discordant/totalpairs
  percentties<-1-concordance-discordance
  return(list("Percent Concordance"=concordance,
              "Percent Discordance"=discordance,
              "Percent Tied"=percentties,
              "Pairs"=totalpairs))
}



#---------------------Function for Area Under ROC Curve -----------------------------------------

roc.area = function(observed, predicted)
{
  roc.grid = matrix(0, 1/0.01 + 1, 7)
  for (p in 1:nrow(roc.grid))
  {
    cutoff <- 0.02 * (nrow(roc.grid) - p)
    
    roc.grid[p,1] = cutoff
    roc.grid[p,2] = sum(prob_tst>cutoff & yvec==1)   # true positives
    roc.grid[p,3] = sum(prob_tst<=cutoff & yvec==0)  # true negatives
    roc.grid[p,4] = sum(prob_tst>cutoff & yvec==0)   # false positives
    roc.grid[p,5] = sum(prob_tst<=cutoff & yvec==1)  # false negatives
    roc.grid[p,6] = roc.grid[p,2]/(roc.grid[p,2] + roc.grid[p,5])
    roc.grid[p,7] = roc.grid[p,4]/(roc.grid[p,3] + roc.grid[p,4])
  }
  
  roc.area <- trapz(x=roc.grid[,7], y=roc.grid[,6])
  
  return(roc.area)
  
}

#-------------------------------------------------------------------------------------------------


at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/fallvalid_15var_latest.csv",
                        header = T, VERBOSE = TRUE, sep=',')

modelfilepath <- '//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/XGB/v4/'

modellist <- list.files(path=modelfilepath, full.names=T)  

aucmatrix = matrix(0, length(modellist), 2)


j <- 1

for (j in 1:length(modellist))
{
  load(modellist[j])
  
  xmatrix <- as.matrix(at.data[,3:(ncol(at.data)-1)])
  yvec = as.matrix(at.data[,2])
  
  prop.tst <- sum(at.data[,2])/nrow(at.data)
  
  gc()
  prob_tst <- predict(object=xgb.model, xmatrix)
  
  adj.prob_tst = 1/(1+(1/0.08145858-1)*(1/prob_tst-1))
  
  roc.auc <- roc.area(yvec, adj.prob_tst)
  
  print(paste(j, prop.tst, roc.auc))
  
  aucmatrix[j,1] = modellist[j]
  aucmatrix[j,2] = roc.auc
  
}

colnames(aucmatrix) <- c('modellist', 'AUC')

write_csv(data.frame(aucmatrix), "//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_fall_validation_xgb.csv", col_names=T)

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

feature.names <- c("net_sales",
                   "disc_p",
                   "avg_unt_rtl",         
                   "unt_per_txn",
                   "on_sale_items",
                   "recency",
                   "items_browsed",
                   "items_abandoned",
                   "num_cat",
                   "net_sales_sameprd",
                   "disc_p_sameprd",
                   "num_txn_sameprd",
                   "avg_unt_rtl_sameprd",
                   "unt_per_txn_sameprd",
                   "on_sale_items_sameprd"
                  )	

feature.names <- sort(feature.names)

# The Gain implies the relative contribution of the corresponding feature to the model calculated by taking each feature's 
# contribution for each tree in the model. A higher value of this metric when compared to another feature implies it is more 
# important for generating a prediction.

# The Cover metric means the relative number of observations related to this feature. For example, if you have 100 observations, 
# 4 features and 3 trees, and suppose feature1 is used to decide the leaf node for 10, 5, and 2 observations in tree1, tree2 and
# tree3 respectively; then the metric will count cover for this feature as 10+5+2 = 17 observations. This will be calculated for 
# all the 4 features and the cover will be 17 expressed as a percentage for all features' cover metrics.

# The Frequence (frequency) is the percentage representing the relative number of times a particular feature occurs in the trees of 
# the model. In the above example, if feature1 occurred in 2 splits, 1 split and 3 splits in each of tree1, tree2 and tree3; then the 
# weightage for feature1 will be 2+1+3 = 6. The frequency for feature1 is calculated as its percentage weight over weights of all features.

gain.matrix      = matrix(0, length(feature.names), 1)
cover.matrix     = matrix(0, length(feature.names), 1)
frequency.matrix = matrix(0, length(feature.names), 1)

gain.matrix[,1]      = feature.names
cover.matrix[,1]     = feature.names
frequency.matrix[,1] = feature.names

colnames(gain.matrix)      = 'Feature'
colnames(cover.matrix)     = 'Feature'
colnames(frequency.matrix) = 'Feature'

j <- 1

for (j in 1:length(modellist))
{
  
  load(modellist[j])
  
  varimportancegrid  = xgb.importance(feature_names = feature.names, model = xgb.model)
  print(varimportancegrid)
  varimportancegrid <- varimportancegrid[order(Feature),] 
  
  gain.matrix      <- merge(data.frame(gain.matrix), data.frame(varimportancegrid[,c(1,2)]), by='Feature', all.x=T)
  colnames(gain.matrix)[j+1] <- paste0('Model',j) 
  
  cover.matrix     <- merge(data.frame(cover.matrix), data.frame(varimportancegrid[,c(1,3)]), by='Feature', all.x=T)
  colnames(cover.matrix)[j+1] <- paste0('Model',j)
  
  frequency.matrix <- merge(data.frame(frequency.matrix), data.frame(varimportancegrid[,c(1,4)]), by='Feature', all.x=T)
  colnames(frequency.matrix)[j+1] <- paste0('Model',j)
  
}

gain.matrix[is.na(gain.matrix)]             <- 0
cover.matrix[is.na(cover.matrix)]           <- 0
frequency.matrix[is.na(frequency.matrix)]   <- 0

gain.matrix[, ncol(gain.matrix)+1]           <- rowMeans(gain.matrix[,2:(length(modellist)+1)])
cover.matrix[, ncol(cover.matrix)+1]         <- rowMeans(cover.matrix[,2:(length(modellist)+1)])
frequency.matrix[, ncol(frequency.matrix)+1] <- rowMeans(frequency.matrix[,2:(length(modellist)+1)])

colnames(gain.matrix)[ncol(gain.matrix)] <- paste0('Mean')
colnames(cover.matrix)[ncol(cover.matrix)] <- paste0('Mean')
colnames(frequency.matrix)[ncol(frequency.matrix)] <- paste0('Mean')






#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
min.sample.size <- 5000; max.sample.size <- 20000;

write.table(aucmatrix, 
            paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_fall_validation_xgb_', min.sample.size,'_', max.sample.size, '_v3.csv'), 
            append=F, sep=",",row.names=F,col.names=T)

write.table(aucmatrix, 
            paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_summer_validation_xgb_', min.sample.size,'_', max.sample.size, '_v3.csv'), 
            append=F, sep=",",row.names=F,col.names=T)

write.table(aucmatrix, 
            paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_fall_validation_xgb_', min.sample.size,'_', max.sample.size, '_v3.csv'), 
            append=F, sep=",",row.names=F,col.names=T)


min.sample.size <- 5000; max.sample.size <- 20000;

at.train.summary <-read.csv(paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_xgb_', 
                                   min.sample.size,'_', max.sample.size, '_v3.csv'), 
                            header = T, sep=',')

at.test.summary  <-read.csv(paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_xgb_', 
                                   min.sample.size,'_', max.sample.size, '_v3.csv'), 
                            header = T, sep=',')


testAUC <- aggregate(at.test.summary$AUC, 
                     by=list(at.test.summary$samplesize, at.test.summary$run), mean)

testConcordance <- aggregate(at.test.summary$Concordance, 
                             by=list(at.test.summary$samplesize, at.test.summary$run), mean)

colnames(testAUC) <- c("samplesize","run","testAUC")
colnames(testConcordance) <- c("samplesize","run","testConcordance")

testAUC <- testAUC[order(testAUC$samplesize, testAUC$run), ] 
testConcordance <- testConcordance[order(testConcordance$samplesize, testConcordance$run), ] 

at.test.summary <- cbind(testAUC, testConcordance$testConcordance)
colnames(at.test.summary) <- c("samplesize","run","testAUC","testConcordance")

at.test.summary <- at.test.summary[order(at.test.summary$samplesize, at.test.summary$run), ] 
at.train.summary <- at.train.summary[order(at.train.summary$samplesize, at.train.summary$run), ] 

at.summary <- cbind(at.train.summary, at.test.summary$testAUC, at.test.summary$testConcordance)


colnames(at.summary) <- c("samplesize","run","TPR","TNR","Accuracy","AUC","Concordance", 
                          "testAUC","testConcordance")

at.summary$diffAUC <- abs(at.summary$AUC - at.summary$testAUC)

at.summary$diffConcordance <- abs(at.summary$Concordance - at.summary$testConcordance)
  
at.summary$diffscore <- at.summary$diffAUC + at.summary$diffConcordance

at.summary <- at.summary[order(-at.summary$testAUC,
                               -at.summary$testConcordance,
                                at.summary$diffscore), ] 

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

modelfilepath <- '//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/XGB/v3/'
setwd(modelfilepath)

modelfilelist <- list.files(path=modelfilepath, full.names=T)  

modellist = matrix(rep("", 50), 50, 1)

for (i in 1:20)
{
  modellist[i] = paste0(modelfilepath, at.summary[i,1], "_", at.summary[i,2], ".RData")
}


modelindex <- as.numeric(modelfilelist %in% modellist)

k = 0
for (j in 1:length(modelfilelist))
{
  if (modelindex[j]==0)
  {
    k <- k + 1
    print(paste(k, modelfilelist[j]))
    file.remove(modelfilelist[j])
  }
}



probmatrix = matrix(0, nrow(at.data), length(modellist)+3)
adjprobmatrix = matrix(0, nrow(at.data), length(modellist)+3)


j <- 1

for (j in 1:length(modellist))
{
  load(modellist[j])
  
  xmatrix <- as.matrix(at.data[,3:ncol(at.data)])
  yvec = as.matrix(at.data[,2])
  
  prop.tst <- sum(at.data[,2])/nrow(at.data)
  
  gc()
  prob_tst <- predict(object=xgb.model, xmatrix)
  
  probmatrix[,j] = prob_tst
  adjprobmatrix[,j] = 1/(1+(1/0.1-1)*(1/prob_tst-1))
  
  roc.area.tst <- auc(roc(factor(yvec), probmatrix[,j]))
  roc.area.tst.adj <- auc(roc(factor(yvec), adjprobmatrix[,j]))
  
  print(paste(j, prop.tst, roc.area.tst, roc.area.tst.adj))
  
}


#invoke function for estimating mode

estimate_mode = function(yvec)
{
  m =  mlv(yvec, method='asselin', bw=0.001)
  modevalue = m$M
  return(modevalue)
} 


probmatrix[,21] = rowMeans(probmatrix[,1:(ncol(probmatrix)-3)])
probmatrix[,22] = rowMedians(probmatrix[,1:(ncol(probmatrix)-3)])
probmatrix[,23] = apply(probmatrix[,1:(ncol(probmatrix)-3)], 1, estimate_mode)

adjprobmatrix[,21] = rowMeans(adjprobmatrix[,1:(ncol(adjprobmatrix)-3)])
adjprobmatrix[,22] = rowMedians(adjprobmatrix[,1:(ncol(adjprobmatrix)-3)])
adjprobmatrix[,23] = apply(adjprobmatrix[,1:(ncol(adjprobmatrix)-3)], 1, estimate_mode)

j <- 1
for (j in 1:3)
{
  
  xmatrix <- as.matrix(at.data[,3:ncol(at.data)])
  yvec = as.matrix(at.data[,2])
  
  roc.area.tst <- auc(roc(factor(yvec), probmatrix[,20+j]))
  
  print(paste(j, ' adjusted:', roc.area.tst))
  
}


headers1<-cbind("customer_key", "bought",
                "model1", "model2", "model3", "model4", "model5","model6", "model7", "model8",
                "model9", "model10", "model11", "model12", "model13", "model14", "model15",
                "model16", "model17", "model18", "model19", "model20", 
                "mean", "median", "mode")

write.table(headers1, paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_validation_xgb_', min.sample.size,'_', max.sample.size, '_v3.csv'), 
            append=F, sep=",",row.names=FALSE,col.names=FALSE)

write.table(cbind(at.data[,1], at.data[,2], probmatrix), 
            paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_validation_xgb_', min.sample.size,'_', max.sample.size, '_v3.csv'), 
            append=T, sep=",",row.names=FALSE,col.names=FALSE)

library(readr)

at.data.netsales <- read_delim('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_catalog_summer_netsales_valid.txt',
                               col_names = c('customer_key', 'netsales'), 
                               delim='|', col_types = c(rep("dc", 2)))

at.data.netsales <- at.data.netsales[order(at.data.netsales$customer_key), ] 

at.data.netsales$netsales <- as.numeric(at.data.netsales$netsales) 
  
at.data.probs <-read.csv(paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_validation_xgb_', min.sample.size,'_', max.sample.size, '_v3.csv'),
                         header = T)

probmatrix[,21] = at.data.probs[,23]
probmatrix[,22] = at.data.probs[,24]
probmatrix[,23] = at.data.probs[,25]


adjprobmatrix[,21] = 1/(1+(1/0.1-1)*(1/at.data.probs[,23]-1))
adjprobmatrix[,22] = 1/(1+(1/0.1-1)*(1/at.data.probs[,24]-1))
adjprobmatrix[,23] = 1/(1+(1/0.1-1)*(1/at.data.probs[,25]-1))

responders = matrix(0, 10, 24)
responders[,1] = seq.int(10) 

for (i in 1:23)
{
  at.data.response <- cbind(at.data.probs[,1],
                            at.data.probs[,2],
                            at.data.probs[,i+2])
  
  colnames(at.data.response) <- c('customer_key', 'bought', 'prob')
  at.data.response <- data.frame(at.data.response)
  
  at.data.response <- at.data.response[order(-at.data.response$prob), ] 
  
  at.data.response$rowid <- seq.int(nrow(at.data.response)) 
  
  decilelength <- round(nrow(at.data.response)/10)
  
  at.data.response$decile <- floor(at.data.response$rowid/decilelength) + 1
  
  at.data.response$decile <- ifelse(at.data.response$decile>10, 10, at.data.response$decile)
  
  responders[,i+1] = aggregate(at.data.response$bought, 
                             by=list(at.data.response$decile), sum)[,2]
  
}


probcolidx <- (ncol(at.data.probs) - 3) + 3
at.data.response <- cbind(at.data.probs[,1],
                          at.data.probs[,2],
                          at.data.probs[,probcolidx])

colnames(at.data.response) <- c('customer_key', 'bought', 'prob')
at.data.response <- data.frame(at.data.response)

at.data.response <- at.data.response[order(at.data.response$customer_key), ] 

at.data.valid <- cbind(at.data.response, at.data.netsales$netsales) 
colnames(at.data.valid) <- c('customer_key', 'bought', 'prob', 'netsales')

at.data.valid <- at.data.valid[order(-at.data.valid$prob), ] 

at.data.valid$rowid <- seq.int(nrow(at.data.valid)) 

decilelength <- round(nrow(at.data.valid)/10)

at.data.valid$decile <- floor(at.data.valid$rowid/decilelength) + 1

at.data.valid$decile <- ifelse(at.data.valid$decile>10, 10, at.data.valid$decile)


responders <- aggregate(at.data.valid$bought, by=list(at.data.valid$decile), sum)
colnames(responders) <- c('decile', 'responders')

netsales   <- aggregate(at.data.valid$netsales, by=list(at.data.valid$decile), sum)
colnames(netsales) <- c('decile', 'netsales')

at.data.valid.summary <- cbind(responders, netsales$netsales)
colnames(at.data.valid.summary) <- c('decile', 'responders', 'netsales')

prop.table(table(at.data.valid$bought, as.numeric(at.data.valid$netsales!=0)),2)
