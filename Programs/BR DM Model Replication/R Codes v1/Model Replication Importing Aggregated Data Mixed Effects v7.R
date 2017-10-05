Sys.setenv(http_proxy="http://prox0xrcc.gap.com:80")

library(nlme)
library(lme4)
library(lattice)
library(rpart)

library(ROCR)
library(verification)

summary(ds1<-read.table(file= "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/BR_ALLCAMPAIGNS_BALANCED_1.txt",header=T,sep="|"))
summary(ds2<-read.table(file= "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/BR_ALLCAMPAIGNS_BALANCED_2.txt",header=T,sep="|"))
summary(ds3<-read.table(file= "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/BR_ALLCAMPAIGNS_BALANCED_3.txt",header=T,sep="|"))

rm(list=(ls()))

summary(df1<-read.table(file= "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/BR_ALLCAMPAIGNS_BALANCED_PRED_3.txt",header=T,sep="|"))

summary(df1.training<-subset(df1,TRAINING==1))
summary(df1.testing<-subset(df1,TRAINING==0))

summary(df2<-subset(df1,RAND<=1))
summary(df2.training<-subset(df2,TRAINING==1))
summary(df2.testing<-subset(df2,TRAINING==0))

#----------- Fitting Mixed Effects Logistic Regression fitted to the data -------------#

df2.training.lmer1 <-lmer(NEW_RESPONDER ~ NUM_TXNS_12MO_SLS + DIV_SHP_BR + YEARS_ON_BOOKS + PLCC_TXN_PCT +
				  BR_PROMOTIONS_RECEIVED_12MO + DAYS_LAST_PUR_BR + AVG_ORD_SZ_12MO +
				  NUM_TXNS_12MO_RTN + ONSALE_QTY_12MO + AVG_UNT_RTL + 
				 (NUM_TXNS_12MO_SLS + DAYS_LAST_PUR_BR + AVG_ORD_SZ_12MO | CLUSTER),
				  offset=OFFSET, family = "binomial", data =  df2.training)

summary(df2.training.lmer1)

summary(df2.training.lmer1.fitted <- fitted(df2.training.lmer1))

summary(df2.training.lmer1.observed <- df2.training$NEW_RESPONDER)

resid.df2.training.lmer1 <- resid(df2.training.lmer1)

ranef.df2.training.lmer1 <- ranef(df2.training.lmer1)

unlist.coef.df2.training.lmer1 <- unlist(coef.df2.training.lmer1 <- coef(df2.training.lmer1))

unlist.coef.df2.training.lmer1[4]

#----------------------------------------------------------------------------------------------------#

df2.training.cluster1 <- subset(df2.training, CLUSTER==1)
df2.training.cluster2 <- subset(df2.training, CLUSTER==2)
df2.training.cluster3 <- subset(df2.training, CLUSTER==3)
df2.training.cluster4 <- subset(df2.training, CLUSTER==4)


{
df2.training.cluster1 <- cbind(df2.training.cluster1, L_MIXED   <-  
					unlist.coef.df2.training.lmer1[1]  +
				      unlist.coef.df2.training.lmer1[5]  * df2.training.cluster1$NUM_TXNS_12MO_SLS +
				      unlist.coef.df2.training.lmer1[9]  * df2.training.cluster1$DIV_SHP_BR +
					unlist.coef.df2.training.lmer1[13] * df2.training.cluster1$PLCC_TXN_PCT +
					unlist.coef.df2.training.lmer1[17] * df2.training.cluster1$DAYS_LAST_PUR_BR +
					unlist.coef.df2.training.lmer1[21] * df2.training.cluster1$AVG_ORD_SZ_12MO +
					unlist.coef.df2.training.lmer1[25] * df2.training.cluster1$NUM_TXNS_12MO_RTN +
					unlist.coef.df2.training.lmer1[29] * df2.training.cluster1$ONSALE_QTY_12MO +
					unlist.coef.df2.training.lmer1[33] * df2.training.cluster1$AVG_UNT_RTL )
}

