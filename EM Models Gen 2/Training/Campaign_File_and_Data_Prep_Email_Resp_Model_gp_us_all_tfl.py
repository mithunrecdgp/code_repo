import tensorflow as tf
import curses
import tflearn as tflearn

import pandas as pd
import csv as csv

from sklearn.utils import shuffle
from sklearn.metrics import roc_curve, auc

import numpy as np

import os
import shutil


def savemodel(dirpath):
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)
    else:
        shutil.rmtree(dirpath)  # removes all the subdirectories!
        os.makedirs(dirpath)


gp_data = pd.read_csv('//10.8.8.51/lv0/Tanumoy/Datasets/Model Replication/gp_us_em_allcampaigns_truncated.txt',
                      sep='|', header=0)

gp_data.columns = ['campaign_version',
                   'customer_key',
                   'event_date',
                   'emailopenflag',
                   'emailclickflag',
                   'responder',
                   'num_txns',
                   'item_qty',
                   'gross_sales_amt',
                   'discount_amt',
                   'tot_prd_cst_amt',
                   'net_sales_amt',
                   'net_margin',
                   'net_sales_amt_6mo_sls',
                   'net_sales_amt_12mo_sls',
                   'net_sales_amt_plcc_6mo_sls',
                   'net_sales_amt_plcc_12mo_sls',
                   'discount_amt_6mo_sls',
                   'discount_amt_12mo_sls',
                   'net_margin_6mo_sls',
                   'net_margin_12mo_sls',
                   'item_qty_6mo_sls',
                   'item_qty_12mo_sls',
                   'item_qty_onsale_6mo_sls',
                   'item_qty_onsale_12mo_sls',
                   'num_txns_6mo_sls',
                   'num_txns_12mo_sls',
                   'num_txns_plcc_6mo_sls',
                   'num_txns_plcc_12mo_sls',
                   'net_sales_amt_6mo_rtn',
                   'net_sales_amt_12mo_rtn',
                   'item_qty_6mo_rtn',
                   'item_qty_12mo_rtn',
                   'num_txns_6mo_rtn',
                   'num_txns_12mo_rtn',
                   'net_sales_amt_6mo_sls_cp',
                   'net_sales_amt_12mo_sls_cp',
                   'net_sales_amt_plcc_6mo_sls_cp',
                   'net_sales_amt_plcc_12mo_sls_cp',
                   'item_qty_6mo_sls_cp',
                   'item_qty_12mo_sls_cp',
                   'item_qty_onsale_6mo_sls_cp',
                   'item_qty_onsale_12mo_sls_cp',
                   'num_txns_6mo_sls_cp',
                   'num_txns_12mo_sls_cp',
                   'num_txns_plcc_6mo_sls_cp',
                   'num_txns_plcc_12mo_sls_cp',
                   'net_sales_amt_6mo_rtn_cp',
                   'net_sales_amt_12mo_rtn_cp',
                   'item_qty_6mo_rtn_cp',
                   'item_qty_12mo_rtn_cp',
                   'num_txns_6mo_rtn_cp',
                   'num_txns_12mo_rtn_cp',
                   'visasig_flag',
                   'basic_flag',
                   'silver_flag',
                   'sister_flag',
                   'card_status',
                   'days_last_pur',
                   'days_last_pur_cp',
                   'days_on_books',
                   'days_on_books_cp',
                   'div_shp',
                   'div_shp_cp',
                   'emails_clicked',
                   'emails_clicked_cp',
                   'emails_opened',
                   'emails_opened_cp',
                   'discount_pct_12mo_sls',
                   'discount_pct_6mo_sls',
                   'avg_ord_size_12mo_sls',
                   'avg_ord_size_6mo_sls',
                   'avg_unit_retail_12mo_sls',
                   'avg_unit_retail_6mo_sls',
                   'net_sales_amt_plcc_pct_12mo_sls',
                   'net_sales_amt_plcc_pct_6mo_sls',
                   'num_txns_plcc_pct_12mo_sls',
                   'num_txns_plcc_pct_6mo_sls',
                   'item_qty_onsale_pct_12mo_sls',
                   'item_qty_onsale_pct_6mo_sls',
                   'net_sales_amt_pct_12mo_rtn',
                   'net_sales_amt_pct_6mo_rtn',
                   'num_txns_pct_12mo_rtn',
                   'num_txns_pct_6mo_rtn',
                   'item_qty_pct_12mo_rtn',
                   'item_qty_pct_6mo_rtn']

