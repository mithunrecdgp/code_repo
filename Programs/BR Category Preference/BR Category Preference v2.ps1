Get-Content "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -TotalCount 20

#AdaRank

java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 3 -metric2t NDCG@59 -kcv 5 -round 100 -tolerance 0.01
java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 3 -metric2t NDCG@59 -round 100 -tolerance 0.01 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_test_v2.txt" -metric2T NDCG@59 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\BR\br_normal_first_train_v2_adarank.txt"


#LamdaMart

java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 6 -metric2t NDCG@59 -kcv 10 -tree 100 -leaf 5 -shrinkage 0.1 -estop 50
java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 6 -metric2t NDCG@59 -tree 100 -leaf 5 -shrinkage 0.1 -estop 50 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_test_v2.txt" -metric2T NDCG@59 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\BR\br_normal_first_train_v2_lambdamart.txt"

#ListNet

java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 7 -metric2t NDCG@59 -kcv 10 -epoch 100 -lr 0.001
java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 7 -metric2t NDCG@59 -epoch 100 -lr 0.001 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_test_v2.txt" -metric2T NDCG@59 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\BR\br_normal_first_train_v2_listnet.txt"

#Coordinate Ascent

java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 4 -metric2t NDCG@59 -kcv 10 -r 5 -i 50 -tolerance 0.001
java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 4 -metric2t NDCG@59 -r 5 -i 50 -tolerance 0.001 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_test_v2.txt" -metric2T NDCG@59 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\BR\br_normal_first_train_v2_coordinateascent.txt"

#Mart - Gradient Boosted Regression Trees

java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 0 -metric2t NDCG@59 -kcv 10 -tree 100 -leaf 10 -tc 10 -lr 0.1
java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 0 -metric2t NDCG@59 -tree 500 -leaf 10 -tc 10 -lr 0.1 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_test_v2.txt" -metric2T NDCG@59 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\BR\br_normal_first_train_v2_gbmregressiontree.txt"


#RankNet

java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 1 -metric2t NDCG@59 -kcv 10 -epoch 100 -lr 0.00005 -node 10 -layer 2
java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 1 -metric2t NDCG@59 -epoch 100 -lr 0.00005 -node 10 -epoch 10 -layer 2 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_test_v2.txt" -metric2T NDCG@59 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\BR\br_normal_first_train_v2_ranknet.txt"

#Random Forests with LambdaMart

java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 8 -metric2t NDCG@59 -kcv 10 -srate 0.3 -bag 100 -frate 0.5 -rtype 6 -leaf 50 -shrinkage 0.05
java -Xmx7168m -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 8 -metric2t NDCG@59 -srate 0.3 -bag 200 -frate 0.5 -rtype 6 -leaf 50 -shrinkage 0.05 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_test_v2.txt" -metric2T NDCG@59 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\BR\br_normal_first_train_v2_rflambdamart.txt"

#Random Forests with Mart - Gradient Boosted Regression Trees

java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 8 -metric2t NDCG@59 -kcv 10 -srate 0.3 -bag 100 -frate 0.5 -rtype 0 -leaf 50 -shrinkage 0.05
java -jar C:\Users\tghosh\Downloads\Ranklib-2.6.jar -train "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_train_v2.txt" -ranker 8 -metric2t NDCG@59 -srate 0.3 -bag 200 -frate 0.5 -rtype 0 -leaf 50 -shrinkage 0.05 -test "\\10.8.8.51\lv0\Tanumoy\Datasets\Model Replication\br_normal_first_test_v2.txt" -metric2T NDCG@59 -save "\\10.8.8.51\lv0\Tanumoy\Datasets\Parameter Files\Category Preference\BR\br_normal_first_train_v2_rfgbmregressiontree.txt"