{
df2.training.cluster2 <- cbind(df2.training.cluster2, L_MIXED   <- 
					unlist.coef.df2.training.lmer1[2]  +
				      unlist.coef.df2.training.lmer1[6]  * df2.training.cluster2$NUM_TXNS_12MO_SLS +
				      unlist.coef.df2.training.lmer1[10] * df2.training.cluster2$DIV_SHP_BR +
					unlist.coef.df2.training.lmer1[14] * df2.training.cluster2$PLCC_TXN_PCT +
					unlist.coef.df2.training.lmer1[18] * df2.training.cluster2$DAYS_LAST_PUR_BR +
					unlist.coef.df2.training.lmer1[22] * df2.training.cluster2$AVG_ORD_SZ_12MO +
					unlist.coef.df2.training.lmer1[26] * df2.training.cluster2$NUM_TXNS_12MO_RTN +
					unlist.coef.df2.training.lmer1[30] * df2.training.cluster2$ONSALE_QTY_12MO +
					unlist.coef.df2.training.lmer1[34] * df2.training.cluster2$AVG_UNT_RTL )
}

{
df2.training.cluster3 <- cbind(df2.training.cluster3, L_MIXED   <-  
					unlist.coef.df2.training.lmer1[3]  +
				      unlist.coef.df2.training.lmer1[7]  * df2.training.cluster3$NUM_TXNS_12MO_SLS +
				      unlist.coef.df2.training.lmer1[11] * df2.training.cluster3$DIV_SHP_BR +
					unlist.coef.df2.training.lmer1[15] * df2.training.cluster3$PLCC_TXN_PCT +
					unlist.coef.df2.training.lmer1[19] * df2.training.cluster3$DAYS_LAST_PUR_BR +
					unlist.coef.df2.training.lmer1[23] * df2.training.cluster3$AVG_ORD_SZ_12MO +
					unlist.coef.df2.training.lmer1[27] * df2.training.cluster3$NUM_TXNS_12MO_RTN +
					unlist.coef.df2.training.lmer1[31] * df2.training.cluster3$ONSALE_QTY_12MO +
					unlist.coef.df2.training.lmer1[35] * df2.training.cluster3$AVG_UNT_RTL )
}

{
df2.training.cluster4 <- cbind(df2.training.cluster4, L_MIXED   <-  
					unlist.coef.df2.training.lmer1[4]  +
				      unlist.coef.df2.training.lmer1[8]  * df2.training.cluster4$NUM_TXNS_12MO_SLS +
				      unlist.coef.df2.training.lmer1[12] * df2.training.cluster4$DIV_SHP_BR +
					unlist.coef.df2.training.lmer1[16] * df2.training.cluster4$PLCC_TXN_PCT +
					unlist.coef.df2.training.lmer1[20] * df2.training.cluster4$DAYS_LAST_PUR_BR +
					unlist.coef.df2.training.lmer1[24] * df2.training.cluster4$AVG_ORD_SZ_12MO +
					unlist.coef.df2.training.lmer1[28] * df2.training.cluster4$NUM_TXNS_12MO_RTN +
					unlist.coef.df2.training.lmer1[32] * df2.training.cluster4$ONSALE_QTY_12MO +
					unlist.coef.df2.training.lmer1[36] * df2.training.cluster4$AVG_UNT_RTL )
}

summary(df2.training.cluster1)
summary(df2.training.cluster2)
summary(df2.training.cluster3)
summary(df2.training.cluster4)

summary(df2.training.cluster1.lmer1.fitted.p <- exp(df2.training.cluster1.lmer1.fitted) / (1 + exp(df2.training.cluster1.lmer1.fitted)))
summary(df2.training.cluster2.lmer1.fitted.p <- exp(df2.training.cluster2.lmer1.fitted) / (1 + exp(df2.training.cluster2.lmer1.fitted)))
summary(df2.training.cluster3.lmer1.fitted.p <- exp(df2.training.cluster3.lmer1.fitted) / (1 + exp(df2.training.cluster3.lmer1.fitted)))
summary(df2.training.cluster4.lmer1.fitted.p <- exp(df2.training.cluster4.lmer1.fitted) / (1 + exp(df2.training.cluster4.lmer1.fitted)))


#----------------------------------------------------------------------------------------------------#

df2.testing.cluster1 <- subset(df2.testing, CLUSTER==1)
df2.testing.cluster2 <- subset(df2.testing, CLUSTER==2)
df2.testing.cluster3 <- subset(df2.testing, CLUSTER==3)
df2.testing.cluster4 <- subset(df2.testing, CLUSTER==4)


