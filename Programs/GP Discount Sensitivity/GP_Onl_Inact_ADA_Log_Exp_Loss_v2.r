install.packages("ada")
install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")
install.packages("verification")
install.packages("ROCR")
install.packages("AUC")
install.packages("party",dep=T)
install.packages("caret",dep=T)

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
library(party)
library(caret)

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

gp.inact.data <-read.table.ffdf(file="GP_Onl_Inact_base.csv",header = TRUE,sep=',',VERBOSE = TRUE)

gp.inact.data <- gp.inact.data[,c('customer_key',
                                  'Disc_Sen_Tag',
                                  'brand_of_acquisition',
                                  'bf_net_sales_amt_12mth',
                                  'bf_gp_sales_ratio' ,
                                  'total_rev_prom_12mth' ,
                                  'holidy_rev_ratio_12mth' ,
                                  'num_txn_6mth' ,
                                  'num_txn_12mth' ,
                                  'ratio_txn_6_12mth' ,
                                  'on_net_sales_amt_12mth' ,
                                  'num_dist_catg_purchase' ,
                                  'ratio_disc_n_disc_ats' ,
                                  'card_status' ,
                                  'order_last_12_mth_onl' ,
                                  'ord_ratio_6_12_mth_onl' ,
                                  'online_net_sales_12mth' ,
                                  'total_net_sales_12mth' ,
                                  'ratio_onl_tot_sales' ,
                                  'num_txn_6mth_onl' ,
                                  'num_units_12mth_onl' )]

gp.inact.data$brand_of_acquisition <- as.factor(gp.inact.data$brand_of_acquisition)
gp.inact.data$card_status <- as.factor(gp.inact.data$card_status)

min.sample.size <- 5000; max.sample.size <- 20000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=1000)

c.list <-c(seq(0.1,1, by=0.1))

loss.list <- c("exponential","logistic")
    
balance <- 1


headers1<-cbind("samplesize", "run", "nu", "LossFunc", "TPR", "TNR", "Accuracy", "AUC","Concordance")
write.table(headers1, paste0('gp_training_ada_inactive_', min.sample.size,'_', max.sample.size, '.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

headers2<-cbind("samplesize","run", "nu" ,"LossFunc","SampleNumber", "AUC","Concordance")
write.table(headers2, paste0('gp_testing_ada_inactive_', min.sample.size,'_', max.sample.size, '.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)





for(i in 1:length(sample.sizes))
{ 
  for (s in 1:5)
  {
    
    if (balance==1)
    {
      gp.inact.data.ones <- gp.inact.data[gp.inact.data[,2]==1,]
      index.ones.tra <- bigsample(1:nrow(gp.inact.data.ones), size=0.5*sample.sizes[i], replace=F)
      tra.gp.ones <- gp.inact.data.ones[ index.ones.tra,]
      tst.gp.ones <- gp.inact.data.ones[-index.ones.tra,]
      
      rm(gp.inact.data.ones); gc();
      
      
      gp.inact.data.zeroes <- gp.inact.data[gp.inact.data[,2]!=1,]
      index.zeroes.tra <- bigsample(1:nrow(gp.inact.data.zeroes), size=0.5*sample.sizes[i], replace=F)
      tra.gp.zeroes <- gp.inact.data.zeroes[ index.zeroes.tra,]
      tst.gp.zeroes <- gp.inact.data.zeroes[-index.zeroes.tra,]
      
      rm(gp.inact.data.zeroes); gc();
      
      tra.gp <- rbind(tra.gp.ones, tra.gp.zeroes)
      rm(tra.gp.ones, tra.gp.zeroes); gc();
      
    }
    
    if (balance==0)
    {
      index.tra <- bigsample(1:nrow(gp.inact.data), size=sample.sizes[i], replace=F)
      tra.gp <- gp.inact.data[ index.tra,]
      tst.gp.all <- gp.inact.data[-index.tra,]
      
    }
    
    tra.gp <- tra.gp[c(-1)]
    
    prop <- sum(tra.gp[,1])/nrow(tra.gp)
    
    
    for(j in 1:length(c.list))
    {
      
      for (ls in 1:length(loss.list))
      {
        
        ada.object <- paste0('RData/ada_onl_inactv', sample.sizes[i],'_', s, '_', 
                             loss.list[ls], '_', c.list[j], '.RData')
        
        ada.model <- ada(as.factor(Disc_Sen_Tag) ~., data=tra.gp, type="discrete",
                         loss=loss.list[ls], bag.frac = 0.5, iter=100, verbose=F,
                         nu=c.list[j])
        
        tnr <- ada.model$confusion[1,1] / sum(ada.model$confusion[1,])
        tpr <- ada.model$confusion[2,2] / sum(ada.model$confusion[2,])
        acc <- (ada.model$confusion[1,1] + ada.model$confusion[2,2])/nrow(tra.gp)
        
        print('------------------------------------------')
        print(ada.model)
        print('------------------------------------------')
        
        prob_tra<- predict(ada.model,tra.gp[c(-1)],type="probs")
        save(ada.model, file=ada.object)
        
        roc.area <- auc(roc(prob_tra[,2], factor(tra.gp$Disc_Sen_Tag)))
        
        concordance <- OptimisedConc(tra.gp$Disc_Sen_Tag,prob_tra[,2])[1]
        
        print(paste('Samplesize', 'lossfunc', 'Run', 'nu', 'Prior', 'TPR', 'TNR', 'Accuracy', 'AUC', 'Concordance'))
        print(paste(sample.sizes[i], loss.list[ls], s, c.list[j], prop, tpr, tnr, acc, roc.area, concordance))
        
        
        write.table(cbind(sample.sizes[i], s, c.list[j],loss.list[ls], tpr, 
                          tnr, acc, roc.area, concordance),
                    paste0('gp_training_ada_inactive_', min.sample.size,'_', max.sample.size, '.csv'), 
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
        
        print(paste('Samplesize', 'lossfunc', 'Run', 'nu', 'TestRun', 'Prior', 'AUC', 'Concordance'))
        
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
          
          print(paste(sample.sizes[i], loss.list[ls], s, c.list[j], l, prop.tst, 
                      roc.area.tst, concordance.tst))
          
          write.table(cbind(sample.sizes[i], s, c.list[j], loss.list[ls], l,
                            roc.area.tst, concordance.tst),
                      paste0('gp_testing_ada_inactive_', min.sample.size,'_', max.sample.size, '.csv'), 
                      append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
          
          
          
        }
        
      }
      
    }
    
    rm(tst.gp.ones, tst.gp.zeroes)
    gc()
    
    
  }
  
}