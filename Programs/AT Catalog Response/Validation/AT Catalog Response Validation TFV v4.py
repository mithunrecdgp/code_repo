import pandas as pd
from sklearn.metrics import roc_curve, auc

import numpy as np

import os
import shutil
from sklearn.externals import joblib

import tensorflow as tf
import keras as keras
from keras.models import Sequential
from keras.layers import Dense, Activation
from keras.optimizers import SGD
from keras.utils.np_utils import to_categorical
from keras.regularizers import l2, activity_l2
from keras.callbacks import ModelCheckpoint
from keras.models import model_from_json


def savemodel (dirpath):
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)
    else:
        shutil.rmtree(dirpath)           #removes all the subdirectories!
        os.makedirs(dirpath)
        
        
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
  
  
  
  
def matrixmodebyrow(dmatrix, num_bins):            #calculates mode by each row of a matrix assuming unimodal distribution
    modes = np.zeros(shape=(dmatrix.shape[0],1))
    for k in list(range(0,dmatrix.shape[0])):    
        counts, binedges = np.histogram(dmatrix[k,:], bins=num_bins, density=False)
        for j in list(range(0,len(counts))):
            if counts[j] == max(counts):
                maxcountidx = j
                modes[k,0] = (binedges[maxcountidx+1] + binedges[maxcountidx])/2 
    return modes



size_list = list(range(5000,21000,1000));

at_train_summary = pd.read_csv('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_tfv_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt',
                               sep='|', header=0)

at_test_summary  = pd.read_csv('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_tfv_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt',
                               sep='|', header=0)

grouped = at_test_summary.groupby(['SampleSize', 'Layers', 'TrainingRun'], as_index=False)
at_test_aggregated = grouped.aggregate(np.average)
at_test_aggregated = at_test_aggregated.drop(['TestingRun', 'Layers'], 1)
at_test_aggregated = at_test_aggregated.sort_values(['SampleSize', 'TrainingRun'], 
                                                    ascending=[1, 1])

TestingAUC = at_test_aggregated['TestingAUC']
TestingConcordance = at_test_aggregated['TestingConcordance']

at_train_summary = at_train_summary.sort_values(['SampleSize', 'TrainingRun'], 
                                                ascending=[1, 1])

at_summary = pd.concat([at_train_summary, TestingAUC, TestingConcordance], axis=1)

del at_test_aggregated, TestingAUC, TestingConcordance

at_summary['DiffAUC'] = abs(at_summary['TrainingAUC'] - at_summary['TestingAUC'])
at_summary['DiffConcordance'] = abs(at_summary['TrainingConcordance'] - at_summary['TestingConcordance'])
at_summary['Score'] = at_summary['DiffAUC'] + at_summary['DiffConcordance']

at_summary = at_summary.sort_values(by=['TestingAUC', 'TestingConcordance', 'valAUC', 'Score'], 
                                    ascending=[0, 0, 0, 1])

at_summary = at_summary.drop(['Layers'], 1)


modelfolderpath = "//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/TFV/v4/"

modelfilelist = os.listdir(modelfolderpath)

i = 0
for modelfilename in modelfilelist:
        modelfilelist[i] = os.path.join(modelfolderpath, modelfilename)
        i = i + 1

modelfilelist_h5   = list("")
modelfilelist_json = list("")

for files in modelfilelist:
    if files.endswith('.h5'):
       print(files)
       modelfilelist_h5.append(files)
     
    if files.endswith('.json'):
       print(files)
       modelfilelist_json.append(files)


num_models = 50        
modellist_h5   = list("")
modellist_json = list("")

at_summary = np.matrix(at_summary)

i = 0
for i in list(range(0,num_models)):
    modellist_h5.append(modelfolderpath + str(int(at_summary[i,0])) + '_' + 
                        str(at_summary[i,1]) + '_' + str(int(at_summary[i,2])) + '.h5')
    modellist_json.append(modelfolderpath + str(int(at_summary[i,0])) + '_' + 
                          str(at_summary[i,1]) + '_' + str(int(at_summary[i,2])) + '.json')

