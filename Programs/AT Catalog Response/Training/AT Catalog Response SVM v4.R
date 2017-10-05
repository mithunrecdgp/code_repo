install.packages("kernlab")
install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")


rm(list=ls())
gc()

library(ff)
library(kernlab)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)


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

c.list <-c(seq(0.1,1, by=0.1),1.5, 3, 5, 7.5, 10)


headers1<-cbind("samplesize", "run", "sigma","cost","trainingerror","CVerror","SV/TotalObs","AUC","Concordance")
write.table(headers1, paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_svm_', min.sample.size,'_', max.sample.size, '_v4.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

headers2<-cbind("samplesize","run", "sigma","cost","SampleNumber","AUC","Concordance")
write.table(headers2, paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_svm_', min.sample.size,'_', max.sample.size, '_v4.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)


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
    
    srange<-sigest(bought ~.,
                   data=tra.at)
    
    
    sigma<-srange[2]
    
    # 0.1  0.2  0.3  0.4  0.5  0.6  0.7  0.8  0.9  1.0  1.5  3.0  5.0  7.5 10.0
    
    for(j in 1:length(c.list))
    {
        
      ksvm.object <- paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/SVM/v4/',
                            'ksvm_',sample.sizes[i],'_',s, '_', c.list[j], '_', round(sigma,4),'.RData')
      
      ksvm.model <- ksvm(
                          as.factor(bought) ~., data=tra.at, type='C-svc',
                          kernel='rbfdot', kpar=list(sigma = sigma), C=c.list[j],
                          cross=10,prob.model=TRUE
                        )
      print('------------------------------------------')
      print(ksvm.model)
      print('------------------------------------------')
      
      prob_tra<- predict(ksvm.model,tra.at[c(-1)],type="probabilities")
      save(ksvm.model, file=ksvm.object)
      
      x<-matrix(prob_tra[,2], nrow(tra.at), 1)
      y<-matrix(tra.at[,1], nrow(tra.at), 1)
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
      
      
      
      roc.grid = matrix(0, 1/0.01 + 1, 7)
      for (p in 1:nrow(roc.grid))
      {
        cutoff <- 0.02 * (nrow(roc.grid) - p)
        
        roc.grid[p,1] = cutoff
        roc.grid[p,2] = sum(prob_tra[,2]>cutoff & tra.at[,1]==1)   # true positives
        roc.grid[p,3] = sum(prob_tra[,2]<=cutoff & tra.at[,1]==0)  # true negatives
        roc.grid[p,4] = sum(prob_tra[,2]>cutoff & tra.at[,1]==0)   # false positives
        roc.grid[p,5] = sum(prob_tra[,2]<=cutoff & tra.at[,1]==1)  # false negatives
        roc.grid[p,6] = roc.grid[p,2]/(roc.grid[p,2] + roc.grid[p,5])
        roc.grid[p,7] = roc.grid[p,4]/(roc.grid[p,3] + roc.grid[p,4])
      }
      
      roc.area <- trapz(x=roc.grid[,7], y=roc.grid[,6])
      
      tnr <- prop.table(table(tra.at[,1], as.numeric(prob_tra[,2] > 0.5)),1)[1,1]
      tpr <- prop.table(table(tra.at[,1], as.numeric(prob_tra[,2] > 0.5)),1)[2,2]
      
      print(paste("samplesize", "run", "sigma","cost", "trainingerror",
                  "TPR", "TNR", "CVerror", "SV/TotalObs", "AUC", "Concordance"))
      
      print(paste(sample.sizes[i], s, sigma, c.list[j], attr(ksvm.model,"error"),
                  tpr, tnr, attr(ksvm.model,"cross"), nSV(ksvm.model)/sample.sizes[i], 
                  roc.area, concordance))
      
      
      write.table(cbind(sample.sizes[i], s, sigma,c.list[j],attr(ksvm.model,"error"),attr(ksvm.model,"cross"),nSV(ksvm.model)/sample.sizes[i],roc.area,concordance),
                  paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_svm_', min.sample.size,'_', max.sample.size, '_v4.csv'), 
                  append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
      
      
      print('------------------------------------------')
      print('---------- Running Validations -----------')
      print('------------------------------------------')
      
      print(paste("samplesize", "run", "sigma","cost", "Testrun", "AUC", "Concordance"))
      
      index.tst.at <- sample(1:nrow(rbind(tst.at.ones, tst.at.zeroes)), 
                             size=10000*10, replace=F)
      
      for (l in 1:10)
      {
        tst.at <- rbind(tst.at.ones, tst.at.zeroes)[index.tst.at[((l-1)*10000 + 1):(l*10000)],]
        tst.at<-tst.at[c(-1, -ncol(tst.at))]
        gc()
        prob_tst<- predict(ksvm.model,tst.at[c(-1)],type="probabilities")
        
        x<-matrix(prob_tst[,2], nrow(tst.at), 1)
        y<-matrix(tst.at[,1], nrow(tst.at), 1)
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
        
        concordance.tst<-concordant/totalpairs
        discordance.tst<-discordant/totalpairs
        percentties.tst<-1-concordance-discordance
        
        
        
        roc.grid = matrix(0, 1/0.01 + 1, 7)
        for (p in 1:nrow(roc.grid))
        {
          cutoff <- 0.02 * (nrow(roc.grid) - p)
          
          roc.grid[p,1] = cutoff
          roc.grid[p,2] = sum(prob_tst[,2]>cutoff & tst.at[,1]==1)   # true positives
          roc.grid[p,3] = sum(prob_tst[,2]<=cutoff & tst.at[,1]==0)  # true negatives
          roc.grid[p,4] = sum(prob_tst[,2]>cutoff & tst.at[,1]==0)   # false positives
          roc.grid[p,5] = sum(prob_tst[,2]<=cutoff & tst.at[,1]==1)  # false negatives
          roc.grid[p,6] = roc.grid[p,2]/(roc.grid[p,2] + roc.grid[p,5])
          roc.grid[p,7] = roc.grid[p,4]/(roc.grid[p,3] + roc.grid[p,4])
        }
        
        roc.area.tst <- trapz(x=roc.grid[,7], y=roc.grid[,6])
        
        print(paste(sample.sizes[i], s, sigma, c.list[j], l,
                    roc.area.tst, concordance.tst))
        
        write.table(cbind(sample.sizes[i], s, sigma,c.list[j],l,roc.area.tst,concordance.tst),
                    paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_svm_', min.sample.size,'_', max.sample.size, '_v4.csv'), 
                    append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)      
      }
      
    }
    
    rm(tst.at.ones, tst.at.zeroes)
    gc()
    
  }
  
}


