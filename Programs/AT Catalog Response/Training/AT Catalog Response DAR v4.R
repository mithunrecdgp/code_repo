install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
install.packages("mxnet")
install.packages('magrittr')
install.packages('darch')

install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")
install.packages("verification")
install.packages("pROC")


rm(list=ls())
gc()

library(mxnet)
library(drat)
library(magrittr)
library(darch)
library(ff)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)
library(verification)
library(pROC)



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


at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_catalog_data_v4.csv",
                        header = T, VERBOSE = TRUE, sep=',')


colnames(at.data) <- c("customer_key",
                       "bought",
                       "net_sales",
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
                       "on_sale_items_sameprd",
                       "season"
                       )	

min.sample.size <- 5000; max.sample.size <- 20000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=1000)

headers1<-cbind('SampleSize', 'run', 'learningrate', 'arraybatchsize', 'rounds',
                'activation', 'Prior', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance')
write.table(headers1, paste0('at_catalog_training_dar_', format(min.sample.size, scientific=F),'_', 
                             format(max.sample.size, scientific=F), '_v4.txt'), 
            append=FALSE, sep="|",row.names=FALSE,col.names=FALSE)

headers2<-cbind('SampleSize', 'run', 'learningrate', 'arraybatchsize', 'rounds',
                'activation', 'SampleNumber', 'AUC','Concordance')
write.table(headers2, paste0('at_catalog_testing_dar_', format(min.sample.size, scientific=F),'_', 
                             format(max.sample.size, scientific=F), '_v4.txt'), 
            append=FALSE, sep="|",row.names=FALSE,col.names=FALSE)


#---------------------------------------------------------------------------------------
#------------------- Global Parameters for Deep Learning Network -----------------------
#---------------------------------------------------------------------------------------

arraybatchsize <- 20 
rounds <- 500
learningrate <- 0.05
activationlist <- c('sigmoidUnit', 'tanhUnit')
layers  <- c(15, 10, 5, 2)

#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------


for(i in 1:length(sample.sizes))
{ 
  for (s in 1:10)
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
    
    tra.at <- tra.at[,c(-1, -ncol(tra.at))]
    
    prop <- sum(tra.at[,1])/nrow(tra.at)
    
    for (z in 1:length(activationlist))
    {  
      
      dar.object <- paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/DAR/v4/',
                           sample.sizes[i],'_', s,'_',activationlist[z])
      
      dar.model <- darch(x=tra.at[,-1], y=tra.at[,1], layers=layers,
                         bootstrap = T, bootstrap.unique = T, bootstrap.num=500,
                         darch.numEpochs = rounds, bp.learnRate=learningrate,
                         darch.unitFunction=activationlist[z],
                         darch.batchSize = arraybatchsize,
                         darch.returnBestModel=T)
      
      prob_tra <- predict(object=dar.model, newdata=tra.at[,-1], type='raw')
      
      ## Auto detect layout of input matrix, use rowmajor..
      resp_tra <- as.numeric(prob_tra>0.5)
      
      
      tpr <- prop.table(table(tra.at[,1], resp_tra), 1)[1,1]
      tnr <- prop.table(table(tra.at[,1], resp_tra), 1)[2,2]  
      acc <- prop.table(table(tra.at[,1], resp_tra))[1,1] + 
             prop.table(table(tra.at[,1], resp_tra))[2,2]
      
      print('------------------------------------------')
      print(dar.model)
      print('------------------------------------------')
      
      saveDArch(dar.model, name=dar.object)
      dar.model <- loadDArch(dar.object)
      
      roc.area <- auc(roc(tra.at[,1], prob_tra))
      
      concordance <- OptimisedConc(tra.at[,1],prob_tra)[1]
      
      print(paste('SampleSize', 'run', 'learningrate', 'arraybatchsize', 'rounds',
                  'activation', 'Prior', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance'))
      print(paste(sample.sizes[i], s, learningrate, arraybatchsize, rounds,
                  activationlist[z], prop, tpr, tnr, acc, roc.area, concordance))
      
      
      write.table(cbind(sample.sizes[i], s, learningrate, arraybatchsize, rounds,
                        activationlist[z], prop, tpr, tnr, acc, roc.area, concordance),
                  paste0('at_catalog_training_dar_', format(min.sample.size, scientific=F),'_', 
                         format(max.sample.size, scientific=F), '_v4.txt'), 
                  append=TRUE, sep="|",row.names=FALSE,col.names=FALSE)
      
      
        
      print('------------------------------------------')
      print('---------- Running Validations -----------')
      print('------------------------------------------')
      
      index.tst.at <- sample(1:nrow(rbind(tst.at.ones, tst.at.zeroes)),
                               size=10000*20, replace=F)
      print(paste('SampleSize', 'run', 'learningrate', 'arraybatchsize', 'rounds',
                  'activation','TestRun', 'Prior', 'AUC', 'Concordance'))
      
      for (l in 1:20)
      {
        
        tst.at <- rbind(tst.at.ones, tst.at.zeroes)[index.tst.at[((l-1)*10000 + 1):(l*10000)],]
        tst.at <- tst.at[,c(-1, -ncol(tst.at))]
        tst.at <- data.frame(tst.at)
        
        
        prop.tst <- sum(tst.at[,1])/nrow(tst.at)
        
        prob_tst <- predict(object=dar.model, newdata=tst.at[,-1], type='raw')
        
        roc.area.tst <- auc(roc(tst.at[,1], prob_tst))
        
        concordance.tst <- OptimisedConc(tst.at[,1], prob_tst)[1]
        
        print(paste(sample.sizes[i], s, learningrate, arraybatchsize, rounds,
                    activationlist[z], l, prop.tst, roc.area.tst, concordance.tst))
        
        write.table(cbind(sample.sizes[i], s, learningrate, arraybatchsize, rounds,
                          activationlist[z], l, prop.tst, roc.area.tst, concordance.tst),
                    paste0('at_catalog_testing_dar_', format(min.sample.size, scientific=F),'_', 
                           format(max.sample.size, scientific=F), '_v4.txt'), 
                    append=TRUE, sep="|",row.names=FALSE,col.names=FALSE)
        
        
      }
      
    }
    
    rm(tst.at.ones, tst.at.zeroes)
    gc()
    
  }
  
}



