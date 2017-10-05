rm(list=ls())
gc()

library(ff)
library(kernlab)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)
library(matrixStats)

sample.size <- 100000


at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_retained_data.csv",header = TRUE,VERBOSE = TRUE,
                        sep=',',colClasses = c(rep("numeric",14)))

runs <- ifelse(nrow(at.data) %% sample.size == 0, 
               nrow(at.data) / sample.size, nrow(at.data) %/% sample.size + 1)

write.table(cbind("Testing_No","Customer_Key","Actual_response",
                  "Model01","Model02","Model03","Model04","Model05",
                  "Model06","Model07","Model08","Model09","Model10",
                  "Model11","Model12","Model13","Model14","Model15",
                  "Model16","Model17","Model18","Model19","Model20",
                  "ModelMedian","VotesinFavour"),
            '//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_retained_ensemble_testing.csv',
            append=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

bigindex<-sample(1:nrow(at.data), size=nrow(at.data))
bigindex <- sort(bigindex)

j <- 1
for (j in 1:runs) 
{
  start <- (j - 1) * sample.size + 1
  
  if (nrow(at.data) %% sample.size == 0)
  {
    end <- start + sample.size - 1
  }
  
  if (nrow(at.data) %% sample.size > 0)
  {
    end <- ifelse(j<runs, start + sample.size - 1, start + nrow(at.data) %% sample.size - 1)
  }
  
  print(paste("run:", j, "start: ", start, "end:", end))
  
  tst.at<-at.data[start:end,]
  
  
  #loop for each of the training dataset(1-20), train SVM and predict
  for (i in 1:20 )
  {
    
    print(paste0('Run: ',j,' , Model:',i))
    
    load(paste0("//10.8.8.51/lv0/Tanumoy/Datasets/SVM_Models/AT/Retained/","model",i,".RData"))
    prob_tst<- predict(ksvm.model,tst.at[c(-1,-2)],type="probabilities")
    
    if(i==1) 
    {
      output <- cbind(rep(j,nrow(tst.at)), tst.at[,1], tst.at[,2], prob_tst[,2])
      rm(prob_tst)
      gc()
    }
    
    if(i>1)
    {
      output<-cbind(output,prob_tst[,2])
      rm(prob_tst)
      gc()
    }
    
  }
  
  #Appending Median Probability
  output<-cbind(output,rowMedians(as.matrix(output[,-c(1,2)])))
  #Appending Favorable Counts
  r<-rowSums(apply(output[,-c(1,2,ncol(output))],c(1,2),'>',0.5))
  output<-cbind(output,r)
  rm(r)
  gc()
  
  #Outputting the final to an external file
  write.table(output,'//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_retained_ensemble_testing.csv', 
              append=TRUE,sep=",",row.names=FALSE,col.names=FALSE)
  
}


at.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_retained_ensemble_testing.csv",
                        header = TRUE,VERBOSE = TRUE, sep=',')


roc.grid = matrix(0, 1/0.02 + 1, 7)
for (p in 1:nrow(roc.grid))
{
  cutoff <- 0.02 * (nrow(roc.grid) - p)
  
  roc.grid[p,1] = cutoff
  roc.grid[p,2] = sum(at.data[,24]>cutoff & at.data[,3]==1)   # true positives
  roc.grid[p,3] = sum(at.data[,24]<=cutoff & at.data[,3]==0)  # true negatives
  roc.grid[p,4] = sum(at.data[,24]>cutoff & at.data[,3]==0)   # false positives
  roc.grid[p,5] = sum(at.data[,24]<=cutoff & at.data[,3]==1)  # false negatives
  roc.grid[p,6] = roc.grid[p,2]/(roc.grid[p,2] + roc.grid[p,5])
  roc.grid[p,7] = roc.grid[p,4]/(roc.grid[p,3] + roc.grid[p,4])
}


print(roc.area <- trapz(x=roc.grid[,7], y=roc.grid[,6]))





prior <- sum(at.data[,3])/nrow(at.data)

logit   <-  log((at.data[,24])/(1-at.data[,24]))
offset  <- -log(prior/(1-prior));
poffset <-  exp(logit - offset)/(1 + exp(logit - offset))


roc.grid = matrix(0, 1/0.02 + 1, 7)
for (p in 1:nrow(roc.grid))
{
  cutoff <- 0.02 * (nrow(roc.grid) - p)
  
  roc.grid[p,1] = cutoff
  roc.grid[p,2] = sum(poffset>cutoff & at.data[,3]==1)   # true positives
  roc.grid[p,3] = sum(poffset<=cutoff & at.data[,3]==0)  # true negatives
  roc.grid[p,4] = sum(poffset>cutoff & at.data[,3]==0)   # false positives
  roc.grid[p,5] = sum(poffset<=cutoff & at.data[,3]==1)  # false negatives
  roc.grid[p,6] = roc.grid[p,2]/(roc.grid[p,2] + roc.grid[p,5])
  roc.grid[p,7] = roc.grid[p,4]/(roc.grid[p,3] + roc.grid[p,4])
}


print(roc.area <- trapz(x=roc.grid[,7], y=roc.grid[,6]))

