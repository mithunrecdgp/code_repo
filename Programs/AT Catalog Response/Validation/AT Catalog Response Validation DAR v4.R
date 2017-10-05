library(ff)
library(ffbase)
library(ada)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)
library(verification)
library(ROCR)
library(pROC)
library(chron)
library(xgboost)
library(matrixStats)
library(modeest)
library(darch)


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

modelfilepath <- '//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/DAR/v4/'

modellist <- list.files(path=modelfilepath, full.names=T)  

aucmatrix = matrix(0, length(modellist), 2)


j <- 1

for (j in 1:length(modellist))
{
  
  dar.model <- loadDArch(gsub(pattern=".net", "", x=modellist[j]))
  
  prop.tst <- sum(at.data[,2])/nrow(at.data)
  
  gc()
  prob_tst <- predict(object=dar.model, at.data[,3:(ncol(at.data)-1)])
  
  adj.prob_tst = 1/(1+(1/0.08145858-1)*(1/prob_tst-1))
  
  yvec <- at.data[,2]
  
  roc.auc <- roc.area(yvec, adj.prob_tst)
  
  print(paste(j, prop.tst, roc.auc))
  
  aucmatrix[j,1] = modellist[j]
  aucmatrix[j,2] = roc.auc
  
}

colnames(aucmatrix) <- c('modellist', 'AUC')


write_csv(data.frame(aucmatrix), "//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_fall_validation_dar.csv", col_names=T)

