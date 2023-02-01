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
filename='data-216.csv'
data_original=pd.read_csv(filename).replace('#VALUE!',np.nan)
data=data_original.iloc[:,np.r_[0,2,5:data_original.shape[1]]].copy()
data.dropna(inplace=True,axis=0,how='any')
y=data.iloc[:,1]
x=data.iloc[:,2:]
#Normalize all data
min_max_scaler = MinMaxScaler(feature_range=(-1, 1))
x=min_max_scaler.fit_transform(x)
#x.to_csv('x.csv',header=False,index=False)
#y.to_csv('y.csv',header=False,index=False)
#x_predictnew=pd.read_excel('??.xlsx',sheet_name='??').iloc[:,1:]

#Split the data into 80% train and 20% test data sets
r_train=[];r_test=[]
for r in np.arange(0,100):
    #print('random:',r)
    x_train,x_test,y_train,y_test=train_test_split(x,y,test_size=0.2,random_state=r)
    #Random Forest Regressor
    etr=ExtraTreesRegressor(n_jobs=-1,n_estimators=100,max_depth=None,min_samples_split=2,min_samples_leaf=3)
    etr.fit(x_train,y_train)
    # Train
    y_pred_train=etr.predict(x_train)
    DataFrame(np.array(y_pred_train)).to_csv('y_pred_train.csv',header=False,index=False)
    y_train.to_csv('y_train.csv',header=False,index=False)
    descriptor_y_train=pd.read_csv('y_train.csv').iloc[:,0]
    descriptor_y_pred_train=pd.read_csv('y_pred_train.csv').iloc[:,0]
    person_train=np.corrcoef(descriptor_y_train,descriptor_y_pred_train,rowvar=0)[0][1]
    RMSE_train=mean_squared_error(descriptor_y_train,descriptor_y_pred_train,squared=False)
    print(person_train,RMSE_train)
    r_train.append(person_train)

    # Test    
    y_pred_test=etr.predict(x_test)
    DataFrame(np.array(y_pred_test)).to_csv('y_pred_test.csv',header=False,index=False)
    y_test.to_csv('y_test.csv',header=False,index=False)
    descriptor_y_test=pd.read_csv('y_test.csv').iloc[:,0]
    descriptor_y_pred_test=pd.read_csv('y_pred_test.csv').iloc[:,0]  
    person_test=np.corrcoef(descriptor_y_test,descriptor_y_pred_test,rowvar=0)[0][1]
    RMSE_test=mean_squared_error(descriptor_y_test,descriptor_y_pred_test,squared=False)
    print(person_test,RMSE_test)
    r_test.append(person_test)

print(np.mean(r_train),np.mean(r_test))
    #os.remove('y_train.csv');os.remove('y_pred_train.csv');os.remove('y_pred_test.csv');os.remove('y_test.csv')

#    y_pred_test=DataFrame(np.array())
#    y_test_test=DataFrame(np.array(y_test).reshape(29,1))