gp_data= gp_data[[ 'campaign_version',
                   'customer_key',
                   'responder',
                   'net_sales_amt_6mo_sls',
                   'net_sales_amt_12mo_sls',
                   'net_sales_amt_plcc_6mo_sls',
                   'net_sales_amt_plcc_12mo_sls',
                   'discount_amt_6mo_sls',
                   'discount_amt_12mo_sls',
                   'net_margin_6mo_sls',
                   'net_margin_12mo_sls',
                   'item_qty_6mo_sls',
                   'item_qty_12mo_sls',
                   'item_qty_onsale_6mo_sls',
                   'item_qty_onsale_12mo_sls',
                   'num_txns_6mo_sls',
                   'num_txns_12mo_sls',
                   'num_txns_plcc_6mo_sls',
                   'num_txns_plcc_12mo_sls',
                   'net_sales_amt_6mo_rtn',
                   'net_sales_amt_12mo_rtn',
                   'item_qty_6mo_rtn',
                   'item_qty_12mo_rtn',
                   'num_txns_6mo_rtn',
                   'num_txns_12mo_rtn',
                   'net_sales_amt_6mo_sls_cp',
                   'net_sales_amt_12mo_sls_cp',
                   'net_sales_amt_plcc_6mo_sls_cp',
                   'net_sales_amt_plcc_12mo_sls_cp',
                   'item_qty_6mo_sls_cp',
                   'item_qty_12mo_sls_cp',
                   'item_qty_onsale_6mo_sls_cp',
                   'item_qty_onsale_12mo_sls_cp',
                   'num_txns_6mo_sls_cp',
                   'num_txns_12mo_sls_cp',
                   'num_txns_plcc_6mo_sls_cp',
                   'num_txns_plcc_12mo_sls_cp',
                   'net_sales_amt_6mo_rtn_cp',
                   'net_sales_amt_12mo_rtn_cp',
                   'item_qty_6mo_rtn_cp',
                   'item_qty_12mo_rtn_cp',
                   'num_txns_6mo_rtn_cp',
                   'num_txns_12mo_rtn_cp',
                   'visasig_flag',
                   'basic_flag',
                   'silver_flag',
                   'sister_flag',
                   'days_last_pur',
                   'days_last_pur_cp',
                   'days_on_books',
                   'days_on_books_cp',
                   'div_shp',
                   'div_shp_cp',
                   'emails_clicked',
                   'emails_clicked_cp',
                   'emails_opened',
                   'emails_opened_cp',
                   'discount_pct_12mo_sls',
                   'discount_pct_6mo_sls',
                   'avg_ord_size_12mo_sls',
                   'avg_ord_size_6mo_sls',
                   'avg_unit_retail_12mo_sls',
                   'avg_unit_retail_6mo_sls',
                   'net_sales_amt_plcc_pct_12mo_sls',
                   'net_sales_amt_plcc_pct_6mo_sls',
                   'num_txns_plcc_pct_12mo_sls',
                   'num_txns_plcc_pct_6mo_sls',
                   'item_qty_onsale_pct_12mo_sls',
                   'item_qty_onsale_pct_6mo_sls',
                   'net_sales_amt_pct_12mo_rtn',
                   'net_sales_amt_pct_6mo_rtn',
                   'num_txns_pct_12mo_rtn',
                   'num_txns_pct_6mo_rtn',
                   'item_qty_pct_12mo_rtn',
                   'item_qty_pct_6mo_rtn']]

