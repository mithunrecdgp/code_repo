##Browse only training period

browseonly <- read.csv("/Users/ke6t4io/Documents/DivisionPreference/GP/browseonly_q1.csv",header=FALSE)

colnames(browseonly) <- c('masterkey',
'count_basket_babygirl',
'count_basket_babyboy',
'count_basket_toddlergirl',
'count_basket_toddlerboy',
'count_basket_girl',
'count_basket_boy',
'count_basket_women',
'count_basket_men',
'count_basket_maternity',
'count_clicks_babygirl',
'count_clicks_babyboy',
'count_clicks_toddlergirl',
'count_clicks_toddlerboy',
'count_clicks_girl',
'count_clicks_boy',
'count_clicks_women',
'count_clicks_men',
'count_clicks_maternity',
'count_purch_baby_pred',
'count_purch_toddlergirl_pred',
'count_purch_toddlerboy_pred',
'count_purch_girl_pred',
'count_purch_boy_pred',
'count_purch_women_pred',
'count_purch_men_pred',
'count_purch_maternity_pred')


##compute proportions
iszero <- function(x) {
	return(ifelse(is.na(x),0,x))
}
prop_basket <- browseonly[,2:10]/apply(browseonly[,2:10],1,sum)
prop_basket <- apply(prop_basket,2,iszero)
colnames(prop_basket) <- c("prop_basket_babygirl","prop_basket_babyboy","prop_basket_toddlergirl","prop_basket_toddlerboy","prop_basket_girl","prop_basket_boy","prop_basket_women","prop_basket_men","prop_basket_maternity")

prop_clicks <- browseonly[,11:19]/apply(browseonly[,11:19],1,sum)
colnames(prop_clicks) <- c("prop_clicks_babygirl","prop_clicks_babyboy","prop_clicks_toddlergirl","prop_clicks_toddlerboy","prop_clicks_girl","prop_clicks_boy","prop_clicks_women","prop_clicks_men","prop_clicks_maternity")
prop_clicks <- apply(prop_clicks,2,iszero)

prop_purch <- cbind(rep(0,nrow(browseonly)),rep(0,nrow(browseonly)),rep(0,nrow(browseonly)),rep(0,nrow(browseonly)),rep(0,nrow(browseonly)),rep(0,nrow(browseonly)),rep(0,nrow(browseonly)),rep(0,nrow(browseonly)),rep(0,nrow(browseonly)))
colnames(prop_purch) <- c("prop_purch_babygirl","prop_purch_babyboy","prop_purch_toddlergirl","prop_purch_toddlerboy","prop_purch_girl","prop_purch_boy","prop_purch_women","prop_purch_men","prop_purch_maternity")

browseonly <- data.frame(browseonly,prop_basket,prop_clicks,prop_purch)

browseonly <- browseonly[browseonly$masterkey!='2-2014070883947-1621744',]

####next purchase browse only (in prediction period)
next_purch_browseonly <- read.csv("/Users/ke6t4io/Documents/DivisionPreference/GP/nextpurch_browseonly_q1.csv",header=FALSE)
colnames(next_purch_browseonly) <- c("masterkey","division","netsalesamt","transaction_date")

next_purch_browseonly$division <- ifelse(next_purch_browseonly$division %in% c('BABYGIRL','BABYBOY'),'BABY',as.character(next_purch_browseonly$division))



next_purch_browseonly <- next_purch_browseonly[next_purch_browseonly$division!='NONE',]

nextpurchdivs <- NULL
ucust <- unique(next_purch_browseonly$masterkey)
for(i in 1:length(ucust)) {
	this.cust <- next_purch_browseonly[next_purch_browseonly$masterkey==as.character(ucust[i]),]	
	##order according to the following
	ord_div <- cbind(c("WOMEN","MEN","BABY","BOY","GIRL","TODDLERGIRL","TODDLERBOY","MATERNITY"),1:8)
	
	div.rank <- as.character(this.cust$division)
	if(nrow(this.cust)>1) {
		div.rank1 <- ord_div[ord_div[,1] %in% this.cust$division,]
		div.rank <- as.character(div.rank1[div.rank1[,2]==min(div.rank1[,2]),1])}
	
	nextpurchdivs <- rbind(nextpurchdivs,c(as.character(ucust[i]),div.rank))
}
colnames(nextpurchdivs) <- c("masterkey","division")

nextpurchall_browseonly <- merge(browseonly,nextpurchdivs,by="masterkey",all.x=TRUE)

nextpurch_purchonly_browseonly <- merge(browseonly,nextpurchdivs,by="masterkey")
quarter='Q1'
nextpurch_purchonly_browseonly <- data.frame(nextpurch_purchonly_browseonly,quarter)
predvalues_browseonly <- predict(model_clicksbasketpurch,newdata=nextpurch_purchonly_browseonly,type='class')

