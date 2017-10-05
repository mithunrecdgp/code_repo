install.packages("ada")
install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")
install.packages("verification")
install.packages("ROCR")
install.packages("AUC")


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


setwd('D:/Discount Sensitivity')

gp.act.data <-read.table.ffdf(file="GP_Onl_act_base.csv",header = TRUE,sep=',',VERBOSE = TRUE)

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

gp.act.data$brand_of_acquisition <- as.factor(gp.act.data$brand_of_acquisition)
gp.act.data$card_status <- as.factor(gp.act.data$card_status)
gp.act.data$on_purchase_12mth_ind <- as.factor(gp.act.data$on_purchase_12mth_ind)

min.sample.size <- 5000; max.sample.size <- 20000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=1000)

c.list <-c(seq(0.1,1, by=0.1))

loss.list <- c("exponential","logistic")

balance <- 1

headers1<-cbind("samplesize", "run", "nu", "Loss Func", "TPR", "TNR", "Accuracy", "AUC","Concordance")
write.table(headers1, paste0('gp_training_ada_active_', min.sample.size,'_', max.sample.size, '.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

headers2<-cbind("samplesize","run", "nu" ,"Loss Func","SampleNumber","TPR", "TNR", "Accuracy", "AUC","Concordance")
write.table(headers2, paste0('gp_testing_ada_active_', min.sample.size,'_', max.sample.size, '.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)




for(i in 1:length(sample.sizes))
{ 
  for (s in 1:5)
  {
    
    if (balance==1)
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
      
    }
    
    if (balance==0)
    {
      index.tra <- bigsample(1:nrow(gp.act.data), size=sample.sizes[i], replace=F)
      tra.gp <- gp.act.data[ index.tra,]
      tst.gp.all <- gp.act.data[-index.tra,]
      
    }
    
    tra.gp <- tra.gp[c(-1)]
    
    prop <- sum(tra.gp[,1])/nrow(tra.gp)
    
    
    for(j in 1:length(c.list))
    {
      
      for (ls in 1:length(loss.list))
      {
        
        ada.object <- paste0('RData/ada_onl_actv', sample.sizes[i],'_', s, '_', 
                             loss.list[ls], '_', c.list[j], '.RData')
        
        ada.model <- ada(as.factor(Disc_Sen_Tag) ~., data=tra.gp, type="discrete",
                         loss=loss.list[ls], bag.frac = 0.5, iter=120, verbose=F,
                         nu=c.list[j])
        
        tpr <- ada.model$confusion[1,1] / sum(ada.model$confusion[1,])
        tnr <- ada.model$confusion[2,2] / sum(ada.model$confusion[2,])
        acc <- (ada.model$confusion[1,1] + ada.model$confusion[2,2])/nrow(tra.gp)
        
        print('------------------------------------------')
        print(ada.model)
        print('------------------------------------------')
        
        prob_tra<- predict(ada.model,tra.gp[c(-1)],type="probs")
        save(ada.model, file=ada.object)
        
        roc.area <- 
          auc(roc(prob_tra[,2], factor(tra.gp$Disc_Sen_Tag)))
        
        concordance <- OptimisedConc(tra.gp$Disc_Sen_Tag,prob_tra[,2])[1]
        
        print(paste('Sample Size', 'Run', 'nu', 'loss Func','Prior', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance'))
        print(paste(sample.sizes[i],loss.list[ls], c.list[j], prop, tpr, tnr, acc, roc.area, concordance))
        
        
        write.table(cbind(sample.sizes[i], s, c.list[j],loss.list[ls], tpr, 
                          tnr, acc, roc.area, concordance),
                    paste0('gp_training_ada_active_', min.sample.size,'_', max.sample.size, '.csv'), 
                    append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
        
        
        
        
        print('------------------------------------------')
        print('---------- Running Validations -----------')
        print('------------------------------------------')
        
        if (balance==1)
        {
          index.tst.gp <- sample(1:nrow(rbind(tst.gp.ones, tst.gp.zeroes)),
                                 size=10000*10, replace=F)
        }
        
        if (balance==0)
        {
          index.tst.gp <- sample(1:nrow(tst.gp.all),
                                 size=10000*10, replace=F)        
        }
        
        print(paste('Sample Size', 'Run', 'nu', 'loss Func', 'TestRun', 'Prior', 'AUC', 'Concordance'))
        
        for (l in 1:10)
        {
          if (balance==1)
          {
            tst.gp <- rbind(tst.gp.ones, tst.gp.zeroes)[index.tst.gp[((l-1)*10000 + 1):(l*10000)],]
            tst.gp <- tst.gp[c(-1)]
          }
          
          if (balance==0)
          {
            tst.gp <- tst.gp.all[index.tst.gp[((l-1)*10000 + 1):(l*10000)],]
            tst.gp <- tst.gp[c(-1)]
          }
          
          prop.tst <- sum(tst.gp[,1])/nrow(tst.gp)
          
          gc()
          prob_tst <- predict(ada.model,tst.gp[c(-1)],type="probs")
          vect.tst <- predict(ada.model,tst.gp[c(-1)],type="vector")
          
          roc.area.tst <- auc(roc(prob_tst[,2], factor(tst.gp$Disc_Sen_Tag)))
          
          concordance.tst <- OptimisedConc(tst.gp$Disc_Sen_Tag,prob_tst[,2])[1]
          
          print(paste(sample.sizes[i],loss.list[ls], c.list[j], l, prop.tst, 
                      roc.area.tst, concordance.tst))
          
          write.table(cbind(sample.sizes[i], s, c.list[j],loss.list[ls], l,
                            roc.area.tst, concordance.tst),
                      paste0('gp_testing_ada_active_', min.sample.size,'_', max.sample.size, '.csv'), 
                      append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
          
          
          
        }
        
      }
      
    }
    
    rm(tst.gp.ones, tst.gp.zeroes)
    gc()
    
  }
  
}