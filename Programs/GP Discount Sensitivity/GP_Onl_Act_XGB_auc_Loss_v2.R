install.packages("ada")
install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")
install.packages("verification")
install.packages("ROCR")
install.packages("AUC")
install.packages("xgboost")


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
library(xgboost)




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


setwd('//10.8.8.51/lv0/Tanumoy/Datasets/Discount Sensitivity')

gp.act.data <-read.table.ffdf(file="GP_Onl_Active_Base.csv",header = TRUE,sep=',',VERBOSE = TRUE)

gp.act.data <- gp.act.data[,c('customer_key',
                              'Disc_Sen_Tag',
                              'on_purchase_12mth_ind',
                              'brand_of_acquisition',
                              'num_dist_catg_purchase',
                              'per_disc_txn_12mth',
                              'rev_wo_rewd_12mth_onl',
                              'onl_non_disc_ats',
                              'disc_last_12_mth_onl',
                              'ratio_units_6_12mth',
                              'num_units_12mth_onl',
                              'total_net_sales_12mth',
                              'num_txn_12mth',
                              'per_rev_wo_rewd_12mth',
                              'num_disc_comm_respded',
                              'avg_order_last_12_mth',
                              'onl_disc_ats',
                              'on_sale_item_qty_12mth',
                              'on_sale_item_rev_12mth',
                              'per_rev_rewd_12mth',
                              'bf_net_sales_amt_12mth',
                              'card_status',
                              'time_last_disc_pur_onl',
                              'time_last_purchase_onl',
                              'on_gp_sales_ratio',
                              'ratio_onl_tot_sales',
                              'bf_gp_sales_ratio',
                              'online_net_sales_12mth',
                              'order_last_12_mth_onl')]

gp.act.data$brand_of_acquisition <- ifelse(gp.act.data$brand_of_acquisition == 'GP'|
                                          gp.act.data$brand_of_acquisition == 'GO', 1, 0)
gp.act.data$on_purchase_12mth_ind <- ifelse(gp.act.data$on_purchase_12mth_ind=='Y', 1, 0)

min.sample.size <- 5000; max.sample.size <- 20000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=1000)

cv.ind <- 0


for(i in 1:length(sample.sizes))
{ 
  for (s in 1:10)
  {
    gp.act.data.ones <- gp.act.data[gp.act.data[,2]==1,]
    index.ones.tra <- bigsample(1:nrow(gp.act.data.ones), size=0.5*sample.sizes[i], replace=F)
    tra.gp.ones <- gp.act.data.ones[ index.ones.tra,]
    tst.gp.ones <- gp.act.data.ones[-index.ones.tra,]
    
    
    
    
    rm(gp.act.data.ones); gc();
    
    
    gp.act.data.zeroes <- gp.act.data[gp.act.data[,2]!=1,]
    index.zeroes.tra <- bigsample(1:nrow(gp.act.data.zeroes), size=0.5*sample.sizes[i], replace=F)
    tra.gp.zeroes <- gp.act.data.zeroes[ index.zeroes.tra,]
    tst.gp.zeroes <- gp.act.data.zeroes[-index.zeroes.tra,]
    
    rm(gp.act.data.zeroes); gc();
    
    
    tra.gp <- rbind(tra.gp.ones, tra.gp.zeroes)
    rm(tra.gp.ones, tra.gp.zeroes); gc();
    
    tra.gp <- tra.gp[c(-1)]
    
    print(prop <- sum(tra.gp[,1])/nrow(tra.gp))
    
    
    xmatrix <- as.matrix(tra.gp[,2:ncol(tra.gp)])
    yvec = as.matrix(tra.gp[,1])
    
    
    param <- list("objective" =  "binary:logistic",
                  "eval_metric" = "auc",
                  "num_class" = 2)
    
    if (cv.ind==1)
    {
      cv.nround <- 20
      cv.nfold <- 10
      cv.nthread <-  2
      
      bst.cv = xgb.cv(param=param, data = xmatrix, label = yvec, 
                      nfold = cv.nfold, nrounds = cv.nround, verbose=F)
    }
    
    
    
    xgboost.model <- xgboost(data=xmatrix, label = yvec, objective = "binary:logistic",
                             verbose=F, nrounds=10)
    
    prob_tra <- predict(xgboost.model, xmatrix)
    pred_tra <- ifelse(prob_tra > 0.5, 1, 0)
    tpr <- prop.table(table(yvec, pred_tra),1)[2, 2]
    tnr <- prop.table(table(yvec, pred_tra),1)[1, 1]
    acc <- sum(diag(prop.table(table(yvec, pred_tra))))
    
    roc.area <- 
      auc(roc(prob_tra, factor(yvec)))
    
    concordance <- OptimisedConc(yvec,prob_tra)[1]
    
    print(paste('Sample Size', 'Run', 'Prior', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance'))
    print(paste(sample.sizes[i], s, prop, tpr, tnr, acc, roc.area, concordance))
    
    print('------------------------------------------')
    print('---------- Running Validations -----------')
    print('------------------------------------------')
    
    index.tst.gp <- sample(1:nrow(rbind(tst.gp.ones, tst.gp.zeroes)),
                             size=10000*10, replace=F)
    
    print(paste('Sample Size', 'Run', 'TestRun', 'Prior', 'AUC', 'Concordance'))
    
    for (l in 1:10)
    {
    
      tst.gp <- rbind(tst.gp.ones, tst.gp.zeroes)[index.tst.gp[((l-1)*10000 + 1):(l*10000)],]
      tst.gp <- tst.gp[c(-1)]
      
      xmatrix <- as.matrix(tst.gp[,2:ncol(tst.gp)])
      yvec = as.matrix(tst.gp[,1])
      
      prop.tst <- sum(tst.gp[,1])/nrow(tst.gp)
      
      gc()
      prob_tst <- predict(xgboost.model, xmatrix)
      
      roc.area.tst <- auc(roc(prob_tst, factor(yvec)))
      
      concordance.tst <- OptimisedConc(yvec,prob_tst)[1]
      
      print(paste(sample.sizes[i], s, l, prop.tst, roc.area.tst, concordance.tst))
    
    }
  }
}