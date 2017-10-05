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

on.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Saumya/Datasets/on_recent_data.csv",
                        header = TRUE,VERBOSE = TRUE,
                        sep=',',colClasses = c(rep("numeric",16)))

on.data[,2]<-1-on.data[,2]

on.data <- subset(on.data, frequency >= 1)

min.sample.size <- 5000; max.sample.size <- 10000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=500)


headers1<-cbind("samplesize", "run", "sigma","cost","trainingerror","CVerror","SV/TotalObs","AUC","Concordance")
write.table(headers1, paste0('//10.8.8.51/lv0/Saumya/Datasets/on_training_recent_', min.sample.size,'_', max.sample.size, '.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

headers2<-cbind("samplesize","run", "sigma","cost","SampleNumber","AUC","Concordance")
write.table(headers2, paste0('//10.8.8.51/lv0/Saumya/Datasets/on_testing_recent_', min.sample.size,'_', max.sample.size, '.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)


interrupted.sample.size <- 10000;

interrupted.run <- 10; interrupted.c <- 10;


if (interrupted.sample.size > 0)
{
  sample.sizes <- seq(interrupted.sample.size, max.sample.size, by=500)  
}

c.list <-c(seq(0.1,1, by=0.1),1.5,5,10)


for(i in 1:length(sample.sizes))
{ 
  
  startindex <- 1;
  
  if (interrupted.sample.size > 0)
  {
    if (interrupted.run > 0)
    {
      startindex <- interrupted.run
    }
  }
  
  
  for (s in startindex:10)
  {
    
    startc <- 0.1
    
    if (interrupted.sample.size > 0)
    {
      if (interrupted.run > 0)
      {
        if (interrupted.c > 0)
        {
          startc <- interrupted.c
          interrupted.run <- 0
          interrupted.c <- 0
        }
      }
    }
    
    start.c.list <- c.list[c.list >= startc]
    
    on.data.ones <- on.data[on.data[,2]==1,]
    index.ones.tra <- bigsample(1:nrow(on.data.ones), size=0.5*sample.sizes[i], replace=F)
    tra.on.ones <- on.data.ones[ index.ones.tra,]
    tst.on.ones <- on.data.ones[-index.ones.tra,]
    
    
    
    
    rm(on.data.ones); gc();
    
    
    on.data.zeroes <- on.data[on.data[,2]!=1,]
    index.zeroes.tra <- bigsample(1:nrow(on.data.zeroes), size=0.5*sample.sizes[i], replace=F)
    tra.on.zeroes <- on.data.zeroes[ index.zeroes.tra,]
    tst.on.zeroes <- on.data.zeroes[-index.zeroes.tra,]
    
    rm(on.data.zeroes); gc();
    
    
    tra.on <- rbind(tra.on.ones, tra.on.zeroes)
    rm(tra.on.ones, tra.on.zeroes); gc();
    
    tra.on <- tra.on[c(-1)]
    
    print(prop <- sum(tra.on[,1])/nrow(tra.on))
    
    srange<-sigest(flag_2013 ~.,
                   data=tra.on)
    
    
    sigma<-srange[2]
    
    
    for(j in 1:length(start.c.list))
    {
      
      
      
      ksvm.object <- paste0('ksvm_',sample.sizes[i],'_',start.c.list[j], '_',round(sigma,2))
      
      ksvm.model <- ksvm(
        as.factor(flag_2013) ~., data=tra.on, type='C-svc',
        kernel='rbfdot', kpar=list(sigma = sigma), C=start.c.list[j],
        cross=10,prob.model=TRUE
      )
      print('------------------------------------------')
      print(ksvm.model)
      print('------------------------------------------')
      
      prob_tra<- predict(ksvm.model,tra.on[c(-1)],type="probabilities")
      
      
      x<-matrix(prob_tra[,2], nrow(tra.on), 1)
      y<-matrix(tra.on[,1], nrow(tra.on), 1)
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
        roc.grid[p,2] = sum(prob_tra[,2]>cutoff & tra.on[,1]==1)   # true positives
        roc.grid[p,3] = sum(prob_tra[,2]<=cutoff & tra.on[,1]==0)  # true negatives
        roc.grid[p,4] = sum(prob_tra[,2]>cutoff & tra.on[,1]==0)   # false positives
        roc.grid[p,5] = sum(prob_tra[,2]<=cutoff & tra.on[,1]==1)  # false negatives
        roc.grid[p,6] = roc.grid[p,2]/(roc.grid[p,2] + roc.grid[p,5])
        roc.grid[p,7] = roc.grid[p,4]/(roc.grid[p,3] + roc.grid[p,4])
      }
      
      
      print(roc.area <- trapz(x=roc.grid[,7], y=roc.grid[,6]))
      
      
      write.table(cbind(sample.sizes[i], s, sigma,start.c.list[j],attr(ksvm.model,"error"),attr(ksvm.model,"cross"),nSV(ksvm.model)/sample.sizes[i],roc.area,concordance),
                  paste0('//10.8.8.51/lv0/Saumya/Datasets/on_training_recent_', min.sample.size,'_', max.sample.size, '.csv'), 
                  append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
      
      
      print('------------------------------------------')
      print('---------- Running Validations -----------')
      print('------------------------------------------')
      
      index.tst.on <- sample(1:nrow(rbind(tst.on.ones, tst.on.zeroes)), 
                             size=10000*10, replace=F)
      
      for (l in 1:10)
      {
        tst.on <- rbind(tst.on.ones, tst.on.zeroes)[index.tst.on[((l-1)*10000 + 1):(l*10000)],]
        tst.on<-tst.on[c(-1)]
        gc()
        prob_tst<- predict(ksvm.model,tst.on[c(-1)],type="probabilities")
        
        x<-matrix(prob_tst[,2], nrow(tst.on), 1)
        y<-matrix(tst.on[,1], nrow(tst.on), 1)
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
          roc.grid[p,2] = sum(prob_tst[,2]>cutoff & tst.on[,1]==1)   # true positives
          roc.grid[p,3] = sum(prob_tst[,2]<=cutoff & tst.on[,1]==0)  # true negatives
          roc.grid[p,4] = sum(prob_tst[,2]>cutoff & tst.on[,1]==0)   # false positives
          roc.grid[p,5] = sum(prob_tst[,2]<=cutoff & tst.on[,1]==1)  # false negatives
          roc.grid[p,6] = roc.grid[p,2]/(roc.grid[p,2] + roc.grid[p,5])
          roc.grid[p,7] = roc.grid[p,4]/(roc.grid[p,3] + roc.grid[p,4])
        }
        
        print(roc.area.tst <- trapz(x=roc.grid[,7], y=roc.grid[,6]))
        
        
        write.table(cbind(sample.sizes[i], s, sigma,start.c.list[j],l,roc.area.tst,concordance.tst),
                    paste0('//10.8.8.51/lv0/Saumya/Datasets/on_testing_recent_', min.sample.size,'_', max.sample.size, '.csv'), 
                    append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)      
      }
      
    }
    
    rm(tst.on.ones, tst.on.zeroes)
    gc()
    
  }
  
}




model <- read.csv(file="//10.8.8.51/lv0/Saumya/Datasets/on_model_ensemble_recent.csv",head=TRUE,sep=",")

headers1 <- cbind("samplesize", "run", "sigma","cost","trainingerror","CVerror","SV_TotalObs",
                  "AUC","Concordance", "Test_AUC", "Test_Concordance")
write.table(headers1, paste0('//10.8.8.51/lv0/Saumya/Datasets/on_model_results_ensemble_recent.csv'), 
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
    
    on.data.ones <- on.data[on.data[,2]==1,]
    index.ones.tra <- bigsample(1:nrow(on.data.ones), size=0.5*sample.size, replace=F)
    tra.on.ones <- on.data.ones[ index.ones.tra,]
    tst.on.ones <- on.data.ones[-index.ones.tra,]
    
    
    
    
    rm(on.data.ones); gc();
    
    
    on.data.zeroes <- on.data[on.data[,2]!=1,]
    index.zeroes.tra <- bigsample(1:nrow(on.data.zeroes), size=0.5*sample.size, replace=F)
    tra.on.zeroes <- on.data.zeroes[ index.zeroes.tra,]
    tst.on.zeroes <- on.data.zeroes[-index.zeroes.tra,]
    
    rm(on.data.zeroes); gc();
    
    tra.on <- rbind(tra.on.ones, tra.on.zeroes)
    rm(tra.on.ones, tra.on.zeroes); gc();
    
    tra.on <- tra.on[c(-1)]
    
    print(prop <- sum(tra.on[,1])/nrow(tra.on))
    
    
    
    ksvm.object <- paste0('ksvm_',i,'_',sample.size,'_',cost, '_',round(sigma,12))
    
    ksvm.model <- ksvm(
      as.factor(flag_2013) ~., data=tra.on, type='C-svc',
      kernel='rbfdot', kpar=list(sigma = sigma), C=cost,
      cross=10,prob.model=TRUE
    )
    print('------------------------------------------')
    print(ksvm.model)
    print('------------------------------------------')
    
    prob_tra<- predict(ksvm.model,tra.on[c(-1)],type="probabilities")
    
    
    x<-matrix(prob_tra[,2], nrow(tra.on), 1)
    y<-matrix(tra.on[,1], nrow(tra.on), 1)
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
      roc.grid[p,2] = sum(prob_tra[,2]>cutoff & tra.on[,1]==1)   # true positives
      roc.grid[p,3] = sum(prob_tra[,2]<=cutoff & tra.on[,1]==0)  # true negatives
      roc.grid[p,4] = sum(prob_tra[,2]>cutoff & tra.on[,1]==0)   # false positives
      roc.grid[p,5] = sum(prob_tra[,2]<=cutoff & tra.on[,1]==1)  # false negatives
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
      index.tst.on <- sample(1:nrow(rbind(tst.on.ones, tst.on.zeroes)), 
                             size=tst.sample.size, replace=F)
      
      tst.on <- rbind(tst.on.ones, tst.on.zeroes)[index.tst.on, ]
      tst.on<-tst.on[c(-1)]
      gc()
      prob_tst<- predict(ksvm.model,tst.on[c(-1)],type="probabilities")
      
      x<-matrix(prob_tst[,2], nrow(tst.on), 1)
      y<-matrix(tst.on[,1], nrow(tst.on), 1)
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
        roc.grid[p,2] = sum(prob_tst[,2]>cutoff & tst.on[,1]==1)   # true positives
        roc.grid[p,3] = sum(prob_tst[,2]<=cutoff & tst.on[,1]==0)  # true negatives
        roc.grid[p,4] = sum(prob_tst[,2]>cutoff & tst.on[,1]==0)   # false positives
        roc.grid[p,5] = sum(prob_tst[,2]<=cutoff & tst.on[,1]==1)  # false negatives
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
                paste0('//10.8.8.51/lv0/Saumya/Datasets/on_model_results_ensemble_recent.csv'),
                append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
    
    if (roc.area.tst >= test.auc & concordance.tst >= test.concordance)
    {
      print('-------------------- Saving Model -------------------------')
      print(ksvm.object)
      save(ksvm.model, file = paste0("//10.8.8.51/lv0/Saumya/Datasets/SVM_Models/ON/Recent/","model",i,".RData"))
      test.auc <- roc.area.tst
      test.concordance <- concordance.tst
    }
    
    rm(tst.on.ones, tst.on.zeroes)
    gc()
    
  }
  
}
