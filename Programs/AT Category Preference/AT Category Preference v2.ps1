#AdaRank

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 3 -metric2t NDCG@19 -kcv 10 -round 100 -tolerance 0.01
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 3 -metric2t NDCG@19 -round 500 -tolerance 0.01 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_adarank.txt"


#LamdaMart

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 6 -metric2t NDCG@19 -kcv 10 -tree 500 -leaf 5 -shrinkage 0.1 -estop 50
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 6 -metric2t NDCG@19 -tree 500 -leaf 5 -shrinkage 0.1 -estop 50 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_lambdamart.txt"

#ListNet

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 7 -metric2t NDCG@19 -kcv 10 -epoch 100 -lr 0.001
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 7 -metric2t NDCG@19 -epoch 500 -lr 0.001 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_listnet.txt"

#Coordinate Ascent

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 4 -metric2t NDCG@19 -kcv 10 -r 5 -i 50 -tolerance 0.001
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 4 -metric2t NDCG@19 -r 5 -i 50 -tolerance 0.001 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_coordinateascent.txt"

#Mart - Gradient Boosted Regression Trees

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 0 -metric2t NDCG@19 -kcv 10 -tree 100 -leaf 10 -tc 10 -lr 0.1
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 0 -metric2t NDCG@19 -tree 500 -leaf 10 -tc 10 -lr 0.1 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_gbmregressiontree.txt"


#RankNet

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 1 -metric2t NDCG@19 -kcv 10 -epoch 100 -lr 0.00005 -node 10 -layer 2
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 1 -metric2t NDCG@19 -epoch 100 -lr 0.00005 -node 10 -epoch 10 -layer 2 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_ranknet.txt"

#Random Forests with LambdaMart

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 8 -metric2t NDCG@19 -kcv 10 -srate 0.3 -bag 100 -frate 0.5 -rtype 6 -leaf 50 -shrinkage 0.05
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 8 -metric2t NDCG@19 -srate 0.3 -bag 200 -frate 0.5 -rtype 6 -leaf 50 -shrinkage 0.05 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_rflambdamart.txt"

#Random Forests with Mart - Gradient Boosted Regression Trees

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 8 -metric2t NDCG@19 -kcv 10 -srate 0.3 -bag 100 -frate 0.5 -rtype 0 -leaf 50 -shrinkage 0.05
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train.txt" -ranker 8 -metric2t NDCG@19 -srate 0.3 -bag 200 -frate 0.5 -rtype 0 -leaf 50 -shrinkage 0.05 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_rfgbmregressiontree.txt"