{
df2.testing.cluster1.lmer1.fitted  <-  
					unlist.coef.df2.training.lmer1[1]  +
				      unlist.coef.df2.training.lmer1[5]  * df2.testing.cluster1$NUM_TXNS_12MO_SLS +
				      unlist.coef.df2.training.lmer1[9]  * df2.testing.cluster1$DIV_SHP_BR +
					unlist.coef.df2.training.lmer1[13] * df2.testing.cluster1$PLCC_TXN_PCT +
					unlist.coef.df2.training.lmer1[17] * df2.testing.cluster1$DAYS_LAST_PUR_BR +
					unlist.coef.df2.training.lmer1[21] * df2.testing.cluster1$AVG_ORD_SZ_12MO +
					unlist.coef.df2.training.lmer1[25] * df2.testing.cluster1$NUM_TXNS_12MO_RTN +
					unlist.coef.df2.training.lmer1[29] * df2.testing.cluster1$ONSALE_QTY_12MO +
					unlist.coef.df2.training.lmer1[33] * df2.testing.cluster1$AVG_UNT_RTL 
}

{
df2.testing.cluster2.lmer1.fitted  <-  
					unlist.coef.df2.training.lmer1[2]  +
				      unlist.coef.df2.training.lmer1[6]  * df2.testing.cluster2$NUM_TXNS_12MO_SLS +
				      unlist.coef.df2.training.lmer1[10] * df2.testing.cluster2$DIV_SHP_BR +
					unlist.coef.df2.training.lmer1[14] * df2.testing.cluster2$PLCC_TXN_PCT +
					unlist.coef.df2.training.lmer1[18] * df2.testing.cluster2$DAYS_LAST_PUR_BR +
					unlist.coef.df2.training.lmer1[22] * df2.testing.cluster2$AVG_ORD_SZ_12MO +
					unlist.coef.df2.training.lmer1[26] * df2.testing.cluster2$NUM_TXNS_12MO_RTN +
					unlist.coef.df2.training.lmer1[30] * df2.testing.cluster2$ONSALE_QTY_12MO +
					unlist.coef.df2.training.lmer1[34] * df2.testing.cluster2$AVG_UNT_RTL 
}

{
df2.testing.cluster3.lmer1.fitted  <-  
					unlist.coef.df2.training.lmer1[3]  +
				      unlist.coef.df2.training.lmer1[7]  * df2.testing.cluster3$NUM_TXNS_12MO_SLS +
				      unlist.coef.df2.training.lmer1[11] * df2.testing.cluster3$DIV_SHP_BR +
					unlist.coef.df2.training.lmer1[15] * df2.testing.cluster3$PLCC_TXN_PCT +
					unlist.coef.df2.training.lmer1[19] * df2.testing.cluster3$DAYS_LAST_PUR_BR +
					unlist.coef.df2.training.lmer1[23] * df2.testing.cluster3$AVG_ORD_SZ_12MO +
					unlist.coef.df2.training.lmer1[27] * df2.testing.cluster3$NUM_TXNS_12MO_RTN +
					unlist.coef.df2.training.lmer1[31] * df2.testing.cluster3$ONSALE_QTY_12MO +
					unlist.coef.df2.training.lmer1[35] * df2.testing.cluster3$AVG_UNT_RTL 
}

{
df2.testing.cluster4.lmer1.fitted  <-  
					unlist.coef.df2.training.lmer1[4]  +
				      unlist.coef.df2.training.lmer1[8]  * df2.testing.cluster4$NUM_TXNS_12MO_SLS +
				      unlist.coef.df2.training.lmer1[12] * df2.testing.cluster4$DIV_SHP_BR +
					unlist.coef.df2.training.lmer1[16] * df2.testing.cluster4$PLCC_TXN_PCT +
					unlist.coef.df2.training.lmer1[20] * df2.testing.cluster4$DAYS_LAST_PUR_BR +
					unlist.coef.df2.training.lmer1[24] * df2.testing.cluster4$AVG_ORD_SZ_12MO +
					unlist.coef.df2.training.lmer1[28] * df2.testing.cluster4$NUM_TXNS_12MO_RTN +
					unlist.coef.df2.training.lmer1[32] * df2.testing.cluster4$ONSALE_QTY_12MO +
					unlist.coef.df2.training.lmer1[36] * df2.testing.cluster4$AVG_UNT_RTL
}

