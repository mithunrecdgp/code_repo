#AdaRank

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 3 -metric2t NDCG@19 -kcv 10 -round 2000 -tolerance 0.01
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -norm linear -ranker 3 -metric2t NDCG@19 -round 2000 -tolerance 0.01 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test_v2.txt" -metric2T NDCG@19 -norm linear -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_v2_adarank.txt"


#LamdaMart

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 6 -metric2t NDCG@19 -kcv 10 -tree 2000 -leaf 5 -shrinkage 0.1 -estop 50
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -norm linear -ranker 6 -metric2t NDCG@19 -tree 2000 -leaf 5 -shrinkage 0.1 -estop 50 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test_v2.txt" -metric2T NDCG@19 -norm linear -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_v2_lambdamart.txt"

#ListNet

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 7 -metric2t NDCG@19 -kcv 10 -epoch 100 -lr 0.001
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 7 -metric2t NDCG@19 -epoch 500 -lr 0.001 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test_v2.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_v2_listnet.txt"

#Coordinate Ascent

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 4 -metric2t NDCG@19 -kcv 10 -r 5 -i 50 -tolerance 0.001
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 4 -metric2t NDCG@19 -r 5 -i 50 -tolerance 0.001 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test_v2.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_v2_coordinateascent.txt"

#Mart - Gradient Boosted Regression Tree

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 0 -metric2t NDCG@19 -kcv 10 -tree 100 -leaf 10 -tc 10 -lr 0.1
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -norm linear -ranker 0 -metric2t NDCG@19 -tree 2000 -leaf 10 -tc 10 -lr 0.1 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test_v2.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_v2_gbmregressiontree.txt"


#RankNet

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 1 -metric2t NDCG@19 -kcv 10 -epoch 100 -lr 0.00005 -node 10 -layer 2
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 1 -metric2t NDCG@19 -epoch 2000 -lr 0.00005 -node 10 -epoch 10 -layer 2 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test_v2.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_v2_ranknet.txt"

#Random Forests with LambdaMart

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 8 -metric2t NDCG@19 -srate 0.3 -bag 100 -frate 0.5 -rtype 6 -leaf 50 -shrinkage 0.05
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 8 -metric2t NDCG@19 -srate 0.3 -bag 200 -frate 0.5 -rtype 6 -leaf 50 -shrinkage 0.05 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test_v2.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_v2_rflambdamart.txt"

#Random Forests with Mart - Gradient Boosted Regression Trees

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 8 -metric2t NDCG@19 -srate 0.3 -bag 100 -frate 0.5 -rtype 0 -leaf 50 -shrinkage 0.05
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_train_v2.txt" -ranker 8 -metric2t NDCG@19 -srate 0.3 -bag 100 -frate 0.5 -rtype 0 -leaf 50 -shrinkage 0.05 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\at_normal_first_test_v2.txt" -metric2T NDCG@19 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\AT\at_normal_first_train_v2_rfgbmregressiontree.txt"
