#*********** Load Packages ************#
library(data.table)
library(quadprog)
library(dplyr)
library(ffbase)
library(ff)
library(matrixStats)

#*********** Read Data ************#
mydata<-read.csv.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/on_may_eq_wt.txt",
                     header = TRUE, VERBOSE = TRUE, sep='|',colClasses = c(rep("numeric",6)))

write.table(cbind('Decile', 'Iteration',
                  'Lambda1', 'Lambda2', 'Lambda3', 'Lambda4',
                  'TrainMAE', 'TrainSDAE', 'TestMAE', 'TestSDAE'), 
            file = "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/on_may_quad.txt", 
            sep= ",", row.names= F, col.names= F, append=F)

for (m in 1:10)
{
  mydata.decile <- mydata[which(mydata[,ncol(mydata)] >= (m-1)*10+1 &  mydata[,ncol(mydata)] <= m*10), ]
  for (n in 1:20)
  {
    
    train.index <- sample((1:nrow(mydata.decile)), size=0.5 * nrow(mydata.decile), replace=F)
    mydata.decile.train <- mydata.decile[c(train.index), ]
    mydata.decile.test <- mydata.decile[-c(train.index), ]
    
    mydata.decile.train[is.na(mydata.decile.train)] <- 0
    mydata.decile.test[is.na(mydata.decile.test)] <- 0
    
    
    
    Y.train<-mydata.decile.train[,2] %>% as.matrix
    X.train<-mydata.decile.train[,3:6] %>% as.matrix
    
    Y.test<-mydata.decile.test[,2] %>% as.matrix
    X.test<-mydata.decile.test[,3:6] %>% as.matrix
    
    #X_wt<-mydata[,7] %>% as.matrix
    N.train<-nrow(X.train); N.test <- nrow(X.test);
    
      
    #*********** Cholesky Decomposition ************#
    Rinv <- solve(chol(t(X.train) %*% X.train))
    
    #*********** Coefficients for Optimization ************#
    nvars<-ncol(X.train)
    C <- cbind(rep(1,nvars), diag(nvars))
    b <- c(1,rep(0,nvars))
    d <- t(Y.train) %*% X.train  
    
    
    
    #*********** Scaled Variable Run ************#
    #If above gives error then scale the variables
    Norm2Scale = sqrt(norm(d,"2"))
    H2<-solve.QP(Dmat = Rinv*Norm2Scale, factorized = T, dvec = d/(Norm2Scale^2), Amat = C, bvec = b, meq = 1)
    Mult2<-round(H2$solution, 5)
    
    trainmae <- mean(abs(Y.train - rowSums(X.train * Mult2)))
    trainsdae <- sqrt(var(abs(Y.train - rowSums(X.train * Mult2))))
    
    testmae <- mean(abs(Y.test - rowSums(X.test * Mult2)))
    testsdae <- sqrt(var(abs(Y.test - rowSums(X.test * Mult2))))
      
    print(paste(m, n, Mult2[1], Mult2[2], Mult2[3], Mult2[4], trainmae, trainsdae, testmae, testsdae))
    write.table(cbind(m, n, Mult2[1], Mult2[2], Mult2[3], Mult2[4], trainmae, trainsdae, testmae, testsdae), 
                file = "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/on_may_quad.txt", 
                sep= ",", row.names= F, col.names= F, append=T)
  }  
  
}

