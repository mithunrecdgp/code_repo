
#--------------------------------- Load BTYD (Buy TIll You Die) Package --------------------------------------------
library(BTYD)
library(grt)
library(amap)
library(ffbase)


#--------------------------------- Import the data for model training and forecasting ------------------------------
mydata <- read.table.ffdf(file="//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/on_may_eq_wt.txt",
                          sep="|",head=TRUE, VERBOSE=T)




write.table(cbind('Decile', 'Iteration',
                  'Lambda1', 'Lambda2', 'Lambda3', 'Lambda4',
                  'TrainError', 'TrainSDError', 'TestError', 'TestSDError'), 
            file = "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/on_may_comb.txt", 
            sep= ",", row.names= F, col.names= F, append=F)

iterations <- 20;


for (m in 1:10)
{
  
  mydata.decile <- mydata[which(mydata[,ncol(mydata)] >= (m-1)*10+1 &  mydata[,ncol(mydata)] <= m*10), ]
  grid <- matrix(0, iterations, 10) 
  
  for (n in 1:20)
  {
    
    train.index <- sample((1:nrow(mydata.decile)), size=0.5 * nrow(mydata.decile), replace=F)
    mydata.decile.train <- mydata.decile[c(train.index), ]
    mydata.decile.test <- mydata.decile[-c(train.index), ]
    
    mydata.decile.train[is.na(mydata.decile.train)] <- 0
    mydata.decile.test[is.na(mydata.decile.test)] <- 0
    
    y.train <- mydata.decile.train[, 2]; y.test <- mydata.decile.test[, 2];
    x.train <- as.matrix(mydata.decile.train[, 3:6]); x.test <- as.matrix(mydata.decile.test[, 3:6]);
    
    min.error.train <- 10^10; min.error.test <- 10^10;
    min.sderror.train <- 10^10; min.sderror.test <- 10^10;
    
    for (i in seq(0, 1, 0.1))           #--------- iterating over lambda1 -----------#
    {
     for (j in seq(0, 1, 0.1))          #--------- iterating over lambda2 -----------#
     {
       for (k in seq(0, 1, 0.1))        #--------- iterating over lambda3 -----------#
       {        
         if (i+j+k <= 1)
         {
           l <- round(1-i-j-k,2)
           lambda.vec<-c(i,j,k,l)
           
           error.train <- sqrt(mean((y.train - i*x.train[,1] - j*x.train[,2] - k*x.train[,3] - l*x.train[,4])**2))
           sderror.train <- sqrt(sqrt(var((y.train - i*x.train[,1] - j*x.train[,2] - k*x.train[,3] - l*x.train[,4])**2)))
           error.test <- sqrt(mean((y.test - i*x.test[,1] - j*x.test[,2] - k*x.test[,3] - l*x.test[,4])**2))
           sderror.test <- sqrt(sqrt(var((y.test - i*x.test[,1] - j*x.test[,2] - k*x.test[,3] - l*x.test[,4])**2)))
           
           print(paste(m, n, i, j, k, l, error.train, sderror.train, error.test, sderror.test))
           
           
           if (error.test < min.error.test & sderror.test < min.sderror.test)
           {
             if (error.train< min.error.train & sderror.train < min.sderror.train)
             {
               min.error.train <- error.train
               min.error.test <- error.test
               min.sderror.train <- sderror.train
               min.sderror.test <- sderror.test
               min.i <- round(i,2)
               min.j <- round(j,2)
               min.k <- round(k,2)
               min.l <- round(l,2)
             }
           }
           
           
           
         } #----------- End: i+j+k+l = 1 constraint --------------------
                  
       }   #----------- End: loop k --------------------
       
      }    #----------- End: loop j --------------------
     
    }      #----------- End: loop i --------------------
    
    print('--------- Best results based on min mean abs error and min sderror abs error ---------')
    print(paste(m, n, min.i, min.j, min.k, min.l,
                min.error.train, min.sderror.train, min.error.test, min.sderror.test))
    print('---------------------------------------------------------------------------------')
    
    
    grid[n, 1] = m
    grid[n, 2] = n
    grid[n, 3] = min.i
    grid[n, 4] = min.j
    grid[n, 5] = min.k
    grid[n, 6] = min.l
    grid[n, 7] = min.error.train
    grid[n, 8] = min.sderror.train
    grid[n, 9] = min.error.test
    grid[n, 10] = min.sderror.test
    
  } #----------- End: loop m itertaion --------------------
  
  write.table(grid, 
              file = "//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/on_may_comb.txt", 
              sep= ",", row.names= F, col.names= F, append=T)
  
}