# Define the function to calculate Concordance----------------------------------------------------------------
def OptimisedConc(responsevalues, fittedvalues):  # responsevalues and fittedvalues are one-dimensional arrays

    z = np.vstack((fittedvalues, responsevalues)).T

    import warnings
    warnings.filterwarnings("ignore", category=np.VisibleDeprecationWarning) 
    
    zeroes = z[z[:, 1] == 0,].T
    ones = z[z[:, 1] == 1,].T
    
    concordant = 0
    discordant = 0
    ties = 0
    totalpairs = len(zeroes) * len(ones)
    
    for k in list(range(0, len(ones))):
        diffx = np.repeat(ones[k], len(zeroes)).T - zeroes[:, 0]
        concordant = concordant + np.sum(np.sign(diffx) == 1)
        discordant = discordant + np.sum(np.sign(diffx) == -1)
        ties = ties + np.sum(np.sign(diffx) == 0)
    
    concordance = concordant / totalpairs
    discordance = discordant / totalpairs
    percentties = 1 - concordance - discordance
    
    return [concordance, discordance, percentties]


# -------------------------------------------------------------------------------------------------------------

# Define the function to calculate cross-validation scores for a keras MLP      -------------------------------
# Call the keras_crossvalidation only after compiling the deep learning network -------------------------------
def tflearn_validation(Xmatrix, Yvector, model):

    probs_val = np.matrix(classifier.predict(Xmatrix))
            
    fpr_val, tpr_val, thresholds_val = roc_curve(Yvector, probs_val[:, 1])
    
    roc_auc_val = auc(fpr_val, tpr_val)
    
    concordance_val = OptimisedConc(responsevalues=Yvector,
                                    fittedvalues=(probs_val[:, 1]).T)[0]
    
    ypred = (probs_val[:,1] > 0.5)
    
    grid  =  pd.DataFrame(np.c_[Yvector, ypred])  
    grid.columns = ['Yvector', 'ypred']
    
    cfmatrix = np.array(pd.crosstab(grid['Yvector'], grid['ypred']), dtype=float)
    
    tpr_val         = cfmatrix[1,1] / np.sum(cfmatrix[1,:])
    
    tnr_val         = cfmatrix[0,0] / np.sum(cfmatrix[0,:])
    
    valAccuracy     = (cfmatrix[0,0] + cfmatrix[1,1]) / np.sum(cfmatrix)
    
    precision_val   = cfmatrix[1,1]/np.sum(ypred == 1)
    
    f1score_val     = 2 * precision_val * tpr_val / (precision_val + tpr_val) 
           
    return [roc_auc_val, concordance_val, tpr_val, tnr_val, valAccuracy, precision_val, f1score_val]

# -------------------------------------------------------------------------------------------------------------



colnames = list(gp_data.columns.values)

gp_data = pd.DataFrame.as_matrix(gp_data, columns=colnames)

gp_data_ones = np.array(gp_data[gp_data[:, 2] == 1])

gp_data_zeroes = gp_data[gp_data[:, 2] == 0]

del(gp_data)

size_list = list(range(20000, 51000, 1000));
testing_size = 20000;
validation_size = 20000;


prop = 0.5;
plot_roc = 0;
hidden_layers = (30, 15, 7);

epochs = 100
batch = 200
activationfunction = "relu"

with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Email Model/US/GP/gp_us_em_response_all_training_tfl_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'w',
          newline='') as fp:
     a = csv.writer(fp, delimiter='|')
     data = [['SampleSize', 'Layers', 'Activation', 'TrainingRun', 'Prior', 'TrainingAccuracy', 'TPR', 'TNR', 
              'TrainingAUC', 'TrainingConcordance', 'TrainingPrecision', 'TrainingF1Score', 
              'valAUC', 'valConcordance', 'valPrecision', 'valF1score']]
     a.writerows(data)

with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Email Model/US/GP/gp_us_em_response_all_testing_tfl_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'w',
          newline='') as fp:
     a = csv.writer(fp, delimiter='|')
     data = [['SampleSize', 'Layers', 'Activation', 'TrainingRun', 'TestingRun', 'Prior', 'TestingAUC', 'TestingConcordance']]
     a.writerows(data)

