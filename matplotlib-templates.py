import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

plt.figure(num=1,figsize=(10,10),dpi=80,facecolor='none',edgecolor='none',frameon=True)
######## 1: line
x=np.linspace(-np.pi,np.pi,1000,endpoint=True)
y=np.sin(x)
z=np.cos(x)
#print(x,y)
plt.subplot(3,3,1)
plt.plot(x,y,color="blue",linewidth=1.0,linestyle="-",label='a',alpha=1)#alpha transparency
plt.plot(x,z,color="blue",linewidth=1.0,linestyle="--",label='b')
plt.legend(loc='upper left')#label position
plt.fill_between(x,0,y,color='red',alpha=0.5)
plt.fill_between(x,0,z,color='yellow',alpha=0.5)
#boundary
xmin,xmax=x.min(),x.max();ymin,ymax=y.min(),y.max()
dx=(xmax-xmin)*0.1
dy=(ymax-ymin)*0.1
plt.xlim(xmin-dx,xmax+dx);plt.ylim(ymin-dy,ymax+dy)
#x,y labels
plt.xticks(np.linspace(-np.pi,np.pi,5,endpoint=True),[r'$-\pi$',r'$-\pi/2$',r'$0$',r'$\pi/2$',r'$\pi$'])
plt.yticks(np.linspace(-1,1,9,endpoint=True))

########## 2: scatter
dy1=np.random.normal(0,0.2,1000)
y1=y+dy1
T=np.arctan2(y1,x)
plt.subplot(3,3,2)
plt.scatter(x,y1,s=10,c=T,marker='.')#size and color
z1=np.sin(x)
plt.plot(x,z1,color="red",linewidth=3.0,linestyle="-",label='fit',alpha=1)
plt.legend(loc='upper left')#label position

########## 3: bar
x3=np.arange(5)
y3=np.random.rand(5)
plt.subplot(3,3,3)
#plt.axes([0.025,0.025,0.95,0.95])
plt.bar(x3,y3,facecolor='green',edgecolor='white',width=0.5,align='center',alpha=1)
#plt.xlabel('x label')
#plt.ylabel('y label')
#plt.title('Title')
xticks1=['A','B','C','D','E']
plt.xticks(x3,xticks1,size='medium',rotation=0)
plt.yticks(np.linspace(0,1.2,5,endpoint=True))
for a,b in zip(x3,y3):
    plt.text(a,b+0.05,'%.2f'%b,ha='center',va='bottom',fontsize=10)

########## 4: contour map
def function1(x,y):return (1-x/2+x**5+y**3)*np.exp(-x**2-y**2)
x4=np.linspace(-3,3,256)
y4=np.linspace(-3,3,256)
X4,Y4=np.meshgrid(x4,y4)
plt.subplot(3,3,4)
plt.contourf(X4,Y4,function1(X4,Y4),16,alpha=0.75,cmap=plt.cm.hot)
c=plt.contour(X4,Y4,function1(X4,Y4),16,colors='black')#linewidth=0.1
plt.clabel(c,inline=True,fontsize=10)#inline
#plt.colorbar(orientation='vertical')
plt.xticks(np.linspace(-3,3,5,endpoint=True))
plt.yticks(np.linspace(-3,3,5,endpoint=True))

########## 5: imshow
x5=np.linspace(-3,3,30)
y5=np.linspace(-3,3,30)
X5,Y5=np.meshgrid(x5,y5)
Z=function1(X5,Y5)
plt.subplot(3,3,5)
plt.imshow(Z,interpolation='bicubic', cmap='bone',origin='lower')
plt.colorbar(shrink=0.92)
plt.xticks([]), plt.yticks([])

########## 6: Pie
labels6=['A','B','C','D']
sizes6=[1,2,3,4]
colors6=['red','yellowgreen','lightskyblue','yellow']
explode6=(0.1,0.1,0.1,0.3)#interval
plt.subplot(3,3,6)
plt.pie(sizes6,explode=explode6,labels=labels6,colors=colors6,labeldistance=0.85,\
                            autopct='%3.2f%%',shadow=True,startangle=90,pctdistance=0.5)
plt.legend(loc='lower right')

########## 7: quiver
x7=np.linspace(0,10,40)
y7=x7**2*np.exp(-x7)
u7=np.array([x7[i+1]-x7[i] for i in range(len(x7)-1)])
v7=np.array([y7[i+1]-y7[i] for i in range(len(x7)-1)])
c7=np.random.randn(len(u7)) #color of the arrows
plt.subplot(3,3,7)
plt.quiver(x7,y7,u7,v7,c7,scale=1,width=0.01)#,angles='xy',scale_units='xy')

########## 8: polar axis
theta=np.arange(0,2*np.pi,2*np.pi/20)
radii=10*np.random.rand(20)
width=np.pi/4*np.random.rand(20)
plt.subplot(3,3,8,polar=True)
#plt.subplots(subplot_kw=dict(polar=True))
bars=plt.bar(theta,radii,width=width,bottom=0)
for r,bar in zip(radii, bars):
    bar.set_facecolor( plt.cm.jet(r/10.))
    bar.set_alpha(0.5)
##ax.set_xticklabels([])
##ax.set_yticklabels([])

########## 9: manuscript
plt.subplot(3,3,9)
eqs = []
eqs.append((r"$Science$"))
eqs.append((r"$Nature$"))
eqs.append((r"$JACS$"))
eqs.append((r"$Angewandte$"))
eqs.append((r"$Cell$"))

for i in range(20):
    index = np.random.randint(0,len(eqs))
    eq = eqs[index]
    size = np.random.uniform(12,32)
    x,y = np.random.uniform(0,1,2)
    alpha = np.random.uniform(0.25,.75)
    plt.text(x, y, eq, ha='center', va='center', color="#11557c", alpha=alpha,
             transform=plt.gca().transAxes, fontsize=size, clip_on=True)

plt.xticks([]), plt.yticks([])

########## 10: 3D figure
##X9=np.arange(-4,4,0.25)
##Y9=np.arange(-4,4,0.25)
##x9,y9=np.meshgrid(X9,Y9)
##R9=np.sqrt(x9**2+y9**2)
##z9=np.sin(R9)
##fig=plt.figure()
##ax=Axes3D(fig)
##ax.plot_surface(x9,y9,z9,rstride=1, cstride=1, cmap=plt.cm.hot)
##ax.contourf(x9,y9,z9,zdir='z',offset=-2, cmap=plt.cm.hot)
##ax.set_zlim(-2,2)

#plt.savefig(r'C:\Users\xwang99\Desktop\1.png',dpi=300)


plt.show()