##Correctly predict browser only
sum(as.vector(predvalues_browseonly)==nextpurch_purchonly_browseonly$division,na.rm=TRUE)
sum(as.vector(predvalues_browseonly)==nextpurch_purchonly_browseonly$division,na.rm=TRUE)/nrow(nextpurch_purchonly_browseonly)
##0.6032716


############################################################################################
##First browseonly
############################################################################################
##throw all variables in
library(nnet)
model_browseonly <- multinom(division~
prop_clicks_babygirl+prop_clicks_babyboy+prop_clicks_toddlergirl+prop_clicks_toddlerboy+prop_clicks_girl+prop_clicks_boy+
prop_clicks_women+prop_clicks_men+prop_clicks_maternity+
prop_basket_babygirl+prop_basket_babyboy+prop_basket_toddlergirl+prop_basket_toddlerboy+prop_basket_girl+prop_basket_boy+
prop_basket_women+prop_basket_men+prop_basket_maternity
,data=nextpurch_purchonly_browseonly,maxit=200)

coeff_browseonly <- summary(model_browseonly)$coefficients
coeff_browseonly
write.csv(coeff_browseonly,"/Users/ke6t4io/Documents/DivisionPreference/GP/model1_coeff_browseonly.csv")

##check p-values
browseonly_z <- coeff_browseonly/summary(model_browseonly)$standard.errors
browseonly_p <- (1 - pnorm(abs(browseonly_z), 0, 1)) * 2
browseonly_p

predvalues_browseonly <- predict(model_browseonly,type='class')

##Correctly predict
sum(as.vector(predvalues_browseonly)== nextpurch_purchonly_browseonly $division)
sum(as.vector(predvalues_browseonly)== nextpurch_purchonly_browseonly $division)/nrow(nextpurch_purchonly_browseonly)
##0.6452715


model_browseonly
##AIC: 23827.41  

predvalues_browseonly_probs <- predict(model_browseonly,type='probs')

############################################################################################
##Use number of clicks in training as ranking
tiebreak <- c(.6,.2,.3,.4,.5,.8,.7,.1)  ##this corresponds to names in this.actuals

divranksactualclicks_train <- NULL
for(i in 1:nrow(nextpurch_purchonly_browseonly)) {

	this.line <- nextpurch_purchonly_browseonly[i,c("count_clicks_baby","count_clicks_toddlergirl","count_clicks_toddlerboy","count_clicks_girl","count_clicks_boy","count_clicks_women","count_clicks_men","count_clicks_maternity")]
colnames(this.line) <- c("BABY","TODDLERGIRL","TODDLERBOY","GIRL","BOY","WOMEN","MEN","MATERNITY")
	
	this.actuals <- this.line+tiebreak
	divactual1 <- names(this.actuals)[this.actuals>1]
	divranksactualclicks_train <- rbind(divranksactualclicks_train, c(divactual1[order(this.actuals[this.actuals>1],decreasing=TRUE)],rep("NULL",8-
sum(this.actuals>1))))
cat("Iteration: ",i,"\n")
}

trainactualclicks <- data.frame(nextpurch_purchonly_browseonly$masterkey, divranksactualclicks_train[,1])
colnames(trainactualclicks) <- c("masterkey","pred_next_div")

trainactualclicks <- merge(trainactualclicks, nextpurch_purchonly_browseonly,by="masterkey")
sum(as.vector(trainactualclicks $pred_next_div)==trainactualclicks$division)/nrow(trainactualclicks)



tiebreak <- c(.6,.2,.3,.4,.5,.8,.7,.1)  ##this corresponds to names in this.actuals
ranks_div <- function(x,colnum){
	ord_divsn <- ord_divs[x>1]
	ord.x <- order(x[x>1],decreasing=TRUE)
	return(ord_divsn[ord.x][colnum])
}
trainaactual_raw <- cbind(nextpurch_purchonly_browseonly$count_purch_babygirl+ nextpurch_purchonly_browseonly$count_purch_babyboy+0.6,
nextpurch_purchonly_browseonly$count_purch_toddlergirl+0.2,
nextpurch_purchonly_browseonly$count_purch_toddlerboy+0.3,
nextpurch_purchonly_browseonly$count_purch_girl+0.4,
nextpurch_purchonly_browseonly$count_purch_boy+0.5,
nextpurch_purchonly_browseonly$count_purch_women+0.8,
nextpurch_purchonly_browseonly$count_purch_men+0.7,
nextpurch_purchonly_browseonly$count_purch_maternity+0.1)

