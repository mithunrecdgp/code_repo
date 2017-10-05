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


path = '//10.8.8.51/lv0/Saumya/Datasets/at_normal_first.txt'
colnames = ("masterkey",
            "category",
            "normal_items_abandoned",
            "normal_items_browsed",
            "normal_items_purchased",
            "normal_items_purch_first",
            "items_purch_pred")
            
at_data = pd.read_table(path, sep='|',header=0)

