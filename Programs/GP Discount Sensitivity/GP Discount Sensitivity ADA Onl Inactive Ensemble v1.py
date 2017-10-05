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

path = '//10.8.8.51/lv0/Tanumoy/Datasets/Discount Sensitivity/GP_Onl_Inactive_Base.csv'
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
gp_data = pd.DataFrame.as_matrix(gp_data, columns=colnames)


print('----------------------------------------------------------------------------')
print('------ Scoring customers using an ensemble of 20 best ADA/SAMME Models -----')
print('----------------------------------------------------------------------------')

modelspath = '//10.8.8.51/lv0/Tanumoy/Datasets/Discount Sensitivity/gp_python_onl_inactive_best_models.csv'
models = pd.read_csv(modelspath, sep=',', header=0)
models = pd.DataFrame.as_matrix(models)
num_models = models.shape[0]


outputmatrix  = np.zeros((gp_data.shape[0], 23))
outputmatrix[:,0] = gp_data[:,0]
outputmatrix[:,1] = gp_data[:,1]

i = 0
for i in list(range(0, num_models)):
    currentmodelfolder = str(models[i,0]) + '_' + str(models[i,1]) + '_' + str(float(models[i,2]))
    currentmodelname = str(models[i,0]) + '_' + str(models[i,1]) + '_' + str(float(models[i,2])) + '.pkl'
    currentmodelpath = 'D:/Discount Sensitivity/Pickle/ADA_Onl_Inactive/' + currentmodelfolder + '/' + currentmodelname
    print(currentmodelpath)
    bdt = joblib.load(currentmodelpath)
    print('Scoring Model ' + str(i+1) + ' : ' + currentmodelfolder)
    probs_test = bdt.predict_proba(gp_data[:,2:gp_data.shape[1]])
    outputmatrix[:, (i+2)] = probs_test[:, 1]



    
outputmatrix[:, (num_models + 2)] = np.median(outputmatrix[:,1:20], axis=1)

roc_auc_test = np.zeros((num_models+1, 1))

print('----------------------------------------------------------------------------')
print('----- Reporting AUC for Unadjusted Probabilities from ADA/SAMME Models -----')
print('----------------------------------------------------------------------------')

j = 0
for j in list(range(0, num_models+1)):  
    
    # Compute ROC curve and area the curve
    fpr_test, tpr_test, thresholds_test = roc_curve(outputmatrix[:,1], outputmatrix[:,j+2])
    roc_grid = np.c_[thresholds_test, tpr_test, fpr_test]
    roc_auc_test[j,0] = auc(fpr_test, tpr_test)
    print('Scoring Model ' + str(j+1) + ' AUC Unadjusted Probabilities: ' + str(roc_auc_test[j,0]))
        
outputmatrix[:, (num_models + 2)] = np.median(outputmatrix[:,1:20], axis=1)

outputmatrix_adj  = np.zeros((gp_data.shape[0], 23))
outputmatrix_adj[:,0] = gp_data[:,0]
outputmatrix_adj[:,1] = gp_data[:,1]

print('----------------------------------------------------------------------------')
print('------ Reporting AUC for Adjusted Probabilities from ADA/SAMME Models ------')
print('----------------------------------------------------------------------------')


j = 0
for j in list(range(0, num_models+1)):  
    prop = sum(outputmatrix[:,1])/outputmatrix.shape[0]
    logit = np.log(outputmatrix[:,j+2]) / (1 + np.log(outputmatrix[:,j+2]))
    offset = - np.log(prop/(1-prop)) 
    outputmatrix_adj[:,j+2] = np.exp(logit - offset)/(1 + np.exp(logit - offset))
    # Compute ROC curve and area the curve
    fpr_test, tpr_test, thresholds_test = roc_curve(outputmatrix_adj[:,1], outputmatrix_adj[:,j+2])
    roc_grid = np.c_[thresholds_test, tpr_test, fpr_test]
    roc_auc_test[j,0] = auc(fpr_test, tpr_test)
    print('Scoring Model ' + str(j+1) + ' AUC Adjusted Probabilities: ' + str(roc_auc_test[j,0]))
    
    
outputmatrix_adj[:, (num_models + 2)] = np.median(outputmatrix_adj[:,1:20], axis=1)


print('----------------------------------------------------------------------------')
print(' Exporting Adjusted Probabilities from ADA/SAMME Models to an external file ')
print('----------------------------------------------------------------------------')

   
with open('//10.8.8.51/lv0/Tanumoy/Datasets/Discount Sensitivity/gp_python_onl_inactive_ensemble.csv', 'w', 
          newline='') as fp:
    a = csv.writer(fp, delimiter=',')
    data = [['customer_key', 'Disc_Sen_Tag', 
             'model1', 'model2', 'model3', 'model4', 
             'model5', 'model6', 'model7', 'model8',
             'model9', 'model10', 'model11', 'model12',
             'model13', 'model14', 'model15', 'model16',
             'model17', 'model18', 'model19', 'model20',
             'modelmedian']]
    a.writerows(data)
    
with open('//10.8.8.51/lv0/Tanumoy/Datasets/Discount Sensitivity/gp_python_onl_inactive_ensemble.csv', 'a', newline='') as fp:
    a = csv.writer(fp, delimiter=',')
    data = [[outputmatrix_adj]]
    a.writerows(outputmatrix_adj)