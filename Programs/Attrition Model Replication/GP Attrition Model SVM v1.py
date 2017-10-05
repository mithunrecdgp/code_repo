
import pylab as pl
import pandas as pd
import csv as csv

import sklearn as sklearn

from sklearn import svm, datasets
from sklearn.utils import shuffle
from sklearn.metrics import roc_curve, auc
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import StratifiedKFold
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import GridSearchCV


import numpy as np
import matplotlib.pyplot as plt




gp_data = np.genfromtxt('//10.8.8.51/lv0/Saumya/Datasets/gp_final_ratio_flag_rec.csv',
                        delimiter=',', skip_header=1)
                        
gp_data[:,1] = 1 -  gp_data[:,1]

gp_data_ones = gp_data[gp_data[:,1] == 1]
                       
gp_data_zeroes = gp_data[gp_data[:,1] == 0]

with open('//10.8.8.51/lv0/Tanumoy/Datasets/Python Attrition Models/gp_retained_training.csv', 'w', 
          newline='') as fp:
    a = csv.writer(fp, delimiter=',')
    data = [['SampleSize', 'TrainingRun', 'BestGamma', 'BestC', 'NumSV', 'CVAccuracy', 
             'TrainingAccuracy', 'TrainingTPR', 'TrainingTNR', 'TrainingAUC', 'TestingRun', 
             'TestingAccuracy', 'TetsingTPR', 'TetsingTNR', 'TestingAUC']]
    a.writerows(data)

size_list = list(range(2000,15500,500)); testing_size=20000;

prop = 0.5; plot_roc=1;

for i in list(range(0,len(size_list))):
    
    size = size_list[i]; 
        
    for j in list(range(0,10)):
        
        gp_data_ones = shuffle(gp_data_ones)
        gp_data_zeroes = shuffle(gp_data_zeroes)
        
        
        gp_data_train = np.vstack([gp_data_ones[0:int(size * prop)], gp_data_zeroes[0:int(size * (1-prop))]])
        gp_data_test  = np.vstack([gp_data_ones[int(size * prop):], gp_data_zeroes[int(size * (1-prop)):]])
        
        
        C_list = [0.001, 0.01, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 10]
        
        gamma_list = [0.001, 0.01, 0.1, 1, 2, 5, 10]
        
        param_grid = dict(gamma=gamma_list, C=C_list)
        
        cv = StratifiedKFold(n_splits=10)
        
        grid = GridSearchCV(SVC(kernel='rbf', degree=0, verbose=False), 
                            param_grid=param_grid, cv=cv)
        grid.fit(gp_data_train[:,2:gp_data_train.shape[1]], gp_data_train[:,1])
        
        print("The best classifier is: ", grid.best_params_)
        
        print("The optimum value of gamma is: ", grid.best_estimator_.gamma)
        print("The optimum value of C is: ", grid.best_estimator_.C)
        print("The CV Accuracy is: ", grid.best_score_)
        
        # Run classifier
        
        classifier = svm.SVC(C=grid.best_estimator_.C, gamma=grid.best_estimator_.gamma, 
                             degree=0, kernel='rbf', verbose=True, probability=True)
        
        classifier_fit = classifier.fit(gp_data_train[:,2:gp_data_train.shape[1]], gp_data_train[:,1])
        
        nSV = np.sum(classifier_fit.n_support_)
        
        probs_train = classifier.predict_proba(gp_data_train[0:size, 2:len(gp_data_train)])
        
        # Compute ROC curve and area the curve
        fpr_train, tpr_train, thresholds_train = roc_curve(gp_data_train[:, 1], probs_train[:, 1])
        roc_grid = np.c_[thresholds_train, tpr_train, fpr_train]
        
        roc_auc_train = auc(fpr_train, tpr_train)
        
        pred_train = classifier.predict(gp_data_train[0:size, 2:len(gp_data_train)])

        TrainingAccuracy = np.sum(pred_train == gp_data_train[:, 1]) / size
        
        tpr_train = np.sum((pred_train + gp_data_train[:, 1]) == 2)/np.sum(gp_data_train[:, 1] == 1)

        tnr_train = np.sum((pred_train + gp_data_train[:, 1]) == 0)/np.sum(gp_data_train[:, 1] == 0)
        
        for k in list(range(0,20)):
            
            gp_data_test = shuffle(gp_data_test)
            probs_test = classifier.predict_proba(gp_data_test[0:testing_size, 2:len(gp_data_test)])
            
            # Compute ROC curve and area the curve
            fpr, tpr, thresholds = roc_curve(gp_data_test[0:testing_size, 1], probs_test[:, 1])
            roc_grid = np.c_[thresholds, tpr, fpr]
            
            roc_auc_test = auc(fpr, tpr)
            
            pred_test = classifier.predict(gp_data_test[0:testing_size, 2:len(gp_data_test)])

            TestingAccuracy = np.sum(pred_test == gp_data_test[0:testing_size, 1]) / testing_size
            
            tpr_test = np.sum((pred_test + gp_data_test[0:testing_size, 1]) == 2)/np.sum(gp_data_test[0:testing_size, 1] == 1)
    
            tnr_test = np.sum((pred_test + gp_data_test[0:testing_size, 1]) == 0)/np.sum(gp_data_test[0:testing_size, 1] == 0)
        
            print("Size:", size, " Training Run: ", j+1, " Testing Run:", k+1, "  Area under the ROC curve : %f" % roc_auc_test)
            
            with open('//10.8.8.51/lv0/Tanumoy/Datasets/Python Attrition Models/gp_retained_training.csv', 'a', newline='') as fp:
                a = csv.writer(fp, delimiter=',')
                data = [[size,j+1,grid.best_estimator_.gamma,grid.best_estimator_.C, nSV,
                         grid.best_score_, TrainingAccuracy,tpr_train,tnr_train,roc_auc_train,
                         k+1,TestingAccuracy,tpr_test,tnr_test,roc_auc_test]]
                a.writerows(data)
            
            # Plot ROC curve
            if plot_roc == 1:
                pl.clf()
                pl.plot(fpr, tpr, label='ROC curve (area = %0.4f)' % roc_auc_train)
                pl.plot([0, 1], [0, 1], 'k--')
                pl.xlim([0.0, 1.0])
                pl.ylim([0.0, 1.0])
                pl.xlabel('False Positive Rate')
                pl.ylabel('True Positive Rate')
                pl.title('Receiver operating characteristic example')
                pl.legend(loc="lower right")
                pl.show()
