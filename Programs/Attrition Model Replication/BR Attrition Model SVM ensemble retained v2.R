install.packages('xgboost')
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
ibrary(xgboost)


br.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Saumya/Datasets/br_final_ratio_flag_rec.csv",header = TRUE,VERBOSE = TRUE,
                        sep=',',colClasses = c(rep("numeric",14)))

br.data[,2]<-1-br.data[,2]


min.sample.size <- 50000; max.sample.size <- 100000;

sample.sizes <- seq(min.sample.size, max.sample.size, by=500)

c.list <-c(seq(0.1,1, by=0.1),1.5,5,10)


for(i in 1:length(sample.sizes))
{ 
  for (s in 1:10)
  {
    br.data.ones <- br.data[br.data[,2]==1,]
    index.ones.tra <- bigsample(1:nrow(br.data.ones), size=0.5*sample.sizes[i], replace=F)
    tra.br.ones <- br.data.ones[ index.ones.tra,]
    tst.br.ones <- br.data.ones[-index.ones.tra,]
    
    
    
    
    rm(br.data.ones); gc();
    
    
    br.data.zeroes <- br.data[br.data[,2]!=1,]
    index.zeroes.tra <- bigsample(1:nrow(br.data.zeroes), size=0.5*sample.sizes[i], replace=F)
    tra.br.zeroes <- br.data.zeroes[ index.zeroes.tra,]
    tst.br.zeroes <- br.data.zeroes[-index.zeroes.tra,]
    
    rm(br.data.zeroes); gc();
    
    
    tra.br <- rbind(tra.br.ones, tra.br.zeroes)
    rm(tra.br.ones, tra.br.zeroes); gc();
    
    tra.br <- tra.br[c(-1)]
    
    print(prop <- sum(tra.br[,1])/nrow(tra.br))
    
    
    xmatrix <- as.matrix(tra.br[,2:ncol(tra.br)])
    yvec = as.matrix(tra.br[,1])
    
    
    param <- list("objective" =  "binary:logistic",
                  "eval_metric" = "auc",
                  "num_class" = 2)
    
    cv.nround <- 20
    cv.nfold <- 10
    cv.nthread <-  2
    
    bst.cv = xgb.cv(param=param, data = xmatrix, label = yvec, 
                    nfold = cv.nfold, nrounds = cv.nround)
    
    
    
    xgboost.model <- xgboost(data=xmatrix, label = yvec, objective = "binary:logistic",
                             verbose=T, nrounds=20)
  }
}