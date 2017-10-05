install.packages("ada")
install.packages("ffbase")
install.packages("ff")
install.packages("plyr")
install.packages("VIF")
install.packages("pracma")
install.packages("AUC")
install.packages("ROCR")
install.packages("verification")

rm(list=ls())
gc()

library(ff)
library(ada)
library(ffbase)
library(plyr)
library(pracma)
library(VIF)
library(AUC)
library(ROCR)
library(verification)

eventcat <- 1; refcat <- 3;

OptimisedConc=function(response, probvar)
{
  x<-matrix(probvar, length(response), 1)
  y<-matrix(response, length(response), 1)
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
  return (concordance)
}

isna <- function(x) 
{
  return(sum(ifelse(is.na(x)|(x==''),1,0)))
}

filelist <- list.files(path=datapath, full.names=T)  

for(i in seq(1, length(filelist), by=1))
{
  if (i==1)
  {
    on_data <- read.csv.ffdf(file=filelist[i], header = TRUE, VERBOSE = TRUE, sep=',')
  }
  if (i>1)
  {
    on_data <- rbind(on_data, 
                     read.csv.ffdf(file=filelist[i], header = TRUE, VERBOSE = TRUE, sep=','))
  }
}

dim(on_data)

on_data_cleaned <- on_data[apply(on_data[,8:13], 1, isna)==0,]
dim(on_data_cleaned)

gender <- factor(on_data_cleaned$IBE8688_8688)

marital_status <- factor(on_data_cleaned$IBE7609_MARITAL_STAT_MARITAL)

presence_children <- factor(on_data_cleaned$IBE7622_CHLDRN_PRES_CHLDRN)

population_dens <- ifelse(on_data_cleaned$IBE1273_POP_DENSITY_IBE_MODEL %in% c(1,2),'Rural', 
                          ifelse(on_data_cleaned$IBE1273_POP_DENSITY_IBE_MODEL %in% c(3,4,5),'SmallSuburb',
                                 ifelse(on_data_cleaned$IBE1273_POP_DENSITY_IBE_MODEL %in% c(6,7,8,9,10),'CitySurrounds',
                                        'Urban')))

age <- on_data_cleaned$IBE8626_8626

income <- factor(on_data_cleaned$IBE7671_INCOM_100PCT_INCOME)
income <- factor(ifelse(income=='A',10,
                        ifelse(income=='B',11,
                               ifelse(income=='C',12,
                                      ifelse(income=='D',13,income)))))

emails_clicked_on <- ifelse(is.na(on_data_cleaned$emails_clicked_on), 0, 
                            on_data_cleaned$emails_clicked_on)

emails_viewed_on <- ifelse(is.na(on_data_cleaned$emails_viewed_on), 0, 
                            on_data_cleaned$emails_viewed_on)

customer_key <- on_data_cleaned$customer_key

on_data_cleaned[is.na(on_data_cleaned)]<-0

pv_segment_p1 <- cut(on_data_cleaned$net_sales + on_data_cleaned$returns,
                     breaks=c(min(on_data_cleaned$net_sales + on_data_cleaned$returns),
                              quantile(on_data_cleaned$net_sales + on_data_cleaned$returns,probs=c(1/3,2/3)),
                              max(on_data_cleaned$net_sales + on_data_cleaned$returns)),
                     labels=c("Low","Medium","High"))

dmable <- on_data_cleaned$dmable; emailable <- on_data_cleaned$emailable;

pv_segment_p1 <- ifelse(pv_segment_p1=='High', 1, ifelse(pv_segment_p1=='Low',3,2))
  
on_data_mod <- data.frame(customer_key, pv_segment_p1, emails_viewed_on, emails_clicked_on,
                          income, age, presence_children, population_dens, marital_status,
                          gender, dmable)
  
on_data_mod[is.na(on_data_mod)]<-0

data <- on_data_mod
rm(on_data_mod, on_data_cleaned); gc();
rm(customer_key, pv_segment_p1, emails_viewed_on, emails_clicked_on,
   income, age, presence_children, population_dens, marital_status,
   gender, emailable, dmable); gc();

index.tra <- bigsample(1:nrow(data), size=0.7*nrow(data), replace=F)
tra.on <- data[ index.tra,]
tst.on <- data[-index.tra,]
c.list <- c(seq(0.2,1, by=0.1))


headers1<-cbind("eventcat", "refcat", "run", "nu",
                "TPR","TNR", "Accuracy", "AUC","Concordance")
