# For quick comparison of various ML algorighms

import numpy as np
import pandas as pd
from pandas import DataFrame
import os
import matplotlib.pyplot as plt
from sklearn import linear_model
from sklearn.model_selection import train_test_split,GridSearchCV
from sklearn.preprocessing import MinMaxScaler,PolynomialFeatures
from sklearn import linear_model
from sklearn.metrics import mean_squared_error
from sklearn.ensemble import RandomForestRegressor,ExtraTreesRegressor,GradientBoostingRegressor
from sklearn.metrics import r2_score,mean_absolute_error,mean_squared_error
from sklearn.svm import OneClassSVM,SVR
from sklearn.ensemble import IsolationForest
import joblib
import time
from sklearn.pipeline import Pipeline
from sklearn import neighbors
from sklearn.kernel_ridge import KernelRidge
from sklearn.neural_network import MLPRegressor

def evaluate(y_test,y_pred):
    score=r2_score(y_test,y_pred)
    person=np.corrcoef(y_test,y_pred,rowvar=0)[0][1]
    rmse=mean_squared_error(y_test,y_pred,squared=False)
    mae=mean_absolute_error(y_test,y_pred)
    return score,person,rmse,mae

os.chdir(r'C:\Users\82375\Desktop\Original Codes')
data=pd.read_csv('data-DFT-G.csv')
#data_predictnew=pd.read_csv('new-composition.csv') #header=None
#Load data using pandas, 
y=data.iloc[:,1]
x=data.iloc[:,12:26]
#x_predictnew=data_predictnew.iloc[:,0:14]

#Split the data into 80% train and 20% test data sets and then normalization
x_train,x_test,y_train,y_test=train_test_split(x,y,test_size=0.2,random_state=0)
min_max_scaler = MinMaxScaler(feature_range=(0, 1))
x_train=min_max_scaler.fit_transform(x_train)
x_test=min_max_scaler.fit_transform(x_test)

### Methods: 1.Linear fitting 2.Ridge 3.Lasso 4.Bayesian 5.Polynomial 6.SVR rbf 7.SVR linear 8.SVR poly
### 9.Nearest neighbors 10.GPR 11.RF 12.ET 13.Gradient Boosting Regressor

### 1.Linear fitting
time1_start=time.time()
regr1=linear_model.LinearRegression().fit(x_train,y_train)
y_pred1=regr1.predict(x_test)
time1=time.time()-time1_start
score1,person1,rmse1,mae1=evaluate(y_test,y_pred1)

### 2.Ridge
time2_start=time.time()
regr2=linear_model.RidgeCV().fit(x_train,y_train)
y_pred2=regr2.predict(x_test)
time2=time.time()-time2_start
score2,person2,rmse2,mae2=evaluate(y_test,y_pred2)

### 3.Lasso
time3_start=time.time()
regr3=linear_model.LassoCV().fit(x_train,y_train)
y_pred3=regr3.predict(x_test)
time3=time.time()-time3_start
score3,person3,rmse3,mae3=evaluate(y_test,y_pred3)

### 4.Bayesian Ridge
time4_start=time.time()
regr4=linear_model.BayesianRidge(compute_score=True).fit(x_train,y_train)
y_pred4=regr4.predict(x_test)
time4=time.time()-time4_start
score4,person4,rmse4,mae4=evaluate(y_test,y_pred4)

### 5.Polynomial Ridge
time5_start=time.time()
regr5=Pipeline([('poly',PolynomialFeatures(degree=2)),
                ('linear',linear_model.LinearRegression(fit_intercept=False))]).fit(x_train,y_train)
y_pred5=regr5.predict(x_test)
time5=time.time()-time5_start
score5,person5,rmse5,mae5=evaluate(y_test,y_pred5)

### 6.SVR rbf
time6_start=time.time()
regr6=SVR(kernel='rbf',C=100,gamma='auto',epsilon=0.1).fit(x_train,y_train)
y_pred6=regr6.predict(x_test)
time6=time.time()-time6_start
score6,person6,rmse6,mae6=evaluate(y_test,y_pred6)

