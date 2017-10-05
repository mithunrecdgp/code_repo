library(gbm)
library(dplyr)
library(sqldf)
library(ff)
library(ffbase)
library(kernlab)
library(readr)

br.data.train <- read.table.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_data_cat_pref_norm_train.txt", 
                                 header = F, VERBOSE = T, sep='|')


colnames(br.data.train)<- c("masterkey",
                            "category",
                            "norm_items_lastyear",
                            "norm_clicks_lastmonth",
                            "recency_purch",
                            "norm_clicks_lastqtr",
                            "norm_items_firstqtr",
                            "recency_click",
                            "norm_items_lastmonth",
                            "norm_abandon_lastqtr",
                            "norm_abandon_lastmonth",
                            "norm_items_lastqtr",
                            "recency_abdnbskt",
                            "items_3mo_pred_cap")


masterkey <- factor(br.data.train[,1])
masterkeyid <- as.numeric(masterkey)
write.table(data.frame(masterkey), file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_masterkey_train_v2.txt", 
            col.names=F, row.names=F, sep=" ")
rm(masterkey)
gc()


category <- factor(br.data.train[,2])
categoryid <- as.numeric(category)
rm(category)
gc()

data.ranklib.train <- cbind(br.data.train[,14],
                            paste0("qid:", masterkeyid),
                            paste0("cid:", categoryid),
                            paste0("1:", br.data.train[,3]),
                            paste0("2:", br.data.train[,4]),
                            paste0("3:", br.data.train[,5]),
                            paste0("4:", br.data.train[,6]),
                            paste0("5:", br.data.train[,7]),
                            paste0("6:", br.data.train[,8]),
                            paste0("7:", br.data.train[,9]),
                            paste0("8:", br.data.train[,10]),
                            paste0("9:", br.data.train[,11])
)

write.table(data.ranklib.train[2:nrow(data.ranklib.train),c(1,2,4:ncol(data.ranklib.train))], 
            file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_normal_first_train_v2.txt", 
            col.names=F, row.names=F, sep=" ")

x <- readLines("//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_normal_first_train_v2.txt")
y <- gsub( '"', '', x )
cat(y, file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_normal_first_train_v2.txt", sep="\n")



br.data.test <- read.table.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_data_cat_pref_norm_test.txt", 
                                 header = F, VERBOSE = T, sep='|')


colnames(br.data.test)<- c("masterkey",
                           "category",
                           "norm_items_lastyear",
                           "norm_clicks_lastmonth",
                           "recency_purch",
                           "norm_clicks_lastqtr",
                           "norm_items_firstqtr",
                           "recency_click",
                           "norm_items_lastmonth",
                           "norm_abandon_lastqtr",
                           "norm_abandon_lastmonth",
                           "norm_items_lastqtr",
                           "recency_abdnbskt",
                           "items_3mo_pred_cap")


masterkey <- factor(br.data.test[,1])
masterkeyid <- as.numeric(masterkey)
write.table(data.frame(masterkey), file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_masterkey_test_v2.txt", 
            col.names=F, row.names=F, sep=" ")
rm(masterkey)
gc()


category <- factor(br.data.test[,2])
categoryid <- as.numeric(category)
rm(category)
gc()

data.ranklib.test <- cbind(br.data.test[,14],
                            paste0("qid:", masterkeyid),
                            paste0("cid:", categoryid),
                            paste0("1:", br.data.test[,3]),
                            paste0("2:", br.data.test[,4]),
                            paste0("3:", br.data.test[,5]),
                            paste0("4:", br.data.test[,6]),
                            paste0("5:", br.data.test[,7]),
                            paste0("6:", br.data.test[,8]),
                            paste0("7:", br.data.test[,9]),
                            paste0("8:", br.data.test[,10]),
                            paste0("9:", br.data.test[,11])
                           )

write.table(data.ranklib.test[2:nrow(data.ranklib.test),c(1,2,4:ncol(data.ranklib.test))], 
            file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_normal_first_test_v2.txt", 
            col.names=F, row.names=F, sep=" ")

x <- readLines("//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_normal_first_test_v2.txt")
y <- gsub( '"', '', x )
cat(y, file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/br_normal_first_test_v2.txt", sep="\n")

