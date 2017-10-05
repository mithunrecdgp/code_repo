gc()

library(ff)
library(kernlab)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)
library(matrixStats)

sample.size <- 100000


br.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Saumya/Datasets/br_recent_data.csv",header = TRUE,VERBOSE = TRUE,
                        sep=',',colClasses = c(rep("numeric",16)))

br.data[,2]<-1-br.data[,2]

runs <- round(nrow(br.data)/sample.size)

write.table(cbind("Testing_No","Customer_Key","Actual_response",
                  "Model01","Model02","Model03","Model04","Model05",
                  "Model06","Model07","Model08","Model09","Model10",
                  "Model11","Model12","Model13","Model14","Model15",
                  "Model16","Model17","Model18","Model19","Model20",
                  "ModelMedian","VotesinFavour"),
            '//10.8.8.51/lv0/Saumya/Datasets/br_recent_ensemble_testing.csv',
            append=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

bigindex<-sample(1:nrow(br.data), size=sample.size * runs)

for (j in 1:runs) 
{
    print('-----------------------------------------------')
    index <- bigindex[((j-1)*sample.size+1):(j*sample.size)]
    tst.br<-br.data[index,]
    
    rm(index)
    gc()
    
    #loop for each of the training dataset(1-20), train SVM and predict
    for (i in 1:20 )
    {
          
          print(paste0('Run: ',j,' , Model:',i))
          
          load(paste0("//10.8.8.51/lv0/Saumya/Datasets/SVM_Models/BR/Recent/","model",i,".RData"))
          prob_tst<- predict(ksvm.model,tst.br[c(-1)],type="probabilities")
          
          if(i==1) 
          {
            output <- cbind(rep(j,sample.size), tst.br[,1], tst.br[,2], prob_tst[,2])
            rm(prob_tst)
            gc()
          }
        
          if(i>1)
          {
            output<-cbind(output,prob_tst[,2])
            rm(prob_tst)
            gc
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
    write.table(output,'//10.8.8.51/lv0/Saumya/Datasets/br_recent_ensemble_testing.csv', append=TRUE,sep=",",row.names=FALSE,col.names=FALSE)

}





