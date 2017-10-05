load("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model.RData")

ds1<-read.table(file= "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/BR_ALLCAMPAIGNS_BALANCED_1.txt",header=T,sep="|")

summary(ds1)

ds3<-read.table(file= "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/BR_ALLCAMPAIGNS_BALANCED_3.txt",header=T,sep="|")

summary(ds3)

ds3$CARD_STATUS <- as.factor(ds3$CARD_STATUS)

df1.training<-subset(ds3,TRAINING==1)
df1.testing<-subset(ds3,TRAINING==0)

df1.testing<-
  
  subset(df1.testing,
         select = c(AVG_ORD_SZ_12MO,
                    AVG_ORD_SZ_12MO,
                    AVG_ORD_SZ_12MO_CP,
                    AVG_ORD_SZ_12MO_PLCC,
                    AVG_ORD_SZ_PROMO_12MO,
                    AVG_ORD_SZ_SLS,
                    AVG_UNT_RTL_12MO,
                    AVG_UNT_RTL_12MO_CP,
                    AVG_UNT_RTL_6MO,
                    AVG_UNT_RTL_6MO_CP,
                    SILVER_FLAG,
                    SISTER_FLAG,
                    BASIC_FLAG,
                    BR_PROMOTIONS_RECEIVED_12MO,
                    CAMPAIGN,
                    CARD_STATUS,
                    CUSTOMER_KEY,
                    DAYS_LAST_PUR_BR,
                    DAYS_LAST_PUR_CP,
                    DISCOUNT_PCT_SLS,
                    DISCOUNT_PCT_12MO,
                    DISCOUNT_SLS_PROMO_12MO,
                    DIV_SHP_BR,
                    DIV_SHP_BR_PCT,
                    ITEM_QTY_12MO_ONSL,
                    ITEM_QTY_12MO_PLCC,
                    ITEM_QTY_12MO_RTN,
                    ITEM_QTY_12MO_SLS,
                    ITEM_QTY_1,
                    ITEM_QTY_2,
                    ITEM_QTY_3,
                    ITEM_QTY_4,
                    ITEM_QTY_6MO_ONSL,
                    ITEM_QTY_6MO_PLCC,
                    ITEM_QTY_6MO_RTN,
                    ITEM_QTY_6MO_SLS,
                    ITEM_QTY_PCT1,
                    ITEM_QTY_PCT2,
                    ITEM_QTY_PCT3,
                    ITEM_QTY_PCT4,
                    LENGTH_PROMO,
                    NET_SALES_AMT,
                    NET_SALES_AMT_12MO_ONSL,
                    NET_SALES_AMT_12MO_PLCC,
                    NET_SALES_AMT_12MO_RTN,
                    NET_SALES_AMT_12MO_RTN_CP,
                    NET_SALES_AMT_12MO_RTN_OTH,
                    NET_SALES_AMT_12MO_SLS,
                    NET_SALES_AMT_12MO_SLS_CP,
                    NET_SALES_AMT_12MO_SLS_OTH,
                    NET_SALES_AMT_1,
                    NET_SALES_AMT_2,
                    NET_SALES_AMT_3,
                    NET_SALES_AMT_4,
                    NET_SALES_AMT_6MO_ONSL,
                    NET_SALES_AMT_6MO_PLCC,
                    NET_SALES_AMT_6MO_RTN,
                    NET_SALES_AMT_6MO_RTN_CP,
                    NET_SALES_AMT_6MO_RTN_OTH,
                    NET_SALES_AMT_6MO_SLS,
                    NET_SALES_AMT_6MO_SLS_CP,
                    NET_SALES_AMT_6MO_SLS_OTH,
                    NET_SALES_AMT_PCT1,
                    NET_SALES_AMT_PCT2,
                    NET_SALES_AMT_PCT3,
                    NET_SALES_AMT_PCT4,
                    NET_SALES_AMT_SLS,
                    NET_SALES_AMT_PCT,
                    NET_SALES_SLS_PROMO_12MO,
                    NUM_PLCC_TXNS_12MO_SLS,
                    NUM_TXNS_12MO_RTN,
                    NUM_TXNS_12MO_SLS,
                    NUM_TXNS_SLS_PROMO_12MO,
                    OFFSET,
                    PROMO_NET_SALES_PCT_12MO,
                    PROMO_TXN_PCT_12MO,
                    PLCC_TXN_PCT_6MO,
                    PLCC_TXN_PCT_12MO,
                    RESPONDER,
                    RETURN_PCT_6MO,
                    RETURN_PCT_12MO,
                    RESPONSE_RATE_12MO,
                    TESTING,
                    TRAINING,
                    UNITS_PER_TXN_12MO_SLS,
                    WT,
                    YEARS_ON_BOOKS
         ))

