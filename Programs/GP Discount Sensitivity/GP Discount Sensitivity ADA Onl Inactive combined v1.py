import pylab as pl
import pandas as pd
import csv as csv
import sklearn as sklearn

from sklearn import cross_validation
from sklearn.utils import shuffle
from sklearn.metrics import roc_curve, auc
from sklearn.ensemble import AdaBoostClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.cross_validation import cross_val_score
from sklearn.externals import joblib

import numpy as np
import matplotlib.pyplot as plt

import os
import shutil

def savemodel (dirpath):
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)
    else:
        shutil.rmtree(dirpath)           #removes all the subdirectories!
        os.makedirs(dirpath)

path = '//10.8.8.51/lv0/Tanumoy/Datasets/Discount Sensitivity/GP_OnlineInactive_1st_2nd_combined.csv'
colnames = ('customer_key',
            'Disc_Sen_Tag',
            'brand_of_acquisition',
            'bf_net_sales_amt_12mth',
            'bf_gp_sales_ratio' ,
            'total_rev_prom_12mth' ,
            'holidy_rev_ratio_12mth' ,
            'num_txn_6mth' ,
            'num_txn_12mth' ,
            'ratio_txn_6_12mth' ,
            'on_net_sales_amt_12mth' ,
            'num_dist_catg_purchase' ,
            'ratio_disc_n_disc_ats' ,
            'card_status' ,
            'order_last_12_mth_onl' ,
            'ord_ratio_6_12_mth_onl' ,
            'online_net_sales_12mth' ,
            'total_net_sales_12mth' ,
            'ratio_onl_tot_sales' ,
            'num_txn_6mth_onl' ,
            'num_units_12mth_onl' )
                         
gp_data = pd.read_csv(path, sep=',',header=0)
gp_data['brand_of_acquisition'] = pd.Categorical.from_array(gp_data.brand_of_acquisition).labels
gp_data['card_status'] = pd.Categorical.from_array(gp_data.card_status).labels

                                
#gp_data = gp_data.convert_objects(convert_numeric=True)

gp_data = pd.DataFrame.as_matrix(gp_data, columns=colnames)

gp_data_ones = gp_data[gp_data[:,1] == 1]
                       
gp_data_zeroes = gp_data[gp_data[:,1] == 0]

with open('//10.8.8.51/lv0/Tanumoy/Datasets/Discount Sensitivity/gp_python_onl_inactive_combined_training.csv', 'w', 
          newline='') as fp:
    a = csv.writer(fp, delimiter=',')
    data = [['SampleSize', 'TrainingRun', 'nu', 'CVAccuracy', 
             'TrainingAccuracy', 'TrainingTPR', 'TrainingTNR', 'TrainingAUC', 'TestingRun', 
             'TestingAUC']]
    a.writerows(data)
    
    
ls = 5000; us = 20000; interval = 1000;
size_list = list(np.linspace(ls, us, 1 + (us - ls)/interval, True)); 
testing_size=20000;

prop = 0.5; plot_roc=0;

i = 0
for i in list(range(0,len(size_list))):
    
    size = size_list[i]; 
    
    j = 0    
    for j in list(range(0,10)):
        
        nu = (j+1)/10
        gp_data_ones = shuffle(gp_data_ones)
        gp_data_zeroes = shuffle(gp_data_zeroes)
        
        
        gp_data_train = np.vstack([gp_data_ones[0:(size * prop)], gp_data_zeroes[0:(size * (1-prop))]])
        gp_data_test  = np.vstack([gp_data_ones[(size * prop):], gp_data_zeroes[(size * (1-prop)):]])
        
        l = 0
        for l in list(range(0,10)):
            
            nu = (l+1)/10
            
            # Run classifier
            
            bdt = AdaBoostClassifier(DecisionTreeClassifier(max_depth=5),
                                     algorithm="SAMME", n_estimators=95,
                                     learning_rate=nu)
                                     
            bdt.fit = bdt.fit(y=gp_data_train[:,1], 
                              X=gp_data_train[:,2:gp_data_train.shape[1]])
                              
            scores = cross_val_score(bdt, y=gp_data_train[:,1], cv=10,
                                     X=gp_data_train[:,2:gp_data_train.shape[1]])
            cv_accuracy = scores.mean()                                 
            
            probs_train = bdt.predict_proba(X=gp_data_train[:,2:gp_data_train.shape[1]])
            
            # Compute ROC curve and area the curve
            fpr_train, tpr_train, thresholds_train = roc_curve(gp_data_train[:, 1], probs_train[:, 1])
            roc_grid = np.c_[thresholds_train, tpr_train, fpr_train]
            
            roc_auc_train = auc(fpr_train, tpr_train)
            
            pred_train = bdt.predict(gp_data_train[0:size, 2:len(gp_data_train)])
    
            TrainingAccuracy = np.sum(pred_train == gp_data_train[:, 1]) / size
            
            tpr_train = np.sum((pred_train + gp_data_train[:, 1]) == 2)/np.sum(gp_data_train[:, 1] == 1)
    
            tnr_train = np.sum((pred_train + gp_data_train[:, 1]) == 0)/np.sum(gp_data_train[:, 1] == 0)
            
            modelfolderpath = "D:/Discount Sensitivity/Pickle/ADA_Onl_Inactive_combined/" + str(int(size)) + "_" + str(int(j+1)) +"_" + str(nu)
            modelfilepath = modelfolderpath + "/" + str(int(size)) + "_" + str(int(j+1)) +"_" + str(nu) + ".pkl"
            savemodel(modelfolderpath)
            
            joblib.dump(bdt, modelfilepath)
            
            k = 0
            for k in list(range(0,20)):
                
                gp_data_test = shuffle(gp_data_test)
                probs_test = bdt.predict_proba(gp_data_test[0:testing_size, 2:len(gp_data_test)])
                
                # Compute ROC curve and area the curve
                fpr_test, tpr_test, thresholds_test = roc_curve(gp_data_test[0:testing_size, 1], probs_test[:, 1])
                roc_grid = np.c_[thresholds_test, tpr_test, fpr_test]
                
                roc_auc_test = auc(fpr_test, tpr_test)
            
                print("Size:", size, " Training Run: ", j+1, " Nu", nu, 
                      " Testing Run:", k+1,
                      " Train.AUC : %f" % roc_auc_train,
                      " Test.AUC : %f" % roc_auc_test)
                
                with open('//10.8.8.51/lv0/Tanumoy/Datasets/Discount Sensitivity/gp_python_onl_inactive_combined_training.csv', 'a', newline='') as fp:
                    a = csv.writer(fp, delimiter=',')
                    data = [[size,j+1, nu, cv_accuracy, TrainingAccuracy, tpr_train, 
                             tnr_train, roc_auc_train, k+1,
                             roc_auc_test]]
                    a.writerows(data)
                
                # Plot ROC curve
                if plot_roc == 1:
                    pl.clf()
                    pl.plot(fpr_test, tpr_test, label='ROC curve (area = %0.4f)' % roc_auc_test)
                    pl.plot([0, 1], [0, 1], 'k--')
                    pl.xlim([0.0, 1.0])
                    pl.ylim([0.0, 1.0])
                    pl.xlabel('False Positive Rate')
                    pl.ylabel('True Positive Rate')
                    pl.title('Receiver operating characteristic example')
                    pl.legend(loc="lower right")
                    pl.show()