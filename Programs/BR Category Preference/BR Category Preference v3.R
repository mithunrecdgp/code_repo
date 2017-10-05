library(gbm)
library(dplyr)
library(sqldf)
library(ff)
library(ffbase)
library(kernlab)
library(readr)

br.data.train <- read.table.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_data_cat_pref_norm_train.txt", 
                           header = F, VERBOSE = T, sep='|')


colnames(br.data.train)<-c("masterkey",
                           "category",
                           "recency_purch",
                           "recency_click",
                           "recency_abdnbskt",
                           "norm_txn_lastyear",
                           "norm_items_lastyear",
                           "norm_gross_lastyear",
                           "norm_net_lastyear",
                           "norm_txn_lastqtr",
                           "norm_items_lastqtr",
                           "norm_gross_lastqtr",
                           "norm_net_lastqtr",
                           "norm_txn_firstqtr",
                           "norm_items_firstqtr",
                           "norm_gross_firstqtr",
                           "norm_net_firstqtr",
                           "norm_txn_lastmonth",
                           "norm_items_lastmonth",
                           "norm_gross_lastmonth",
                           "norm_net_lastmonth",
                           "norm_clicks_lastqtr",
                           "norm_clicks_lastmonth",
                           "norm_abandon_lastqtr",
                           "norm_abandon_lastmonth",
                           "items_3mo_pred_cap"
                           )

gbm.ndcg <- gbm(items_3mo_pred_cap ~
                                    recency_purch +
                                    recency_click +
                                    recency_abdnbskt +
                                    norm_txn_lastyear +
                                    norm_items_lastyear +
                                    norm_gross_lastyear +
                                    norm_net_lastyear +
                                    norm_txn_lastqtr +
                                    norm_items_lastqtr +
                                    norm_gross_lastqtr +
                                    norm_net_lastqtr +
                                    norm_txn_firstqtr +
                                    norm_items_firstqtr +
                                    norm_gross_firstqtr +
                                    norm_net_firstqtr +
                                    norm_txn_lastmonth +
                                    norm_items_lastmonth +
                                    norm_gross_lastmonth +
                                    norm_net_lastmonth +
                                    norm_clicks_lastqtr +
                                    norm_clicks_lastmonth +
                                    norm_abandon_lastqtr +
                                    norm_abandon_lastmonth,    
                data=data.frame(br.data.train),     
                distribution=list(name='pairwise', metric="ndcg", group='masterkey'),    
                n.trees=2000,        
                shrinkage=0.005,     
                interaction.depth=3, 
                bag.fraction = 0.5,  
                train.fraction = 1,  
                n.minobsinnode = 10, 
                keep.data=TRUE,      
                cv.folds=10
                )    

save(gbm.ndcg, file='//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/Category Preference/AT/at_normal_train_v2.RData')

load("//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/Category Preference/AT/at_normal_train_v2.RData")
gbm.ndcg.perf <- gbm.perf(gbm.ndcg, method='cv')
score <- predict(gbm.ndcg, br.train, gbm.ndcg.perf)
br.train.score <- cbind(br.train, score) 
br.train.score$training = 1

score <- predict(gbm.ndcg, br.test, gbm.ndcg.perf)
br.test.score <- cbind(br.test, score)
br.test.score$training = 0

br.score <- rbind(br.train.score, br.test.score)
write.table(br.score, file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_normal_first_score_v2.txt", 
            col.names=T, row.names=F, sep=",")
