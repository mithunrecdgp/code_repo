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

gp.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/GP_disc_sens_Data_pull.txt",header = F,
                        VERBOSE = TRUE, sep='|')


colnames(gp.data) <- c('customer_key',	
                       'offline_last_txn_date',	
                       'offline_disc_last_txn_date',	
                       'total_plcc_cards',	
                       'avg_order_amt_last_6_mth',	
                       'num_order_num_last_6_mth',	
                       'avg_order_amt_last_12_mth',	
                       'ratio_order_6_12_mth',	
                       'num_order_num_last_12_mth',	
                       'ratio_order_units_6_12_mth',	
                       'gp_net_sales_amt_12_mth',	
                       'gp_br_sales_ratio',	
                       'num_disc_comm_responded',	
                       'percent_disc_last_6_mth',	
                       'percent_disc_last_12_mth',	
                       'gp_go_net_sales_ratio',	
                       'gp_bf_net_sales_ratio',	
                       'gp_on_net_sales_ratio',	
                       'card_status',	
                       'disc_ats',	
                       'non_disc_ats',	
                       'ratio_disc_non_disc_ats',
                       'num_dist_catg_purchased',	
                       'num_units_6mth',	
                       'num_txn_6mth',	
                       'num_units_12mth',	
                       'num_txn_12mth',
                       'ratio_rev_rewd_12mth',	
                       'ratio_rev_wo_rewd_12mth',	
                       'num_em_campaign',	
                       'per_elec_comm',	
                       'on_sales_item_rev_12mth',	
                       'on_sales_rev_ratio_12mth',	
                       'on_sale_item_qty_12mth',	
                       'masterkey',
                       'mobile_ind_tot',	
                       'searchdex_ind_tot',	
                       'gp_hit_ind_tot',	
                       'br_hit_ind_tot',	
                       'on_hit_ind_tot',	
                       'at_hit_ind_tot',	
                       'factory_hit_ind_tot',	
                       'sale_hit_ind_tot',	
                       'markdown_hit_ind_tot',	
                       'clearance_hit_ind_tot',
                       'pct_off_hit_ind_tot',	
                       'browse_hit_ind_tot',	
                       'home_hit_ind_tot',	
                       'bag_add_ind_tot',	
                       'purchased',
                       'Resp_Disc_Percent')


gp.data <- gp.data[c('customer_key',
                     'masterkey',
                     'Resp_Disc_Percent',
                     'offline_last_txn_date',	
                     'offline_disc_last_txn_date',	
                     'total_plcc_cards',	
                     'avg_order_amt_last_6_mth',	
                     'num_order_num_last_6_mth',	
                     'avg_order_amt_last_12_mth',	
                     'ratio_order_6_12_mth',	
                     'num_order_num_last_12_mth',	
                     'ratio_order_units_6_12_mth',	
                     'gp_net_sales_amt_12_mth',	
                     'gp_br_sales_ratio',	
                     'num_disc_comm_responded',	
                     'percent_disc_last_6_mth',	
                     'percent_disc_last_12_mth',	
                     'gp_go_net_sales_ratio',	
                     'gp_bf_net_sales_ratio',	
                     'gp_on_net_sales_ratio',	
                     'card_status',	
                     'disc_ats',	
                     'non_disc_ats',	
                     'ratio_disc_non_disc_ats',
                     'num_dist_catg_purchased',	
                     'num_units_6mth',	
                     'num_txn_6mth',	
                     'num_units_12mth',	
                     'num_txn_12mth',
                     'ratio_rev_rewd_12mth',	
                     'ratio_rev_wo_rewd_12mth',	
                     'num_em_campaign',	
                     'per_elec_comm',	
                     'on_sales_item_rev_12mth',	
                     'on_sales_rev_ratio_12mth',	
                     'on_sale_item_qty_12mth',
                     'mobile_ind_tot',	
                     'searchdex_ind_tot',	
                     'gp_hit_ind_tot',	
                     'br_hit_ind_tot',	
                     'on_hit_ind_tot',	
                     'at_hit_ind_tot',	
                     'factory_hit_ind_tot',	
                     'sale_hit_ind_tot',	
                     'markdown_hit_ind_tot',	
                     'clearance_hit_ind_tot',
                     'pct_off_hit_ind_tot',	
                     'browse_hit_ind_tot',	
                     'home_hit_ind_tot',	
                     'bag_add_ind_tot',	
                     'purchased')]