#    person=np.corrcoef(x_test,y_test,rowvar=0)[0][1]
#    print(person)

    
#    print(y_pred_test.shape,y_test_test.shape)
#    r_test=np.corrcoef(y_pred_test,y_test_test,rowvar=0)[0][1]
##    print('Test',n,r_test)
##    #pd.concat([DataFrame(np.array(y_test)),y_pred_test],axis=1).to_csv('pred_test.csv',header=False,index=False)
##
##    y_pred_train=DataFrame(np.array(etr.predict(x_train)))
##    r_train=np.corrcoef(y_pred_train.iloc[:,0],y_train.iloc[:,0],rowvar=0)[0][1]
##    print('Train',n,r_train)
    #pd.concat([DataFrame(np.array(y_train)),y_pred_train],axis=1).to_csv('pred_train.csv',header=False,index=False)

    #joblib.dump(etr,'test1.pkl') #Save model
    ####################################################Predict_new
    #etr_y_predictnew=etr.predict(x_predictnew)
    #DataFrame(np.array(etr_y_predictnew)).to_csv('predict_new_1.csv',header=False,index=False)

    ##print('RandomForestRegressor')
    ##print('score=%f Person=%f RMSE=%f MAE=%f \n'%(etr.score(x_test,y_test),person_etr,
    ##                                           mean_squared_error(y_test,etr_y_pred,squared=True),
    ##                                           mean_absolute_error(y_test,etr_y_pred)))
    ##print('ExtraTreesRegressor')
    ##print('score=%f Person=%f RMSE=%f MAE=%f \n'%(etr.score(x_test,y_test),person_etr,
    ##                                           mean_squared_error(y_test,etr_y_pred,squared=True),
    ##                                           mean_absolute_error(y_test,etr_y_pred)))  
    ##print('GradientBoostingRegressor')
    ##print('score=%f Person=%f RMSE=%f MAE=%f \n'%(gbr.score(x_test,y_test),person_gbr,
    ##                                           mean_squared_error(y_test,gbr_y_pred,squared=True),
    ##                                           mean_absolute_error(y_test,gbr_y_pred)))

    # Plot    
    ##fig=plt.figure(figsize=(15,5))   
    ##plt.subplot(121) #RandomForestRegressor
    ##plt.scatter(y_test,etr_y_pred)
    ##plt.plot(y_test,y_test)
    ##plt.title('RandomForestRegressor\nscore=%f Person=%f RMSE=%f MAE=%f \n'%(etr.score(x_test,y_test),person_etr,
    ##                                           mean_squared_error(y_test,etr_y_pred,squared=True),
    ##                                           mean_absolute_error(y_test,etr_y_pred)))
    ##plt.xlabel("Real y")
    ##plt.ylabel("Predicted y")
    ##
    ##plt.subplot(122) #ExtraTreesRegressor
    ##plt.scatter(y_test,etr_y_pred)
    ##plt.plot(y_test,y_test)
    ##plt.title('ExtraTreesRegressor\nscore=%f Person=%f RMSE=%f MAE=%f \n'%(etr.score(x_test,y_test),person_etr,
    ##                                           mean_squared_error(y_test,etr_y_pred,squared=True),
    ##                                           mean_absolute_error(y_test,etr_y_pred)))
    ##plt.xlabel("Real y")
    ##plt.ylabel("Predicted y")
    ##
    ##plt.subplot(133) #GradientBoostingRegressor
    ##plt.scatter(y_test,gbr_y_pred)
    ##plt.plot(y_test,y_test)
    ##plt.title('GradientBoostingRegressor\nscore=%f Person=%f RMSE=%f MAE=%f \n'%(gbr.score(x_test,y_test),person_gbr,
    ##                                           mean_squared_error(y_test,gbr_y_pred,squared=True),
    ##                                           mean_absolute_error(y_test,gbr_y_pred)))
    ##plt.xlabel("Real y")
    ##plt.ylabel("Predicted y")
    ##plt.show()

    # Model evaluation 
    #cvs=cross_val_score(etr,x,y,cv=5)
    #print(cvs.mean())
    # Evaluate
##    x_list=[0,1,2,3,4,5] #,1,2] #,8,9,10,11,12,13,14,15,16,17]
##    n=len(x_list)
##    out_data=pd.read_csv("pred_test.csv",header=None)
##    for x in x_list:
##        descriptor_1=out_data.iloc[:,x]
##        descriptor_2=out_data.iloc[:,x+n]
##        print("Test: %.3f\t%.3f\t%.3f"%(np.corrcoef(descriptor_1,descriptor_2,rowvar=0)[0][1],mean_squared_error(out_data[x],out_data[x+n],squared=False),mean_absolute_error(out_data[x],out_data[x+n])))
##
##    out_data=pd.read_csv("pred_train.csv",header=None)
##    for x in x_list:
##        descriptor_1=out_data.iloc[:,x]
##        descriptor_2=out_data.iloc[:,x+n]
##        print("Train: %.3f\t%.3f\t%.3f"%(np.corrcoef(descriptor_1,descriptor_2,rowvar=0)[0][1],mean_squared_error(out_data[x],out_data[x+n],squared=False),mean_absolute_error(out_data[x],out_data[x+n])))

    # Importance analysis
    #for x in etr.feature_importances_:
    #    print('%.3f'%x)
