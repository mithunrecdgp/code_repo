rm(list=ls())

load("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model.RData")

ds3<-read.table(file= "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/BR_ALLCAMPAIGNS_BALANCED_3.txt",
                header=T,sep="|",)

summary(ds3)

ds3$CARD_STATUS <- as.factor(ds3$CARD_STATUS)



df1  <-  subset(ds3,
                select =  c(CUSTOMER_KEY,
                            RESPONDER,
                            NUM_TXNS_12MO_SLS,
                            DIV_SHP_BR,
                            YEARS_ON_BOOKS,
                            RESPONSE_RATE_12MO,
                            BR_PROMOTIONS_RECEIVED_12MO,
                            DAYS_LAST_PUR_BR,
                            AVG_ORD_SZ_12MO,
                            NUM_TXNS_12MO_RTN,
                            ONSALE_QTY_12MO,
                            AVG_UNT_RTL,
                            ONSALE_QTY_12MO,
                            CARD_STATUS
                           )
               )

rm(ds3)

save.image("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model.RData")





#----------------------------------- Logistic Regression -------------------------------------------

logit.reg = 
function(dataset, iterations, trainpct, roc.graph, lift.graph, gains.graph,
         append.results, startindex)
{
  
    library(ROCR)
    library(verification)
    library(pracma)
    
    trainpct.array = rep(0,iterations);
    iteration.array = rep(0,iterations);
    
    misclassification.train = rep(0,iterations); 
    true.pos.rate.train = rep(0,iterations);
    true.neg.rate.train = rep(0,iterations);
    roc.area.train = rep(0,iterations);
    area.gains.train = rep(0, iterations);
    area.gains.best.train = rep(0, iterations);
    
    misclassification.test  = rep(0,iterations)
    true.pos.rate.test = rep(0,iterations);
    true.neg.rate.test = rep(0,iterations);
    roc.area.test = rep(0,iterations);
    area.gains.test = rep(0, iterations);
    area.gains.best.test = rep(0, iterations);
    
    
    iteration=1:iterations
    
    for(j in iteration)
      
    {
      i=startindex + j - 1
      
      trainpct.array[j] = trainpct; iteration.array[j] = i;
      
      train.index <- sample(1:nrow(dataset), size=trainpct * nrow(dataset), replace=FALSE)
      
      data.train <- dataset[ train.index, ]
      
      data.test  <- dataset[-train.index, ]
      
      print(j); print(trainpct);
      print(dim(data.train)); 
      print(dim(data.test));
      
      gc();
      
      logit1 <- glm(RESPONDER ~ NUM_TXNS_12MO_SLS +
                                DIV_SHP_BR +
                                YEARS_ON_BOOKS +
                                RESPONSE_RATE_12MO +
                                BR_PROMOTIONS_RECEIVED_12MO +
                                DAYS_LAST_PUR_BR +
                                AVG_ORD_SZ_12MO +
                                NUM_TXNS_12MO_RTN +
                                ONSALE_QTY_12MO +
                                AVG_UNT_RTL +
                                ONSALE_QTY_12MO +
                                CARD_STATUS,
                    data=data.train, family=binomial("logit"))
      
      gc();
      
      obs.responder.train <- data.train$RESPONDER
      
      
      nrow.train <- dim(data.train)[1]
      
      rm(data.train); gc();
      
      print(summary(logit1));
      
      coef.temp <- t(coef(logit1))
        
      write.table(coef.temp,
                  file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Coefficients Temp.TXT",
                  sep="|",row.names= FALSE,col.names= TRUE)
      coef.temp <- read.table(file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Coefficients Temp.TXT",sep="|",head=TRUE)
      file.remove("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Coefficients Temp.TXT")    
      
      ifelse(j==1, 
             coef <- cbind(trainpct, i, coef.temp),
             coef <- rbind(coef, cbind(trainpct, i, coef.temp))
             );
      
      rm(coef.temp)
      
      print(coef)
      
      prob.train <- fitted(logit1);  
         
      resp.train <- ifelse(prob.train < 0.5, 0, 1);

         
      true.pos <- prop.table(table(obs.responder.train, resp.train))[1,1]
      true.neg <- prop.table(table(obs.responder.train, resp.train))[2,2]
         
      true.pos.rate.train[j] = prop.table(table(obs.responder.train, resp.train),1)[1,1]
      true.neg.rate.train[j] = prop.table(table(obs.responder.train, resp.train),1)[2,2]
      
      misclassification.train[j] = 1 - (true.pos + true.neg) 
         
         
      roc.area.logit.train <- roc.area(obs.responder.train, prob.train)      
      labels.roc.logit.train <- paste("Logit Reg: Training AUC=",
                                         round(roc.area.logit.train$A,5))
      roc.area.train[j] = roc.area.logit.train$A
       
      
      max.yval.lift.train = 1 / (sum(obs.responder.train)/nrow.train);   
         
         
         
         
      prob.test  <- predict(newdata=data.test, logit1, type="response");
      obs.responder.test <- data.test$RESPONDER
      
      nrow.test <- dim(data.test)[1]
      
      rm(data.test); gc();
         
      resp.test <- ifelse(prob.test < 0.5, 0, 1);
         
         
      table(obs.responder.test, resp.test);
         
      true.pos <- prop.table(table(obs.responder.test, resp.test))[1,1]
      true.neg <- prop.table(table(obs.responder.test, resp.test))[2,2]
         
      true.pos.rate.test[j] = prop.table(table(obs.responder.test, resp.test),1)[1,1]
      true.neg.rate.test[j] = prop.table(table(obs.responder.test, resp.test),1)[2,2] 
         
      misclassification.test[j] = 1 - (true.pos + true.neg)
         
      roc.area.logit.test <- roc.area(obs.responder.test, prob.test)
      labels.roc.logit.test <- paste("Logit Reg: Testing AUC=",
                                        round(roc.area.logit.test$A,5))
      roc.area.test[j] = roc.area.logit.test$A
         
      
      max.yval.lift.test = 1 / (sum(obs.responder.test)/nrow.test);   
      
      
      
      
      if (roc.graph==1)
      {
        plot(performance(prediction(prob.train, obs.responder.train), "tpr","fpr") , 
             avg = "threshold", col = "red", typ="b", lwd = 2, lty=10); 
        title(main = list(paste("ROC Curves"), 
                          cex = 0.95, col = "black", font = 1));
        par(new=T)
           
           
           
        plot(performance(prediction(prob.test, obs.responder.test), "tpr","fpr") , 
             avg = "threshold", col = "Blue", typ="b", lwd = 2, lty=10); 
        title(main = list(paste("ROC Curves"), 
                          cex = 0.95, col = "black", font = 1));
        par(new=T)
           
           
           
        grid(lty=3,lwd=1,col="gray",equilogs = T)
           
        legend("topleft", c(labels.roc.logit.train, labels.roc.logit.test), 
                lty=c(10,10), lwd=c(2,2), col=c("red","Blue"), bty="o", box.lty=2) 
           
        box()
      }
         
         
      if (gains.graph==1)
      {
           
        plot(performance(prediction(prob.train,obs.responder.train), "tpr", "rpp"),lwd = 2, col = "red", lty=10);
        title(main = list(paste("Cumulative Gains Chart - Training : Testing ", length(resp.train), ":", length(resp.test)), cex = 0.95, col = 1, font = 1));
        par(new=T)
           
        plot(performance(prediction(prob.test, obs.responder.test), "tpr", "rpp"),lwd = 2, col = "Blue", lty=10);
        title(main = list(paste("Cumulative Gains Chart - Training : Testing ", length(resp.train), ":", length(resp.test)), cex = 0.95, col = "black", font = 1));
        par(new=T)
           
        grid(lty=3,lwd=1,col="gray",equilogs = T)
           
        legend("topleft", c("Training", "Testing"), 
                lty=c(10,10), lwd=c(2,2), col=c("red","Blue"), bty="o", box.lty=2)
           
        box() 
           
      }
         
         
         
         
      if (lift.graph==1)
      {
           
        max.yval.lift = max(max.yval.lift.train, max.yval.lift.test)
           
        plot(performance(prediction(prob.train,obs.responder.train), "lift", "rpp"),lwd = 2, col = "red", lty=10, ylim=c(1,max.yval.lift));
        title(main = list(paste("Lift Chart - Training : Testing ", length(resp.train), ":", length(resp.test)), cex = 0.95, col = 1, font = 1));
        par(new=T)
           
        plot(performance(prediction(prob.test, obs.responder.test), "lift", "rpp"),lwd = 2, col = "Blue", lty=10, ylim=c(1,max.yval.lift));
        title(main = list(paste("Lift Chart - Training : Testing ", length(resp.train), ":", length(resp.test)), cex = 0.95, col = "black", font = 1));
        par(new=T)
           
        grid(lty=3,lwd=1,col="gray",equilogs = T)
           
        legend("topright", c("Training", "Testing"), 
                lty=c(10,10), lwd=c(2,2), col=c("red","Blue"), bty="o", box.lty=2)
           
        box()
           
      }
         
         
      prob.train.sort <- cbind(obs.responder.train, 
                               prob.train
                              )
         
      prob.train.sort <- prob.train.sort[order(-prob.train), ]
         
      cumresponder <- cumsum(prob.train.sort[,1]);  
      cumcustomer <- seq(1, nrow.train, by=1);
         
      cum.gains.train <- cumresponder / sum(obs.responder.train) 
      cum.pct.cust <- cumcustomer / nrow.train
         
      rm(cumresponder, cumcustomer)
         
      area.gains.train[j] <- trapz(y=cum.gains.train, x=cum.pct.cust)
         
      if (gains.graph==1)
      {
        plot(y=cum.gains.train, x=cum.pct.cust, col = "red", typ="l", lwd = 2, lty=10,
             xlab="Rate of Positive Prediction", ylab="Cumulative Gains: Training")
        grid(lty=3,lwd=1,col="gray",equilogs = T)
        legend("topleft", c("Best Model", "Training", "No Model"), 
                lty=c(10,10,10), lwd=c(2,2,2), col=c("Blue","Red","brown" ), 
                bty="o", box.lty=2)  
      }
         
         
      rm(cum.gains.train, cum.pct.cust); gc();
         
      prob.train.sort <- prob.train.sort[order(-prob.train.sort[,1]), ]
         
      cumresponder <- cumsum(prob.train.sort[,1]);  
      cumcustomer <- seq(1, nrow.train, by=1);
         
      cum.gains.train <- cumresponder / sum(obs.responder.train) 
      cum.pct.cust <- cumcustomer / nrow.train
         
      rm(prob.train.sort, cumresponder, cumcustomer); gc();
         
      area.gains.best.train[j] <- trapz(y=cum.gains.train, x=cum.pct.cust)
         
      if (gains.graph==1)
      {
        lines(y=cum.gains.train, x=cum.pct.cust, col="blue", lty=10, lwd=2)
        lines(y=seq(0,1,by=0.01), x=seq(0,1,by=0.01), col="brown", lty=10, lwd=2)      
      }
         
      rm(cum.gains.train, cum.pct.cust); gc();
         
         
         
         
      prob.test.sort <- cbind(obs.responder.test, 
                              prob.test
                             )
         
      prob.test.sort <- prob.test.sort[order(-prob.test), ]
         
      cumresponder <- cumsum(prob.test.sort[,1]);  
      cumcustomer <- seq(1, nrow.test, by=1);
         
      cum.gains.test <- cumresponder / sum(obs.responder.test) 
      cum.pct.cust <- cumcustomer / nrow.test
         
      rm(cumresponder, cumcustomer); gc();
         
      area.gains.test[j] <- trapz(y=cum.gains.test, x=cum.pct.cust)
         
      if (gains.graph==1)
      {
        plot(y=cum.gains.test, x=cum.pct.cust, col = "red", typ="l", lwd = 2, lty=10,
             xlab="Rate of Positive Prediction", ylab="Cumulative Gains: Testing")
        grid(lty=3,lwd=1,col="gray",equilogs = T)
        legend("topleft", c("Best Model", "Testing", "No Model"), 
                lty=c(10,10,10), lwd=c(2,2,2), col=c("Blue","Red","Brown" ), 
                bty="o", box.lty=2)
      }
         
      rm(cum.gains.test, cum.pct.cust); gc();
         
      prob.test.sort <- prob.test.sort[order(-prob.test.sort[,1]), ]
         
      cumresponder <- cumsum(prob.test.sort[,1]);  
      cumcustomer <- seq(1, nrow.test, by=1);
         
      cum.gains.test <- cumresponder / sum(obs.responder.test) 
      cum.pct.cust <- cumcustomer / nrow.test
         
      rm(prob.test.sort, cumresponder, cumcustomer); gc();
         
      area.gains.best.test[j] <- trapz(y=cum.gains.test, x=cum.pct.cust)
         
      if (gains.graph==1)
      {
        lines(y=cum.gains.test, x=cum.pct.cust, col="blue", lty=10, lwd=2)
        lines(y=seq(0,1,by=0.01), x=seq(0,1,by=0.01), col="brown", lty=10, lwd=2)
      }
      rm(cum.gains.test, cum.pct.cust); gc();
         
      rm(
         obs.responder.train,
         obs.responder.test,
         prob.train,
         prob.test,
         resp.train,
         resp.test,
         true.pos,
         true.neg
        )
             
    }
    
    diagnostics <- cbind(
                          trainpct.array,
                          iteration.array,
                          misclassification.train, 
                          misclassification.test,
                          true.pos.rate.train,
                          true.pos.rate.test,
                          true.neg.rate.train,
                          true.neg.rate.test,
                          roc.area.train,
                          roc.area.test,
                          area.gains.train,
                          area.gains.best.train,
                          area.gains.test,
                          area.gains.best.test
                        )
    
    
    if (append.results==0)
    {
      
      coef.grid <- coef
      diagnostics.grid <- diagnostics
      
      write.table(coef.grid,
                  file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Coefficients.TXT",
                  sep="|",row.names= FALSE,col.names= TRUE)
      
      write.table(diagnostics.grid,
                  file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Diagnostics.TXT",
                  sep="|",row.names= FALSE,col.names= TRUE)
      
    }
    
    if (append.results==1)
    {
      if (file.exists("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Coefficients.txt"))
      {
        coef.grid <- read.table(file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Coefficients.TXT",sep="|",head=TRUE)
        
        coef.grid <- rbind(coef.grid, coef)
        
        print(coef.grid)
        
        write.table(coef.grid,
                    file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Coefficients.TXT",
                    sep="|",row.names= FALSE,col.names= TRUE)
      } else
      {
        print("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Coefficients.TXT does not exist.")
      }
    }
    
    if (append.results==1)
    {
      if (file.exists("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Diagnostics.TXT"))
      {
        diagnostics.grid <- read.table(file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Diagnostics.TXT",sep="|",head=TRUE)
        
        diagnostics.grid <- rbind(diagnostics.grid, diagnostics)
        
        print(diagnostics.grid)
        
        write.table(diagnostics.grid,
                    file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Diagnostics.TXT",
                    sep="|",row.names= FALSE,col.names= TRUE)
      } else
      {
        print("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Diagnostics.TXT does not exist.")
      }
    }
    
    gc();
        
}

gc()

logit.reg(dataset=df1, iterations=1,  trainpct=0.95, append.results=1,
          roc.graph=0, lift.graph=0, gains.graph=0, startindex=1)

gc()







  
gc()
  
iterationloop=seq(1, 20, by=1)
  
for (x in iterationloop)
    
{
    
  gc()
    
  logit.reg(dataset=df1, iterations=1,  trainpct=0.9, append.results=1,
              roc.graph=0, lift.graph=0, gains.graph=0, startindex=x)
}


#------------- for looping across varying training percentages ------------------- 

logit.reg(dataset=df1, iterations=20,  trainpct=0.05, append.results=0,
          roc.graph=0, lift.graph=0, gains.graph=0, startindex=1)

trainpctloop=seq(0.10, 0.95, by=0.05)

num_iterations = 20; 

for(k in trainpctloop)
  
{
  print(k);
  
  
  logit.reg(dataset=df1, iterations=num_iterations,  trainpct=k, append.results=1,
            roc.graph=0, lift.graph=0, gains.graph=0, startindex=1);

}



resultsarray <- read.table(file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Diagnostics.TXT",sep="|",head=TRUE)

pdf(file="//10.8.8.51/lv0/Tanumoy/Graphs/BR MODEL ACCURACY LOGISTIC REGRESSION.PDF",height=9, width=16,bg="white")
par(mfrow=c(1,1))

min = min(resultsarray[,3:4])
max = max(resultsarray[,3:4])

plot(y=resultsarray[,3], x=seq(1:nrow(resultsarray)), type="b", ylim=c(min-0.01, max+0.01),
     xlab="Iteration", ylab="Misclassification Rate", col="blue", lty=10);
lines(y=resultsarray[,4], x=seq(1:nrow(resultsarray)), col="red", type="b", lty=10);
legend("topright", legend=c("Training","Testing"), text.col=c("Blue","red"),
       lty=c(10,10), col=c("Blue","red"))
grid(lty=3,lwd=1,col="gray",equilogs = T);




min = 1 - max(resultsarray[,3:4])
max = 1 - min(resultsarray[,3:4])

plot(y=1 - resultsarray[,3], x=seq(1:nrow(resultsarray)), type="b", ylim=c(min-0.01, max+0.01),
     xlab="Iteration", ylab="Classification Rate", col="blue", lty=10);
lines(y=1- resultsarray[,4], x=seq(1:nrow(resultsarray)), col="red", type="b", lty=10);
legend("topright", legend=c("Training","Testing"), text.col=c("Blue","red"),
       lty=c(10,10), col=c("Blue","red"))
grid(lty=3,lwd=1,col="gray",equilogs = T);



min = min(resultsarray[,9:10])
max = max(resultsarray[,9:10])

plot(y=resultsarray[,9], x=seq(1:nrow(resultsarray)), type="b", ylim=c(min-0.01, max+0.01),
     xlab="Iteration", ylab="Area Under ROC Curve", col="blue", lty=10);
lines(y=resultsarray[,10], x=seq(1:nrow(resultsarray)), col="red", type="b", lty=10);
legend("topright", legend=c("Training","Testing"), text.col=c("Blue","red"),
       lty=c(10,10), col=c("Blue","red"))
grid(lty=3,lwd=1,col="gray",equilogs = T);



min = min(resultsarray[,c(11,13)])
max = max(resultsarray[,c(11,13)])

plot(y=resultsarray[,11], x=seq(1:nrow(resultsarray)), type="b", ylim=c(min-0.01, max+0.01),
     xlab="Iteration", ylab="Area Under Cumulative Gains Curve", col="blue", lty=10);
lines(y=resultsarray[,13], x=seq(1:nrow(resultsarray)), col="red", type="b", lty=10);
legend("topright", legend=c("Training","Testing"), text.col=c("Blue","red"),
       lty=c(10,10), col=c("Blue","red"))
grid(lty=3,lwd=1,col="gray",equilogs = T);


box()

dev.off()


coefarray <- read.table(file="//10.8.8.51/lv0/Tanumoy/RData/BR Response Model Coefficients.TXT",sep="|",head=TRUE)
coefloop=seq(1, ncol(coefarray) - 2)

pdf(file="//10.8.8.51/lv0/Tanumoy/Graphs/BR COEFFICIENT STABILITY LOGISTIC REGRESSION.PDF",height=9, width=16,bg="white")
par(mfrow=c(1,1))

i=1;
for (i in coefloop)
{
  
  min = min(coefarray[,i + 2])
  max = max(coefarray[,i + 2])
  
  plot(y=coefarray[,i + 2], x=seq(1:nrow(coefarray)), type="b", ylim=c(min-0.01, max+0.01),
       xlab="ITERATION", ylab="LOG-LIKELIHOOD", col="blue", lty=10);
  title(main = list(toupper(colnames(coefarray)[i + 2]), 
                    cex = 0.95, col = "blue", font = 1));
  grid(lty=3,lwd=1,col="gray",equilogs = T);
   
  box()
  
  
  
  min = min(exp(coefarray[,i + 2]))
  max = max(exp(coefarray[,i + 2]))
  
  plot(y=exp(coefarray[,i + 2]), x=seq(1:nrow(coefarray)), type="b", ylim=c(min-0.01, max+0.01),
       xlab="ITERATION", ylab="LIKELIHOOD", col="blue", lty=10);
  title(main = list(toupper(colnames(coefarray)[i + 2]), 
                    cex = 0.95, col = "red", font = 1));
  grid(lty=3,lwd=1,col="gray",equilogs = T);
  
  box()
}

dev.off()








#----------------------------------- Support Vector Machines -------------------------------------------


install.packages('kernlab'); install.packages('e1071');

library(kernlab)
library(e1071)

srange<-sigest(RESPONDER ~ NUM_TXNS_12MO_SLS +
                           DIV_SHP_BR +
                           YEARS_ON_BOOKS +
                           RESPONSE_RATE_12MO +
                           BR_PROMOTIONS_RECEIVED_12MO +
                           DAYS_LAST_PUR_BR +
                           AVG_ORD_SZ_12MO +
                           NUM_TXNS_12MO_RTN +
                           ONSALE_QTY_12MO +
                           AVG_UNT_RTL +
                           ONSALE_QTY_12MO +
                           CARD_STATUS,
               data = df1, frac = 0.05);

train.index <- sample(1:nrow(df1), size = 0.05 * nrow(df1) , replace=FALSE)

data.train <- df1[ train.index, ]

data.test  <- df1[-train.index, ]


svm1 <- ksvm(RESPONDER ~   NUM_TXNS_12MO_SLS +
                           DIV_SHP_BR +
                           YEARS_ON_BOOKS +
                           RESPONSE_RATE_12MO +
                           BR_PROMOTIONS_RECEIVED_12MO +
                           DAYS_LAST_PUR_BR +
                           AVG_ORD_SZ_12MO +
                           NUM_TXNS_12MO_RTN +
                           ONSALE_QTY_12MO +
                           AVG_UNT_RTL +
                           ONSALE_QTY_12MO +
                           CARD_STATUS, 
             data = data.train, kernel="rbfdot", prob.model=T, 
             C = 1, kpar = list(sigma=srange[2]), cross = 10, type="C-svc")

summary(svm1)