for i in list(range(0, len(size_list))):

    size = size_list[i];

    for run in list(range(0, 10)):

        gp_data_ones   = shuffle(gp_data_ones)
        gp_data_zeroes = shuffle(gp_data_zeroes)
        
        trainindexones   = int(size * prop)
        trainindexzeroes = int(size * (1 - prop))
        
        valindexones   = trainindexones + int(validation_size * prop)
        valindexzeroes = trainindexzeroes + int(validation_size * (1 - prop))
        
        gp_data_train = np.vstack([gp_data_ones[0:trainindexones], gp_data_zeroes[0:trainindexzeroes]])
        gp_data_val   = np.vstack([gp_data_ones[trainindexones:valindexones], gp_data_zeroes[trainindexzeroes:valindexzeroes]])
        gp_data_test  = np.vstack([gp_data_ones[valindexones:], gp_data_zeroes[valindexzeroes:]])
        
        gp_data_train = np.delete(gp_data_train, (0,1), 1)
        gp_data_val   = np.delete(gp_data_val, (0,1), 1)
        gp_data_test  = np.delete(gp_data_test, (0,1), 1)
        
        
        
        gp_data_train = np.array(gp_data_train, dtype=float)
        gp_data_val   = np.array(gp_data_val, dtype=float)
        gp_data_test  = np.array(gp_data_test, dtype=float)
        
        print("Training Prop   : ", np.sum(gp_data_train[:,0])/np.shape(gp_data_train)[0])
        print("Validation Prop : ", np.sum(gp_data_val[:,0])/np.shape(gp_data_val)[0])
        print("Testing Prop    : ", np.sum(gp_data_test[:,0])/np.shape(gp_data_test)[0])
        
        sess = tf.Session()
        init = tf.global_variables_initializer()
        sess.run(init) 
        
        tf.reset_default_graph()
        tf.logging.set_verbosity(tf.logging.ERROR)

        # Building deep neural network
        input_layer = tflearn.input_data(shape=[None, np.shape(gp_data_train)[1]-1])
        
        dense1 = tflearn.fully_connected(input_layer, hidden_layers[0], activation=activationfunction,
                                         regularizer='L2', weight_decay=0.001)
        
        dense2 = tflearn.fully_connected(dense1, hidden_layers[1], activation=activationfunction,
                                         regularizer='L2', weight_decay=0.001)
        
        dense3 = tflearn.fully_connected(dense1, hidden_layers[2], activation=activationfunction,
                                         regularizer='L2', weight_decay=0.001)
        
        softmax = tflearn.fully_connected(dense3, 2, activation='softmax')
        
        
        # Regression using SGD with learning rate decay and Top-3 accuracy
        opt =  tflearn.optimizers.Adam (learning_rate=0.001, beta1=0.9, beta2=0.999, 
                                         epsilon=1e-08, use_locking=False, name='Adam')
        
        acc = tflearn.metrics.Accuracy()
        net = tflearn.regression(softmax, optimizer=opt, loss='categorical_crossentropy', metric=acc)
        classifier = tflearn.DNN(net, tensorboard_verbose=1)
        
        # Training
        X_train = gp_data_train[:,1:(np.shape(gp_data_train)[1])]
        Y_train = np.matrix(pd.get_dummies(gp_data_train[:,0]))
        
        X_val = gp_data_val[: , 1:np.shape(gp_data_val)[1]]
        Y_val = np.matrix(pd.get_dummies(gp_data_val[:,0]))
               
        classifier.fit(X_train, Y_train, batch_size = batch,show_metric=True, 
                       n_epoch=epochs, validation_set=(X_val, Y_val))
        
        probs_train = np.matrix(classifier.predict(X_train))
            
        fpr_train, tpr_train, thresholds_train = roc_curve(gp_data_train[:,0], probs_train[:, 1])
        
        roc_grid = np.c_[thresholds_train, tpr_train, fpr_train]
        
        roc_auc_train = auc(fpr_train, tpr_train)
        
        concordance_train = OptimisedConc(responsevalues=np.matrix(gp_data_train[:, 0]),
                                          fittedvalues=(probs_train[:, 1]).T)[0]
        
        ypred = (probs_train[:,1] > 0.5)
        yvec  = (gp_data_train[:,0])
        
        grid  =  pd.DataFrame(np.c_[yvec, ypred])  
        grid.columns = ['yvec', 'ypred']
        
        cfmatrix = np.array(pd.crosstab(grid['yvec'], grid['ypred']), dtype=float)
        
        tpr_train         = cfmatrix[1,1] / np.sum(cfmatrix[1,:])
        
        tnr_train         = cfmatrix[0,0] / np.sum(cfmatrix[0,:])
        
        TrainingAccuracy  = (cfmatrix[0,0] + cfmatrix[1,1]) / np.sum(cfmatrix)
        
        precision_train   = cfmatrix[1,1]/np.sum(ypred == 1)
        
        f1score_train     = 2 * precision_train * tpr_train / (precision_train + tpr_train) 
        
        validationscores = tflearn_validation(Xmatrix=X_val, Yvector=gp_data_val[:,0], 
                                              model=classifier)
        
        
        print('SampleSize', 'Layers', 'Activation', 'Run', 'Prior', 'TrainingAccuracy', 
              'TPR', 'TNR', 'AUC', 'Concordance', 'Precision', 'F1Score',
              'valAUC', 'valConcordance', 'valPrecision', 'valF1score')
        print(size, hidden_layers, activationfunction, run+1, prop, TrainingAccuracy, 
              tpr_train, tnr_train, roc_auc_train, concordance_train, precision_train, 
              f1score_train, validationscores[0], validationscores[1], 
              validationscores[5], validationscores[6])
        
        modelfolderpath = "//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/Email Model/US/GP/TFL/"
        modelfilename = modelfolderpath + str(int(size)) + "_" + activationfunction + "_" + str(int(run+1)) + '.tflearn'
        
        classifier.save(modelfilename)
        
        classifier.load(modelfilename)
        
        with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Email Model/US/GP/gp_us_em_response_all_training_tfl_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'a', newline='') as fp:
             a = csv.writer(fp, delimiter='|')
             data = [[size, hidden_layers, activationfunction, run+1, prop, TrainingAccuracy, tpr_train, 
                     tnr_train, roc_auc_train, concordance_train, precision_train, f1score_train,
                     validationscores[0], validationscores[1], validationscores[5],
                     validationscores[5]]]
             a.writerows(data)
        
        
        for k in list(range(0,10)):
            
            gp_data_test = shuffle(gp_data_test)
            probs_test = np.matrix(classifier.predict(gp_data_test[0:testing_size, 1:(gp_data_test.shape[1])]))
            
            # Compute ROC curve and area the curve
            fpr, tpr, thresholds = roc_curve(gp_data_test[0:testing_size, 0], 
                                             probs_test[:, 1])
            roc_grid = np.c_[thresholds, tpr, fpr]
            
            roc_auc_test = auc(fpr, tpr)
            
            
            concordance_test = OptimisedConc(responsevalues=np.matrix(gp_data_test[0:testing_size, 0]),
                                          fittedvalues=(probs_test[:, 1]).T)[0]
        
            prop_tst = np.sum(gp_data_test[0:testing_size,0])/testing_size
             
            print("Size:", size, "Layers", hidden_layers, " Activation: ", activationfunction, 
                  " Training Run: ", run+1, " Testing Run:", k+1, " Prior:", prop_tst,
                  "  AUC : %f" % roc_auc_test, " Concordance:", concordance_test)
            
            with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Email Model/US/GP/gp_us_em_response_all_testing_tfl_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'a', newline='') as fp:
                 a = csv.writer(fp, delimiter='|')
                 data = [[size, hidden_layers, activationfunction, run+1, k+1, 
                         prop_tst, roc_auc_test, concordance_test]]
                 a.writerows(data)
                 
        if os.path.isfile(modelfolderpath + 'checkpoint'):
           os.remove(modelfolderpath + 'checkpoint')
        
        sess.close()