#Online Inactive Train Data Analysis
inactive_data<- gp.data[is.na(gp.data$browse_hit_ind_tot),]
onl_inact_trn_data_index <- bigsample(x = nrow(inactive_data),size = 0.5*nrow(inactive_data),replace = F)
data_train <- inactive_data[onl_inact_trn_data_index,]

data_train$offline_last_txn_date[data_train$offline_last_txn_date==""]<-'2014-10-31'
data_train$offline_disc_last_txn_date[data_train$offline_disc_last_txn_date==""]<-'2014-10-31'

data_train$Time_Since_last_purchase <- as.numeric(as.Date("2015-11-01")-as.Date(data_train$offline_last_txn_date),units = "days")
data_train$Time_Since_last_disc_purchase <- as.numeric(as.Date('2015-11-01')-as.Date(data_train$offline_disc_last_txn_date),units = "days")

require(dplyr)

attach(data_train)

#Clean up the response variable

test <- data_train$Resp_Disc_Percent[ which(Resp_Disc_Percent!=-Inf & Resp_Disc_Percent!=Inf & 
                                            !is.nan(Resp_Disc_Percent) & !is.na(Resp_Disc_Percent))]

ul <- quantile(test, 0.995)
ll <- quantile(test, 0.005)

data_train$Resp_Disc_Percent <- ifelse(data_train$Resp_Disc_Percent<=ll, ll, data_train$Resp_Disc_Percent)
data_train$Resp_Disc_Percent <- ifelse(data_train$Resp_Disc_Percent>=ul, ul, data_train$Resp_Disc_Percent)

data_train$Resp_Disc_Percent <- ifelse(is.na (data_train$Resp_Disc_Percent), 0, data_train$Resp_Disc_Percent)
data_train$Resp_Disc_Percent <- ifelse(is.nan(data_train$Resp_Disc_Percent), 0, data_train$Resp_Disc_Percent)


summary(data_train$Resp_Disc_Percent)


#Clean up the predictors

data_train$Response <- ifelse(data_train$Resp_Disc_Percent < -0.35 , 1, 0)
data_train$Response[is.na(data_train$Response)] <- 0


min.sample.size <- 5000; max.sample.size <- 20000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=1000)

distribution.list <- c("bernoulli","adaboost")

shrinkage.list <- c(0.001, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1)

balance <- 1

