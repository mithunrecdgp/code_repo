install.packages("ada")
install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")
install.packages("verification")
install.packages("ROCR")
install.packages("AUC")
install.packages("gbm")
install.packages("party")
install.packages("partykit")

rm(list=ls())
gc()

library(ff)
library(ada)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)
library(verification)
library(ROCR)
library(AUC)
library(gbm)
library(party)
library(partykit)


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
    ties<-ties+length(subset(diffx,sign(diffx) ==-0))
  }
  
  concordance<-concordant/totalpairs
  discordance<-discordant/totalpairs
  percentties<-1-concordance-discordance
  return(list("Percent Concordance"=concordance,
              "Percent Discordance"=discordance,
              "Percent Tied"=percentties,
              "Pairs"=totalpairs))
}


setwd('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model')

at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_catalog_data_v1.txt",header = F,
                        VERBOSE = TRUE, sep='|',colClasses = c(rep("numeric",28)))


colnames(at.data) <- c('customer_key',
                       'bought',
                       'net_sales',
                       'disc_p',
                       'items_purch',
                       'num_txn',
                       'avg_ord_sz',
                       'avg_unt_rtl',
                       'unt_per_txn',
                       'on_sale_items',
                       'recency',
                       'net_sales_season',
                       'disc_p_season',
                       'items_purch_season',
                       'num_txn_season',
                       'avg_ord_sz_season',
                       'avg_unt_rtl_season',
                       'unt_per_txn_season',
                       'on_sale_items_season',
                       'recency_season',
                       'items_browsed_season',
                       'items_browsed',
                       'items_abandoned_season',
                       'items_abandoned',
                       'emails_clicked',
                       'emails_viewed',
                       'num_cat_season',
                       'num_cat'
)	


at.data <- at.data[,c('customer_key',
                      'bought',
                      'net_sales',
                      'disc_p',
                      'avg_ord_sz',
                      'unt_per_txn',
                      'on_sale_items',
                      'recency',
                      'items_browsed',
                      'items_abandoned',
                      'emails_clicked',
                      'emails_viewed',
                      'num_cat')
                   ]


min.sample.size <- 5000; max.sample.size <- 20000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=1000)

ntree.list <- c(50, 100, 150, 200, 250, 300)

balance <- 1

