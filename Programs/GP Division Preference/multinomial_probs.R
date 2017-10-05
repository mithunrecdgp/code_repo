expfn <- function(x) 
{
	exp(x)	
}

tmp <- nextpurch_purchonly_browseonly[1,c("prop_clicks_babygirl","prop_clicks_babyboy","prop_clicks_toddlergirl","prop_clicks_toddlerboy","prop_clicks_girl","prop_clicks_boy","prop_clicks_women","prop_clicks_men","prop_clicks_maternity",
"prop_basket_babygirl","prop_basket_babyboy","prop_basket_toddlergirl","prop_basket_toddlerboy","prop_basket_girl","prop_basket_boy",
"prop_basket_women","prop_basket_men","prop_basket_maternity")]

p1 <- sum(exp(coeff_browseonly[1,]*unlist(c(1,tmp))))
p2 <- sum(exp(coeff_browseonly[2,]*unlist(c(1,tmp))))
p3 <- sum(exp(coeff_browseonly[3,]*unlist(c(1,tmp))))
p4 <- sum(exp(coeff_browseonly[4,]*unlist(c(1,tmp))))
p5 <- sum(exp(coeff_browseonly[5,]*unlist(c(1,tmp))))
p6 <- sum(exp(coeff_browseonly[6,]*unlist(c(1,tmp))))
p7 <- sum(exp(coeff_browseonly[7,]*unlist(c(1,tmp))))

1/(1+p1+p2+p3+p4+p5+p6+p7)

p1/(1+p1+p2+p3+p4+p5+p6+p7)
p2/(1+p1+p2+p3+p4+p5+p6+p7)


p1 <- exp(sum(coeff_browseonly[1,]*unlist(c(1,tmp))))
p2 <- exp(sum(coeff_browseonly[2,]*unlist(c(1,tmp))))
p3 <- exp(sum(coeff_browseonly[3,]*unlist(c(1,tmp))))
p4 <- exp(sum(coeff_browseonly[4,]*unlist(c(1,tmp))))
p5 <- exp(sum(coeff_browseonly[5,]*unlist(c(1,tmp))))
p6 <- exp(sum(coeff_browseonly[6,]*unlist(c(1,tmp))))
p7 <- exp(sum(coeff_browseonly[7,]*unlist(c(1,tmp))))

1/(1+p1+p2+p3+p4+p5+p6+p7)

p1/(1+p1+p2+p3+p4+p5+p6+p7)
p2/(1+p1+p2+p3+p4+p5+p6+p7)


predvalues_clicksbasketpurch_probs[1,]