ord_divs <- c("BABY","TODDLERGIRL","TODDLERBOY","GIRL","BOY","WOMEN","MEN","MATERNITY")
rank1 <- apply(trainaactual_raw,1,ranks_div,colnum=1)
rank2 <- apply(trainaactual_raw,1,ranks_div,colnum=1)
rank3 <- apply(trainaactual_raw,1,ranks_div,colnum=1)
rank4 <- apply(trainaactual_raw,1,ranks_div,colnum=1)
rank5 <- apply(trainaactual_raw,1,ranks_div,colnum=1)
rank6 <- apply(trainaactual_raw,1,ranks_div,colnum=1)
rank7 <- apply(trainaactual_raw,1,ranks_div,colnum=1)
rank8 <- apply(trainaactual_raw,1,ranks_div,colnum=1)

trainaactual <- cbind(rank1,rank2,rank3,rank4,rank5,rank6,rank7,rank8)
colnames(trainaactual) <- c("RANK1","RANK2","RANK3","RANK4","RANK5","RANK6","RANK7","RANK8")

sum(nextpurch_purchonly$division== trainaactual[,1])/nrow(trainaactual)







library(MASS)
##Negative binomial
nb.women.clicks.basket <- glm.nb(count_purch_women_pred~prop_clicks_women+prop_basket_women+prop_clicks_maternity+prop_basket_maternity,data= nextpurch_purchonly_browseonly)               
nb.men.clicks.basket <- glm.nb(count_purch_men_pred~prop_clicks_men+prop_basket_men,data= nextpurch_purchonly_browseonly)   
nb.baby.clicks.basket <- glm.nb(count_purch_baby_pred~prop_clicks_babygirl+prop_clicks_babyboy+prop_basket_babygirl+prop_basket_babyboy+prop_clicks_maternity+prop_basket_maternity,data= nextpurch_purchonly_browseonly)   
nb.toddlergirl.clicks.basket <- glm.nb(count_purch_toddlergirl_pred~prop_clicks_babygirl+prop_basket_babygirl+prop_clicks_toddlergirl+prop_basket_toddlergirl,data= nextpurch_purchonly_browseonly)     
nb.toddlerboy.clicks.basket <- glm.nb(count_purch_toddlerboy_pred~prop_clicks_babyboy+prop_basket_babyboy+prop_clicks_toddlerboy+prop_basket_toddlerboy,data= nextpurch_purchonly_browseonly)     
nb.girl.clicks.basket <- glm.nb(count_purch_girl_pred~prop_clicks_girl+prop_basket_girl+prop_clicks_toddlergirl+prop_basket_toddlergirl,data= nextpurch_purchonly_browseonly)     
nb.boy.clicks.basket <- glm.nb(count_purch_boy_pred~prop_clicks_boy+prop_basket_boy+prop_clicks_toddlerboy+prop_basket_toddlerboy,data= nextpurch_purchonly_browseonly)     
nb.maternity.clicks.basket <- glm.nb(count_purch_maternity_pred~prop_clicks_maternity+prop_basket_maternity,data= nextpurch_purchonly_browseonly)     

women_nb_pred <- predict(nb.women.clicks.basket,type="response")
men_nb_pred <- predict(nb.men.clicks.basket,type="response")
baby_nb_pred <- predict(nb.baby.clicks.basket,type="response")
toddlergirl_nb_pred <- predict(nb.toddlergirl.clicks.basket,type="response")
toddlerboy_nb_pred <- predict(nb.toddlerboy.clicks.basket,type="response")
girl_nb_pred <- predict(nb.girl.clicks.basket,type="response")
boy_nb_pred <- predict(nb.boy.clicks.basket,type="response")
maternity_nb_pred <- predict(nb.maternity.clicks.basket,type="response")

ord_divs <- c("WOMEN","MEN","BABY","TODDLERGIRL","TODDLERBOY","GIRL","BOY","MATERNITY")
ranks_div1 <- function(x){
	ord_divsn <- ord_divs[x>1]
	ord.x <- order(x[x>1],decreasing=TRUE)
	return(ord_divsn[ord.x][1])
}
ranks_div2 <- function(x){
	ord_divsn <- ord_divs[x>1]
	ord.x <- order(x[x>1],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][2]),'NULL',ord_divsn[ord.x][2]))
}
ranks_div3 <- function(x){
	ord_divsn <- ord_divs[x>1]
	ord.x <- order(x[x>1],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][3]),'NULL',ord_divsn[ord.x][3]))
}
ranks_div4 <- function(x){
	ord_divsn <- ord_divs[x>1]
	ord.x <- order(x[x>1],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][4]),'NULL',ord_divsn[ord.x][4]))
}
ranks_div5 <- function(x){
	ord_divsn <- ord_divs[x>1]
	ord.x <- order(x[x>1],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][5]),'NULL',ord_divsn[ord.x][5]))
}
ranks_div6 <- function(x){
	ord_divsn <- ord_divs[x>1]
	ord.x <- order(x[x>1],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][6]),'NULL',ord_divsn[ord.x][6]))
}
ranks_div7 <- function(x){
	ord_divsn <- ord_divs[x>1]
	ord.x <- order(x[x>1],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][7]),'NULL',ord_divsn[ord.x][7]))
}
ranks_div8 <- function(x){
	ord_divsn <- ord_divs[x>1]
	ord.x <- order(x[x>1],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][8]),'NULL',ord_divsn[ord.x][8]))
}