headers1<-cbind("samplesize", "run", "ntree", "TPR", "TNR", "Accuracy", "AUC","Concordance")
write.table(headers1, paste0('at_catalog_training_lbt_', min.sample.size,'_', max.sample.size, '_v1.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

headers2<-cbind("samplesize","run", "ntree" , "SampleNumber", "TestRun", "AUC","Concordance")
write.table(headers2, paste0('at_catalog_testing_lbt_', min.sample.size,'_', max.sample.size, '_v1.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)


for(i in 1:length(sample.sizes))
{ 
  for (s in 1:5)
  {
    
    if (balance==1)
    {
      at.data.ones <- at.data[at.data[,2]==1,]
      index.ones.tra <- bigsample(1:nrow(at.data.ones), size=0.5*sample.sizes[i], replace=F)
      tra.at.ones <- at.data.ones[ index.ones.tra,]
      tst.at.ones <- at.data.ones[-index.ones.tra,]
      
      rm(at.data.ones); gc();
      
      
      at.data.zeroes <- at.data[at.data[,2]!=1,]
      index.zeroes.tra <- bigsample(1:nrow(at.data.zeroes), size=0.5*sample.sizes[i], replace=F)
      tra.at.zeroes <- at.data.zeroes[ index.zeroes.tra,]
      tst.at.zeroes <- at.data.zeroes[-index.zeroes.tra,]
      
      rm(at.data.zeroes); gc();
      
      tra.at <- rbind(tra.at.ones, tra.at.zeroes)
      rm(tra.at.ones, tra.at.zeroes); gc();
      
    }
    
    if (balance==0)
    {
      index.tra <- bigsample(1:nrow(at.data), size=sample.sizes[i], replace=F)
      tra.at <- at.data[ index.tra,]
      tst.at.all <- at.data[-index.tra,]
      
    }
    
    tra.at <- tra.at[,c(-1)]
    
    prop <- sum(tra.at[,1])/nrow(tra.at)
    
    tra.at <- data.frame(tra.at)
    
    tra.at[,1] <- as.factor(tra.at[,1])
    
    
    
      
    for (ls in 1:length(ntree.list))
    {
      
      lbt.object <- paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/LBT/v1/', sample.sizes[i],'_', s, '_', 
                           ntree.list[ls], '_', '.RData')
      
      measurevar <- colnames(tra.at)[ 1]
      groupvars  <- colnames(tra.at)[-1]
      
      # This creates the appropriate string:
      paste(measurevar, paste(groupvars, collapse=" + "), sep=" ~ ")
      
      # This returns the formula:
      f <- as.formula(paste(measurevar, paste(groupvars, collapse=" + "), sep=" ~ "))
      
      
      lbt.model <- LogitBoost(xlearn=tra.at[,c(-1)], ylearn=tra.at[,1], nIter=20)
      
      
      
      prob_tra <- predict(object=lbt.model, xtest=data.frame(tra.at[,c(-1)]), type='raw')
      
      confusion <- table(tra.at[,1] == 1, prob_tra[,2] > 0.5)
      
      tpr <- confusion[1,1] / sum(confusion[1,])
      tnr <- confusion[2,2] / sum(confusion[2,])
      acc <- (confusion[1,1] + confusion[2,2])/nrow(tra.at)
      
      print('------------------------------------------')
      print(lbt.model)
      print('------------------------------------------')
      
      save(lbt.model, file=lbt.object)
      
      roc.area <- auc(roc(prob_tra[,2], tra.at[,1]))
      
      concordance <- OptimisedConc(tra.at[,1], prob_tra[,2])[1]
      
      print(paste('SampleSize', 'Run', 'ntree', 'Prior', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance'))
      print(paste(sample.sizes[i], s, ntree.list[ls], prop, tpr, tnr, acc, roc.area, concordance))
      
      
      write.table(cbind(sample.sizes[i], s, ntree.list[ls], tpr, tnr, acc, roc.area, concordance),
                  paste0('at_catalog_training_lbt_', min.sample.size,'_', max.sample.size, '_v1.csv'), 
                  append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
      
      print('------------------------------------------')
      print('---------- Running Validations -----------')
      print('------------------------------------------')
      
      if (balance==1)
      {
        index.tst.at <- sample(1:nrow(rbind(tst.at.ones, tst.at.zeroes)),
                               size=100000*10, replace=F)
      }
      
      if (balance==0)
      {
        index.tst.at <- sample(1:nrow(tst.at.all),
                               size=100000*10, replace=F)        
      }
      
      print(paste('SampleSize', 'ntree', 'Run', 'TestRun', 'Prior', 'AUC', 'Concordance'))
      
      for (l in 1:10)
      {
        if (balance==1)
        {
          tst.at <- rbind(tst.at.ones, tst.at.zeroes)[index.tst.at[((l-1)*10000 + 1):(l*10000)],]
          tst.at <- tst.at[,c(-1)]
          tst.at <- data.frame(tst.at)
        }
        
        if (balance==0)
        {
          tst.at <- tst.at.all[index.tst.at[((l-1)*10000 + 1):(l*10000)],]
          tst.at <- tst.at[c(-1)]
          tst.at <- data.frame(tst.at)
        }
        
        prop.tst <- sum(tst.at[,1])/nrow(tst.at)
        
        gc()
        prob_tst <- predict(lbt.model, xtest=data.frame(tst.at[,c(-1)]), type='raw')

        roc.area.tst <- auc(roc(as.factor(tst.at[,1]), prob_tst[,2]))
        
        concordance.tst <- OptimisedConc(tst.at[,1], prob_tst[,2])[1]
        
        print(paste(sample.sizes[i], s, ntree.list[ls], l, prop.tst, roc.area.tst, concordance.tst))
        
        write.table(cbind(sample.sizes[i], s, ntree.list[ls], l, roc.area.tst, concordance.tst),
                    paste0('at_catalog_testing_lbt_', min.sample.size,'_', max.sample.size, '_v1.csv'), 
                    append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
        
        
        
      }
      
    }
    
  
  
    rm(tst.at.ones, tst.at.zeroes)
    gc()
    
  }
  
}