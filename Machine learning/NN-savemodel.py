import tensorflow as tf
import numpy as np
import pandas as pd
from pandas import DataFrame
import os
from sklearn import svm
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
from sklearn import preprocessing
from sklearn.preprocessing import Imputer
#import matplotlib.pyplot as plt
import time

start = time.time()

pd.set_option('display.max_rows',None)

os.chdir(r"C:\Users\xwang99\Desktop\test\test")

nmadata=pd.read_csv("test.csv")
nma_y=nmadata.loc[:,['0']]
nma_x=nmadata.iloc[:,2:]
nma_x_train, nma_x_test, nma_y_train, nma_y_test = train_test_split(nma_x, nma_y, test_size=0.3,random_state=2)
min_max_scaler = preprocessing.MinMaxScaler(feature_range=(-1, 1))
nma_x_train = min_max_scaler.fit_transform(nma_x_train)
nma_x_test = min_max_scaler.fit_transform(nma_x_test)

#Neuron number of each layer
n_hidden_1=32
n_hidden_2=32
n_hidden_3=64
n_input=4 #number of descriptors
n_classes=1 #number of targets
regularizer = tf.contrib.layers.l2_regularizer(0.001) #Counter overfitting

def get_weight_variable(shape,regularizer):
    weights = tf.get_variable("weights",shape,initializer=tf.contrib.layers.xavier_initializer())
    return weights

x=tf.placeholder("float",[None,n_input],name='x')
y=tf.placeholder("float",[None,n_classes],name='y')

#Define and initialize weight and bias
with tf.variable_scope('layer1') as scope:
    W1 = get_weight_variable([n_input,n_hidden_1],regularizer)
    b1 = tf.Variable(tf.random_uniform([n_hidden_1]))
    L1 = tf.nn.relu(tf.matmul(x, W1) + b1)

with tf.variable_scope('layer2') as scope:
    W2 = get_weight_variable([n_hidden_1,n_hidden_2],regularizer)
    b2 = tf.Variable(tf.random_uniform([n_hidden_2]))
    L2 = tf.nn.relu(tf.matmul(L1, W2) + b2)

with tf.variable_scope('layer3') as scope:
    W3 = get_weight_variable([n_hidden_2,n_hidden_3],regularizer)
    b3 = tf.Variable(tf.random_uniform([n_hidden_3]))
    L3 = tf.nn.relu(tf.matmul(L2, W3) + b3)
    w = tf.get_variable("w", shape=[n_hidden_3,n_classes],
                         initializer=tf.contrib.layers.xavier_initializer())
    b = tf.Variable(tf.random_uniform([n_classes]))  #],0,10
    pred = tf.matmul(L3,w)+b

regularization=regularizer(W1)+regularizer(W2)+regularizer(W3)

#Loss/cost function
cost=tf.reduce_mean(tf.square(y-pred))
cost=cost+regularization

global_step = tf.Variable(0)
learning_rate = tf.train.exponential_decay(0.004, global_step, 500, 0.5, staircase=True)

optm=tf.train.AdamOptimizer(learning_rate).minimize(cost)

#Define error
error=tf.reduce_mean(abs((pred-y)/y))
error_max=tf.reduce_max(abs((pred-y)/y))
    
init=tf.global_variables_initializer()
saver=tf.train.Saver(max_to_keep=1)
sess=tf.InteractiveSession()
sess.run(init)
tf.add_to_collection('pred_network', pred)

step_number=0

while True:
        sess.run(optm, feed_dict={x: nma_x_train, y: nma_y_train})
        train_cost = sess.run(cost,feed_dict={x: nma_x_train, y: nma_y_train})
        train_error=sess.run(error,feed_dict={x: nma_x_train, y: nma_y_train})
        train_maxerr=sess.run(error_max,feed_dict={x: nma_x_train, y: nma_y_train})
        test_error=sess.run(error,feed_dict={x:nma_x_test,y:nma_y_test})
        test_maxerr=sess.run(error_max,feed_dict={x:nma_x_test,y:nma_y_test})
        test_cost = sess.run(cost,feed_dict={x:nma_x_test,y:nma_y_test})
        pred_y = sess.run(pred, feed_dict={x: nma_x_test})
        pred_train = sess.run(pred, feed_dict={x: nma_x_train})
        person_test=np.corrcoef(pred_y,nma_y_test,rowvar=0)[0][1]
        person_train=np.corrcoef(pred_train,nma_y_train,rowvar=0)[0][1]
        step_number=step_number+1
        print("***************************Step",step_number,"***************************")
        print("        Cost_function Person Mean_error Max_error")
        print("Train   %.3f         %.3f  %.3f      %.3f"%(train_cost,person_train,train_error,train_maxerr))
        print("Test    %.3f         %.3f  %.3f      %.3f"%(test_cost,person_test,test_error,test_maxerr))        
        #print("train: cost function=%.3f"%(train_cost),"person=%.3f"%(person_train),"mean error=%.3f max error=%.3f"%(train_error,train_maxerr))
        #print("test: cost function=%.3f"%(test_cost),"person=%.3f"%(person_test),"mean error=%.3f max error=%.3f"%(test_error,test_maxerr))
        if person_test > 0.98 and abs(test_error) < 0.1 :
            #save_path=saver.save(sess,'save.ckpt',global_step=10000)
            saver.save(sess, os.path.join(os.getcwd(), 'save.ckpt'))
            break
print()
print("********Congratulations!********")
end = time.time()
print("User time (sec)=%.3f"%(end-start))
print("test error:%.3f test max error:%.3f"
	      %(test_error,test_maxerr))
print("test person=%.3f"%(person_test))
#Output
pred_y=DataFrame(np.array(pred_y))
nma_y_test=DataFrame(np.array(nma_y_test))
result=pd.concat([nma_y_test,pred_y],axis=1,join='outer')
result.to_csv('cal-pred.csv',header=False,index=False)

sess.close()
