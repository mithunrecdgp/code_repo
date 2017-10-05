install.packages("ada")
install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")
install.packages("verification")
install.packages("ROCR")
install.packages("pROC")
install.packages("randomForest")

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
library(pROC)
library(randomForest)

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



setwd('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model')

at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_catalog_data_v3.txt",
                        header = F, VERBOSE = TRUE, sep=',',colClasses = c(rep("numeric",21)))


colnames(at.data) <- c("customer_key",
                       "bought",
                       "net_sales",
                       "disc_p",
                       "num_txn",
                       "avg_ord_sz",
                       "avg_unt_rtl",
                       "unt_per_txn",
                       "on_sale_items",
                       "recency",
                       "items_browsed",
                       "items_abandoned",
                       "emails_clicked",
                       "emails_viewed",
                       "num_cat",
                       "net_sales_sameprd",
                       "disc_p_sameprd",
                       "num_txn_sameprd",
                       "avg_ord_sz_sameprd",
                       "unt_per_txn_sameprd",
                       "on_sale_items_sameprd"
                      )	


min.sample.size <- 5000; max.sample.size <- 20000;

sample.sizes  <- seq(min.sample.size, max.sample.size, by=1000)

ntree.list    <- seq(100, 1000, by=100)

nodesize.list <- c(seq(50, 100, 10)) 
  
balance <- 1

headers1<-cbind("samplesize", "run", "ntree", "nodesize", "TPR", "TNR", "Accuracy", "AUC","Concordance")
write.table(headers1, paste0('at_catalog_training_rft_', min.sample.size,'_', max.sample.size, '_v3.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

headers2<-cbind("samplesize","run", "ntree", "nodesize", "SampleNumber", "AUC","Concordance")
write.table(headers2, paste0('at_catalog_testing_rft_', min.sample.size,'_', max.sample.size, '_v3.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)


for(i in 1:length(sample.sizes))
{ 
  for (s in 1:10)
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
    
    for(j in 1:length(ntree.list))
    {
      
      for (ls in 1:length(nodesize.list))
      {
        
        rft.object <- paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/RFT/v3/', sample.sizes[i],'_', s, '_', 
                             ntree.list[j], '_', nodesize.list[ls], '.RData')
        
        rft.model <- randomForest(y=as.factor(tra.at[,1]), x=tra.at[,c(-1)], ntree=100, 
                                  mtry=round(sqrt(ncol(tra.at[,c(-1)]))), replace=T,
                                  nodesize=16, importance=T, proximity=T)
        
        tpr <- rft.model$confusion[1,1] / sum(rft.model$confusion[1,])
        tnr <- rft.model$confusion[2,2] / sum(rft.model$confusion[2,])
        acc <- (rft.model$confusion[1,1] + rft.model$confusion[2,2])/nrow(tra.at)
        
        print('------------------------------------------')
        print(rft.model)
        print('------------------------------------------')
        
        prob_tra<- predict(rft.model, tra.at[,c(-1)], type="prob")
        
        save(rft.model, file=rft.object)
        
        roc.area <- auc(roc(tra.at[,1], prob_tra[,2]))
        
        concordance <- OptimisedConc(tra.at$bought,prob_tra[,2])[1]
        
        print(paste('SampleSize', 'Run', 'ntree', 'nodesize','Prior', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance'))
        print(paste(sample.sizes[i], s, ntree.list[j], nodesize.list[ls], prop, tpr, tnr, acc, roc.area, concordance))
        
        
        write.table(cbind(sample.sizes[i], s, ntree.list[j], nodesize.list[ls], tpr, 
                          tnr, acc, roc.area, concordance),
                    paste0('at_catalog_training_rft_', min.sample.size,'_', max.sample.size, '_v3.csv'), 
                    append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
        
        
        
        
        print('------------------------------------------')
        print('---------- Running Validations -----------')
        print('------------------------------------------')
        
        if (balance==1)
        {
          index.tst.at <- sample(1:nrow(rbind(tst.at.ones, tst.at.zeroes)),
                                 size=10000*10, replace=F)
        }
        
        if (balance==0)
        {
          index.tst.at <- sample(1:nrow(tst.at.all),
                                 size=10000*10, replace=F)        
        }
        
        print(paste('SampleSize', 'Run', 'ntree', 'nodesize', 'TestRun', 'Prior', 'AUC', 'Concordance'))
        
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
          prob_tst <- predict(rft.model,tst.at[,c(-1)],type="prob")
          
          roc.area.tst <- auc(roc(tst.at[,1], prob_tst[,2]))
          
          concordance.tst <- OptimisedConc(tst.at$bought,prob_tst[,2])[1]
          
          print(paste(sample.sizes[i], s, ntree.list[j], nodesize.list[ls], l, prop.tst, 
                      roc.area.tst, concordance.tst))
          
          write.table(cbind(sample.sizes[i], s, ntree.list[j], nodesize.list[ls], l,
                            roc.area.tst, concordance.tst),
                      paste0('at_catalog_testing_rft_', min.sample.size,'_', max.sample.size, '_v3.csv'), 
                      append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
          
          
          
        }
        
      }
      
    }
    
    rm(tst.at.ones, tst.at.zeroes)
    gc()
    
  }
  
}