### 7.SVR linear
time7_start=time.time()
regr7=SVR(kernel='linear',C=100,gamma='auto').fit(x_train,y_train)
y_pred7=regr7.predict(x_test)
time7=time.time()-time7_start
score7,person7,rmse7,mae7=evaluate(y_test,y_pred7)

### 8.SVR poly
time8_start=time.time()
regr8=SVR(kernel='poly',C=100,gamma='auto',degree=3,epsilon=0.1,coef0=1).fit(x_train,y_train)
y_pred8=regr8.predict(x_test)
time8=time.time()-time8_start
score8,person8,rmse8,mae8=evaluate(y_test,y_pred8)

### 9.Nearest neighbors
time9_start=time.time()
regr9=neighbors.KNeighborsRegressor(5,weights='uniform').fit(x_train,y_train)
y_pred9=regr9.predict(x_test)
time9=time.time()-time9_start
score9,person9,rmse9,mae9=evaluate(y_test,y_pred9)

### 10.GPR
time10_start=time.time()
param_grid10 = {"alpha": [1e0, 1e-1, 1e-2, 1e-3]}
regr10=GridSearchCV(KernelRidge(),param_grid=param_grid10).fit(x_train,y_train)
y_pred10=regr10.predict(x_test)
time10=time.time()-time10_start
score10,person10,rmse10,mae10=evaluate(y_test,y_pred10)

### 11.RF
time11_start=time.time()
regr11=RandomForestRegressor(n_jobs=-1).fit(x_train,y_train)
y_pred11=regr11.predict(x_test)
time11=time.time()-time11_start
score11,person11,rmse11,mae11=evaluate(y_test,y_pred11)

### 12.ET
time12_start=time.time()
regr12=ExtraTreesRegressor().fit(x_train,y_train)
y_pred12=regr12.predict(x_test)
time12=time.time()-time12_start
score12,person12,rmse12,mae12=evaluate(y_test,y_pred12)
##y_predd=DataFrame(np.array(y_pred_regr1))
##y_testt=DataFrame(np.array(y_test))
##pd.concat([y_testt,y_predd],axis=1).to_csv('test3.csv',header=False,index=False)

### 13.Gradient Boosting Regressor
time13_start=time.time()
regr13=GradientBoostingRegressor().fit(x_train,y_train)
y_pred13=regr13.predict(x_test)
time13=time.time()-time13_start
score13,person13,rmse13,mae13=evaluate(y_test,y_pred13)

# Output data
print('1.Linear fitting\t%.3f\t%.3f\t%.3f\t%.3f'%(time1,score1,person1,mae1))
print('2.Ridge\t%.3f\t%.3f\t%.3f\t%.3f'%(time2,score2,person2,mae2))
print('3.Lasso\t%.3f\t%.3f\t%.3f\t%.3f'%(time3,score3,person3,mae3))
print('4.Bayesian\t%.3f\t%.3f\t%.3f\t%.3f'%(time4,score4,person4,mae4))
print('5.Polynomial\t%.3f\t%.3f\t%.3f\t%.3f'%(time5,score5,person5,mae5))
print('6.SVR rbf\t%.3f\t%.3f\t%.3f\t%.3f'%(time6,score6,person6,mae6))
print('7.SVR linear\t%.3f\t%.3f\t%.3f\t%.3f'%(time7,score7,person7,mae7))
print('8.SVR poly\t%.3f\t%.3f\t%.3f\t%.3f'%(time8,score8,person8,mae8))
print('9.Nearest neighbors\t%.3f\t%.3f\t%.3f\t%.3f'%(time9,score9,person9,mae9))
print('10.GPR\t%.3f\t%.3f\t%.3f\t%.3f'%(time10,score10,person10,mae10))
print('11.RF\t%.3f\t%.3f\t%.3f\t%.3f'%(time11,score11,person11,mae11))
print('12.ET\t%.3f\t%.3f\t%.3f\t%.3f'%(time12,score12,person12,mae12))
print('13.Gradient Boosting Regressor\t%.3f\t%.3f\t%.3f\t%.3f'%(time13,score13,person13,mae13))
