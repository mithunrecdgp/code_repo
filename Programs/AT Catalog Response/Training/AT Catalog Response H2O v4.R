install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
install.packages("mxnet")
install.packages("mlbench")
install.packages("h2o")

install.packages("devtools")
require(devtools)
remove.packages("DiagrammeR")
install_version("DiagrammeR", version = "0.8.1", repos = "http://cran.us.r-project.org")
require(mxnet)


install.packages("pROC")
install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")



require(drat)
require(mxnet)
require(mlbench)
require(h2o)

## Start a local cluster with 2GB RAM
localH2O = h2o.init(ip = "localhost", port = 54321, startH2O = TRUE, 
                    max_mem_size = '7G')

library(pROC)
library(ff)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)



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


setwd('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model')

headers1<-cbind('SampleSize', 'run', 'rate', 'epochs', 'activation', 'Prior', 
                'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance',
                'cvaccuracy', 'cvauc', 'cvf1', 'cvf2', 'cvprecision',
                'cvrecall', 'cvspecificity')
write.table(headers1, paste0('at_catalog_training_h2o_', format(min.sample.size, scientific=F),'_', 
                             format(max.sample.size, scientific=F), '_v4.txt'), 
            append=FALSE, sep="|",row.names=FALSE,col.names=FALSE)

headers2<-cbind('SampleSize', 'run', 'rate', 'epochs', 'activation','TestRun', 'Prior', 
                'AUC', 'Concordance')
write.table(headers2, paste0('at_catalog_testing_h2o_', format(min.sample.size, scientific=F),'_', 
                             format(max.sample.size, scientific=F), '_v4.txt'), 
            append=FALSE, sep="|",row.names=FALSE,col.names=FALSE)


#---------------------------------------------------------------------
# ------------- declare deep learning parameters----------------------
activation = "Tanh"
rate = 1.0e-4
hidden = c(12,10,8,6)
epochs = 100
distribution='bernoulli'
momentum_start = 0.5
momentum_stable = 0.9
nfolds=5
#---------------------------------------------------------------------
#---------------------------------------------------------------------


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
    
    tra.at <- tra.at[c(-1, -ncol(tra.at))]
    
    print(prop <- sum(tra.at[,1])/nrow(tra.at))
    tra.at[,1] <- factor(tra.at[,1])
    
    tra.at.h2o <- as.h2o(x=tra.at, destination_frame='h2o.data.frame')
    
    h2o.model <-  h2o.deeplearning(x = 2:ncol(tra.at),  # column numbers for predictors
                                   y = 1,   # column number for label
                                   training_frame = tra.at.h2o, # data in H2O format
                                   activation = activation, # Activaion function
                                   balance_classes = F, # set to false for balanced data
                                   rate = rate, # rate parameter
                                   hidden = hidden, # hidden layers with nodes in each layer
                                   epochs = epochs, # max. no. of epochs
                                   overwrite_with_best_model=T, # retains the best model
                                   adaptive_rate = F,
                                   distribution = distribution,
                                   momentum_start = momentum_start,
                                   momentum_stable = momentum_stable,
                                   nfolds = nfolds,
                                   fast_mode = T,
                                   variable_importances = T
                                   ) 
    
    cv.summary <- data.frame(attr(h2o.model,"model")$cross_validation_metrics_summary)
    cv.summary <- t(cv.summary)[1,c('accuracy', 'auc', 'f1', 'f2', 'precision',
                                    'recall', 'specificity')]
    
    names(cv.summary) <- c('cvaccuracy', 'cvauc', 'cvf1', 'cvf2', 'cvprecision',
                           'cvrecall', 'cvspecificity')
      
    roc.area <- attr(attr(h2o.model,"model")$training_metrics, "metrics")$AUC
    
    prob_tra <- matrix(as.numeric(h2o.predict(h2o.model, tra.at.h2o)), 
                       nrow(tra.at.h2o), 3)
    
    concordance <- OptimisedConc(tra.at[,1],prob_tra[,3])[1]
    
    tnr <- prop.table(table(tra.at[,1], prob_tra[,1]), 1)[1,1]
    tpr <- prop.table(table(tra.at[,1], prob_tra[,1]), 1)[2,2]  
    acc <- prop.table(table(tra.at[,1], prob_tra[,1]))[1,1] + 
           prop.table(table(tra.at[,1], prob_tra[,1]))[2,2]
    
    print(paste('SampleSize', 'run', 'rate', 'epochs', 'activation', 'Prior', 
                'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance',
                'cvaccuracy', 'cvauc', 'cvf1', 'cvf2', 'cvprecision',
                'cvrecall', 'cvspecificity'))
    print(paste(sample.sizes[i], s, rate, epochs, activation, prop, 
                tpr, tnr, acc, roc.area, concordance,
                cv.summary[1], cv.summary[2], cv.summary[3], cv.summary[4],
                cv.summary[5], cv.summary[6], cv.summary[7]))
    
    write.table(cbind(sample.sizes[i], s, rate, epochs, activation, prop, 
                      tpr, tnr, acc, roc.area, concordance,
                      cv.summary[1], cv.summary[2], cv.summary[3], cv.summary[4],
                      cv.summary[5], cv.summary[6], cv.summary[7]),
                paste0('at_catalog_training_h2o_', format(min.sample.size, scientific=F),'_', 
                       format(max.sample.size, scientific=F), '_v4.txt'), 
                append=TRUE, sep="|",row.names=FALSE,col.names=FALSE)
    
    h2o.object <- paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/H2O/v4/',
                         sample.sizes[i],'_', s,'_',activation)
    
    unlink(h2o.object, recursive = T, force = T)

    h2o.saveModel(h2o.model, path=h2o.object, force=T)
    
    h2o.model <- h2o.loadModel(path=paste0(h2o.object, '/', list.files(h2o.object)))
    
    print('------------------------------------------')
    print('---------- Running Validations -----------')
    print('------------------------------------------')
    
    
    print(paste('SampleSize', 'run', 'rate', 'epochs', 'activation','TestRun', 'Prior', 
                'AUC', 'Concordance'))
    
    index.tst.at <- sample(1:nrow(rbind(tst.at.ones, tst.at.zeroes)), 
                           size=10000*20, replace=F)
    
    for (l in 1:20)
    {
      
      tst.at <- rbind(tst.at.ones, tst.at.zeroes)[index.tst.at[((l-1)*10000 + 1):(l*10000)],]
      tst.at<-tst.at[c(-1, -ncol(tst.at))]
      
      prop.tst <- sum(tst.at[,1])/nrow(tst.at)
      
      tst.at.h2o <- as.h2o(x=tst.at, destination_frame='h2o.data.frame')
      
      prob_tst <- matrix(as.numeric(h2o.predict(h2o.model, tst.at.h2o)), 
                         nrow(tst.at.h2o), 3)
      
      concordance.tst <- OptimisedConc(tst.at[,1],prob_tst[,3])[1]
      
      roc.area.tst <- auc(roc(tst.at[,1], prob_tst[,3]))
      
      print(paste(sample.sizes[i], s, rate, epochs, activation, l, prop.tst, 
                  roc.area.tst, concordance.tst)) 
      
      write.table(cbind(sample.sizes[i], s, rate, epochs, activation, l, prop.tst, 
                        roc.area.tst, concordance.tst),
                  paste0('at_catalog_testing_h2o_', format(min.sample.size, scientific=F),'_', 
                         format(max.sample.size, scientific=F), '_v4.txt'), 
                  append=TRUE, sep="|",row.names=FALSE,col.names=FALSE)
      
    }

  }
  
}