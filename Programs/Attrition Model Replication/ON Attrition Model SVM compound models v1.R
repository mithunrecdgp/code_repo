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
require(partykit)

on.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Saumya/Datasets/final_ratio_flag_rec.csv",header = TRUE,VERBOSE = TRUE,
                        sep=',',colClasses = c(rep("numeric",15)))
on.data[,2]<-1-on.data[,2]


#train and save models with different sample size, cost & gamma

model <- read.csv(file="//10.8.8.51/lv0/Saumya/Datasets/model.csv",head=TRUE,sep=",")
s<-1
#for(s in 1:nrow(model))
{
  samplesize<-model[s,1]
  c<-model[s,2]
  sigma<-model[s,3]
  print('------------------------------------------------------')
  print(model[s,])
  on.data.ones <- on.data[on.data[,2]==1,]
  index.ones.tra <- bigsample(1:nrow(on.data.ones), size=0.5*samplesize, replace=F)
  tra.on.ones <- on.data.ones[ index.ones.tra,]
  
  rm(on.data.ones); gc();
  
  
  on.data.zeroes <- on.data[on.data[,2]!=1,]
  index.zeroes.tra <- bigsample(1:nrow(on.data.zeroes), size=0.5*samplesize, replace=F)
  tra.on.zeroes <- on.data.zeroes[ index.zeroes.tra,]
  
  rm(on.data.zeroes); gc();
  
  
  check.data <- rbind(tra.on.ones, tra.on.zeroes)
  rm(tra.on.ones, tra.on.zeroes); gc();
  check.data <- check.data[c(-1)]
  
  ksvm.model <- ksvm(as.factor(flag_2013) ~.,check.data, type='C-svc',
                     kernel='rbfdot', kpar=list(sigma = sigma), C=c,
                     cross=10,prob.model=TRUE)
  save(ksvm.model, file = paste0("Z:/Saumya/Datasets/SVM_Models/","test",s,".RData"))
  

  
#create a sample - say A - of 10k observations
#score the sample A using different variants(say 10 or 20) of stored SVM models - store the scores for referral later

index.tst.on <-  bigsample(1:nrow(on.data), size=20000, replace=F)
tst.on <- on.data[ index.tst.on,]
num.features <- ncol(tst.on) - 2

  l <- 1
  #for (l in 1:10)
  {
    
    #tst.on<-tst.on[c(-1)]
    gc()
    prob_tst<- predict(ksvm.model,tst.on[],type="probabilities")
  }

#}


#For each customer, flag/count/score the number of correct and incorrect predictions



tst.on<-cbind(tst.on[,1:15], prob_tst[,2])
tst.on<-rename(tst.on, c("prob_tst[, 2]"=paste0("p_",s)))

#label the observations as 0/1 to specify correct/incorrect predictions
acc <-ifelse((tst.on$flag_2013==1 & tst.on[,ncol(tst.on)]>0.5) |
             (tst.on$flag_2013==0 & tst.on[,ncol(tst.on)]<0.5), 
             1, 0)
tst.on <- cbind(tst.on, acc)
tst.on<-rename(tst.on, c("acc"=paste0("acc_",s)))


tst.on.tree <- cbind(tst.on[, 3:((num.features) + 2) ], acc)
tst.on.zeros<-subset(tst.on.tree, acc==0)
tst.on<-subset(tst.on.tree, acc==1)
sizes<-nrow(tst.on.zeros)
index.ones<-sample(1:nrow(tst.on),sizes,replace = FALSE, prob = NULL)
tst.on.ones<- tst.on[index.ones,]

tst.on.tree<-rbind(tst.on.zeros,tst.on.ones)

library(C50)

C50.model <- C5.0(as.factor(acc) ~ ., data = tst.on.tree, 
                  rules=T, earlyStopping = T, noGlobalPruning = F)

summary(C50.model)