nb_preds <- cbind(nextpurch_purchonly_browseonly$masterkey,women_nb_pred,men_nb_pred,baby_nb_pred,toddlergirl_nb_pred,toddlerboy_nb_pred,girl_nb_pred,boy_nb_pred,maternity_nb_pred)

rank1 <- apply(nb_preds[,2:9],1,ranks_div10)
rank2 <- apply(nb_preds[,2:9],1,ranks_div20)
rank3 <- apply(nb_preds[,2:9],1,ranks_div30)
rank4 <- apply(nb_preds[,2:9],1,ranks_div40)
rank5 <- apply(nb_preds[,2:9],1,ranks_div50)
rank6 <- apply(nb_preds[,2:9],1,ranks_div60)
rank7 <- apply(nb_preds[,2:9],1,ranks_div70)
rank8 <- apply(nb_preds[,2:9],1,ranks_div80)

divranksnbmod <- cbind(rank1,rank2,rank3,rank4,rank5,rank6,rank7,rank8)

colnames(divranksnbmod) <- c("RANK1","RANK2","RANK3","RANK4","RANK5","RANK6","RANK7","RANK8")


ranks_div10 <- function(x){
	ord_divsn <- ord_divs[x>0]
	ord.x <- order(x[x>0],decreasing=TRUE)
	return(ord_divsn[ord.x][1])
}
ranks_div20 <- function(x){
	ord_divsn <- ord_divs[x>0]
	ord.x <- order(x[x>0],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][2]),'NULL',ord_divsn[ord.x][2]))
}
ranks_div30 <- function(x){
	ord_divsn <- ord_divs[x>0]
	ord.x <- order(x[x>0],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][3]),'NULL',ord_divsn[ord.x][3]))
}
ranks_div40 <- function(x){
	ord_divsn <- ord_divs[x>0]
	ord.x <- order(x[x>0],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][4]),'NULL',ord_divsn[ord.x][4]))
}
ranks_div50 <- function(x){
	ord_divsn <- ord_divs[x>0]
	ord.x <- order(x[x>0],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][5]),'NULL',ord_divsn[ord.x][5]))
}
ranks_div60 <- function(x){
	ord_divsn <- ord_divs[x>0]
	ord.x <- order(x[x>0],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][6]),'NULL',ord_divsn[ord.x][6]))
}
ranks_div70 <- function(x){
	ord_divsn <- ord_divs[x>0]
	ord.x <- order(x[x>0],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][7]),'NULL',ord_divsn[ord.x][7]))
}
ranks_div80 <- function(x){
	ord_divsn <- ord_divs[x>0]
	ord.x <- order(x[x>0],decreasing=TRUE)
	return(ifelse(is.na(ord_divsn[ord.x][8]),'NULL',ord_divsn[ord.x][8]))
}


pred_actual <- cbind(nextpurch_purchonly_browseonly$count_purch_baby_pred+0.6,
nextpurch_purchonly_browseonly$count_purch_toddlergirl_pred+0.2,
nextpurch_purchonly_browseonly$count_purch_toddlerboy_pred+0.3,
nextpurch_purchonly_browseonly$count_purch_girl_pred+0.4,
nextpurch_purchonly_browseonly$count_purch_boy_pred+0.5,
nextpurch_purchonly_browseonly$count_purch_women_pred+0.8,
nextpurch_purchonly_browseonly$count_purch_men_pred+0.7,
nextpurch_purchonly_browseonly$count_purch_maternity_pred+0.1)

ord_divs <- c("BABY","TODDLERGIRL","TODDLERBOY","GIRL","BOY","WOMEN","MEN","MATERNITY")
rank1 <- apply(pred_actual,1,ranks_div1)
rank2 <- apply(pred_actual,1,ranks_div2)
rank3 <- apply(pred_actual,1,ranks_div3)
rank4 <- apply(pred_actual,1,ranks_div4)
rank5 <- apply(pred_actual,1,ranks_div5)
rank6 <- apply(pred_actual,1,ranks_div6)
rank7 <- apply(pred_actual,1,ranks_div7)
rank8 <- apply(pred_actual,1,ranks_div8)

divranks_pred <- cbind(rank1,rank2,rank3,rank4,rank5,rank6,rank7,rank8)


sum(divranks_pred[,1]== divranksnbmod[,1])/nrow(divranks_pred)