df1.training<- 
  
  subset(df1.training,
         select = c(AVG_ORD_SZ_12MO,
                    AVG_ORD_SZ_12MO,
                    AVG_ORD_SZ_12MO_CP,
                    AVG_ORD_SZ_12MO_PLCC,
                    AVG_ORD_SZ_PROMO_12MO,
                    AVG_ORD_SZ_SLS,
                    AVG_UNT_RTL_12MO,
                    AVG_UNT_RTL_12MO_CP,
                    AVG_UNT_RTL_6MO,
                    AVG_UNT_RTL_6MO_CP,
                    SILVER_FLAG,
                    SISTER_FLAG,
                    BASIC_FLAG,
                    BR_PROMOTIONS_RECEIVED_12MO,
                    CAMPAIGN,
                    CARD_STATUS,
                    CUSTOMER_KEY,
                    DAYS_LAST_PUR_BR,
                    DAYS_LAST_PUR_CP,
                    DISCOUNT_PCT_SLS,
                    DISCOUNT_PCT_12MO,
                    DISCOUNT_SLS_PROMO_12MO,
                    DIV_SHP_BR,
                    DIV_SHP_BR_PCT,
                    ITEM_QTY_12MO_ONSL,
                    ITEM_QTY_12MO_PLCC,
                    ITEM_QTY_12MO_RTN,
                    ITEM_QTY_12MO_SLS,
                    ITEM_QTY_1,
                    ITEM_QTY_2,
                    ITEM_QTY_3,
                    ITEM_QTY_4,
                    ITEM_QTY_6MO_ONSL,
                    ITEM_QTY_6MO_PLCC,
                    ITEM_QTY_6MO_RTN,
                    ITEM_QTY_6MO_SLS,
                    ITEM_QTY_PCT1,
                    ITEM_QTY_PCT2,
                    ITEM_QTY_PCT3,
                    ITEM_QTY_PCT4,
                    LENGTH_PROMO,
                    NET_SALES_AMT,
                    NET_SALES_AMT_12MO_ONSL,
                    NET_SALES_AMT_12MO_PLCC,
                    NET_SALES_AMT_12MO_RTN,
                    NET_SALES_AMT_12MO_RTN_CP,
                    NET_SALES_AMT_12MO_RTN_OTH,
                    NET_SALES_AMT_12MO_SLS,
                    NET_SALES_AMT_12MO_SLS_CP,
                    NET_SALES_AMT_12MO_SLS_OTH,
                    NET_SALES_AMT_1,
                    NET_SALES_AMT_2,
                    NET_SALES_AMT_3,
                    NET_SALES_AMT_4,
                    NET_SALES_AMT_6MO_ONSL,
                    NET_SALES_AMT_6MO_PLCC,
                    NET_SALES_AMT_6MO_RTN,
                    NET_SALES_AMT_6MO_RTN_CP,
                    NET_SALES_AMT_6MO_RTN_OTH,
                    NET_SALES_AMT_6MO_SLS,
                    NET_SALES_AMT_6MO_SLS_CP,
                    NET_SALES_AMT_6MO_SLS_OTH,
                    NET_SALES_AMT_PCT1,
                    NET_SALES_AMT_PCT2,
                    NET_SALES_AMT_PCT3,
                    NET_SALES_AMT_PCT4,
                    NET_SALES_AMT_SLS,
                    NET_SALES_AMT_PCT,
                    NET_SALES_SLS_PROMO_12MO,
                    NUM_PLCC_TXNS_12MO_SLS,
                    NUM_TXNS_12MO_RTN,
                    NUM_TXNS_12MO_SLS,
                    NUM_TXNS_SLS_PROMO_12MO,
                    OFFSET,
                    PROMO_NET_SALES_PCT_12MO,
                    PROMO_TXN_PCT_12MO,
                    PLCC_TXN_PCT_6MO,
                    PLCC_TXN_PCT_12MO,
                    RESPONDER,
                    RETURN_PCT_6MO,
                    RETURN_PCT_12MO,
                    RESPONSE_RATE_12MO,
                    TESTING,
                    TRAINING,
                    UNITS_PER_TXN_12MO_SLS,
                    WT,
                    YEARS_ON_BOOKS
         ))

df1.validation <- 
  
  subset(df1,
         select = c(AVG_ORD_SZ_12MO,
                    AVG_ORD_SZ_12MO,
                    AVG_ORD_SZ_12MO_CP,
                    AVG_ORD_SZ_12MO_PLCC,
                    AVG_ORD_SZ_PROMO_12MO,
                    AVG_ORD_SZ_SLS,
                    AVG_UNT_RTL_12MO,
                    AVG_UNT_RTL_12MO_CP,
                    AVG_UNT_RTL_6MO,
                    AVG_UNT_RTL_6MO_CP,
                    SILVER_FLAG,
                    SISTER_FLAG,
                    BASIC_FLAG,
                    BR_PROMOTIONS_RECEIVED_12MO,
                    CAMPAIGN,
                    CARD_STATUS,
                    CUSTOMER_KEY,
                    DAYS_LAST_PUR_BR,
                    DAYS_LAST_PUR_CP,
                    DISCOUNT_PCT_SLS,
                    DISCOUNT_PCT_12MO,
                    DISCOUNT_SLS_PROMO_12MO,
                    DIV_SHP_BR,
                    DIV_SHP_BR_PCT,
                    ITEM_QTY_12MO_ONSL,
                    ITEM_QTY_12MO_PLCC,
                    ITEM_QTY_12MO_RTN,
                    ITEM_QTY_12MO_SLS,
                    ITEM_QTY_1,
                    ITEM_QTY_2,
                    ITEM_QTY_3,
                    ITEM_QTY_4,
                    ITEM_QTY_6MO_ONSL,
                    ITEM_QTY_6MO_PLCC,
                    ITEM_QTY_6MO_RTN,
                    ITEM_QTY_6MO_SLS,
                    ITEM_QTY_PCT1,
                    ITEM_QTY_PCT2,
                    ITEM_QTY_PCT3,
                    ITEM_QTY_PCT4,
                    LENGTH_PROMO,
                    NET_SALES_AMT,
                    NET_SALES_AMT_12MO_ONSL,
                    NET_SALES_AMT_12MO_PLCC,
                    NET_SALES_AMT_12MO_RTN,
                    NET_SALES_AMT_12MO_RTN_CP,
                    NET_SALES_AMT_12MO_RTN_OTH,
                    NET_SALES_AMT_12MO_SLS,
                    NET_SALES_AMT_12MO_SLS_CP,
                    NET_SALES_AMT_12MO_SLS_OTH,
                    NET_SALES_AMT_1,
                    NET_SALES_AMT_2,
                    NET_SALES_AMT_3,
                    NET_SALES_AMT_4,
                    NET_SALES_AMT_6MO_ONSL,
                    NET_SALES_AMT_6MO_PLCC,
                    NET_SALES_AMT_6MO_RTN,
                    NET_SALES_AMT_6MO_RTN_CP,
                    NET_SALES_AMT_6MO_RTN_OTH,
                    NET_SALES_AMT_6MO_SLS,
                    NET_SALES_AMT_6MO_SLS_CP,
                    NET_SALES_AMT_6MO_SLS_OTH,
                    NET_SALES_AMT_PCT1,
                    NET_SALES_AMT_PCT2,
                    NET_SALES_AMT_PCT3,
                    NET_SALES_AMT_PCT4,
                    NET_SALES_AMT_SLS,
                    NET_SALES_AMT_PCT,
                    NET_SALES_SLS_PROMO_12MO,
                    NUM_PLCC_TXNS_12MO_SLS,
                    NUM_TXNS_12MO_RTN,
                    NUM_TXNS_12MO_SLS,
                    NUM_TXNS_SLS_PROMO_12MO,
                    OFFSET,
                    PROMO_NET_SALES_PCT_12MO,
                    PROMO_TXN_PCT_12MO,
                    PLCC_TXN_PCT_6MO,
                    PLCC_TXN_PCT_12MO,
                    RESPONDER,
                    RETURN_PCT_6MO,
                    RETURN_PCT_12MO,
                    RESPONSE_RATE_12MO,
                    TESTING,
                    TRAINING,
                    UNITS_PER_TXN_12MO_SLS,
                    WT,
                    YEARS_ON_BOOKS
         ))