summary(df2.testing.cluster1.lmer1.fitted)
summary(df2.testing.cluster2.lmer1.fitted)
summary(df2.testing.cluster3.lmer1.fitted)
summary(df2.testing.cluster4.lmer1.fitted)

summary(df2.testing.cluster1.lmer1.fitted.p <- exp(df2.testing.cluster1.lmer1.fitted) / (1 + exp(df2.testing.cluster1.lmer1.fitted)))
summary(df2.testing.cluster2.lmer1.fitted.p <- exp(df2.testing.cluster2.lmer1.fitted) / (1 + exp(df2.testing.cluster2.lmer1.fitted)))
summary(df2.testing.cluster3.lmer1.fitted.p <- exp(df2.testing.cluster3.lmer1.fitted) / (1 + exp(df2.testing.cluster3.lmer1.fitted)))
summary(df2.testing.cluster4.lmer1.fitted.p <- exp(df2.testing.cluster4.lmer1.fitted) / (1 + exp(df2.testing.cluster4.lmer1.fitted)))

#---------------------------------------------------------------------------------------------------------------------------------------#
df2.testing.lmer1.fitted <- rbind(df2.testing.cluster1.lmer1.fitted,df2.testing.cluster2.lmer1.fitted,df2.testing.cluster3.lmer1.fitted,df2.testing.cluster4.lmer1.fitted)
						

#---------------------------------------------------------------------------------------------------------------------------------------#

pdf(file="//10.8.8.51/lv0/Tanumoy/Outputs/BR Model Replication/GRAPHS ALL SAMPLES BALANCED MIXED & FIXED EFFECTS LOGISTIC.pdf",height=16, width=9,bg="white")
par(mfrow=c(1,1))

#----------- Produce Receiver Operating Characteristic (ROC) Curves for Mixed Effects Logistic Regression fitted to the data -------------#

prediction.df2.training.lmer1.pred <- summary(prediction(df2.training.lmer1.fitted, df2.training.lmer1.observed))
performance.roc.df2.training.lmer1.pred <- performance(prediction.df2.training.lmer1.pred, "tpr","fpr")
roc.area.df2.training.lmer1.pred <- roc.area( df2.training.lmer1.observed, df2.training.lmer1.fitted)
labels.df2.training.lmer1.pred <- paste("Training: Mixed Effects AUC=",round(roc.area.df2.training.lmer1.pred$A,5))

plot(performance.roc.df2.training.lmer1.pred , avg = "threshold", col = "Red", typ="b", lwd = 2, lty=10, main = "ROC Curves for Mixed Effects vs Fixed Effects")
par(new=T)

#----------- Fitting Fixed Effects Logistic Regression fitted to the data -------------#

df2.training.lme1 <- glm (NEW_RESPONDER ~ NUM_TXNS_12MO_SLS + DIV_SHP_BR + YEARS_ON_BOOKS + PLCC_TXN_PCT +
				  BR_PROMOTIONS_RECEIVED_12MO + DAYS_LAST_PUR_BR + AVG_ORD_SZ_12MO +
				  NUM_TXNS_12MO_RTN + ONSALE_QTY_6MO + AVG_UNT_RTL,
				  offset=OFFSET, family=binomial(link="logit"), data =  df2.training)

summary(df2.training.lme1)

exp(df2.training.lme1$coeff)

prob.df2.training <- predict(df2.training.lme1, df2.training, type="response")

summary(df2.training.lme1.fitted <- prob.df2.training)

summary(df2.training.lme1.observed <- df2.training$NEW_RESPONDER)

#----------- Produce Receiver Operating Characteristic (ROC) Curves for Fixed Effects Logistic Regression fitted to the data -------------#

prediction.df2.training.lme1.pred <- prediction(df2.training.lme1.fitted, df2.training.lme1.observed)
performance.roc.df2.training.lme1.pred <- performance(prediction.df2.training.lme1.pred, "tpr","fpr")
roc.area.df2.training.lme1.pred <- roc.area( df2.training.lme1.observed, df2.training.lme1.fitted)
labels.df2.training.lme1.pred <- paste("Training: Fixed Effects AUC=",round(roc.area.df2.training.lme1.pred$A,5))

