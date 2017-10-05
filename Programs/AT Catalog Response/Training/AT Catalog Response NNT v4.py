import pylab as pl
import pandas as pd
import csv as csv
import sklearn as sklearn


from sklearn import svm, datasets, model_selection
from sklearn.neural_network import MLPClassifier
from sklearn.utils import shuffle
from sklearn.metrics import roc_curve, auc
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import StratifiedKFold
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import KFold
from sklearn.metrics import precision_recall_fscore_support


import numpy as np
import matplotlib.pyplot as plt


import os
import shutil
from sklearn.externals import joblib


def savemodel (dirpath):
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)
    else:
        shutil.rmtree(dirpath)           #removes all the subdirectories!
        os.makedirs(dirpath)


at_data = pd.read_csv('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/at_catalog_data_v4.csv',
                      sep=',', header=0)

at_data.columns = [
                   "customer_key",
                   "bought",
                   "net_sales",
                   "disc_p",
                   "avg_unt_rtl",         
                   "unt_per_txn",
                   "on_sale_items",
                   "recency",
                   "items_browsed",
                   "items_abandoned",
                   "num_cat",
                   "net_sales_sameprd",
                   "disc_p_sameprd",
                   "num_txn_sameprd",
                   "avg_unt_rtl_sameprd",
                   "unt_per_txn_sameprd",
                   "on_sale_items_sameprd",
                   "season"
                  ]

def OptimisedConc(responsevalues,fittedvalues): #responsevalues and fittedvalues are one-dimensional arrays
    
  z = np.vstack((fittedvalues,responsevalues)).T
  
  zeroes = z[z[:,1]==0, ]
  ones   = z[z[:,1]==1, ]

  concordant = 0
  discordant = 0
  ties = 0
  totalpairs = len(zeroes) * len(ones)
  
  
  for k in list(range(0, len(ones))):    
    diffx = np.repeat(ones[k,0], len(zeroes)) - zeroes[:,0]
    concordant = concordant + np.sum(np.sign(diffx) ==  1)
    discordant = discordant + np.sum(np.sign(diffx) == -1)
    ties       = ties       + np.sum(np.sign(diffx) ==  0)
    
  concordance = concordant/totalpairs
  discordance = discordant/totalpairs
  percentties = 1-concordance-discordance
  
  return [concordance, discordance, percentties]
  
  
  
  
colnames = list(at_data.columns.values)

at_data = pd.DataFrame.as_matrix(at_data, columns=colnames)

at_data_ones = np.array(at_data[at_data[:,1] == 1])
                       
at_data_zeroes = at_data[at_data[:,1] == 0]

size_list = list(range(5000,21000,1000)); testing_size=20000;

with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_nnt_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'w', 
          newline='') as fp:
    a = csv.writer(fp, delimiter='|')
    data = [['SampleSize', 'Layers', 'TrainingRun', 'TrainingAccuracy', 'cvAUC', 'TrainingTPR', 'TrainingTNR', 
             'TrainingAUC', 'TrainingConcordance', 'TrainingPrecision', 'TrainingF1Score' ]]
    a.writerows(data)
    
    

with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_nnt_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'w', 
          newline='') as fp:
    a = csv.writer(fp, delimiter='|')
    data = [['SampleSize', 'Layers', 'TrainingRun', 'TestingRun', 'TestingAUC', 'TestingConcordance']]
    a.writerows(data)


prop = 0.5; plot_roc=0; hidden_layers = (12, 10, 8, 6, 4);

