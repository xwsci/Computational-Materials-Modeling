import numpy as np
import math
import os
import pandas as pd
import scipy.stats as st
from sklearn.metrics import r2_score,mean_absolute_error,mean_squared_error

def exp(i):
        return(i.apply(np.exp))
def log(i):
        return(i.apply(np.log))
def sqrt(i):
        return(i.apply(np.sqrt))
def sin(i):
        return(i.apply(np.sin))
def cos(i):
        return(i.apply(np.cos))

#os.chdir(r'D:\Google Drive2\works-USTC\Machine-learning-IR\data-2021-11-21\ML')
data=pd.read_table("train.dat",sep=' ')

target=data.iloc[:,1]
f3=data.iloc[:,2]
f4=data.iloc[:,3]
f5=data.iloc[:,4]
f6=data.iloc[:,5]
i3=data.iloc[:,6]
i4=data.iloc[:,7]
i5=data.iloc[:,8]
i6=data.iloc[:,9]
I3=data.iloc[:,10]
I4=data.iloc[:,11]
I5=data.iloc[:,12]
I6=data.iloc[:,13]

descriptor=(cos(log(i6))*((f4-f6)/sqrt(i6)))

slope, intercept, r_value, p_value, std_err = st.linregress(descriptor,target)

pearson=abs(np.corrcoef(descriptor,target,rowvar=0)[0][1])
RMSE=mean_squared_error(slope*descriptor+intercept,target,squared=False)

pred=slope*descriptor+intercept
y_target=pd.DataFrame(np.array(target))
y_pred=pd.DataFrame(np.array(pred))
pd.concat([y_target,y_pred],axis=1).to_csv('pred.csv',header=False,index=False)

print('A\tB\tr\tRMSE')
print("%.5f\t%.5f\t%.3f\t%.3f"%(slope,intercept,pearson,RMSE))
##        try:
##                descriptor=((f2+f3)/(log(f4)*exp(I3/f2)))
##                slope, intercept, r_value, p_value, std_err = st.linregress(descriptor,target)
##                pearson=abs(np.corrcoef(descriptor,target,rowvar=0)[0][1])
##                RMSE=mean_squared_error(slope*descriptor+intercept,target,squared=False)
##                print("%.3f\t%.3f\t%.3f\t%.3f"%(slope,intercept,pearson,RMSE))
##        except:
##                print("Nan")