purgelist_h5   = [item for item in set(modelfilelist_h5) if item not in set(modellist_h5)]
purgelist_json = [item for item in set(modelfilelist_json) if item not in set(modellist_json)]


i = 0
for i in list(range(0,len(purgelist_h5))):
    os.remove(purgelist_h5[i])

i = 0
for i in list(range(0,len(purgelist_json))):
    os.remove(purgelist_json[i])

    
at_data = pd.read_csv('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/fallvalid_15var_latest.csv',
                      sep=',', header=0)

at_data = pd.read_csv('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/summervalid_15var_latest.csv',
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


colnames = list(at_data.columns.values)

at_data = pd.DataFrame.as_matrix(at_data, columns=colnames)

at_data  = np.delete(at_data,  0, 1)

at_data = np.delete(at_data, np.shape(at_data)[1] - 1, 1)


num_models = 50      
        
probmatrix = np.zeros(shape=(at_data.shape[0],num_models+2))

adjprobmatrix = np.zeros(shape=(at_data.shape[0],num_models+2))

aucmatrix = np.zeros(shape=(num_models, 3))
    
i = 0
for i in list(range(0,len(modellist_json))):
    
    # load json and create model
    json_file = open(modellist_json[i], 'r')
    classifier_json = json_file.read()
    json_file.close()
    classifier = model_from_json(classifier_json)
    # load weights into new model
    classifier.load_weights(modellist_h5[i])
    print("Loaded model from disk")
        
    probs_test = classifier.predict_proba(at_data[:,1:(at_data.shape[1])],
                                          verbose=0)
    
    probmatrix[:, i] = probs_test[:, 1]

    adjprobmatrix[:, i] = 1/ (1 + (1/0.08145858 - 1) * (1/probs_test[:, 1] - 1))     

    fpr, tpr, thresholds = roc_curve(at_data[:, 0], probmatrix[:, i])
    roc_grid = np.c_[thresholds, tpr, fpr]
            
    roc_auc_test = auc(fpr, tpr)
    
    fpr, tpr, thresholds = roc_curve(at_data[:, 0], adjprobmatrix[:, i])
    roc_grid = np.c_[thresholds, tpr, fpr]
            
    roc_auc_test_adj = auc(fpr, tpr)
    
    print(i+1, roc_auc_test, roc_auc_test_adj)
    
    aucmatrix[i, 0] = i
    aucmatrix[i, 1] = roc_auc_test
    aucmatrix[i, 2] = roc_auc_test_adj
    
    
probmatrix[:, num_models] = np.mean(probmatrix[:, 0:(len(modellist_h5)-1)], axis=1)
probmatrix[:, num_models + 1] = np.median(probmatrix[:, 0:(len(modellist_h5)-1)], axis=1)


adjprobmatrix[:, num_models] = np.mean(adjprobmatrix[:, 0:(len(modellist_h5)-1)], axis=1)
adjprobmatrix[:, num_models + 1] = np.median(adjprobmatrix[:, 0:(len(modellist_h5)-1)], axis=1)

i = 0
for i in list(range(0,2)):
        
    fpr, tpr, thresholds = roc_curve(at_data[:, 0], adjprobmatrix[:, num_models + i])
    roc_grid = np.c_[thresholds, tpr, fpr]
            
    roc_auc_test = auc(fpr, tpr)
    
    print(i, "AUC: ", roc_auc_test)
    
aucmatrix = pd.concat([pd.DataFrame(modellist_h5), pd.DataFrame(aucmatrix[:,2])], axis=1)    

aucmatrix.columns = ['modellist', 'AUC']

aucmatrix.to_csv('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_fall_validation_tfv.csv',
                 index=0, sep=',')