summary(df1.testing)
summary(df1.training)
summary(df1.validation)

save.image("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model.RData")

rm(ds3, ds1)

library(ROCR)
library(verification)

prop <- sum(df1.training$RESPONDER)/length(df1.training$RESPONDER)

#----------------------------------- Logistic Regression -------------------------------------------

logit1 <- glm(  RESPONDER ~ NUM_TXNS_12MO_SLS +
                DIV_SHP_BR_PCT +
                YEARS_ON_BOOKS +
                NET_SALES_AMT_PCT +
                BR_PROMOTIONS_RECEIVED_12MO +
                DAYS_LAST_PUR_BR +
                AVG_ORD_SZ_12MO +
                RETURN_PCT_12MO +
                AVG_UNT_RTL_12MO +
                RESPONSE_RATE_12MO +
                NET_SALES_AMT_12MO_ONSL +
                PLCC_TXN_PCT_12MO +
                PROMO_TXN_PCT_12MO +
                CARD_STATUS,
                data=df1.training, family=binomial("logit"))

summary(logit1)

exp(coef(logit1))


table(df1.validation$RESPONDER)

table(df1.validation$NONRESPONDER <- ifelse(df1.validation$RESPONDER == 1, 0, 1))

correct <- sum(df1.validation$RESPONDER* (predict(logit1, df1.validation, type="response") >= prop)) + sum(df1.validation$NONRESPONDER* (predict(logit1, df1.validation, type="response") < prop))

tot <- sum(df1.validation$RESPONDER) + sum(df1.validation$NONRESPONDER)

correct/tot

df1.validation<-subset(df1.validation,select=-c(NONRESPONDER))



summary(pred.df1.validation.logit<-predict(logit1, df1.validation, type="response"))

pred.df1.validation.logit <- ifelse(pred.df1.validation.logit < prop, 0, 1)

prop.table(table(df1.validation$RESPONDER, pred.df1.validation.logit))

prop.table(table(df1.validation$RESPONDER, pred.df1.validation.logit),1)


PRED_PROB <- predict(logit1, df1.validation, type="response")

PRED_RESP <- ifelse(PRED_PROB < prop, 0, 1)

summary(pred.df1.validation.logit <- cbind(df1.validation, PRED_PROB, PRED_RESP))

save.image("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model.RData")

#----------------------------------- Support Vector Machines -------------------------------------------

library(kernlab)
library(e1071)
srange<-sigest(RESPONDER~.,data = df3.training)

df4.training <- cbind(df3.training, RAND<-runif(nrow(df3.training),0,1))
df4.training <- subset(df3.training, RAND<=0.1)

summary(df4.training)

dim(df1.training <-  subset(df4.training, select=c(RESPONDER, NUM_TXNS_12MO_SLS, DIV_SHP_BR, YEARS_ON_BOOKS, RESPONSE_RATE_12MO,
                                                   BR_PROMOTIONS_RECEIVED_12MO, DAYS_LAST_PUR_BR, AVG_ORD_SZ_12MO,
                                                   NUM_TXNS_12MO_RTN, ONSALE_QTY_12MO, AVG_UNT_RTL, DISCOUNT_PCT_OFFER)))


tobj <- tune.svm(RESPONDER ~ ., data = df4.training, gamma = 10^(-5:0), cost = 10^(0:2))
summary(tobj)
plot(tobj, transform.x = log10, xlab = expression(log[10](gamma)), ylab = "C")

bestGamma <- tobj$best.parameters[[1]]
bestC <- tobj$best.parameters[[2]]

svm1 <- svm(as.factor(RESPONDER) ~ ., data = df4.training, kernel="radial", 
            probability=T, cost = bestC, gamma = bestGamma, cross = 10, type="C")
summary(svm1)

summary(pred.df1.validation.svm<-predict(svm1, df1.validation, probability=T, decision.values=T))

summary(attr(pred.df1.validation.svm, "probabilities"))

summary(attr(pred.df1.validation.svm, "decision.values"))



table(df1.validation$RESPONDER)

table(df1.validation$NONRESPONDER <- ifelse(df1.validation$RESPONDER == 1, 0, 1))