write.table(headers1, paste0('on/Outputs/ADA/on_train_potential_',
                             eventcat,'_vs_', refcat,'.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

headers2<-cbind("eventcat", "refcat", "run", "nu","SampleNumber",
                "TPR","TNR", "Accuracy", "AUC","Concordance")
write.table(headers2, paste0('on/Outputs/ADA/on_test_potential_',
                             eventcat,'_vs_', refcat,'.csv'), 
            append=FALSE, sep=",",row.names=FALSE,col.names=FALSE)

z<-0; 
for (s in 1:5)
{
  tra.on.mod <- tra.on[(tra.on[,2]==refcat | tra.on[,2] == eventcat), ]
  ind <- bigsample(1:nrow(tra.on.mod), size=10000, replace=F)
  tra.samp <- tra.on.mod[ind,]
  tra.samp <- tra.samp[c(-1)]
  tra.samp[,1] <- ifelse(tra.samp[,1]==eventcat,1,0)
  
  for(j in 1:length(c.list))
  {
    z<-z+1
    
    ada.model <- ada(pv_segment_p1 ~., data=tra.samp, type="discrete", 
					 loss="exponential", bag.frac = 0.5, iter=100, verbose=T,
					 nu=c.list[j])
    save(ada.model, file = paste0("on/RData/ADA/on_",eventcat,"_vs_", refcat,
                                   "_",z,".RData"))
    
    print('------------------------------------------')
    print(ada.model)
    print('------------------------------------------')
    
    prob_tra<- predict(ada.model,tra.samp[,c(-1)],type="probs")
    
    tpr <- ada.model$confusion[1,1] / sum(ada.model$confusion[1,])
    tnr <- ada.model$confusion[2,2] / sum(ada.model$confusion[2,])
    acc <- (ada.model$confusion[1,1] + ada.model$confusion[2,2])/nrow(tra.samp)
    
  
    
    auc <-auc(roc(prob_tra[,2], factor(tra.samp[,1])))
    concordance<-OptimisedConc(tra.samp[,1],prob_tra[,2])
    print(paste(eventcat, s, c.list[j], tpr, tnr, acc, auc, concordance))
    
    write.table(cbind(eventcat, s, c.list[j], tpr, tnr, acc, auc, concordance),
                paste0('on/Outputs/ADA/on_train_potential_',
                       eventcat,'_vs_', refcat, '.csv'), 
                append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
    
    print('------------------------------------------')
    print('--------- Running Validations ------------')
    print('------------------------------------------')
    
    
    for (l in 1:5)
    {
      
      tst.on.mod <- tst.on
      ind.tst <- bigsample(1:nrow(tst.on.mod), size=10000, replace=F)
      val.tst.on <- tst.on.mod[ind.tst,]
      rm(tst.on.mod); gc();
      
      val.tst.on<-val.tst.on[c(-1)]
      val.tst.on[,1] <- ifelse(val.tst.on[,1]==eventcat,1,0)
      
      prob_tst<- predict(ada.model,val.tst.on[c(-1)],type="probs")
      pred_tst<- predict(ada.model,val.tst.on[c(-1)],type="vector")
      tnr.tst <- prop.table(table(pred_tst, val.tst.on[,1]),1)[1,1]
      tpr.tst <- prop.table(table(pred_tst, val.tst.on[,1]),1)[2,2]
      
      acc.tst <- 1/nrow(val.tst.on) * table(pred_tst, val.tst.on[,1])[1,1] + 
                 1/nrow(val.tst.on) * table(pred_tst, val.tst.on[,1])[2,2]
                 
    
      auc.tst <-auc(roc(prob_tst[,2], factor(val.tst.on[,1])))
      concordance.tst<-OptimisedConc(val.tst.on[,1],prob_tst[,2])
      print(paste(eventcat, s, c.list[j], l, 
                  tpr.tst, tnr.tst, acc.tst, auc.tst, concordance.tst))
      
      write.table(cbind(eventcat, s, c.list[j], l, tpr.tst, tnr.tst, acc.tst,
                        auc.tst, concordance.tst),
                  paste0('on/Outputs/ADA/on_test_potential_',
                         eventcat,'_vs_', refcat, '.csv'), 
                  append=TRUE, sep=",",row.names=FALSE,col.names=FALSE)
	  rm(val.tst.on);
      
    }
    
  }
  
}
