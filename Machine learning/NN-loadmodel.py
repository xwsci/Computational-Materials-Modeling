import tensorflow as tf
import numpy as np
import pandas as pd
from pandas import DataFrame as df
import os
from sklearn import svm
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
from sklearn import preprocessing
from sklearn.preprocessing import Imputer
#import matplotlib.pyplot as plt
import time

os.chdir(r"C:\Users\xwang99\Desktop\test\test")

def predict(x,model_dir):
    with tf.Session() as sess: 
        init = tf.global_variables_initializer()
        sess.run(init)
    
        # restore saver
        saver = tf.train.import_meta_graph(meta_graph_or_file=model_dir+".meta")
        saver.restore(sess,model_dir)
        
        graph = tf.get_default_graph()
    
        # get placeholder from graph
        xs = graph.get_tensor_by_name("x:0")
        # get operation from graph
        #pred = graph.get_tensor_by_name("y:0")
        pred = tf.get_collection('pred_network')[0]
        # run preds
        feed_dict = {xs: x}
        y_test_pred = sess.run(pred,feed_dict=feed_dict)
    
    return y_test_pred

input_x=pd.read_csv("test.csv").iloc[:,2:]
min_max_scaler = preprocessing.MinMaxScaler(feature_range=(-1, 1))
input_x = min_max_scaler.fit_transform(input_x)

predict_y = predict(x=input_x,model_dir="C:\\Users\\xwang99\\Desktop\\test\\test\\save.ckpt")
print(predict_y)
np.savetxt('001.txt',(predict_y))


