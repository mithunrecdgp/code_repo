install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
install.packages("mxnet")

install.packages("devtools")
require(devtools)
remove.packages("DiagrammeR")
install_version("DiagrammeR", version = "0.8.1", repos = "http://cran.us.r-project.org")
require(mxnet)

install.packages('magrittr')
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


setwd('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Email Model/US/GP')

load("//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/gp_us_em_allcampaigns_combined.RData")

min.sample.size <- 20000; max.sample.size <- 50000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=5000)

balance <- 0


model.data <- gp.data.balanced.scaled

headers1<-cbind('SampleSize', 'run', 'learningrate', 'momentum', 'arraybatchsize', 'rounds',
                'activation', 'Prior', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance')
write.table(headers1, paste0('gp_us_em_response_all_training_mxn_', format(min.sample.size, scientific=F),'_', 
                             format(max.sample.size, scientific=F), '_v4.txt'), 
            append=FALSE, sep="|",row.names=FALSE,col.names=FALSE)

headers2<-cbind('SampleSize', 'run', 'learningrate', 'momentum', 'arraybatchsize', 'rounds',
                'activation', 'SampleNumber', 'AUC','Concordance')
write.table(headers2, paste0('gp_us_em_response_all_testing_mxn_', format(min.sample.size, scientific=F),'_', 
                             format(max.sample.size, scientific=F), '_v4.txt'), 
            append=FALSE, sep="|",row.names=FALSE,col.names=FALSE)


#---------------------------------------------------------------------------------------
#------------- Global Parameters for Deep Learning Network -----------------------------
#---------------------------------------------------------------------------------------

arraybatchsize <- 200 # 20 for 'sigmoid' and 100 for 'tanh'
rounds <- 200
momentum <- 0.9
learningrate <- 0.05 # 0.1 for 'sigmoid' and 0.05 for 'tanh'
activationlist <- c('tanh')  # activationlist <- c('tanh', 'sigmoid')
layers  <- c(30, 15, 7) # c(12, 9, 6) for 'sigmoid' and c(10, 5) for 'tanh'

#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------


for(i in 1:length(sample.sizes))
{ 
  for (s in 1:10)
  {
    for (z in 1:length(activationlist))
    {  
      if (balance==1)
      {
        model.data.ones <- model.data[model.data[,2]==1,]
        index.ones.tra <- bigsample(1:nrow(model.data.ones), size=0.5*sample.sizes[i], replace=F)
        tra.at.ones <- model.data.ones[ index.ones.tra,]
        tst.at.ones <- model.data.ones[-index.ones.tra,]
        
        rm(model.data.ones); gc();
        
        
        model.data.zeroes <- model.data[model.data[,2]!=1,]
        index.zeroes.tra <- bigsample(1:nrow(model.data.zeroes), size=0.5*sample.sizes[i], replace=F)
        tra.at.zeroes <- model.data.zeroes[ index.zeroes.tra,]
        tst.at.zeroes <- model.data.zeroes[-index.zeroes.tra,]
        
        rm(model.data.zeroes); gc();
        
        tra.at <- rbind(tra.at.ones, tra.at.zeroes)
        rm(tra.at.ones, tra.at.zeroes); gc();
        
      }
      
      if (balance==0)
      {
        index.tra <- bigsample(1:nrow(model.data), size=sample.sizes[i], replace=F)
        tra.at <- model.data[ index.tra,]
        tst.at.all <- model.data[-index.tra,]
        
      }
      
      tra.at <- tra.at[,c('responder',
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
                          'item_qty_pct_6mo_rtn')]
      
      prop <- sum(tra.at[,1])/nrow(tra.at)
      
      tra.at <- data.matrix(tra.at)
      
      tra.at.x <- tra.at[,-1]
      tra.at.y <- tra.at[, 1]
      
  
      
      mlp.object <- paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/Email Model/US/GP/MXN/',
                           sample.sizes[i],'_', s,'_',activationlist[z])
      
                
      devices <- mx.cpu()
      mx.set.seed(0)
      mlp.model <- mx.mlp(tra.at.x, tra.at.y, hidden_node=layers, out_node=2, out_activation="softmax",
                          num.round=rounds, array.batch.size=arraybatchsize, learning.rate=learningrate,
                          momentum=momentum, eval.metric=mx.metric.accuracy, activation=activationlist[z], 
                          array.layout = 'rowmajor', optimizer='sgd',
                          epoch.end.callback=mx.callback.log.train.metric(100))
      
      preds <- predict(mlp.model, tra.at.x, array.layout = 'rowmajor')
      prob_tra <- t(preds)
      
      ## Auto detect layout of input matrix, use rowmajor..
      resp_tra <- max.col(t(preds))-1
      
      
      tpr <- prop.table(table(tra.at.y, resp_tra), 1)[1,1]
      tnr <- prop.table(table(tra.at.y, resp_tra), 1)[2,2]  
      acc <- prop.table(table(tra.at.y, resp_tra))[1,1] + 
             prop.table(table(tra.at.y, resp_tra))[2,2]
      
      print('------------------------------------------')
      print(mlp.model)
      print('------------------------------------------')
      
      mx.model.save(mlp.model, prefix=mlp.object, iteration=rounds)
      mlp.model <- mx.model.load(mlp.object, rounds)
      
      roc.area <- auc(roc(tra.at[,1], prob_tra[,2]))
      
      concordance <- OptimisedConc(tra.at[,1],prob_tra[,2])[1]
      
      print(paste('SampleSize', 'run', 'learningrate', 'momentum', 'arraybatchsize', 'rounds',
                  'activation', 'Prior', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance'))
      print(paste(sample.sizes[i], s, learningrate, momentum, arraybatchsize, rounds,
                  activationlist[z], prop, tpr, tnr, acc, roc.area, concordance))
      
      
      write.table(cbind(sample.sizes[i], s, learningrate, momentum, arraybatchsize, rounds,
                        activationlist[z], prop, tpr, tnr, acc, roc.area, concordance),
                  paste0('gp_us_em_response_all_training_mxn_', format(min.sample.size, scientific=F),'_', 
                         format(max.sample.size, scientific=F), '_v4.txt'), 
                  append=TRUE, sep="|",row.names=FALSE,col.names=FALSE)
      
      
      
          
      print('------------------------------------------')
      print('---------- Running Validations -----------')
      print('------------------------------------------')
      
      if (balance==1)
      {
        index.tst.at <- sample(1:nrow(rbind(tst.at.ones, tst.at.zeroes)),
                               size=10000*20, replace=F)
      }
      
      if (balance==0)
      {
        index.tst.at <- sample(1:nrow(tst.at.all),
                               size=10000*20, replace=F)        
      }
      
      tst.at.all <- tst.at.all[,c('responder',
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
                                  'item_qty_pct_6mo_rtn')]
              
      print(paste('SampleSize', 'run', 'learningrate', 'momentum', 'arraybatchsize', 'rounds',
                  'activation','TestRun', 'Prior', 'AUC', 'Concordance'))
      
      for (l in 1:20)
      {
        if (balance==1)
        {
          tst.at <- rbind(tst.at.ones, tst.at.zeroes)[index.tst.at[((l-1)*10000 + 1):(l*10000)],]
          tst.at <- data.frame(tst.at)
        }
        
        if (balance==0)
        {
          tst.at <- tst.at.all[index.tst.at[((l-1)*10000 + 1):(l*10000)],]
          tst.at <- data.frame(tst.at)
        }
        
        
        
        tst.at <- data.matrix(tst.at)
        
        tst.at.x <- tst.at[,-1]
        tst.at.y <- tst.at[, 1]
        
        prop.tst <- sum(tst.at[,1])/nrow(tst.at)
        
        preds <- predict(mlp.model, tst.at.x, array.layout = 'rowmajor')
        prob_tst <- t(preds)
      
        roc.area.tst <- auc(roc(tst.at[,1], prob_tst[,2]))
        
        concordance.tst <- OptimisedConc(tst.at[,1], prob_tst[,2])[1]
        
        print(paste(sample.sizes[i], s, learningrate, momentum, arraybatchsize, rounds,
                    activationlist[z], l, prop.tst, roc.area.tst, concordance.tst))
        
        write.table(cbind(sample.sizes[i], s, learningrate, momentum, arraybatchsize, rounds,
                          activationlist[z], l, prop.tst, roc.area.tst, concordance.tst),
                    paste0('gp_us_em_response_all_testing_mxn_', format(min.sample.size, scientific=F),'_', 
                           format(max.sample.size, scientific=F), '_v4.txt'), 
                    append=TRUE, sep="|",row.names=FALSE,col.names=FALSE)
        
        
        
      }
	  
	  #rm(tst.at.ones, tst.at.zeroes)
	  gc()
	
          
    }
	
  }
  
}




# mx.symbol.FullyConnected(name = "fc1", num_hidden = 15) %>%
# mx.symbol.Activation(name = "sigmoid1", act_type = "sigmoid") %>%
# mx.symbol.FullyConnected(name = "fc2", num_hidden = 12) %>%
# mx.symbol.Activation(name = "sigmoid2", act_type = "sigmoid") %>%
# mx.symbol.FullyConnected(name="fc3", num_hidden=9) %>%
# mx.symbol.Activation(name = "sigmoid3", act_type = "sigmoid") %>%
# mx.symbol.FullyConnected(name="fc4", num_hidden=6) %>%
# mx.symbol.Activation(name = "sigmoid4", act_type = "sigmoid") %>%
# mx.symbol.FullyConnected(name="fc5", num_hidden=3) %>%
# mx.symbol.Activation(name = "sigmoid5", act_type = "sigmoid") %>%
# mx.symbol.FullyConnected(name="fc6", num_hidden=1) %>%
# mx.symbol.SoftmaxOutput(name="sm")

