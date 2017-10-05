library(ff)
library(ada)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)
library(verification)
library(ROCR)
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



#---------------------Function for Area Under ROC Curve -----------------------------------------

roc.area = function(observed, predicted)
{
  roc.grid = matrix(0, 1/0.01 + 1, 7)
  for (p in 1:nrow(roc.grid))
  {
    cutoff <- 0.02 * (nrow(roc.grid) - p)
    
    roc.grid[p,1] = cutoff
    roc.grid[p,2] = sum(prob_tst>cutoff & yvec==1)   # true positives
    roc.grid[p,3] = sum(prob_tst<=cutoff & yvec==0)  # true negatives
    roc.grid[p,4] = sum(prob_tst>cutoff & yvec==0)   # false positives
    roc.grid[p,5] = sum(prob_tst<=cutoff & yvec==1)  # false negatives
    roc.grid[p,6] = roc.grid[p,2]/(roc.grid[p,2] + roc.grid[p,5])
    roc.grid[p,7] = roc.grid[p,4]/(roc.grid[p,3] + roc.grid[p,4])
  }
  
  roc.area <- trapz(x=roc.grid[,7], y=roc.grid[,6])
  
  return(roc.area)
  
}

#--------------------------------------------------------------------------------------------------



at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/fallvalid_15var_latest.csv",
                        header = T, VERBOSE = TRUE, sep=',')

modelfilepath <- '//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/ADA/v4/'

modellist <- list.files(path=modelfilepath, full.names=T)  

aucmatrix = matrix(0, length(modellist), 2)


j <- 1

for (j in 1:length(modellist))
{
  
  load(modellist[j])
  
  yvec = as.matrix(at.data[,2])
  
  prop.tst <- sum(at.data[,2])/nrow(at.data)
  
  gc()
  prob_tst <- predict(ada.model, at.data[,3:(ncol(at.data)-1)], type="probs")[,2]
  
  adj.prob_tst = 1/(1+(1/0.08145858-1)*(1/prob_tst-1))
  
  yvec <- at.data[,2]
  
  roc.auc <- roc.area(yvec, adj.prob_tst)
  
  print(paste(j, prop.tst, roc.auc))
  
  aucmatrix[j,1] = modellist[j]
  aucmatrix[j,2] = roc.auc
  
}

colnames(aucmatrix) <- c('modellist', 'AUC')

write_csv(data.frame(aucmatrix), "//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_fall_validation_ada.csv", col_names=T)

min.sample.size <- 5000; max.sample.size <- 20000;

at.train.summary <-read.csv(paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_ada_', 
                                   min.sample.size,'_', max.sample.size, '_v3.csv'), 
                            header = T, sep=',')

at.test.summary  <-read.csv(paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_ada_', 
                                   min.sample.size,'_', max.sample.size, '_v3.csv'), 
                            header = T, sep=',')


testAUC <- aggregate(at.test.summary$AUC, 
                     by=list(at.test.summary$samplesize, at.test.summary$run, 
                             at.test.summary$nu, at.test.summary$Loss.Func), mean)

testConcordance <- aggregate(at.test.summary$Concordance, 
                             by=list(at.test.summary$samplesize, at.test.summary$run, 
                                     at.test.summary$nu, at.test.summary$Loss.Func), mean)

colnames(testAUC) <- c("samplesize","run","nu","Loss.Func","testAUC")
colnames(testConcordance) <- c("samplesize","run","nu","Loss.Func","testConcordance")

testAUC <- testAUC[order(testAUC$samplesize, testAUC$run, 
                         testAUC$nu, testAUC$Loss.Func), ] 
testConcordance <- testConcordance[order(testConcordance$samplesize, testConcordance$run, 
                                         testConcordance$nu, testConcordance$Loss.Func), ] 

at.test.summary <- cbind(testAUC, testConcordance$testConcordance)
colnames(at.test.summary) <- c("samplesize","run","nu","Loss.Func","testAUC","testConcordance")

at.test.summary <- at.test.summary[order(at.test.summary$samplesize, at.test.summary$run, 
                                         at.test.summary$nu, at.test.summary$Loss.Func), ] 

at.train.summary <- at.train.summary[order(at.train.summary$samplesize, at.train.summary$run, 
                                           at.train.summary$nu, at.train.summary$Loss.Func), ] 

at.summary <- cbind(at.train.summary, at.test.summary$testAUC, at.test.summary$testConcordance)


colnames(at.summary) <- c("samplesize","run","nu","Loss.Func","TPR","TNR","Accuracy","AUC","Concordance", 
                          "testAUC","testConcordance")

at.summary$diffAUC <- at.summary$AUC - at.summary$testAUC

at.summary$diffConcordance <- at.summary$Concordance - at.summary$testConcordance
  
at.summary$diffscore <- at.summary$diffAUC + at.summary$diffConcordance

at.summary <- at.summary[order(-at.summary$testAUC,
                               -at.summary$testConcordance,
                                at.summary$diffscore), ] 

modelfilepath <- '//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/ADA/v3/'
setwd(modelfilepath)

modelfilelist <- list.files(path=modelfilepath, full.names=T)  

modellist = matrix(rep("", 20), 20, 1)

for (i in 1:20)
{
  modellist[i] = paste0(modelfilepath, at.summary[i,1], "_", at.summary[i,2], "_", at.summary[i,4], "_", at.summary[i,3], ".RData")
}


modelindex <- as.numeric(modelfilelist %in% modellist)

k = 0
for (j in 1:length(modelfilelist))
{
  if (modelindex[j]==0)
  {
    k <- k + 1
    print(paste(k, modelfilelist[j]))
    file.remove(modelfilelist[j])
  }
}



at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_catalog_fall_valid.csv",
                        header = T, VERBOSE = TRUE, sep=',',colClasses = c(rep("numeric",21)))

modelfilepath <- '//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/ADA/v3/'

modellist <- list.files(path=modelfilepath, full.names=T)  

j <- 1

for (j in 1:length(modellist))
{
  load(modellist[j])
  prob_tst <- predict(ada.model, at.data[,c(-1,-2)], type="probs")
  roc.area.tst <- auc(roc(as.factor(at.data[,2]), prob_tst[,2]))
  print(paste(j, roc.area.tst))
}

