validate = function(file, id, response, prob, path)

{
  library(ROCR)
  library(verification)
  library(pracma) 
  
  filename <- paste0(path,"/", file, ".TXT")
  print(filename)

  ds<-read.table(file= filename,header=T,sep="|")
  
  ds1<-subset(ds, TREATMENT_GRP==1)
  
  prediction.logit <- prediction(ds1[,c(prob)], ds1[,c(response)])
  performance.roc.logit <- performance(prediction.logit, "tpr","fpr")
  roc.area.logit <- roc.area(ds1[,c(response)], ds1[,c(prob)])      
  labels.roc.logit <- paste("Logit Reg AUC=",
                            round(roc.area.logit$A,5))
  
  auc.roc <- roc.area.logit$A 
  
  graphout <- paste0("//10.8.8.51/lv0/Tanumoy/Graphs/", file, ".PDF")
  print(graphout)
  
  pdf(file=graphout,height=9, width=16,bg="white")
  par(mfrow=c(1,1))
  
  plot(performance.roc.logit , 
       avg = "threshold", col = "red", typ="b", lwd = 2, lty=10); 
  par(new=T)
  plot(
       seq(0,1,0.001), seq(0,1,by=0.001), col="green", typ="l", lwd = 2, lty=2,
       xlab="Average false positive rate", ylab="Average true positive rate"
      );
  title(main = list(paste("ROC Curve"), 
                    cex = 0.95, col = "black", font = 1));
  
  grid(lty=3,lwd=1,col="blue",equilogs = T)
  
  legend("topleft", c(labels.roc.logit), 
         lty=c(10), lwd=c(2), col=c("red"), bty="o", box.lty=2)
  
  box()
  
  prob.sort <- cbind(
                      ds1[,c(id)],
                      ds1[,c(prob)], 
                      ds1[,c(response)]
                    )

  prob.sort <- prob.sort[order(-prob.sort[,2]), ]
  
  CUMRESPONDER <- cumsum(prob.sort[,3]);  
  CUMCUSTOMER <- seq(1, nrow(prob.sort), by=1);
  
  cum.gains <- CUMRESPONDER / sum(prob.sort[,3]) 
  cum.pct.cust <- CUMCUSTOMER / nrow(prob.sort)
  
  prob.sort <- cbind(
                      prob.sort,
                      CUMRESPONDER,
                      CUMCUSTOMER,
                      cum.gains,
                      cum.pct.cust
                    )
  
  auc.gains <- trapz(y=cum.gains, x=cum.pct.cust)
  
  plot(y=cum.gains, x=cum.pct.cust, col = "red", typ="l", lwd = 2, lty=10,
       xlab="Rate of Positive Prediction", ylab="Cumulative Gains Response")
  
  prob.sort.best <- cbind(
                            ds1[,c(id)],
                            ds1[,c(prob)], 
                            ds1[,c(response)]
                          )
  
  prob.sort.best <- prob.sort.best[order(-prob.sort.best[,3]), ]
  
  CUMRESPONDER <- cumsum(prob.sort.best[,3]);  
  CUMCUSTOMER <- seq(1, nrow(prob.sort.best), by=1);
  
  cum.gains <- CUMRESPONDER / sum(prob.sort.best[,3]) 
  cum.pct.cust <- CUMCUSTOMER / nrow(prob.sort.best)
  
  prob.sort.best <- cbind(
                            prob.sort.best,
                            CUMRESPONDER,
                            CUMCUSTOMER,
                            cum.gains,
                            cum.pct.cust
                         )
  
  auc.best.gains <- trapz(y=cum.gains, x=cum.pct.cust)
  
  lines(y=cum.gains, x=cum.pct.cust, col="blue", lty=10, lwd=2)
  lines(y=seq(0,1,by=0.01), x=seq(0,1,by=0.01), col="brown", lty=10, lwd=2)      
  grid(lty=3,lwd=1,col="gray",equilogs = T)
  legend("bottomright", 
          lty=c(10,10,10), 
          lwd=c(2,2,2), 
          col=c("Blue","Red","Brown" ),
          c(paste("Best Model: ",round(auc.best.gains,5)), 
            paste("Current Model: ", round(auc.gains,5)), 
            paste("No Model")
           ),  
           bty="o", box.lty=2)
  
  
  box()
  dev.off()
  
  return(results <- cbind(auc.roc, auc.gains, auc.best.gains))
  
}

results <- 
  validate(file="ON_252071_DM", response="RESPONDER", prob="POFFSET_1", 
           path="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication",
           id="CUSTOMER_KEY")

results <- 
  validate(file="ON_253363_DM", response="RESPONDER", prob="POFFSET_1", 
           path="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication",
           id="CUSTOMER_KEY")

results <- 
  validate(file="ON_253458_DM", response="RESPONDER", prob="POFFSET_1", 
           path="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication",
           id="CUSTOMER_KEY")