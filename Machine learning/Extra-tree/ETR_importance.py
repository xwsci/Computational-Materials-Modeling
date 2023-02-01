# Structures to raman
import numpy as np
import pandas as pd
from pandas import DataFrame
import os
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn import linear_model
from sklearn.metrics import mean_squared_error
from sklearn.ensemble import RandomForestRegressor,ExtraTreesRegressor,GradientBoostingRegressor
from sklearn.inspection import permutation_importance
from sklearn.metrics import r2_score,mean_absolute_error,mean_squared_error
from sklearn.svm import OneClassSVM
from sklearn.ensemble import IsolationForest
from sklearn.multioutput import MultiOutputRegressor
import joblib
from sklearn.model_selection import cross_val_score
##np.set_printoptions(threshold=np.inf)
##pd.set_option('display.max_columns', None)
##pd.set_option('display.max_rows', None)
##pd.set_option('max_colwidth',100)

#os.chdir(r'C:\Users\82375\我的云端硬盘\works-NU\ICEP\output\high-throughput\ML')
#Load data using pandas
filename="data-216.csv"
data_original=pd.read_csv(filename).replace('#VALUE!',np.nan)
number_random=100

for G in [2]: #[1,2,3,4]:# 1-homo 2-4-M1-3
    data=data_original.iloc[:,np.r_[0,G,5:data_original.shape[1]]].copy()
    data.dropna(inplace=True,axis=0,how='any')
    y1=data.iloc[:,1]
    x1=data.iloc[:,2:]
    #Normalize all data
    min_max_scaler = MinMaxScaler(feature_range=(-1, 1))
    x1=min_max_scaler.fit_transform(x1)
    DataFrame(np.array(x1)).to_csv('x.csv',header=False,index=False)
    DataFrame(np.array(y1)).to_csv('y.csv',header=False,index=False)
    x=pd.read_csv('x.csv').iloc[:,:]
    y=pd.read_csv('y.csv').iloc[:,0]
    print(x)
    
    #x_predictnew=pd.read_excel('??.xlsx',sheet_name='??').iloc[:,1:]
   
    #Split the data into 80% train and 20% test data sets
    #x_train,x_test,y_train,y_test=train_test_split(x,y,test_size=0.2,random_state=r)

    #Extra Trees Regressor
    etr=ExtraTreesRegressor(n_jobs=-1)
    #etr.fit(x_train,y_train)
    #etr_y_pred=rfr.predict(x_test)
    #person_etr=np.corrcoef(etr_y_pred,y_test,rowvar=0)[0][1]
    #y_pred=DataFrame(np.array(etr_y_pred))
    #y_testt=DataFrame(np.array(y_test))
    #pd.concat([y_testt,y_pred],axis=1).to_csv('test1.csv',header=False,index=False)
    etr.fit(x,y)
##    etr_y_pred=etr.predict(x)
##    person_etr=np.corrcoef(etr_y_pred,y,rowvar=0)[0][1]
##    y_pred=DataFrame(np.array(etr_y_pred))
##    y_testt=DataFrame(np.array(y))
##    pd.concat([y_testt,y_pred],axis=1).to_csv('test1.csv',header=False,index=False)
##
    # Importance analysis
    for xx in etr.feature_importances_:
        print('%.3f'%xx)
    print('---------------------')
    result = permutation_importance(etr, x, y, n_repeats=100) #random_state=42,n_jobs=-1
    for xx in result.importances_mean:
        print('%.3f'%xx)