plot(performance.roc.df2.training.lme1.pred , avg = "threshold", col = "Blue", typ="b", lwd = 2, lty=10, main = "ROC Curves for Mixed Effects vs Fixed Effects")
par(new=T)


grid(lty=3,lwd=1,col="gray60",equilogs = T)

legend("topleft", c(labels.df2.training.lmer1.pred,labels.df2.training.lme1.pred), lty=c(10,10), lwd=c(2,2), col=c("Red","Blue"), bty="o", box.lty=2) 

box()

#--------------------------------- Produce Lift Curves for the Mixed Effects and Fixed Effects models fitted to the data ---------------------------------#


performance.lift.df2.training.lmer1.pred<- performance(prediction.df2.training.lmer1.pred, "lift", "rpp")
performance.lift.df2.training.lme1.pred<- performance(prediction.df2.training.lme1.pred, "lift", "rpp")

xvalues.training.lmer1<-unlist(attributes(performance.lift.df2.training.lmer1.pred)[[4]])
yvalues.training.lmer1<-unlist(attributes(performance.lift.df2.training.lmer1.pred)[[5]])

max.xaxis.training.lmer1<-max(subset(xvalues.training.lmer1,xvalues.training.lmer1>0))
max.yaxis.training.lmer1<-max(subset(yvalues.training.lmer1,yvalues.training.lmer1>0))

xvalues.training.lme1<-unlist(attributes(performance.lift.df2.training.lme1.pred)[[4]])
yvalues.training.lme1<-unlist(attributes(performance.lift.df2.training.lme1.pred)[[5]])

max.xaxis.training.lme1<-max(subset(xvalues.training.lme1,xvalues.training.lme1>0))
max.yaxis.training.lme1<-max(subset(yvalues.training.lme1,yvalues.training.lme1>0))

max.xaxis=max(max.xaxis.training.lmer1,max.xaxis.training.lme1)
max.yaxis=max(max.yaxis.training.lmer1,max.yaxis.training.lme1)

plot(performance.lift.df2.training.lmer1.pred, avg = "threshold", xlim=c(0,max.xaxis), ylim=c(0,max.yaxis), col="Red", lty=10, lwd = 2, main = "Cum Lift for Mixed Effects vs Fixed Effects")
par(new=T)

plot(performance.lift.df2.training.lme1.pred, avg = "threshold", xlim=c(0,max.xaxis), ylim=c(0,max.yaxis), col="Blue", lty=10, lwd = 2, main = "Cum Lift for Mixed Effects vs Fixed Effects")

par(new=F)

grid(lty=3,lwd=1,col="gray60",equilogs = T)

legend("topright", c("Lift Curve for Mixed Effects","Lift Curve for Fixed Effects"), lty=c(10,10), lwd=c(2,2), col=c("Red","Blue"), bty="o", box.lty=2)

box()


#------------------------------------------- Produce Gains Charts for the Mixed Effects and Fixed Effects models fitted to the data -----------------------------------------------------------#


plot(performance(prediction(df2.training.lmer1.fitted, df2.training.lmer1.observed), "tpr", "rpp"),lwd = 2, col = "Red", lty=10, main = paste("Gains Charts for Mixed Effects vs Fixed Effects"))
par(new=T)

plot(performance(prediction(df2.training.lme1.fitted, df2.training.lme1.observed), "tpr", "rpp"),lwd = 2, col = "Blue", lty=10, main = paste("Gains Charts for Mixed Effects vs Fixed Effects"))
par(new=T)

grid(lty=3,lwd=1,col="gray60",equilogs = T)

legend("topright", c("Gains Chart for Mixed Effects","Gains Chart for Fixed Effects"), lty=c(10,10), lwd=c(2,2), col=c("Red","Blue"), bty="o", box.lty=2)

box()


dev.off() 


P_MIXED <- df2.training.lmer1.fitted
P_FIXED <- df2.training.lme1.fitted

df2.training <- cbind(df2.training, P_MIXED, P_FIXED)

write.table(df2.training, file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/BR_ALLCAMPAIGNS_BALANCED_RAND.txt", col.names= T, row.names= F,sep= "|")

