library(gbm)
library(dplyr)
library(sqldf)
library(ff)
library(ffbase)
library(kernlab)
library(readr)

on.data <- read_delim(file="//10.8.8.51/lv0/Move to Box/Mithun/projects/6.ON Category Pref/on_cat_pref_model_train_R.txt", 
                      col_names=F, delim="|", n_max=-1)

on.data <-read.csv.ffdf(file="//10.8.8.51/lv0/Move to Box/Mithun/projects/6.ON Category Pref/on_cat_pref_model_train_R.txt",
                        header = F, VERBOSE = T,  sep=',', first.rows=1000, next.rows=100000)


colnames(on.data)<-c("purch_resp_time",
                     "masterkeyid",
                     "categoryid",
                     "norm_items_purch_lastyear",
                     "recency_purchase",
                     "norm_prod_view_last_qtr",
                     "norm_onl_purchase_last_qtr",
                     "norm_item_abandoned_lastmonth",
                     "norm_item_abandoned_lastyear",
                     "recency_abandon",
                     "norm_cart_add_lastqtr",
                     "norm_items_purch_first_qtr",
                     "norm_items_purch_lastmnth",
                     "recency_click"
                    )

for (i in 4:ncol(on.data))
{
  on.data[,i] <- (on.data[,i] - min(on.data[,i]))/max(on.data[,i] - min(on.data[,i]))
}


summary(on.data)


on.data$masterkey <- factor(on.data$masterkey)
on.data$category  <- factor(on.data$category)

ul<-quantile(on.data$purch_resp_time,0.995)
on.data$purch_resp_time <- ifelse(on.data$purch_resp_time>ul, ul, on.data$purch_resp_time)

summary(on.data)


all.masterkey <- unique(on.data[,2])
index.train <- bigsample(1:nrow(all.masterkey), size=1000000, replace=F)
train.masterkey <- all.masterkey[ index.train, ]
test.masterkey  <- all.masterkey[-index.train, ]