correct <- sum(df1.validation$RESPONDER* (attr(pred.df1.validation.svm, "probabilities") [,1] >= prop)) + sum(df1.validation$NONRESPONDER* (attr(pred.df1.validation.svm, "probabilities") [,1] < prop))

tot <- sum(df1.validation$RESPONDER) + sum(df1.validation$NONRESPONDER)

correct/tot

df1.validation<-subset(df1.validation,select=-c(NONRESPONDER))



pred.df1.validation.svm <-p

prop.table(table(df1.validation$RESPONDER, pred.df1.validation.svm))

prop.table(table(df1.validation$RESPONDER, pred.df1.validation.svm),1)


PRED_PROB <- attr(pred.df1.validation.svm, "probabilities") [,1]

PRED_RESP <- pred.df1.validation.svm

summary(pred.df1.validation.svm <- cbind(df1.validation, PRED_PROB, PRED_RESP))


save.image("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model.RData")

#----------------------------------- Adaptive Boosting Algorithm -------------------------------------------


library(ada)

adaboost1<-ada(RESPONDER ~ ., data=df3.training, iter=100,loss="l", type="discrete", bag.frac=prop, nu=0.1)

varplot(adaboost1)

adaboost1<-addtest(adaboost1,df1.validation[,-1],df1.validation[,1])

summary(adaboost1)

plot(adaboost1,F,T)

table(df1.validation$RESPONDER)

table(df1.validation$NONRESPONDER <- ifelse(df1.validation$RESPONDER == 1, 0, 1))

correct <- sum(df1.validation$RESPONDER* (predict(adaboost1, df1.validation, type="probs")[,2] >= prop)) + sum(df1.validation$NONRESPONDER* (predict(adaboost1, df1.validation, type="probs")[,2] < prop))

tot <- sum(df1.validation$RESPONDER) + sum(df1.validation$NONRESPONDER)

correct/tot

df1.validation<-subset(df1.validation,select=-c(NONRESPONDER))


summary(pred.df1.validation.ada<-predict(adaboost1, df1.validation, type="vector"))

prop.table(table(df1.validation$RESPONDER, pred.df1.validation.ada))

prop.table(table(df1.validation$RESPONDER, pred.df1.validation.ada),1)


PRED_PROB <- predict(adaboost1,df1.validation,"probs")[,2]

PRED_RESP <- predict(adaboost1,df1.validation,"vector")

summary(pred.df1.validation.ada <- cbind(df1.validation, PRED_PROB, PRED_RESP))

#----------------------------------- Random Forest Algorithm -------------------------------------------

library(randomForest)

randomForest1<-randomForest(as.factor(RESPONDER) ~ ., data=df3.training, importance=T, proximity=F, type="classification")

print(randomForest1)

varImpPlot(randomForest1)

plot(randomForest1)

getTree(randomForest1)

table(df1.validation$RESPONDER)

table(df1.validation$NONRESPONDER <- ifelse(df1.validation$RESPONDER == 1, 0, 1))

correct <- sum(df1.validation$RESPONDER* (predict(randomForest1, df1.validation, type="prob")[,2] >= prop)) + sum(df1.validation$NONRESPONDER* (predict(randomForest1, df1.validation, type="prob")[,2] < prop))

tot <- sum(df1.validation$RESPONDER) + sum(df1.validation$NONRESPONDER)

correct/tot

df1.validation<-subset(df1.validation,select=-c(NONRESPONDER))


summary(pred.df1.validation.rf<-predict(randomForest1, df1.validation, type="response"))

prop.table(table(df1.validation$RESPONDER, pred.df1.validation.rf))

prop.table(table(df1.validation$RESPONDER, pred.df1.validation.rf),1)


PRED_PROB <- predict(randomForest1,df1.validation,"prob")[,2]

PRED_RESP <- predict(randomForest1,df1.validation,"response")

summary(pred.df1.validation.rf <- cbind(df1.validation, PRED_PROB, PRED_RESP))




#--------------------------------- Decision Trees from Party package -----------------------------------------

library(party)

library(partykit)

library(Formula)

ctree1 <- ctree(as.factor(RESPONDER) ~ ., data=df3.training)

pdf(file="//10.8.8.51/lv0/Tanumoy/Graphs/CONDITIONAL INFERENCE TREE.pdf",height=20, width=50,bg="white")
par(mfrow=c(1,1))

plot(ctree1 , main="Conditional Inference Tree for Response")

dev.off()

