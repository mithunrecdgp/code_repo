library(ff)
library(kernlab)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)





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



min.sample.size <- 5000; max.sample.size <- 20000;

at.train.summary <-read.csv(paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_svm_', 
                                   min.sample.size,'_', max.sample.size, '_v4.csv'), 
                            header = T, sep=',')

at.test.summary  <-read.csv(paste0('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_svm_', 
                                   min.sample.size,'_', max.sample.size, '_v4.csv'), 
                            header = T, sep=',')


testAUC <- aggregate(at.test.summary$AUC, 
                     by=list(at.test.summary$samplesize, at.test.summary$run,
                             at.test.summary$cost, at.test.summary$sigma), mean)
colnames(testAUC) <- c("samplesize","run","cost","sigma","testAUC")

testAUC <- testAUC[order(testAUC$samplesize, testAUC$run,
                         testAUC$sigma, testAUC$cost), ] 

testConcordance <- aggregate(at.test.summary$Concordance, 
                             by=list(at.test.summary$samplesize, at.test.summary$run,
                                     at.test.summary$cost, at.test.summary$sigma), mean)

colnames(testConcordance) <- c("samplesize","run","cost","sigma","testConcordance")

testConcordance <- testConcordance[order(testConcordance$samplesize, testConcordance$run,
                                         testConcordance$sigma, testConcordance$cost), ] 

at.test.summary <- cbind(testAUC, testConcordance$testConcordance)
colnames(at.test.summary) <- c("samplesize","run","cost","sigma","testAUC","testConcordance")

at.test.summary <- at.test.summary[order(at.test.summary$samplesize, at.test.summary$run,
                                         at.test.summary$cost, at.test.summary$sigma), ] 

at.train.summary <- at.train.summary[order(at.train.summary$samplesize, at.train.summary$run,
                                           at.train.summary$cost, at.train.summary$sigma), ] 


at.summary <- cbind(at.train.summary, at.test.summary$testAUC, at.test.summary$testConcordance)


colnames(at.summary) <- c("samplesize","run", "sigma", "cost", "trainingerror","CVerror",
                          "Accuracy","AUC","Concordance", "testAUC","testConcordance")


at.summary$diffAUC <- abs(at.summary$AUC - at.summary$testAUC)

at.summary$diffConcordance <- abs(at.summary$Concordance - at.summary$testConcordance)

at.summary$diffscore <- at.summary$diffAUC + at.summary$diffConcordance

at.summary <- at.summary[order(-at.summary$testAUC,
                               -at.summary$testConcordance,
                                at.summary$diffscore), ] 

modelfilepath <- '//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/SVM/v4/'
setwd(modelfilepath)

modelfilelist <- list.files(path=modelfilepath, full.names=T)  

num_models <- 100

modellist = matrix(rep("", num_models), num_models, 1)

for (i in 1:num_models)
{
  modellist[i] = paste0(modelfilepath, 'ksvm_', at.summary[i,1], "_", at.summary[i,2],
                        '_', at.summary[i,4], '_', round(at.summary[i,3], 4),".RData")
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



at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/fallvalid_15var_latest.csv",
                        header = T, VERBOSE = TRUE, sep=',')

modelfilepath <- '//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/SVM/v4/'

modellist <- list.files(path=modelfilepath, full.names=T)  


j <- 1

aucmatrix = matrix(0, length(modellist), 2)

for (j in 1:length(modellist))
{
  
  load(modellist[j])
  
  prob_tst<- predict(ksvm.model,at.data[, 3:(ncol(at.data)-1)],
                     type="probabilities")[,2]
  
  adj.prob_tst = 1/(1+(1/0.08145858-1)*(1/prob_tst-1))
  
  yvec <- at.data[,2]
  
  prop.tst <- sum(yvec)/length(yvec)
  
  roc.auc <- roc.area(yvec, adj.prob_tst)
  
  print(paste(j, prop.tst, roc.auc))
  
  aucmatrix[j,1] = modellist[j]
  aucmatrix[j,2] = roc.auc
  
}

colnames(aucmatrix) <- c('modellist', 'AUC')


write_csv(data.frame(aucmatrix), "//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_fall_validation_svm.csv", col_names=T)




