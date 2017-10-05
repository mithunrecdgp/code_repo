install.packages("kernlab")
install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")

gc()

library(ff)
library(kernlab)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)

at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_retained_data.csv",header = TRUE,VERBOSE = TRUE,
                        sep=',',colClasses = c(rep("numeric",15)))

							
min.sample.size <- 5000; max.sample.size <- 10000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=500)

c.list <-c(seq(0.1,1, by=0.1),1.5,5,10)




headers1<-cbind("samplesize", "run", "sigma","cost","trainingerror","CVerror","SV/TotalObs","AUC","Concordance")
write.table(headers1, paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_training_retained_', min.sample.size,'_', max.sample.size, '.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

headers2<-cbind("samplesize","run", "sigma","cost","SampleNumber","AUC","Concordance")
write.table(headers2, paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_testing_retained_', min.sample.size,'_', max.sample.size, '.csv'), 
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
    
    tra.at <- tra.at[c(-1)]
    
    print(prop <- sum(tra.at[,1])/nrow(tra.at))
    
    srange<-sigest(attr_flag ~.,
                   data=tra.at)
    
    
    sigma<-srange[2]
    
    
    for(j in 1:length(c.list))
    {
      
      
      
      ksvm.object <- paste0('ksvm_',sample.sizes[i],'_',c.list[j], '_',round(sigma,2))
      
      ksvm.model <- ksvm(
                          as.factor(attr_flag) ~., data=tra.at, type='C-svc',
                          kernel='rbfdot', kpar=list(sigma = sigma), C=c.list[j],
                          cross=10,prob.model=TRUE
                        )
      print('------------------------------------------')
      print(ksvm.model)
      print('------------------------------------------')
      
      prob_tra<- predict(ksvm.model,tra.at[c(-1)],type="probabilities")
      
      
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
      
      
      
      roc.grid = matrix(0, 1/0.02 + 1, 7)
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
      
      
      print(roc.area <- trapz(x=roc.grid[,7], y=roc.grid[,6]))
      
      
      write.table(cbind(sample.sizes[i], s, sigma,c.list[j],attr(ksvm.model,"error"),attr(ksvm.model,"cross"),nSV(ksvm.model)/sample.sizes[i],roc.area,concordance),
                  paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_training_retained_', min.sample.size,'_', max.sample.size, '.csv'), 
                  append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
      
      
      print('------------------------------------------')
      print('---------- Running Validations -----------')
      print('------------------------------------------')
      
      index.tst.at <- sample(1:nrow(rbind(tst.at.ones, tst.at.zeroes)), 
                             size=10000*10, replace=F)
      
      for (l in 1:10)
      {
        tst.at <- rbind(tst.at.ones, tst.at.zeroes)[index.tst.at[((l-1)*10000 + 1):(l*10000)],]
        tst.at<-tst.at[c(-1)]
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
        
        
        
        roc.grid = matrix(0, 1/0.02 + 1, 7)
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
        
        print(roc.area.tst <- trapz(x=roc.grid[,7], y=roc.grid[,6]))
        
        
        write.table(cbind(sample.sizes[i], s, sigma,c.list[j],l,roc.area.tst,concordance.tst),
                    paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_testing_retained_', min.sample.size,'_', max.sample.size, '.csv'), 
                    append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)      
      }
      
    }
    
    rm(tst.at.ones, tst.at.zeroes)
    gc()
    
  }
  
}




model <- read.csv(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_model_ensemble_retained.csv",head=TRUE,sep=",")

headers1 <- cbind("samplesize", "run", "sigma","cost","trainingerror","CVerror","SV_TotalObs",
                  "AUC","Concordance", "Test_AUC", "Test_Concordance")
write.table(headers1, paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_model_results_ensemble_retained.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

for (i in 1:nrow(model))
{
  
  test.auc <- 0
  test.concordance <- 0
  
  sample.size <-  model[i, 1]
  cost <- model[i, 2]
  sigma <- model[i, 3]
  
  for (s in 1:10)
  {
    
    at.data.ones <- at.data[at.data[,2]==1,]
    index.ones.tra <- bigsample(1:nrow(at.data.ones), size=0.5*sample.size, replace=F)
    tra.at.ones <- at.data.ones[ index.ones.tra,]
    tst.at.ones <- at.data.ones[-index.ones.tra,]
    
    
    
    
    rm(at.data.ones); gc();
    
    
    at.data.zeroes <- at.data[at.data[,2]!=1,]
    index.zeroes.tra <- bigsample(1:nrow(at.data.zeroes), size=0.5*sample.size, replace=F)
    tra.at.zeroes <- at.data.zeroes[ index.zeroes.tra,]
    tst.at.zeroes <- at.data.zeroes[-index.zeroes.tra,]
    
    rm(at.data.zeroes); gc();
    
    tra.at <- rbind(tra.at.ones, tra.at.zeroes)
    rm(tra.at.ones, tra.at.zeroes); gc();
    
    tra.at <- tra.at[c(-1)]
    
    print(prop <- sum(tra.at[,1])/nrow(tra.at))
    
    
    
    ksvm.object <- paste0('ksvm_',i,'_',sample.size,'_',cost, '_',round(sigma,12))
    
    ksvm.model <- ksvm(
                       as.factor(attr_flag) ~., data=tra.at, type='C-svc',
                       kernel='rbfdot', kpar=list(sigma = sigma), C=cost,
                       cross=10,prob.model=TRUE
                      )
    print('------------------------------------------')
    print(ksvm.model)
    print('------------------------------------------')
    
    prob_tra<- predict(ksvm.model,tra.at[c(-1)],type="probabilities")
    
    
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
    
    
    
    roc.grid = matrix(0, 1/0.02 + 1, 7)
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
    
    
    print(roc.area <- trapz(x=roc.grid[,7], y=roc.grid[,6]))
    
    print('------------------------------------------')
    print('---------- Running Validations -----------')
    print('------------------------------------------')
    
    roc.area.tst <- 0
    concordance.tst <- 0
    discordance.tst <- 0
    percentties.tst <- 0
    
    tst.sample.size <- 10000
    
    for (l in 1:20)
    {
      index.tst.at <- sample(1:nrow(rbind(tst.at.ones, tst.at.zeroes)), 
                             size=tst.sample.size, replace=F)
      
      tst.at <- rbind(tst.at.ones, tst.at.zeroes)[index.tst.at, ]
      tst.at<-tst.at[c(-1)]
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
      
      concordance.tst <- (concordance.tst + concordant/totalpairs)
      discordance.tst <- (discordance.tst + discordant/totalpairs)
      percentties.tst <- (percentties.tst + 1-concordance-discordance)
      
      
      
      roc.grid = matrix(0, 1/0.02 + 1, 7)
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
      
      print(trapz(x=roc.grid[,7], y=roc.grid[,6]))
      roc.area.tst <- roc.area.tst + trapz(x=roc.grid[,7], y=roc.grid[,6])
      
    }
    
    roc.area.tst <- roc.area.tst/20
    concordance.tst <- concordance.tst/20
    
    write.table(cbind(sample.size, s, sigma, cost, attr(ksvm.model,"error"), 
                      attr(ksvm.model,"cross"), nSV(ksvm.model)/sample.size, 
                      roc.area, concordance, roc.area.tst, concordance.tst),
                paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_model_results_ensemble_retained.csv'),
                append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
    
    if (roc.area.tst >= test.auc & concordance.tst >= test.concordance)
    {
      print('-------------------- Saving Model -------------------------')
      print(ksvm.object)
      save(ksvm.model, file = paste0("//10.8.8.51/lv0/Tanumoy/Datasets/SVM_Models/AT/Retained/","model",i,".RData"))
      test.auc <- roc.area.tst
      test.concordance <- concordance.tst
    }
    
    rm(tst.at.ones, tst.at.zeroes)
    gc()
    
  }
  
}
