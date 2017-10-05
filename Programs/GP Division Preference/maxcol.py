import sys
import csv
import pandas as pd
import numpy as np

path = "//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/PURCH_ALL_TRAIN_OLD_EXT"
colnames = ['MASTERKEY', 'BABY','TODDLERGIRL','TODDLERBOY','GIRL','BOY','WOMEN','MEN','MATERNITY']
divnames = ['BABY','TODDLERGIRL','TODDLERBOY','GIRL','BOY','WOMEN','MEN','MATERNITY']


names = []
values = []
maxcount = []
maxdiv = []

with open(path, 'r') as infile:
    csv_reader = csv.reader(infile, delimiter=',')
    for line in csv_reader:
        names.append(line[0])
        maxdivindex = np.argmax(np.asarray(np.asarray(line[1:8], dtype=float) == max(np.asarray(line[1:8], dtype=float)), dtype=float), axis=0)
        maxdiv.append(divnames[maxdivindex])
infile.close()

names  = np.asarray(names,dtype=str).reshape(len(names), 1)

maxdiv = np.asarray(maxdiv,dtype=str).reshape(len(maxdiv), 1)

rankeddf  = pd.DataFrame(np.concatenate((names, maxdiv), axis = 1))


with open('//10.8.8.51/lv0/Tanumoy/Datasets/From Hive/maxnew', 'a', newline='') as fp:
            a = csv.writer(fp, delimiter=',')
            data = [rankeddf]
            a.writerows(data)  

