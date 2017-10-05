clicks_basket_purch <- read.csv("/Users/ke6t4io/Documents/DivisionPreference/GP/clicks_basket_purch.csv",header=FALSE)

colnames(clicks_basket_purch) <- c('masterkey',
'count_basket_baby',
'count_basket_toddlergirl',
'count_basket_toddlerboy',
'count_basket_girl',
'count_basket_boy',
'count_basket_women',
'count_basket_men',
'count_basket_maternity',
'count_clicks_baby',
'count_clicks_toddlergirl',
'count_clicks_toddlerboy',
'count_clicks_girl',
'count_clicks_boy',
'count_clicks_women',
'count_clicks_men',
'count_clicks_maternity',
'count_purch_baby',
'count_purch_toddlergirl',
'count_purch_toddlerboy',
'count_purch_girl',
'count_purch_boy',
'count_purch_women',
'count_purch_men',
'count_purch_maternity',
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
prop_basket <- clicks_basket_purch[2:9]/apply(clicks_basket_purch[2:9],1,sum)
prop_basket <- apply(prop_basket,2,iszero)
colnames(prop_basket) <- c("prop_basket_baby","prop_basket_toddlergirl","prop_basket_toddlerboy","prop_basket_girl","prop_basket_boy","prop_basket_women","prop_basket_men","prop_basket_maternity")

prop_clicks <- clicks_basket_purch[10:17]/apply(clicks_basket_purch[10:17],1,sum)
colnames(prop_clicks) <- c("prop_clicks_baby","prop_clicks_toddlergirl","prop_clicks_toddlerboy","prop_clicks_girl","prop_clicks_boy","prop_clicks_women","prop_clicks_men","prop_clicks_maternity")
prop_clicks <- apply(prop_clicks,2,iszero)

prop_purch <- clicks_basket_purch[18:25]/apply(clicks_basket_purch[18:25],1,sum)
colnames(prop_purch) <- c("prop_purch_baby","prop_purch_toddlergirl","prop_purch_toddlerboy","prop_purch_girl","prop_purch_boy","prop_purch_women","prop_purch_men","prop_purch_maternity")
prop_purch <- apply(prop_purch,2,iszero)

clicks_basket_purch <- data.frame(clicks_basket_purch,prop_basket,prop_clicks,prop_purch)

##Next purchase in prediction period
next_purch <- read.csv("/Users/ke6t4io/Documents/DivisionPreference/GP/pred_next_purch.csv",header=FALSE)
colnames(next_purch) <- c("masterkey","division","netsalesamt","transaction_date")

next_purch <- next_purch[next_purch$division!='NONE',]

nextpurchdivs <- NULL
ucust <- unique(next_purch$masterkey)
for(i in 1:length(ucust)) {
	this.cust <- next_purch[next_purch$masterkey==as.character(ucust[i]),]	
	##order according to the following
	ord_div <- cbind(c("WOMEN","MEN","BABY","BOY","GIRL","TODDLERGIRL","TODDLERBOY","MATERNITY"),1:8)
	
	div.rank <- as.character(this.cust$division)
	if(nrow(this.cust)>1) {
		div.rank1 <- ord_div[ord_div[,1] %in% this.cust$division,]
		div.rank <- as.character(div.rank1[div.rank1[,2]==min(div.rank1[,2]),1])}
	
	nextpurchdivs <- rbind(nextpurchdivs,c(as.character(ucust[i]),div.rank))
}
colnames(nextpurchdivs) <- c("masterkey","division")

nextpurchall <- merge(clicks_basket_purch,nextpurchdivs,by="masterkey",all.x=TRUE)

nextpurch_purchonly <- merge(clicks_basket_purch,nextpurchdivs,by="masterkey")



##how many have browse?
sum(apply(nextpurch_purchonly[,2:17],1,sum)>0)
dim(nextpurch_purchonly)
browsers <- nextpurch_purchonly[apply(nextpurch_purchonly[,2:17],1,sum)>5,]
nonbrowsers <- nextpurch_purchonly[apply(nextpurch_purchonly[,2:17],1,sum)==0,]


#predvalues_clicksbasketpurch_browsers <- predict(model_clicksbasketpurch,newdata=browsers,type='class')
#predvalues_clicksbasketpurch_nonbrowsers <- predict(model_clicksbasketpurch,newdata=nonbrowsers,type='class')
predvalues_clicksbasketpurch_browsers <- predict(model_clicksbasketpurch,newdata=browsers,type='class')
predvalues_clicksbasketpurch_nonbrowsers <- predict(model_clicksbasketpurch,newdata=nonbrowsers,type='class')

##Correctly predict browsers
sum(as.vector(predvalues_clicksbasketpurch_browsers)==browsers $division)
sum(as.vector(predvalues_clicksbasketpurch_browsers)==browsers $division)/nrow(browsers)
##0.6712974

##Correctly predict nonbrowsers
sum(as.vector(predvalues_clicksbasketpurch_nonbrowsers)==nonbrowsers $division)
sum(as.vector(predvalues_clicksbasketpurch_nonbrowsers)==nonbrowsers $division)/nrow(nonbrowsers)
##0.7456044

model_clicksbasketpurch

#############
##Browsers with purch
#######

library(nnet)
model_clicksbasketpurch_b <- multinom(division~prop_purch_baby+prop_purch_toddlergirl+prop_purch_toddlerboy+prop_purch_girl+prop_purch_boy+
prop_purch_women+prop_purch_men+prop_purch_maternity+
prop_clicks_baby+prop_clicks_toddlergirl+prop_clicks_toddlerboy+prop_clicks_girl+prop_clicks_boy+
prop_clicks_women+prop_clicks_men+prop_clicks_maternity
,data= browsers,maxit=200)

coeff_clicksbasketpurch_b <- summary(model_clicksbasketpurch_b)$coefficients
coeff_clicksbasketpurch_b

##check p-values
clicksbasketpurch_b_z <- coeff_clicksbasketpurch_b/summary(model_clicksbasketpurch_b)$standard.errors
clicksbasketpurch_b_p <- (1 - pnorm(abs(clicksbasketpurch_b_z), 0, 1)) * 2
clicksbasketpurch_b_p

predvalues_clicksbasketpurch_b <- predict(model_clicksbasketpurch_b,type='class')

##Correctly predict
sum(as.vector(predvalues_clicksbasketpurch_b)== browsers$division)
sum(as.vector(predvalues_clicksbasketpurch_b)== browsers$division)/nrow(browsers)
##0.712666

model_clicksbasketpurch_b
##AIC: 170690 

##########################
##Use actual rankings from training
##########################

tiebreak <- c(.6,.2,.3,.4,.5,.8,.7,.1)  ##this corresponds to names in this.actuals

divranksactual_train <- NULL
for(i in 1:length(ucust)) {

	this.line <- nextpurch_purchonly[i,c("count_purch_baby","count_purch_toddlergirl","count_purch_toddlerboy","count_purch_girl","count_purch_boy","count_purch_women","count_purch_men","count_purch_maternity")]
colnames(this.line) <- c("BABY","TODDLERGIRL","TODDLERBOY","GIRL","BOY","WOMEN","MEN","MATERNITY")
	
	this.actuals <- this.line+tiebreak
	divactual1 <- names(this.actuals)[this.actuals>1]
	divranksactual_train <- rbind(divranksactual_train, c(divactual1[order(this.actuals[this.actuals>1],decreasing=TRUE)],rep("NULL",8-
sum(this.actuals>1))))
cat("Iteration: ",i,"\n")
}

trainactual <- data.frame(nextpurch_purchonly$masterkey,divranksactual_train[,1])
colnames(trainactual) <- c("masterkey","pred_next_div")

trainactual <- merge(trainactual,nextpurch_purchonly,by="masterkey")
sum(as.vector(trainactual$pred_next_div)==trainactual$division)/nrow(trainactual)


trainactual_browse <- trainactual[apply(nextpurch_purchonly[,2:17],1,sum)>0,]
sum(as.vector(trainactual_browse$pred_next_div)== trainactual_browse$division)/nrow(trainactual_browse)

trainactual_nobrowse <- trainactual[apply(nextpurch_purchonly[,2:17],1,sum)==0,]
sum(as.vector(trainactual_nobrowse$pred_next_div)== trainactual_nobrowse$division)/nrow(trainactual_nobrowse)



############################################################################################
##First fit next purchase model
############################################################################################
##throw all variables in
library(nnet)
model_clicksbasketpurch <- multinom(division~prop_purch_baby+prop_purch_toddlergirl+prop_purch_toddlerboy+prop_purch_girl+prop_purch_boy+
prop_purch_women+prop_purch_men+prop_purch_maternity+
prop_clicks_baby+prop_clicks_toddlergirl+prop_clicks_toddlerboy+prop_clicks_girl+prop_clicks_boy+
prop_clicks_women+prop_clicks_men+prop_clicks_maternity+
prop_basket_baby+prop_basket_toddlergirl+prop_basket_toddlerboy+prop_basket_girl+prop_basket_boy+
prop_basket_women+prop_basket_men+prop_basket_maternity
,data=nextpurch_purchonly,maxit=200)

coeff_clicksbasketpurch <- summary(model_clicksbasketpurch)$coefficients
coeff_clicksbasketpurch

##check p-values
clicksbasketpurch_z <- coeff_clicksbasketpurch/summary(model_clicksbasketpurch)$standard.errors
clicksbasketpurch_p <- (1 - pnorm(abs(clicksbasketpurch_z), 0, 1)) * 2
clicksbasketpurch_p

predvalues_clicksbasketpurch <- predict(model_clicksbasketpurch,type='class')

##Correctly predict
sum(as.vector(predvalues_clicksbasketpurch)==nextpurch_purchonly$division)
sum(as.vector(predvalues_clicksbasketpurch)==nextpurch_purchonly$division)/nrow(nextpurch_purchonly)
##0.712666

model_clicksbasketpurch
##AIC: 170690 

############################################################################################
##Purchase+browse (no basket)
model_clickspurch <- multinom(division~prop_purch_baby+prop_purch_toddlergirl+prop_purch_toddlerboy+prop_purch_girl+prop_purch_boy+
prop_purch_women+prop_purch_men+prop_purch_maternity+
prop_clicks_baby+prop_clicks_toddlergirl+prop_clicks_toddlerboy+prop_clicks_girl+prop_clicks_boy+
prop_clicks_women+prop_clicks_men+prop_clicks_maternity
,data=nextpurch_purchonly)

coeff_clickspurch <- summary(model_clickspurch)$coefficients
coeff_clickspurch

##check p-values
clickspurch_z <- coeff_clickspurch/summary(model_clickspurch)$standard.errors
clickspurch_p <- (1 - pnorm(abs(clickspurch_z), 0, 1)) * 2
clickspurch_p

predvalues_clickspurch <- predict(model_clickspurch,type='class')

##Correctly predict
sum(as.vector(predvalues_clickspurch)==nextpurch_purchonly$division)
sum(as.vector(predvalues_clickspurch)==nextpurch_purchonly$division)/nrow(nextpurch_purchonly)
##0.7122569

model_clickspurch
AIC: 170749.4 

############################################################################################


############################################################################################
##Purch only
model_purchonly <- multinom(division~prop_purch_baby+prop_purch_toddlergirl+prop_purch_toddlerboy+prop_purch_girl+prop_purch_boy+prop_purch_women+prop_purch_men+prop_purch_maternity,data=nextpurch_purchonly)

coeff_purchonly <- summary(model_purchonly)$coefficients
coeff_purchonly

##check p-values
purchonly_z <- coeff_purchonly/summary(model_purchonly)$standard.errors
purchonly_p <- (1 - pnorm(abs(purchonly_z), 0, 1)) * 2
purchonly_p

predvalues_purchonly <- predict(model_purchonly,type='class')

##Correctly predict
sum(as.vector(predvalues_purchonly)==nextpurch_purchonly$division)
sum(as.vector(predvalues_purchonly)==nextpurch_purchonly$division)/nrow(nextpurch_purchonly)
## 0.7097187

model_purchonly
##AIC: 175187.7 
############################################################################################


############################################################################################
##Use mlogit package



############################################################################################
##Predict ranks in next 6 months

##Line level purchases                
line_purch <- read.csv("/Users/ke6t4io/Documents/DivisionPreference/GP/line_purch.csv",header=FALSE)
colnames(line_purch)<- c('customer_key',
'transaction_date',
'item_qty',
'line_num',
'transaction_num',
'sales_amt',
'mdse_div_desc',
'mdse_class_desc',
'mdse_dept_desc',
'product_size_desc',
'prod_hier',
'prod_desc',
'masterkey',
'division','discount_amt')

line_purch_6mos <- line_purch[as.vector(line_purch$transaction_date)<='2013-06-30'&line_purch$division!='NONE',]
dim(line_purch_6mos)

line_purch_6mos$division <- factor(line_purch_6mos$division,levels=unique(line_purch_6mos$division))

predvalues_clicksbasketpurch <- predict(model_clicksbasketpurch,type='probs')
tiebreak <- c(.8,.7,.6,.2,.3,.4,.5,.1)  ##this corresponds to names in this.actuals

ucust <- as.vector(unique(line_purch_6mos$masterkey))
nextpurch_mk <- as.vector(nextpurch_purchonly$masterkey)
divrankspred <- NULL
divranksactual <- NULL
count6mos <- NULL
for(i in 1:length(ucust)) {
	this.preds <- predvalues_clicksbasketpurch[nextpurch_mk==ucust[i],]
	divrankspred <- rbind(divrankspred,colnames(predvalues_clicksbasketpurch)[order(this.preds,decreasing=TRUE)])

	this.line <- line_purch_6mos[line_purch_6mos$masterkey==ucust[i],"division"]

	count6mos.this <- table(this.line)
	
	this.actuals <- count6mos.this+tiebreak
	divactual1 <- names(this.actuals)[this.actuals>1]

	divranksactualclicks_train <- rbind(divranksactualclicks_train, c(divactual1[order(this.actuals[this.actuals>1],decreasing=TRUE)],rep("NULL",8-sum(this.actuals>1))))

	count6mos <- rbind(count6mos,c(count6mos,c(count6mos.this,rep("NULL",8-length(this.line)))))

cat("Iteration: ",i,"\n")
}


notnulls <- function(x) {
	return(sum(x!='NULL'))
}
numranks <- apply(divranksactual,1,notnulls)

colnames(divranksactual) <- c("RANK1","RANK2","RANK3","RANK4","RANK5","RANK6","RANK7","RANK8")
colnames(divrankspred) <- c("RANK1","RANK2","RANK3","RANK4","RANK5","RANK6","RANK7","RANK8")

##correctly predict top rank
sum(divranksactual[,1]==divrankspred[,1])/nrow(divranksactual)
##0.7541272

top2set <- NULL
top3set <- NULL
top4set <- NULL
for(i in 1: length(numranks)) {

	this.rank.pred <- sort(divrankspred[i,1:2])
	this.rank.act <- sort(divranksactual[i,1:2])
	top2set <- c(top2set,sum(this.rank.act %in% this.rank.pred))
	
	this.rank.pred <- sort(divrankspred[i,1:3])
	this.rank.act <- sort(divranksactual[i,1:3])
	top3set <- c(top3set,sum(this.rank.act %in% this.rank.pred))

	this.rank.pred <- sort(divrankspred[i,1:4])
	this.rank.act <- sort(divranksactual[i,1:4])
	top4set <- c(top4set,sum(this.rank.act %in% this.rank.pred))
	
	cat("Iteration: ",i,"\n")
}


##top 2
sum(divranksactual[,1]==divrankspred[,1]&divranksactual[,2]==divrankspred[,2])/sum(numranks>=2)
##0.3276558
length(top2set[numranks>=2&top2set==2])/sum(numranks>=2)
##0.4291139

##top 3
sum(divranksactual[,1]==divrankspred[,1]&divranksactual[,2]==divrankspred[,2]&divranksactual[,3]==divrankspred[,3])/sum(numranks>=3)
##0.2006922
length(top3set[numranks>=3&top3set==3])/sum(numranks>=3)
##0.4099324

##top 4
sum(divranksactual[,1]==divrankspred[,1]&divranksactual[,2]==divrankspred[,2]&divranksactual[,3]==divrankspred[,3])/sum(numranks>=3&divranksactual[,4]==divrankspred[,4])/sum(numranks>=4)
##0.0003101041
length(top4set[numranks>=3&top4set==4])/sum(numranks>=4)
##0.1858778












######################################################


##model selection
##try polyclass


##########################################################################
##proportions 
##counts over next 6 mos
library(MASS)
##Negative binomial
nb.women.clicks.basket.purch <- glm.nb(count_purch_women_pred~prop_clicks_women+prop_purch_women,data=clicks_basket_purch)               
nb.men.clicks.basket.purch <- glm.nb(count_purch_men_pred~count_clicks_men+count_basket_men+ count_purch_men,data=clicks_basket_purch)   
nb.baby.clicks.basket.purch <- glm.nb(count_purch_baby_pred~prop_clicks_baby+prop_basket_baby+prop_purch_baby+prop_clicks_maternity+prop_basket_maternity+prop_purch_maternity,data=clicks_basket_purch)   
nb.toddlergirl.clicks.basket.purch <- glm.nb(count_purch_toddlergirl_pred~prop_clicks_baby+prop_basket_baby+prop_purch_baby+prop_clicks_toddlergirl+prop_basket_toddlergirl+prop_purch_toddlergirl,data=clicks_basket_purch)     






##########################################################################
##Model the counts over next year
##calculate proportions for predictors

##proportions 
library(MASS)



##########################################################################


Nextpurchm <- mlogit.data(nextpurch_purchonly,shape="wide",varying=2:33,choice="division")

nextpurchfit <- glm(division~count_purch_baby+count_purch_toddlergirl+count_purch_toddlerboy+count_purch_girl+count_purch_boy+
count_purch_women+count_purch_men+count_purch_maternity+
count_clicks_baby+count_clicks_toddlergirl+count_clicks_toddlerboy+count_clicks_girl+count_clicks_boy+
count_clicks_women+count_clicks_men+count_clicks_maternity+
count_basket_baby+count_basket_toddlergirl+count_basket_toddlerboy+count_basket_girl+count_basket_boy+
count_basket_women+count_basket_men+count_basket_maternity
,data=nextpurch_purchonly,family="binomial")  


##First treat proportion as continuous
lm.women.clicks.purch <- lm(ppurch_women_pred~pclicks_women+ppurch_women,data=clicks_purch_only)               
summary(lm.women.clicks.purch)
lm.plus.clicks.purch <- lm(ppurch_plus_pred~pclicks_plus+ppurch_plus,data=clicks_purch_only)        
summary(lm.plus.clicks.purch)
lm.maternity.clicks.purch <- lm(ppurch_maternity_pred~pclicks_maternity+ppurch_maternity,data=clicks_purch_only)        
summary(lm.maternity.clicks.purch)
lm.men.clicks.purch <- lm(ppurch_men_pred~pclicks_men+ppurch_men,data=clicks_purch_only)        
summary(lm.men.clicks.purch)
lm.girls.clicks.purch <- lm(ppurch_girls_pred~pclicks_girls+ppurch_girls,data=clicks_purch_only)        
summary(lm.girls.clicks.purch)
lm.boys.clicks.purch <- lm(ppurch_boys_pred~pclicks_boys+ppurch_boys,data=clicks_purch_only)        
summary(lm.boys.clicks.purch)
lm.baby.clicks.purch <- lm(ppurch_baby_pred~pclicks_baby+ppurch_baby,data=clicks_purch_only)        
summary(lm.baby.clicks.purch)
lm.toddlergirl.clicks.purch <- lm(ppurch_toddlergirl_pred~pclicks_toddlergirl+ppurch_toddlergirl,data=clicks_purch_only)        
summary(lm.toddlergirl.clicks.purch)
lm.toddlerboy.clicks.purch <- lm(ppurch_toddlerboy_pred~pclicks_toddlerboy+ppurch_toddlerboy,data=clicks_purch_only)        
summary(lm.toddlerboy.clicks.purch)

##Maternity not sign
lm.baby.clicks.purch <- lm(ppurch_baby_pred~pclicks_baby+ppurch_baby+pclicks_maternity,data=clicks_purch_only)        
summary(lm.baby.clicks.purch)
lm.baby.clicks.purch <- lm(ppurch_baby_pred~pclicks_baby+ppurch_baby+ppurch_maternity,data=clicks_purch_only)        
summary(lm.baby.clicks.purch)

lm.toddlergirl.clicks.purch <- lm(ppurch_toddlergirl_pred~pclicks_toddlergirl+ppurch_toddlergirl+ppurch_baby,data=clicks_purch_only)        
summary(lm.toddlergirl.clicks.purch)

lm.toddlerboy.clicks.purch <- lm(ppurch_toddlerboy_pred~pclicks_toddlerboy+ppurch_toddlerboy+ppurch_baby,data=clicks_purch_only)        
summary(lm.toddlerboy.clicks.purch)

##Now rank for all 
##Use the pop means to scale the division scores
pop.means.clicks.purch <- c(mean(clicks_purch_only$pclicks_women+clicks_purch_only$ppurch_women),
mean(clicks_purch_only$pclicks_plus+clicks_purch_only$ppurch_plus),
mean(clicks_purch_only$pclicks_maternity+clicks_purch_only$ppurch_maternity),
mean(clicks_purch_only$pclicks_men+clicks_purch_only$ppurch_men),
mean(clicks_purch_only$pclicks_girls+clicks_purch_only$ppurch_girls),
mean(clicks_purch_only$pclicks_boys+clicks_purch_only$ppurch_boys),
mean(clicks_purch_only$pclicks_baby+clicks_purch_only$ppurch_baby),
mean(clicks_purch_only$pclicks_toddlergirl+clicks_purch_only$ppurch_toddlergirl),
mean(clicks_purch_only$pclicks_toddlerboy+clicks_purch_only$ppurch_toddlerboy))

pred.div <- cbind(predict(lm.women.clicks.purch,data=clicks_purch_only),
predict(lm.plus.clicks.purch,data=clicks_purch_only),
predict(lm.maternity.clicks.purch,data=clicks_purch_only),
predict(lm.men.clicks.purch,data=clicks_purch_only),
predict(lm.girls.clicks.purch,data=clicks_purch_only),
predict(lm.boys.clicks.purch,data=clicks_purch_only),
predict(lm.toddlergirl.clicks.purch,data=clicks_purch_only),
predict(lm.toddlerboy.clicks.purch,data=clicks_purch_only),
predict(lm.baby.clicks.purch,data=clicks_purch_only))

div_scores <- pred.div*(2/pop.means.clicks.purch)

clicks_basket_purch <- onemail_samp
oncol <- ncol(clicks_basket_purch)
clicks_basket_purch <- data.frame(clicks_basket_purch,clicks_basket_purch[3:11]/clicks_basket_purch$onclicks,clicks_basket_purch[12:20]/clicks_basket_purch$n_sty_purch,
clicks_basket_purch[21:29]/clicks_basket_purch$n_sty_purch_pred,clicks_basket_purch[30:38]/clicks_basket_purch$n_sty_basket)

colnames(clicks_basket_purch)[(oncol+1):ncol(clicks_basket_purch)] <-c('pclicks_women',
                'pclicks_plus',
                'pclicks_maternity',
                'pclicks_men',
                'pclicks_girls',
                'pclicks_boys',
                'pclicks_baby',
                'pclicks_toddlergirl',
                'pclicks_toddlerboy',
                'pbasket_women',
                'pbasket_plus',
                'pbasket_maternity',
                'pbasket_men',
                'pbasket_girls',
                'pbasket_boys',
                'pbasket_baby',
                'pbasket_toddlergirl',
                'pbasket_toddlerboy',
                'ppurch_women',
                'ppurch_plus',
                'ppurch_maternity',
                'ppurch_men',
                'ppurch_girls',
                'ppurch_boys',
                'ppurch_baby',
                'ppurch_toddlergirl',
                'ppurch_toddlerboy',
                'ppurch_women_pred',
                'ppurch_plus_pred',
                'ppurch_maternity_pred',
                'ppurch_men_pred',
                'ppurch_girls_pred',
                'ppurch_boys_pred',
                'ppurch_baby_pred',
                'ppurch_toddlergirl_pred',
                'ppurch_toddlerboy_pred')

##Adjust for 0 in denominator
for(i in (oncol+10):(oncol+18))   {
	clicks_basket_purch[,i] <- ifelse(clicks_basket_purch$n_sty_basket==0,0,clicks_basket_purch[,i])	
}

for(i in (oncol+19):(oncol+27))   {
	clicks_basket_purch[,i] <- ifelse(clicks_basket_purch$n_sty_purch==0,0,clicks_basket_purch[,i])	
}

for(i in (oncol+28):(oncol+36))   {
	clicks_basket_purch[,i] <- ifelse(clicks_basket_purch$n_sty_purch==0,0,clicks_basket_purch[,i])	
}

  
lm.women.clicks.basket.purch <- lm(ppurch_women_pred~pclicks_women+pbasket_women+ppurch_women-1,data=clicks_basket_purch)               
summary(lm.women.clicks.basket.purch)
lm.plus.clicks.basket.purch <- lm(ppurch_plus_pred~pclicks_plus+pbasket_plus+ppurch_plus-1,data=clicks_basket_purch)        
summary(lm.plus.clicks.basket.purch)
lm.maternity.clicks.basket.purch <- lm(ppurch_maternity_pred~pclicks_maternity+pbasket_maternity+ppurch_maternity-1,data=clicks_basket_purch)        
summary(lm.maternity.clicks.basket.purch)
lm.men.clicks.basket.purch <- lm(ppurch_men_pred~pclicks_men+pbasket_men+ppurch_men-1,data=clicks_basket_purch)        
summary(lm.men.clicks.basket.purch)
lm.girls.clicks.basket.purch <- lm(ppurch_girls_pred~pclicks_girls+pbasket_girls+ppurch_girls-1,data=clicks_basket_purch)        
summary(lm.girls.clicks.basket.purch)
lm.boys.clicks.basket.purch <- lm(ppurch_boys_pred~pclicks_boys+pbasket_boys+ppurch_boys-1,data=clicks_basket_purch)        
summary(lm.boys.clicks.basket.purch)
lm.baby.clicks.basket.purch <- lm(ppurch_baby_pred~pclicks_baby+pbasket_baby+ppurch_baby-1,data=clicks_basket_purch)        
summary(lm.baby.clicks.basket.purch)
lm.toddlergirl.clicks.basket.purch <- lm(ppurch_toddlergirl_pred~pclicks_toddlergirl+pbasket_toddlergirl+ppurch_toddlergirl-1,data=clicks_basket_purch)        
summary(lm.toddlergirl.clicks.basket.purch)
lm.toddlerboy.clicks.basket.purch <- lm(ppurch_toddlerboy_pred~pclicks_toddlerboy+pbasket_toddlerboy+ppurch_toddlerboy-1,data=clicks_basket_purch)        
summary(lm.toddlerboy.clicks.basket.purch)


##Now rank for all 
##Use the pop means to scale the division scores
pop.means.clicks.basket.purch <- c(mean(clicks_basket_purch$pclicks_women+clicks_basket_purch$ppurch_women),
mean(clicks_basket_purch$pclicks_plus+clicks_basket_purch$ppurch_plus),
mean(clicks_basket_purch$pclicks_maternity+clicks_basket_purch$ppurch_maternity),
mean(clicks_basket_purch$pclicks_men+clicks_basket_purch$ppurch_men),
mean(clicks_basket_purch$pclicks_girls+clicks_basket_purch$ppurch_girls),
mean(clicks_basket_purch$pclicks_boys+clicks_basket_purch$ppurch_boys),
mean(clicks_basket_purch$pclicks_baby+clicks_basket_purch$ppurch_baby),
mean(clicks_basket_purch$pclicks_toddlergirl+clicks_basket_purch$ppurch_toddlergirl),
mean(clicks_basket_purch$pclicks_toddlerboy+clicks_basket_purch$ppurch_toddlerboy))

pred.div <- cbind(predict(lm.women.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.plus.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.maternity.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.men.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.girls.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.boys.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.toddlergirl.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.toddlerboy.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.baby.clicks.basket.purch,data=clicks_basket_purch))

pop.means.purch <- c(mean(clicks_basket_purch$ppurch_women_pred),
mean(clicks_basket_purch$ppurch_plus_pred),
mean(clicks_basket_purch$ppurch_maternity_pred),
mean(clicks_basket_purch$ppurch_men_pred),
mean(clicks_basket_purch$ppurch_girls_pred),
mean(clicks_basket_purch$ppurch_boys_pred),
mean(clicks_basket_purch$ppurch_baby_pred),
mean(clicks_basket_purch$ppurch_toddlergirl_pred),
mean(clicks_basket_purch$ppurch_toddlerboy_pred))

div_scores <- sweep(pred.div,2,pop.means.purch,"/")
colnames(div_scores) <- c("Women","Plus","Maternity","Men","Girl","Boy","Baby","Toddlergirl","Toddlerboy")
colnames(pred.div) <- c("Women","Plus","Maternity","Men","Girl","Boy","Baby","Toddlergirl","Toddlerboy")


##Poisson
poiss.women.clicks.basket.purch <- glm(p_cnt_women_pred~pclicks_women+pbasket_women+ppurch_women,data=clicks_basket_purch,family='poisson')               
summary(poiss.women.clicks.basket.purch)
poiss.plus.clicks.basket.purch <- glm(p_cnt_plus_pred~pclicks_plus+pbasket_plus+ppurch_plus,data=clicks_basket_purch,family='poisson')        
summary(poiss.plus.clicks.basket.purch)
poiss.maternity.clicks.basket.purch <- glm(p_cnt_maternity_pred~pclicks_maternity+pbasket_maternity+ppurch_maternity,data=clicks_basket_purch,family='poisson')        
summary(poiss.maternity.clicks.basket.purch)
poiss.men.clicks.basket.purch <- glm(p_cnt_men_pred~pclicks_men+pbasket_men+ppurch_men,data=clicks_basket_purch,family='poisson')        
summary(poiss.men.clicks.basket.purch)
poiss.girls.clicks.basket.purch <- glm(ppurch_girls_pred~pclicks_girls+pbasket_girls+ppurch_girls,data=clicks_basket_purch,family='poisson')        
summary(poiss.girls.clicks.basket.purch)
poiss.boys.clicks.basket.purch <- glm(ppurch_boys_pred~pclicks_boys+pbasket_boys+ppurch_boys,data=clicks_basket_purch,family='poisson')        
summary(poiss.boys.clicks.basket.purch)
poiss.baby.clicks.basket.purch <- glm(ppurch_baby_pred~pclicks_baby+pbasket_baby+ppurch_baby,data=clicks_basket_purch,family='poisson')        
summary(poiss.baby.clicks.basket.purch)
poiss.toddlergirl.clicks.basket.purch <- glm(ppurch_toddlergirl_pred~pclicks_toddlergirl+pbasket_toddlergirl+ppurch_toddlergirl,data=clicks_basket_purch,family='poisson')        
summary(poiss.toddlergirl.clicks.basket.purch)
poiss.toddlerboy.clicks.basket.purch <- glm(ppurch_toddlerboy_pred~pclicks_toddlerboy+pbasket_toddlerboy+ppurch_toddlerboy,data=clicks_basket_purch,family='poisson')        
summary(poiss.toddlerboy.clicks.basket.purch)

plot(clicks_basket_purch$sum_of_Clicks_Women,clicks_basket_purch$p_cnt_women_pred,xlim=c(1,15),ylim=c(1,15))
boxplot(clicks_basket_purch$p_cnt_women_pred~clicks_basket_purch$sum_of_Clicks_Women)

library(MASS)
##Negative binomial
nb.women.clicks.basket.purch <- glm.nb(p_cnt_women_pred~pclicks_women+pbasket_women+ppurch_women,data=clicks_basket_purch)               
summary(nb.women.clicks.basket.purch)
nb.plus.clicks.basket.purch <- glm.nb(p_cnt_plus_pred~pclicks_plus+pbasket_plus+ppurch_plus,data=clicks_basket_purch)        
summary(nb.plus.clicks.basket.purch)
nb.maternity.clicks.basket.purch <- glm.nb(p_cnt_maternity_pred~pclicks_maternity+pbasket_maternity+ppurch_maternity,data=clicks_basket_purch)        
summary(nb.maternity.clicks.basket.purch)
nb.men.clicks.basket.purch <- glm.nb(p_cnt_men_pred~pclicks_men+pbasket_men+ppurch_men,data=clicks_basket_purch)        
summary(nb.men.clicks.basket.purch)
nb.girls.clicks.basket.purch <- glm.nb(ppurch_girls_pred~pclicks_girls+pbasket_girls+ppurch_girls,data=clicks_basket_purch)        
summary(nb.girls.clicks.basket.purch)
nb.boys.clicks.basket.purch <- glm.nb(ppurch_boys_pred~pclicks_boys+pbasket_boys+ppurch_boys,data=clicks_basket_purch)        
summary(nb.boys.clicks.basket.purch)
nb.baby.clicks.basket.purch <- glm.nb(ppurch_baby_pred~pclicks_baby+pbasket_baby+ppurch_baby,data=clicks_basket_purch)        
summary(nb.baby.clicks.basket.purch)
nb.toddlergirl.clicks.basket.purch <- glm.nb(ppurch_toddlergirl_pred~pclicks_toddlergirl+pbasket_toddlergirl+ppurch_toddlergirl,data=clicks_basket_purch)        
summary(nb.toddlergirl.clicks.basket.purch)
nb.toddlerboy.clicks.basket.purch <- glm.nb(ppurch_toddlerboy_pred~pclicks_toddlerboy+pbasket_toddlerboy+ppurch_toddlerboy,data=clicks_basket_purch)        
summary(nb.toddlerboy.clicks.basket.purch)


samp.check <- clicks_basket_purch[sample(1:nrow(clicks_basket_purch),size=500000),]
samp.check <- samp.check[samp.check$n_sty_purch_pred<100,]
nb.all <- glm.nb(n_sty_purch_pred~onclicks+n_sty_basket+n_sty_purch,data=samp.check)
summary(nb.all)
poiss.all <- glm(n_sty_purch_pred~onclicks+n_sty_basket+n_sty_purch,data=samp.check,family='poisson')        
summary(poiss.all)

hist(samp.check$n_sty_purch_pred)
mean(samp.check$n_sty_purch_pred)
var(samp.check$n_sty_purch_pred)


pred.div <- cbind(predict(poiss.all,data=clicks_basket_purch),
predict(lm.plus.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.maternity.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.men.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.girls.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.boys.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.toddlergirl.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.toddlerboy.clicks.basket.purch,data=clicks_basket_purch),
predict(lm.baby.clicks.basket.purch,data=clicks_basket_purch))


pred.women <- exp(summary(nb.all)$coefficients[1,1]+summary(nb.all)$coefficients[2,1]*clicks_basket_purch$sum_of_Clicks_Women+summary(nb.all)$coefficients[3,1]*clicks_basket_purch$b_cnt_women+summary(nb.all)$coefficients[4,1]*clicks_basket_purch$p_cnt_women)
summary(pred.women)

pred.men <- exp(summary(nb.all)$coefficients[1,1]+summary(nb.all)$coefficients[2,1]*clicks_basket_purch$sum_of_Clicks_Men+summary(nb.all)$coefficients[3,1]*clicks_basket_purch$b_cnt_men+summary(nb.all)$coefficients[4,1]*clicks_basket_purch$p_cnt_men)
summary(pred.men)

pred.maternity <- exp(summary(nb.all)$coefficients[1,1]+summary(nb.all)$coefficients[2,1]*clicks_basket_purch$sum_of_Clicks_WomenMaternity+summary(nb.all)$coefficients[3,1]*clicks_basket_purch$b_cnt_maternity+summary(nb.all)$coefficients[4,1]*clicks_basket_purch$p_cnt_maternity)
summary(pred.maternity)


pred.girls <- exp(summary(nb.all)$coefficients[1,1]+summary(nb.all)$coefficients[2,1]*clicks_basket_purch$sum_of_Clicks_Girls+summary(nb.all)$coefficients[3,1]*clicks_basket_purch$b_cnt_girls+summary(nb.all)$coefficients[4,1]*clicks_basket_purch$p_cnt_girls)
summary(pred.girls)


pred.boys <- exp(summary(nb.all)$coefficients[1,1]+summary(nb.all)$coefficients[2,1]*clicks_basket_purch$sum_of_Clicks_Boys+summary(nb.all)$coefficients[3,1]*clicks_basket_purch$b_cnt_boys+summary(nb.all)$coefficients[4,1]*clicks_basket_purch$p_cnt_boys)
summary(pred.boys)


pred.toddlergirl <- exp(exp(summary(nb.all)$coefficients[1,1]+summary(nb.all)$coefficients[2,1]*clicks_basket_purch$sum_of_Clicks_ToddlerGirls+summary(nb.all)$coefficients[3,1]*clicks_basket_purch$b_cnt_toddlergirl+summary(nb.all)$coefficients[4,1]*clicks_basket_purch$p_cnt_toddlergirl)
summary(pred.toddlergirl))

pred.toddlerboy <- exp(summary(nb.all)$coefficients[1,1]+summary(nb.all)$coefficients[2,1]*clicks_basket_purch$sum_of_Clicks_Toddlerboys+summary(nb.all)$coefficients[3,1]*clicks_basket_purch$b_cnt_toddlerboy+summary(nb.all)$coefficients[4,1]*clicks_basket_purch$p_cnt_toddlerboy)
summary(pred.toddlerboy)

pred.baby <- exp(summary(nb.all)$coefficients[1,1]+summary(nb.all)$coefficients[2,1]*clicks_basket_purch$sum_of_Clicks_Baby+summary(nb.all)$coefficients[3,1]*clicks_basket_purch$b_cnt_baby+summary(nb.all)$coefficients[4,1]*clicks_basket_purch$p_cnt_baby)
summary(pred.baby)



pred.plus <- summary(nb.all)$coefficients[1,1]+summary(nb.all)$coefficients[2,1]*clicks_basket_purch$sum_of_Clicks_Plus+summary(nb.all)$coefficients[3,1]*clicks_basket_purch$b_cnt_plus+summary(nb.all)$coefficients[4,1]*clicks_basket_purch$p_cnt_plus
summary(pred.plus)

classification.rate <- ifelse(round(pred.women[clicks_basket_purch$p_cnt_women_pred<25])==clicks_basket_purch$p_cnt_women_pred[clicks_basket_purch$p_cnt_women_pred<25],1,0)

classification.rate <- ifelse(abs((round(pred.women[clicks_basket_purch$p_cnt_women_pred<25])-3)-clicks_basket_purch$p_cnt_women_pred[clicks_basket_purch$p_cnt_women_pred<25])<3,1,0)
sum(classification.rate)/nrow(clicks_basket_purch)


      