headers1<-cbind("samplesize", "run", "shrinkage", "LossFunc", "Predictors", "OptNumTrees", "TPR", "TNR", "Accuracy", "AUC","Concordance")
write.table(headers1, paste0('at_catalog_training_gbm_', min.sample.size,'_', max.sample.size, '_v1.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

headers2<-cbind("samplesize","run", "shrinkage" ,"LossFunc","SampleNumber", "Predictors", "OptNumTrees", "TestRun", "AUC","Concordance")
write.table(headers2, paste0('at_catalog_testing_gbm_', min.sample.size,'_', max.sample.size, '_v1.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)


for(i in 1:length(sample.sizes))
{ 
  for (s in 1:5)
  {
    
    if (balance==1)
    {
      gp.data.ones <- gp.data[gp.data[,2]==1,]
      index.ones.tra <- bigsample(1:nrow(gp.data.ones), size=0.5*sample.sizes[i], replace=F)
      tra.at.ones <- gp.data.ones[ index.ones.tra,]
      tst.at.ones <- gp.data.ones[-index.ones.tra,]
      
      rm(gp.data.ones); gc();
      
      
      gp.data.zeroes <- gp.data[gp.data[,2]!=1,]
      index.zeroes.tra <- bigsample(1:nrow(gp.data.zeroes), size=0.5*sample.sizes[i], replace=F)
      tra.at.zeroes <- gp.data.zeroes[ index.zeroes.tra,]
      tst.at.zeroes <- gp.data.zeroes[-index.zeroes.tra,]
      
      rm(gp.data.zeroes); gc();
      
      tra.at <- rbind(tra.at.ones, tra.at.zeroes)
      rm(tra.at.ones, tra.at.zeroes); gc();
      
    }
    
    if (balance==0)
    {
      index.tra <- bigsample(1:nrow(gp.data), size=sample.sizes[i], replace=F)
      tra.at <- gp.data[ index.tra,]
      tst.at.all <- gp.data[-index.tra,]
      
    }
    
    tra.at <- tra.at[,c(-1)]
    
    prop <- sum(tra.at[,1])/nrow(tra.at)
    
    tra.at <- data.frame(tra.at)
    
    for(j in 1:length(shrinkage.list))
    {
      
      for (ls in 1:length(distribution.list))
      {
        
        gbm.object <- paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/GBM/v1/', sample.sizes[i],'_', s, '_', 
                             distribution.list[ls], '_', shrinkage.list[j], '.RData')
        
        n <- names(tra.at)
        f <- as.formula(paste("bought ~", paste(n[!n %in% "bought"], collapse = " + ")))
        
        gbm.model <- gbm(f, data=tra.at, distribution=distribution.list[ls],  bag.fraction = 0.3, verbose=F,
                         n.trees=round(20/shrinkage.list[j]), cv.folds=10, shrinkage = shrinkage.list[j], interaction.depth = 2,
                         n.minobsinnode = 10)
        
        opt.num.trees <- gbm.perf(gbm.model)
        predictors <- sum(relative.influence(gbm.model, opt.num.trees)>0)
        
        prob_tra <- predict.gbm(object=gbm.model, data=data.frame(tra.at), type='response', n.trees=opt.num.trees)
        
        confusion <- table(tra.at[,1] == 1, prob_tra > 0.5)
        
        tpr <- confusion[1,1] / sum(confusion[1,])
        tnr <- confusion[2,2] / sum(confusion[2,])
        acc <- (confusion[1,1] + confusion[2,2])/nrow(tra.at)
        
        print('------------------------------------------')
        print(gbm.model)
        print('------------------------------------------')
        
        prob_tra<- predict(gbm.model, tra.at[,c(-1)],type="response", n.trees=opt.num.trees)
        save(gbm.model, file=gbm.object)
        
        roc.area <- auc(roc(prob_tra, factor(tra.at$bought)))
        
        concordance <- OptimisedConc(tra.at$bought, prob_tra)[1]
        
        print(paste('SampleSize', 'Distribution', 'shrinkage', 'Run', 'Prior', 'Predictors', 'OptNumTrees', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance'))
        print(paste(sample.sizes[i],distribution.list[ls], shrinkage.list[j], s, prop, predictors, opt.num.trees, tpr, tnr, acc, roc.area, concordance))
        
        
        write.table(cbind(sample.sizes[i], s, shrinkage.list[j], distribution.list[ls], predictors, opt.num.trees, tpr, 
                          tnr, acc, roc.area, concordance),
                    paste0('at_catalog_training_gbm_', min.sample.size,'_', max.sample.size, '_v1.csv'), 
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
        
        print(paste('SampleSize', 'Distribution', 'shrinkage', 'Run', 'TestRun', 'Prior', 'Predictors', 'OptNumTrees', 'AUC', 'Concordance'))
        
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
          prob_tst <- predict(gbm.model, tst.at[,c(-1)],type="response", n.trees=opt.num.trees)

          roc.area.tst <- auc(roc(prob_tst, factor(tst.at$bought)))
          
          concordance.tst <- OptimisedConc(tst.at$bought,prob_tst)[1]
          
          print(paste(sample.sizes[i],distribution.list[ls], shrinkage.list[j], s, l, prop.tst, 
                      predictors, opt.num.trees, roc.area.tst, concordance.tst))
          
          write.table(cbind(sample.sizes[i], s, shrinkage.list[j], distribution.list[ls], predictors, opt.num.trees, l,
                            roc.area.tst, concordance.tst),
                      paste0('at_catalog_testing_gbm_', min.sample.size,'_', max.sample.size, '_v1.csv'), 
                      append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
          
          
          
        }
        
      }
      
    }
    
    rm(tst.at.ones, tst.at.zeroes)
    gc()
    
  }
  
}