for i in list(range(0,len(size_list))):
    
    size = size_list[i];     
    
    print('SampleSize', 'Layers', 'Run', 'Prior', 'TrainingAccuracy', 'cvAUC', 'TPR', 'TNR', 'AUC',
          'Concordance', 'Precision', 'F1Score')
                
    for run in list(range(0,20)):
            
        at_data_ones = shuffle(at_data_ones)
        at_data_zeroes = shuffle(at_data_zeroes)
        
        
        at_data_train = np.vstack([at_data_ones[0:int(size * prop)], at_data_zeroes[0:int(size * (1-prop))]])
        at_data_test  = np.vstack([at_data_ones[int(size * prop):], at_data_zeroes[int(size * (1-prop)):]])
        
        at_data_train = np.delete(at_data_train, 0, 1)
        at_data_test  = np.delete(at_data_test,  0, 1)
        
        at_data_train = np.delete(at_data_train, np.shape(at_data_train)[1] - 1, 1)
        at_data_test  = np.delete(at_data_test,  np.shape(at_data_test )[1] - 1, 1)
        
        at_data_train = np.array(at_data_train,dtype=float)
        at_data_test  = np.array(at_data_test ,dtype=float)
        
        classifier = MLPClassifier(solver='lbfgs', alpha=1e-5, 
                                   hidden_layer_sizes=hidden_layers, random_state=1)
        
        cvscores = cross_val_score(classifier, at_data_train[:,1:(at_data_train.shape[1]-1)],
                                   at_data_train[:,0], cv=10, scoring='roc_auc')

        classifier_fit = classifier.fit(at_data_train[:,1:(at_data_train.shape[1]-1)], at_data_train[:,0])
        
        probs_train = classifier.predict_proba(at_data_train[0:size, 1:at_data_train.shape[1]-1])
        
        # Compute ROC curve and area the curve
        fpr_train, tpr_train, thresholds_train = roc_curve(at_data_train[:, 0], probs_train[:, 1])
        roc_grid = np.c_[thresholds_train, tpr_train, fpr_train]
        
        roc_auc_train = auc(fpr_train, tpr_train)
        
        pred_train = classifier.predict(at_data_train[0:size, 1:(at_data_train.shape[1]-1)])
    
        TrainingAccuracy  = np.sum(pred_train == at_data_train[:, 0]) / size
         
        tpr_train         = np.sum((pred_train + at_data_train[:, 0]) == 2)/np.sum(at_data_train[:, 0] == 1)
    
        tnr_train         = np.sum((pred_train + at_data_train[:, 0]) == 0)/np.sum(at_data_train[:, 0] == 0)
        
        precision_train   = np.sum((pred_train + at_data_train[:, 0]) == 2)/np.sum(pred_train == 1)
        
        f1score_train     = 2 * precision_train * tpr_train / (precision_train + tpr_train)                            
                                     
        concordance_train = OptimisedConc(responsevalues=at_data_train[:, 0], fittedvalues=probs_train[:, 1])[0]
                         
        print(size, hidden_layers, run+1, prop, TrainingAccuracy, np.mean(cvscores), tpr_train, tnr_train, 
              roc_auc_train, concordance_train, precision_train, f1score_train)
        
        with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_nnt_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'a', newline='') as fp:
                a = csv.writer(fp, delimiter='|')
                data = [[size, hidden_layers, run+1, TrainingAccuracy, np.mean(cvscores),tpr_train,tnr_train,
                         roc_auc_train, concordance_train, precision_train, f1score_train]]
                a.writerows(data)
                
        modelfolderpath = "//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/NNT/v4/"
        modelfilepath = modelfolderpath + str(int(size)) + "_" + str(int(run+1)) + ".pkl"
        joblib.dump(classifier, modelfilepath)

            
        for k in list(range(0,20)):
            
            at_data_test = shuffle(at_data_test)
            probs_test = classifier.predict_proba(at_data_test[0:testing_size, 1:(at_data_train.shape[1]-1)])
            
            # Compute ROC curve and area the curve
            fpr, tpr, thresholds = roc_curve(at_data_test[0:testing_size, 0], probs_test[:, 1])
            roc_grid = np.c_[thresholds, tpr, fpr]
            
            roc_auc_test = auc(fpr, tpr)
            
            pred_test = classifier.predict(at_data_test[0:testing_size, 1:(at_data_train.shape[1]-1)])
    
            TestingAccuracy  = np.sum(pred_test == at_data_test[0:testing_size, 0]) / testing_size
            
            tpr_test         = np.sum((pred_test + at_data_test[0:testing_size, 0]) == 2)/np.sum(at_data_test[0:testing_size, 0] == 1)
    
            tnr_test         = np.sum((pred_test + at_data_test[0:testing_size, 0]) == 0)/np.sum(at_data_test[0:testing_size, 0] == 0)
            
            concordance_test = OptimisedConc(responsevalues=at_data_test[0:testing_size, 0], fittedvalues=probs_test[:, 1])[0]
            
            print("Size:", size, "Layers", hidden_layers, " Training Run: ", run+1, 
                  " Testing Run:", k+1, "  AUC : %f" % roc_auc_test,
                  " Concordance:", concordance_test)
            
            with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_nnt_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'a', newline='') as fp:
                a = csv.writer(fp, delimiter='|')
                data = [[size, hidden_layers, run+1, k+1, roc_auc_test, concordance_test]]
                a.writerows(data)