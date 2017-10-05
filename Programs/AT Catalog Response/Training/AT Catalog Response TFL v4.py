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



colnames = list(at_data.columns.values)

at_data = pd.DataFrame.as_matrix(at_data, columns=colnames)

at_data_ones = np.array(at_data[at_data[:, 1] == 1])

at_data_zeroes = at_data[at_data[:, 1] == 0]

del(at_data)

size_list = list(range(5000, 21000, 1000));
testing_size = 20000;
validation_size = 20000;


prop = 0.5;
plot_roc = 0;
hidden_layers = (12, 9, 6);

epochs = 100
batch = 200
activationfunction = "tanh"

with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_tfl_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'w',
          newline='') as fp:
     a = csv.writer(fp, delimiter='|')
     data = [['SampleSize', 'Layers', 'Activation', 'TrainingRun', 'Prior', 'TrainingAccuracy', 'TPR', 'TNR', 
              'TrainingAUC', 'TrainingConcordance', 'TrainingPrecision', 'TrainingF1Score', 
              'valAUC', 'valConcordance', 'valPrecision', 'valF1score']]
     a.writerows(data)

with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_tfl_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'w',
          newline='') as fp:
     a = csv.writer(fp, delimiter='|')
     data = [['SampleSize', 'Layers', 'Activation', 'TrainingRun', 'TestingRun', 'Prior', 'TestingAUC', 'TestingConcordance']]
     a.writerows(data)

