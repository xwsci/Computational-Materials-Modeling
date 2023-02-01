import matplotlib as mpl
from adjustText import adjust_text
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sklearn
from sklearn.cluster import KMeans,AffinityPropagation,MeanShift,estimate_bandwidth, \
      spectral_clustering,AgglomerativeClustering,DBSCAN,OPTICS, cluster_optics_dbscan, \
      Birch, MiniBatchKMeans
from sklearn.mixture import GaussianMixture
from sklearn.preprocessing import MinMaxScaler
from sklearn.decomposition import PCA,KernelPCA,FastICA,FactorAnalysis 

# Parameters
colorbar_min=110
colorbar_max=220
label_good=140
label_bad=180
n_cluster=2
fontsize=30 # 20

# Data preparation
filename="data-summary.csv"
name=pd.read_csv(filename).iloc[:,0]
y=pd.read_csv(filename).iloc[:,9]
x=pd.read_csv(filename).iloc[:,10:]
min_max_scaler = MinMaxScaler(feature_range=(-1, 1))
x=min_max_scaler.fit_transform(x)
x=np.array(x)

# PCA dimensional reduction
for r1 in [0]: #np.arange(0,100):
    #print(r1)
    method=PCA 
    pca=method(n_components=2,random_state=r1)
    reduced_data=pca.fit_transform(x)
    ##y_pred=y

    # KMeans
    for r2 in [46]: # np.arange(30,100): #[57]: #np.arange(30,100):
        print(r2)
        method = Birch(threshold=0.2+0.01*r2, n_clusters=n_cluster) # r=34, 37, 57, 62
        #GaussianMixture(n_components=2,random_state=r,covariance_type='spherical',max_iter=2000) #Good full,tied,diag
        #Birch(threshold=0.01, n_clusters=2) # Good
        #OPTICS(min_samples=20, xi=0.02, min_cluster_size=0.1) # Bad
        #DBSCAN(eps=0.2, min_samples=10) # Bad
        #AgglomerativeClustering(n_clusters=3,affinity = "manhattan",linkage='complete') # Good
        #spectral_clustering(reduced_data, n_clusters=2, eigen_solver="arpack") # Not work
        #MeanShift(bandwidth=estimate_bandwidth(reduced_data, quantile=0.08, n_samples=216), bin_seeding=True) # Soso
        #AffinityPropagation(preference=-80, random_state=0) # Good
        #KMeans(init="k-means++", n_clusters=3, n_init=4,algorithm='full',random_state=r) # Good
        method.fit(reduced_data)
        
        plt.figure(figsize=(30, 15)) #
        h=0.02
        x_min, x_max = reduced_data[:, 0].min() - 0.5, reduced_data[:, 0].max() + 0.5
        y_min, y_max = reduced_data[:, 1].min() - 0.5, reduced_data[:, 1].max() + 0.5
        xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
        Z = method.predict(np.c_[xx.ravel(), yy.ravel()])
        Z = Z.reshape(xx.shape)

        plt.clf()
    ##    for m in np.arange(0,Z.shape[0]):
    ##        for n in np.arange(0,Z.shape[1]):
    ##            if Z[m][n] == 1:
    ##                plt.imshow(Z[m][n],c='r',alpha=0.3)
    ##            elif Z[m][n] == 0:
    ##                plt.imshow(Z[m][n],c='g',alpha=0.3)
        
        plt.imshow(
            Z+1,interpolation="nearest",
            extent=(xx.min(), xx.max(), yy.min(), yy.max()),
            cmap='viridis',vmin=0,vmax=n_cluster+1, #plt.cm.Paired, RdYlGn_r
            aspect="auto",
            origin="lower",
            alpha=0.3
        )
        #print(Z)
        plt.scatter(reduced_data[:, 0], reduced_data[:, 1], c=np.array(y),cmap='RdYlGn_r',vmin=colorbar_min,vmax=colorbar_max,marker='o',s=300) #RdYlGn_r
        #print(np.array(y))
        ##plt.scatter(reduced_data[:, 0], reduced_data[:, 1], c=method.labels_,marker='o',s=250)
        ##
        texts = []
        bias_x=0.000;bias_y=0.000
        for xx, yy, s, n in zip(reduced_data[:, 0], reduced_data[:, 1], y,name):
            if s < label_good:
                texts.append(plt.text(xx+bias_x, yy+bias_y, n,c='green',fontsize=fontsize,horizontalalignment='left',verticalalignment='center'))
            elif s > label_bad:
                texts.append(plt.text(xx+bias_x, yy+bias_y, n,c='red',fontsize=fontsize,horizontalalignment='left',verticalalignment='center')) #,horizontalalignment='left',verticalalignment='center'
                
        # Plot
        plt.subplots_adjust(left=0.1,right=0.9,top=0.9,bottom=0.1)
        font1={
            'family':'Arial',
            'weight':'bold',
            'style':'normal',
            'size':25
            }
        plt.xlabel("PCA Feature 1",font1)
        plt.ylabel("PCA Feature 2",font1)
        plt.xticks([]);plt.yticks([])
        #plt.xlim((-2.3,2.8));plt.ylim((-2.1,2.6))
        cb=plt.colorbar(pad=0.01)
        cb.set_label('$\Delta$G${_m}$${_i}$${_n}$ (kJ/mol)',fontdict=font1)
        cb.ax.tick_params(labelsize=20)
        adjust_text(texts, only_move={'points':'x', 'texts':'x'},save_steps=False, arrowprops=dict(arrowstyle="->", color='b', lw=1))
        plt.savefig('Gmin_gmm_r'+str(r1)+'.png',bbox_inches='tight')
        #plt.show()