summary(predict(ctree1 , df3.training, type="prob")
        
        
        table(df1.validation$RESPONDER)
        
        table(df1.validation$NONRESPONDER <- ifelse(df1.validation$RESPONDER == 1, 0, 1))
        
        correct <- sum(df1.validation$RESPONDER* (predict(ctree1, df1.validation, type="prob")[,2] >= prop)) + sum(df1.validation$NONRESPONDER* (predict(ctree1, df1.validation, type="prob")[,2] < prop))
        
        tot <- sum(df1.validation$RESPONDER) + sum(df1.validation$NONRESPONDER)
        
        correct/tot
        
        df1.validation<-subset(df1.validation,select=-c(NONRESPONDER))
        
        
        
        
        
        summary(pred.df1.validation.ctree<-as.factor(predict(ctree1, df1.validation, type="response")))
        
        prop.table(table(df1.validation$RESPONDER, pred.df1.validation.ctree))
        
        prop.table(table(df1.validation$RESPONDER, pred.df1.validation.ctree),1)
        
        
        
        
        
        summary(PRED_PROB <- as.numeric(predict(ctree1, df1.validation, type="prob")[,2]))
        
        summary(PRED_RESP <- as.factor(predict(ctree1, df1.validation, type="response")))
        
        summary(pred.df1.validation.ctree <- cbind(df1.validation, PRED_PROB, PRED_RESP))
        
        
        #--------------------------------- C 5.0 Classification Tree using C50 package -----------------------------------------
        
        library(C50)
        
        costmatrix <- matrix(c(0,1,2,0), nrow = 2, ncol=2, dimnames = list(c("0", "1"), c("0", "1")))
        
        c50_1 <- C5.0(as.factor(RESPONDER) ~ ., data=df3.training)
        
        c50_1 <- C5.0(as.factor(RESPONDER) ~ ., data=df3.training, costs=costmatrix)
        
        summary(c50_1)
        
        plot(c50_1)
        
        print(c50_1.imp <- C5imp(c50_1))
        
        summary(predict(c50_1, df3.training, type="prob"))
        
        
        
        
        table(df1.validation$RESPONDER)
        
        table(df1.validation$NONRESPONDER <- ifelse(df1.validation$RESPONDER == 1, 0, 1))
        
        correct <- sum(df1.validation$RESPONDER* (predict(c50_1, df1.validation, type="prob")[,2] >= prop)) + sum(df1.validation$NONRESPONDER* (predict(c50_1, df1.validation, type="prob")[,2] < prop))
        
        tot <- sum(df1.validation$RESPONDER) + sum(df1.validation$NONRESPONDER)
        
        correct/tot
        
        df1.validation<-subset(df1.validation,select=-c(NONRESPONDER))
        
        
        
        
        
        summary(pred.df1.validation.c50_1<-as.factor(predict(c50_1, df1.validation, type="class")))
        
        prop.table(table(df1.validation$RESPONDER, pred.df1.validation.c50_1))
        
        prop.table(table(df1.validation$RESPONDER, pred.df1.validation.c50_1),1)
        
        
        
        
        summary(PRED_RESP<-as.numeric(predict(c50_1, df1.validation, type="prob")[,2]))
        
        summary(PRED_RESP<-as.factor(predict(c50_1, df1.validation, type="class")))
        
        summary(pred.df1.validation.c50_1 <- cbind(df1.validation, PRED_PROB, PRED_RESP))
        
        
        
        
        #----------------------------------- Neural Networks Classifier -------------------------------------------
        
        library(nnet)
        
        nnet1 <- nnet(as.factor(RESPONDER) ~ ., df3.training, size=5, rang = 0.1, decay = 5e-4, maxit = 200)
        
        summary(nnet1)
        
        predict(nnet1, df3.training)
        
        
        
        
        table(df1.validation$RESPONDER)
        
        table(df1.validation$NONRESPONDER <- ifelse(df1.validation$RESPONDER == 1, 0, 1))
        
        correct <- sum(df1.validation$RESPONDER* (predict(nnet1, df1.validation, type="raw") >= prop)) + sum(df1.validation$NONRESPONDER* (predict(nnet1, df1.validation, type="raw") < prop))
        
        tot <- sum(df1.validation$RESPONDER) + sum(df1.validation$NONRESPONDER)
        
        correct/tot
        
        df1.validation<-subset(df1.validation,select=-c(NONRESPONDER))
        
        
        
        
        
        summary(pred.df1.validation.nnet<-as.factor(predict(nnet1, df1.validation, type="class")))
        
        prop.table(table(df1.validation$RESPONDER, pred.df1.validation.nnet))
        
        prop.table(table(df1.validation$RESPONDER, pred.df1.validation.nnet),1)
        
        
        
        
        
        summary(PRED_PROB <- as.numeric(predict(nnet1, df1.validation, type="raw")))
        
        summary(PRED_RESP <- as.factor(predict(nnet1, df1.validation, type="class")))
        
        summary(pred.df1.validation.nnet <- cbind(df1.validation, PRED_PROB, PRED_RESP))
        
        
        #----------- Produce Receiver Operating Characteristic (ROC) Curves for the models fitted to the data -------------#
        
        
        
        prediction.pred.df1.validation.rf <- prediction(pred.df1.validation.rf$PRED_PROB,pred.df1.validation.rf$RESPONDER)
        
        performance.roc.pred.df1.validation.rf <- performance(prediction.pred.df1.validation.rf, "tpr","fpr")
        roc.area.pred.df1.validation.rf <- roc.area(pred.df1.validation.rf$RESPONDER,pred.df1.validation.rf$PRED_PROB)
        labels.pred.df1.validation.rf <- paste("Random Forest: AUC=",round(roc.area.pred.df1.validation.rf$A,5))
        
        
        
        
        prediction.pred.df1.validation.ada <- prediction(pred.df1.validation.ada$PRED_PROB,pred.df1.validation.ada$RESPONDER)
        
        performance.roc.pred.df1.validation.ada <- performance(prediction.pred.df1.validation.ada, "tpr","fpr")
        roc.area.pred.df1.validation.ada <- roc.area(pred.df1.validation.ada$RESPONDER,pred.df1.validation.ada$PRED_PROB)
        labels.pred.df1.validation.ada <- paste("Adaptive Boosting: AUC=",round(roc.area.pred.df1.validation.ada$A,5))
        
        
        
        
        prediction.pred.df1.validation.nnet <- prediction(pred.df1.validation.nnet$PRED_PROB,pred.df1.validation.nnet$RESPONDER)
        
        performance.roc.pred.df1.validation.nnet <- performance(prediction.pred.df1.validation.nnet, "tpr","fpr")
        roc.area.pred.df1.validation.nnet <- roc.area(pred.df1.validation.nnet$RESPONDER,pred.df1.validation.nnet$PRED_PROB)
        labels.pred.df1.validation.nnet <- paste("Neural Networks: AUC=",round(roc.area.pred.df1.validation.nnet$A,5))
        
        
        
        prediction.pred.df1.validation.logit <- prediction(pred.df1.validation.logit$PRED_PROB,pred.df1.validation.logit$RESPONDER)
        
        performance.roc.pred.df1.validation.logit <- performance(prediction.pred.df1.validation.logit, "tpr","fpr")
        roc.area.pred.df1.validation.logit <- roc.area(pred.df1.validation.logit$RESPONDER,pred.df1.validation.logit$PRED_PROB)
        labels.pred.df1.validation.logit <- paste("Logistic Regression: AUC=",round(roc.area.pred.df1.validation.logit$A,5))
        
        
        
        
        prediction.pred.df1.validation.c50_1 <- prediction(pred.df1.validation.c50_1$PRED_PROB,pred.df1.validation.c50_1$RESPONDER)
        
        performance.roc.pred.df1.validation.c50_1 <- performance(prediction.pred.df1.validation.c50_1, "tpr","fpr")
        roc.area.pred.df1.validation.c50_1 <- roc.area(pred.df1.validation.c50_1$RESPONDER,pred.df1.validation.c50_1$PRED_PROB)
        labels.pred.df1.validation.c50_1 <- paste("C 5.0 Decision Tree: AUC=",round(roc.area.pred.df1.validation.c50_1$A,5))
        
        
        
        prediction.pred.df1.validation.ctree <- prediction(pred.df1.validation.ctree$PRED_PROB,pred.df1.validation.ctree$RESPONDER)
        
        performance.roc.pred.df1.validation.ctree <- performance(prediction.pred.df1.validation.ctree, "tpr","fpr")
        roc.area.pred.df1.validation.ctree <- roc.area(pred.df1.validation.ctree$RESPONDER,pred.df1.validation.ctree$PRED_PROB)
        labels.pred.df1.validation.ctree <- paste("C.I Decision Tree: AUC=",round(roc.area.pred.df1.validation.ctree$A,5))
        
        
        
        prediction.pred.df1.validation.svm <- prediction(pred.df1.validation.svm$PRED_PROB,pred.df1.validation.svm$RESPONDER)
        
        performance.roc.pred.df1.validation.svm <- performance(prediction.pred.df1.validation.svm, "tpr","fpr")
        roc.area.pred.df1.validation.svm <- roc.area(pred.df1.validation.svm$RESPONDER,pred.df1.validation.svm$PRED_PROB)
        labels.pred.df1.validation.svm <- paste("SVM RBF: AUC=",round(roc.area.pred.df1.validation.svm$A,5))
        
        
        
        
        pdf(file="//10.8.8.51/lv0/Tanumoy/Graphs/GRAPHS ALL SAMPLES BALANCED ROC CURVES.pdf",height=9, width=16,bg="white")
        par(mfrow=c(1,1))
        
        plot(performance.roc.pred.df1.validation.rf , avg = "threshold", col = "Red", typ="b", lwd = 2, lty=10, main = "Receiver Operating Characteristic Curves")
        par(new=T)
        
        plot(performance.roc.pred.df1.validation.ada , avg = "threshold", col = "Blue", typ="b", lwd = 2, lty=10, main = "Receiver Operating Characteristic Curves")
        par(new=T)
        
        plot(performance.roc.pred.df1.validation.nnet , avg = "threshold", col = "Yellow", typ="b", lwd = 2, lty=10, main = "Receiver Operating Characteristic Curves")
        par(new=T)
        
        plot(performance.roc.pred.df1.validation.logit , avg = "threshold", col = "Green", typ="b", lwd = 2, lty=10, main = "Receiver Operating Characteristic Curves")
        par(new=T)
        
        plot(performance.roc.pred.df1.validation.c50_1 , avg = "threshold", col = "Brown", typ="b", lwd = 2, lty=10, main = "Receiver Operating Characteristic Curves")
        par(new=T)
        
        plot(performance.roc.pred.df1.validation.ctree , avg = "threshold", col = "Black", typ="b", lwd = 2, lty=10, main = "Receiver Operating Characteristic Curves")
        par(new=T)
        
        plot(performance.roc.pred.df1.validation.svm , avg = "threshold", col = "Pink", typ="b", lwd = 2, lty=10, main = "Receiver Operating Characteristic Curves")
        par(new=T)
        
        
        grid(lty=3,lwd=1,col="gray60",equilogs = T)
        
        legend("topleft", c(labels.pred.df1.validation.rf, labels.pred.df1.validation.ada, labels.pred.df1.validation.nnet, 
                            labels.pred.df1.validation.logit, labels.pred.df1.validation.c50_1, labels.pred.df1.validation.ctree,
                            labels.pred.df1.validation.svm), 
               lty=c(10,10,10,10,10,10,10), lwd=c(2,2,2,2,2,2,2), col=c("Red","Blue","Yellow","Green","Brown","Black","Pink"), bty="o", box.lty=2) 
        
        box()
        
        
        dev.off() 
        
        
        #--------------------------------- Produce Lift Curves for the models fitted to the data ---------------------------------#
        
        
        performance.lift.df1.validation.rf<- performance(prediction.pred.df1.validation.rf, "lift", "rpp")
        
        xvalues.lift.df1.validation.rf<-unlist(attributes(performance.lift.df1.validation.rf)[[4]])
        yvalues.lift.df1.validation.rf<-unlist(attributes(performance.lift.df1.validation.rf)[[5]])
        
        max.xaxis.lift.df1.validation.rf<-max(subset(xvalues.lift.df1.validation.rf,xvalues.lift.df1.validation.rf>0))
        max.yaxis.lift.df1.validation.rf<-max(subset(yvalues.lift.df1.validation.rf,yvalues.lift.df1.validation.rf>0))
        
        
        
        
        
        performance.lift.df1.validation.ada<- performance(prediction.pred.df1.validation.ada, "lift", "rpp")
        
        xvalues.lift.df1.validation.ada<-unlist(attributes(performance.lift.df1.validation.ada)[[4]])
        yvalues.lift.df1.validation.ada<-unlist(attributes(performance.lift.df1.validation.ada)[[5]])
        
        max.xaxis.lift.df1.validation.ada<-max(subset(xvalues.lift.df1.validation.ada,xvalues.lift.df1.validation.ada>0))
        max.yaxis.lift.df1.validation.ada<-max(subset(yvalues.lift.df1.validation.ada,yvalues.lift.df1.validation.ada>0))
        
        
        
        
        
        performance.lift.df1.validation.nnet<- performance(prediction.pred.df1.validation.nnet, "lift", "rpp")
        
        xvalues.lift.df1.validation.nnet<-unlist(attributes(performance.lift.df1.validation.nnet)[[4]])
        yvalues.lift.df1.validation.nnet<-unlist(attributes(performance.lift.df1.validation.nnet)[[5]])
        
        max.xaxis.lift.df1.validation.nnet<-max(subset(xvalues.lift.df1.validation.nnet,xvalues.lift.df1.validation.nnet>0))
        max.yaxis.lift.df1.validation.nnet<-max(subset(yvalues.lift.df1.validation.nnet,yvalues.lift.df1.validation.nnet>0))
        
        
        
        
        
        
        performance.lift.df1.validation.logit<- performance(prediction.pred.df1.validation.logit, "lift", "rpp")
        
        xvalues.lift.df1.validation.logit<-unlist(attributes(performance.lift.df1.validation.logit)[[4]])
        yvalues.lift.df1.validation.logit<-unlist(attributes(performance.lift.df1.validation.logit)[[5]])
        
        max.xaxis.lift.df1.validation.logit<-max(subset(xvalues.lift.df1.validation.logit,xvalues.lift.df1.validation.logit>0))
        max.yaxis.lift.df1.validation.logit<-max(subset(yvalues.lift.df1.validation.logit,yvalues.lift.df1.validation.logit>0))
        
        
        
        
        performance.lift.df1.validation.ctree<- performance(prediction.pred.df1.validation.ctree, "lift", "rpp")
        
        xvalues.lift.df1.validation.ctree<-unlist(attributes(performance.lift.df1.validation.ctree)[[4]])
        yvalues.lift.df1.validation.ctree<-unlist(attributes(performance.lift.df1.validation.ctree)[[5]])
        
        max.xaxis.lift.df1.validation.ctree<-max(subset(xvalues.lift.df1.validation.ctree,xvalues.lift.df1.validation.ctree>0))
        max.yaxis.lift.df1.validation.ctree<-max(subset(yvalues.lift.df1.validation.ctree,yvalues.lift.df1.validation.ctree>0))
        
        
        
        
        
        
        performance.lift.df1.validation.c50_1<- performance(prediction.pred.df1.validation.c50_1, "lift", "rpp")
        
        xvalues.lift.df1.validation.c50_1<-unlist(attributes(performance.lift.df1.validation.c50_1)[[4]])
        yvalues.lift.df1.validation.c50_1<-unlist(attributes(performance.lift.df1.validation.c50_1)[[5]])
        
        max.xaxis.lift.df1.validation.c50_1<-max(subset(xvalues.lift.df1.validation.c50_1,xvalues.lift.df1.validation.c50_1>0))
        max.yaxis.lift.df1.validation.c50_1<-max(subset(yvalues.lift.df1.validation.c50_1,yvalues.lift.df1.validation.c50_1>0))
        
        
        
        
        
        performance.lift.df1.validation.svm<- performance(prediction.pred.df1.validation.svm, "lift", "rpp")
        
        xvalues.lift.df1.validation.svm<-unlist(attributes(performance.lift.df1.validation.svm)[[4]])
        yvalues.lift.df1.validation.svm<-unlist(attributes(performance.lift.df1.validation.svm)[[5]])
        
        max.xaxis.lift.df1.validation.svm<-max(subset(xvalues.lift.df1.validation.svm,xvalues.lift.df1.validation.svm>0))
        max.yaxis.lift.df1.validation.svm<-max(subset(yvalues.lift.df1.validation.svm,yvalues.lift.df1.validation.svm>0))
        
        
        
        max.xaxis=max(max.xaxis.lift.df1.validation.svm, max.xaxis.lift.df1.validation.ada,  max.xaxis.lift.df1.validation.nnet,
                      max.xaxis.lift.df1.validation.rf, max.xaxis.lift.df1.validation.logit, max.xaxis.lift.df1.validation.c50_1, max.xaxis.lift.df1.validation.ctree)
        max.yaxis=max(max.yaxis.lift.df1.validation.svm, max.yaxis.lift.df1.validation.ada,  max.yaxis.lift.df1.validation.nnet,
                      max.yaxis.lift.df1.validation.rf, max.yaxis.lift.df1.validation.logit, max.yaxis.lift.df1.validation.c50_1, max.yaxis.lift.df1.validation.ctree)
        
        
        pdf(file="//10.8.8.51/lv0/Tanumoy/Graphs/GRAPHS ALL SAMPLES BALANCED LIFT CURVES.pdf",height=9, width=16,bg="white")
        par(mfrow=c(1,1))
        
        
        plot(performance.lift.df1.validation.rf, avg = "threshold", xlim=c(0,max.xaxis), ylim=c(1,max.yaxis), col="Red", lty=10, lwd = 2, main = "Cumulative Lift Curve")
        par(new=T)
        
        
        plot(performance.lift.df1.validation.ada, avg = "threshold", xlim=c(0,max.xaxis), ylim=c(1,max.yaxis), col="Blue", lty=10, lwd = 2, main = "Cumulative Lift Curve")
        par(new=T)
        
        
        plot(performance.lift.df1.validation.nnet, avg = "threshold", xlim=c(0,max.xaxis), ylim=c(1,max.yaxis), col="Yellow", lty=10, lwd = 2, main = "Cumulative Lift Curve")
        par(new=T)
        
        
        plot(performance.lift.df1.validation.logit, avg = "threshold", xlim=c(0,max.xaxis), ylim=c(1,max.yaxis), col="Green", lty=10, lwd = 2, main = "Cumulative Lift Curve")
        par(new=T)
        
        
        plot(performance.lift.df1.validation.ctree, avg = "threshold", xlim=c(0,max.xaxis), ylim=c(1,max.yaxis), col="Black", lty=10, lwd = 2, main = "Cumulative Lift Curve")
        par(new=T)
        
        
        plot(performance.lift.df1.validation.c50_1, avg = "threshold", xlim=c(0,max.xaxis), ylim=c(1,max.yaxis), col="Brown", lty=10, lwd = 2, main = "Cumulative Lift Curve")
        par(new=T)
        
        
        plot(performance.lift.df1.validation.svm, avg = "threshold", xlim=c(0,max.xaxis), ylim=c(1,max.yaxis), col="Pink", lty=10, lwd = 2, main = "Cumulative Lift Curve")
        par(new=T)
        
        
        
        grid(lty=3,lwd=1,col="gray60",equilogs = T)
        
        legend("topright", c("Random Forest", "Adaptive Boosting", "Neural Networks", "Logistic Regression", "C.I Decision Tree", "C 5.0 Decision Tree", "SVM RBF"), 
               lty=c(10,10,10,10,10,10,10), lwd=c(2,2,2,2,2,2,2), col=c("Red","Blue","Yellow","Green","Black","Brown","Pink"), bty="o", box.lty=2)
        
        box()
        
        dev.off() 
        
        save.image("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model.RData")
        
        
        
        
        #------------------------------------------- Produce Cumulative Gains Charts for the models fitted to the data -----------------------------------------------------------#
        
        pdf(file="//10.8.8.51/lv0/Tanumoy/Graphs/GRAPHS ALL SAMPLES BALANCED GAIN CURVES.pdf",height=9, width=16,bg="white")
        par(mfrow=c(1,1))
        
        plot(performance(prediction(pred.df1.validation.rf$PRED_PROB,pred.df1.validation.rf$RESPONDER), "tpr", "rpp"),lwd = 2, col = "Red", lty=10, main = paste("Cumulative Gains Charts"))
        par(new=T)
        
        plot(performance(prediction(pred.df1.validation.ada$PRED_PROB,pred.df1.validation.ada$RESPONDER), "tpr", "rpp"),lwd = 2, col = "Blue", lty=10, main = paste("Cumulative Gains Charts"))
        par(new=T)
        
        plot(performance(prediction(pred.df1.validation.nnet$PRED_PROB,pred.df1.validation.nnet$RESPONDER), "tpr", "rpp"),lwd = 2, col = "Yellow", lty=10, main = paste("Cumulative Gains Charts"))
        par(new=T)
        
        plot(performance(prediction(pred.df1.validation.logit$PRED_PROB,pred.df1.validation.logit$RESPONDER), "tpr", "rpp"),lwd = 2, col = "Green", lty=10, main = paste("Cumulative Gains Charts"))
        par(new=T)
        
        plot(performance(prediction(pred.df1.validation.ctree$PRED_PROB,pred.df1.validation.c50_1$RESPONDER), "tpr", "rpp"),lwd = 2, col = "Black", lty=10, main = paste("Cumulative Gains Charts"))
        par(new=T)
        
        plot(performance(prediction(pred.df1.validation.c50_1$PRED_PROB,pred.df1.validation.c50_1$RESPONDER), "tpr", "rpp"),lwd = 2, col = "Brown", lty=10, main = paste("Cumulative Gains Charts"))
        par(new=T)
        
        plot(performance(prediction(pred.df1.validation.svm$PRED_PROB,pred.df1.validation.svm$RESPONDER), "tpr", "rpp"),lwd = 2, col = "Pink", lty=10, main = paste("Cumulative Gains Charts"))
        par(new=T)
        
        
        grid(lty=3,lwd=1,col="gray60",equilogs = T)
        
        legend("topleft", c("Random Forest", "Adaptive Boosting", "Neural Networks", "Logistic Regression", "C.I Decision Tree", "C 5.0 Decision Tree", "SVM RBF"), 
               lty=c(10,10,10,10,10,10,10), lwd=c(2,2,2,2,2,2,2), col=c("Red","Blue","Yellow","Green","Black","Brown","Pink"), bty="o", box.lty=2)
        
        box()
        
        dev.off() 
        
        save.image("//10.8.8.51/lv0/Tanumoy/RData/BR Response Model.RData")
        
        
        #--------------------------------- Support Vector Machines from Kernlab package -----------------------------------------
        
        
        library(kernlab)
        
        unlist(srange<-sigest(RESPONDER~.,data = df4.training))
        
        gaussiansvm <- ksvm(RESPONDER ~ ., data=df4.training, type = "C-svc", kernel = "rbfdot", cross=20, C=10, prob.model=T)
        
        laplaciansvm <- ksvm(RESPONDER ~ ., data=df4.training, type = "C-svc", kernel = "laplacedot", cross=20, C=10, prob.model=T)
        
        linearsvm <- ksvm(RESPONDER ~ ., data=df4.training, type = "C-svc", kernel = "polydot", kpar=list(degree=2), cross=20, C=10, prob.model=T)
        
        
        
        
        
        
        
        
        
        