for i in list(range(0, len(size_list))):

    size = size_list[i];

    for run in list(range(0, 10)):

        at_data_ones   = shuffle(at_data_ones)
        at_data_zeroes = shuffle(at_data_zeroes)
        
        trainindexones   = int(size * prop)
        trainindexzeroes = int(size * (1 - prop))
        
        valindexones   = trainindexones + int(validation_size * prop)
        valindexzeroes = trainindexzeroes + int(validation_size * (1 - prop))
        
        at_data_train = np.vstack([at_data_ones[0:trainindexones], at_data_zeroes[0:trainindexzeroes]])
        at_data_val   = np.vstack([at_data_ones[trainindexones:valindexones], at_data_zeroes[trainindexzeroes:valindexzeroes]])
        at_data_test  = np.vstack([at_data_ones[valindexones:], at_data_zeroes[valindexzeroes:]])
        
        at_data_train = np.delete(at_data_train, 0, 1)
        at_data_val   = np.delete(at_data_val, 0, 1)
        at_data_test  = np.delete(at_data_test, 0, 1)
        
        at_data_train = np.delete(at_data_train, np.shape(at_data_train)[1] - 1, 1)
        at_data_val   = np.delete(at_data_val, np.shape(at_data_val)[1] - 1, 1)
        at_data_test  = np.delete(at_data_test, np.shape(at_data_test)[1] - 1, 1)
        
        at_data_train = np.array(at_data_train, dtype=float)
        at_data_val   = np.array(at_data_val, dtype=float)
        at_data_test  = np.array(at_data_test, dtype=float)
        
        print("Training Prop   : ", np.sum(at_data_train[:,0])/np.shape(at_data_train)[0])
        print("Validation Prop : ", np.sum(at_data_val[:,0])/np.shape(at_data_val)[0])
        print("Testing Prop    : ", np.sum(at_data_test[:,0])/np.shape(at_data_test)[0])
        
        sess = tf.Session()
        init = tf.global_variables_initializer()
        sess.run(init) 
        
        tf.reset_default_graph()
        tf.logging.set_verbosity(tf.logging.ERROR)

        # Building deep neural network
        input_layer = tflearn.input_data(shape=[None, 15])
        
        dense1 = tflearn.fully_connected(input_layer, 12, activation=activationfunction,
                                         regularizer='L2', weight_decay=0.001)
        
        dense2 = tflearn.fully_connected(dense1, 9, activation=activationfunction,
                                         regularizer='L2', weight_decay=0.001)
        
        dense3 = tflearn.fully_connected(dense1, 6, activation=activationfunction,
                                         regularizer='L2', weight_decay=0.001)
        
        softmax = tflearn.fully_connected(dense3, 2, activation='softmax')
        
        
        # Regression using SGD with learning rate decay and Top-3 accuracy
        opt =  tflearn.optimizers.Adam (learning_rate=0.001, beta1=0.9, beta2=0.999, 
                                         epsilon=1e-08, use_locking=False, name='Adam')
        
        acc = tflearn.metrics.Accuracy()
        net = tflearn.regression(softmax, optimizer=opt, loss='categorical_crossentropy', metric=acc)
        classifier = tflearn.DNN(net, tensorboard_verbose=1)
        
        # Training
        X_train = at_data_train[:,1:(np.shape(at_data_train)[1])]
        Y_train = np.matrix(pd.get_dummies(at_data_train[:,0]))
        
        X_val = at_data_val[: , 1:np.shape(at_data_val)[1]]
        Y_val = np.matrix(pd.get_dummies(at_data_val[:,0]))
               
        classifier.fit(X_train, Y_train, batch_size = batch,show_metric=True, 
                       n_epoch=epochs, validation_set=(X_val, Y_val))
        
        probs_train = np.matrix(classifier.predict(X_train))
            
        fpr_train, tpr_train, thresholds_train = roc_curve(at_data_train[:,0], probs_train[:, 1])
        
        roc_grid = np.c_[thresholds_train, tpr_train, fpr_train]
        
        roc_auc_train = auc(fpr_train, tpr_train)
        
        concordance_train = OptimisedConc(responsevalues=np.matrix(at_data_train[:, 0]),
                                          fittedvalues=(probs_train[:, 1]).T)[0]
        
        ypred = (probs_train[:,1] > 0.5)
        yvec  = (at_data_train[:,0])
        
        grid  =  pd.DataFrame(np.c_[yvec, ypred])  
        grid.columns = ['yvec', 'ypred']
        
        cfmatrix = np.array(pd.crosstab(grid['yvec'], grid['ypred']), dtype=float)
        
        tpr_train         = cfmatrix[1,1] / np.sum(cfmatrix[1,:])
        
        tnr_train         = cfmatrix[0,0] / np.sum(cfmatrix[0,:])
        
        TrainingAccuracy  = (cfmatrix[0,0] + cfmatrix[1,1]) / np.sum(cfmatrix)
        
        precision_train   = cfmatrix[1,1]/np.sum(ypred == 1)
        
        f1score_train     = 2 * precision_train * tpr_train / (precision_train + tpr_train) 
        
        validationscores = tflearn_validation(Xmatrix=X_val, Yvector=at_data_val[:,0], 
                                              model=classifier)
        
        
        print('SampleSize', 'Layers', 'Activation', 'Run', 'Prior', 'TrainingAccuracy', 
              'TPR', 'TNR', 'AUC', 'Concordance', 'Precision', 'F1Score',
              'valAUC', 'valConcordance', 'valPrecision', 'valF1score')
        print(size, hidden_layers, activationfunction, run+1, prop, TrainingAccuracy, 
              tpr_train, tnr_train, roc_auc_train, concordance_train, precision_train, 
              f1score_train, validationscores[0], validationscores[1], 
              validationscores[5], validationscores[6])
        
        modelfolderpath = "//10.8.8.51/lv0/Tanumoy/Datasets/Parameter Files/AT Catalog Response/TFL/v4/"
        modelfilename = modelfolderpath + str(int(size)) + "_" + activationfunction + "_" + str(int(run+1)) + '.tflearn'
        
        classifier.save(modelfilename)
        
        classifier.load(modelfilename)
        
        with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_training_tfl_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'a', newline='') as fp:
             a = csv.writer(fp, delimiter='|')
             data = [[size, hidden_layers, activationfunction, run+1, prop, TrainingAccuracy, tpr_train, 
                     tnr_train, roc_auc_train, concordance_train, precision_train, f1score_train,
                     validationscores[0], validationscores[1], validationscores[5],
                     validationscores[5]]]
             a.writerows(data)
        
        
        for k in list(range(0,10)):
            
            at_data_test = shuffle(at_data_test)
            probs_test = np.matrix(classifier.predict(at_data_test[0:testing_size, 1:(at_data_test.shape[1])]))
            
            # Compute ROC curve and area the curve
            fpr, tpr, thresholds = roc_curve(at_data_test[0:testing_size, 0], 
                                             probs_test[:, 1])
            roc_grid = np.c_[thresholds, tpr, fpr]
            
            roc_auc_test = auc(fpr, tpr)
            
            
            concordance_test = OptimisedConc(responsevalues=np.matrix(at_data_test[0:testing_size, 0]),
                                          fittedvalues=(probs_test[:, 1]).T)[0]
        
            prop_tst = np.sum(at_data_test[0:testing_size,0])/testing_size
             
            print("Size:", size, "Layers", hidden_layers, " Activation: ", activationfunction, 
                  " Training Run: ", run+1, " Testing Run:", k+1, " Prior:", prop_tst,
                  "  AUC : %f" % roc_auc_test, " Concordance:", concordance_test)
            
            with open('//10.8.8.51/lv0/Tanumoy/Datasets/Model Results/Catalog Response Model/at_catalog_testing_tfl_' + str(min(size_list)) + '_' + str(max(size_list)) + '_v4.txt', 'a', newline='') as fp:
                 a = csv.writer(fp, delimiter='|')
                 data = [[size, hidden_layers, activationfunction, run+1, k+1, 
                         prop_tst, roc_auc_test, concordance_test]]
                 a.writerows(data)
                 
        if os.path.isfile(modelfolderpath + 'checkpoint'):
           os.remove(modelfolderpath + 'checkpoint')
        
        sess.close()