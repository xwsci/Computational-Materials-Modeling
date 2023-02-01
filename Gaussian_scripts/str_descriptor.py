# This script is for obtaining geometric parameters among the selected atoms
# Define parameters based on systems
Ag1=8
Ag2=6
Ag3=10
C1=13
O1=14

# Define functions
def bond_length(a,b):
    return(((a[0]-b[0])*(a[0]-b[0])+(a[1]-b[1])*(a[1]-b[1])+(a[2]-b[2])*(a[2]-b[2]))**0.5)
def bond_angle(a,b,c):
    ba=[(a[0]-b[0]),(a[1]-b[1]),(a[2]-b[2])]
    bc=[(c[0]-b[0]),(c[1]-b[1]),(c[2]-b[2])]
    ba_length=math.sqrt(ba[0]**2+ba[1]**2+ba[2]**2)
    bc_length=math.sqrt(bc[0]**2+bc[1]**2+bc[2]**2)
    return((180/3.1415926535897932385)*math.acos((ba[0]*bc[0]+ba[1]*bc[1]+ba[2]*bc[2])/(ba_length*bc_length)))
def dihedral_angle(a,b,c,d):
    ba=[(a[0]-b[0]),(a[1]-b[1]),(a[2]-b[2])]
    bc=[(c[0]-b[0]),(c[1]-b[1]),(c[2]-b[2])]
    cd=[(d[0]-c[0]),(d[1]-c[1]),(d[2]-c[2])]
    N_1=[(ba[1]*bc[2]-ba[2]*bc[1]),(ba[2]*bc[0]-ba[0]*bc[2]),(ba[0]*bc[1]-ba[1]*bc[0])] #N_abc
    N_2=[(cd[1]*bc[2]-cd[2]*bc[1]),(cd[2]*bc[0]-cd[0]*bc[2]),(cd[0]*bc[1]-cd[1]*bc[0])] #N_bcd
    N_1_length=math.sqrt(N_1[0]**2+N_1[1]**2+N_1[2]**2)
    N_2_length=math.sqrt(N_2[0]**2+N_2[1]**2+N_2[2]**2)
    N_1_dot_N_2=N_1[0]*N_2[0]+N_1[1]*N_2[1]+N_1[2]*N_2[2]
    test=N_2[0]*ba[0]+N_2[1]*ba[1]+N_2[2]*ba[2]
    if test < 0:
        return((-180/3.1415926535897932385)*math.acos(N_1_dot_N_2/(N_1_length*N_2_length)))
    else:
        return((180/3.1415926535897932385)*math.acos(N_1_dot_N_2/(N_1_length*N_2_length)))

import math
import numpy as np
import pandas as pd
import os

# Read coordinates from .gjf file
f_list=os.listdir('.')
for files in f_list:
	if '.gjf' in files:
		filename=files #;print(filename)
data=pd.read_table(filename,header=None)
coordinate_Ag1=data.iloc[Ag1+5][0] #x1 y1 z1
coordinate_Ag2=data.iloc[Ag2+5][0] #x2 y2 z2
coordinate_Ag3=data.iloc[Ag3+5][0] #x3 y3 z3
coordinate_C=data.iloc[C1+5][0] #x4 y4 z4
coordinate_O=data.iloc[O1+5][0] #x5 y5 z5
x1,y1,z1=coordinate_Ag1.split()[2],coordinate_Ag1.split()[3],coordinate_Ag1.split()[4]
x2,y2,z2=coordinate_Ag2.split()[2],coordinate_Ag2.split()[3],coordinate_Ag2.split()[4]
x3,y3,z3=coordinate_Ag3.split()[2],coordinate_Ag3.split()[3],coordinate_Ag3.split()[4]
x4,y4,z4=coordinate_C.split()[2],coordinate_C.split()[3],coordinate_C.split()[4]
x5,y5,z5=coordinate_O.split()[2],coordinate_O.split()[3],coordinate_O.split()[4]
Ag1=[float(x1),float(y1),float(z1)];Ag2=[float(x2),float(y2),float(z2)];Ag3=[float(x3),float(y3),float(z3)]
C=[float(x4),float(y4),float(z4)];O=[float(x5),float(y5),float(z5)]
# Calculate d, a, D
d1=bond_length(Ag1,Ag2);d2=bond_length(Ag1,Ag3);d3=bond_length(Ag1,C);d4=bond_length(Ag1,O);d5=bond_length(Ag2,Ag3)
d6=bond_length(Ag2,C);d7=bond_length(Ag2,O);d8=bond_length(Ag3,C);d9=bond_length(Ag3,O);d10=bond_length(C,O)

a1=bond_angle(Ag1,Ag2,Ag3);a2=bond_angle(Ag2,Ag1,Ag3);a3=bond_angle(Ag2,Ag3,Ag1);a4=bond_angle(Ag1,Ag2,C);a5=bond_angle(Ag2,Ag1,C)
a6=bond_angle(Ag2,C,Ag1);a7=bond_angle(Ag1,Ag2,O);a8=bond_angle(Ag2,Ag1,O);a9=bond_angle(Ag1,O,Ag2);a10=bond_angle(Ag1,Ag3,C)
a11=bond_angle(Ag3,Ag1,C);a12=bond_angle(Ag1,C,Ag3);a13=bond_angle(Ag1,Ag3,O);a14=bond_angle(Ag3,Ag1,O);a15=bond_angle(Ag1,O,Ag3)
a16=bond_angle(Ag1,C,O);a17=bond_angle(C,Ag1,O);a18=bond_angle(C,O,Ag1);a19=bond_angle(Ag2,Ag3,C);a20=bond_angle(Ag3,Ag2,C)
a21=bond_angle(Ag2,C,Ag3);a22=bond_angle(Ag2,Ag3,O);a23=bond_angle(Ag3,Ag2,O);a24=bond_angle(Ag2,O,Ag3);a25=bond_angle(Ag2,C,O)
a26=bond_angle(C,Ag2,O);a27=bond_angle(Ag2,O,C);a28=bond_angle(Ag3,C,O);a29=bond_angle(C,Ag3,O);a30=bond_angle(Ag3,O,C)

D1=dihedral_angle(Ag1,Ag2,Ag3,C);D2=dihedral_angle(Ag1,Ag2,Ag3,O);D3=dihedral_angle(Ag1,Ag2,C,O);D4=dihedral_angle(Ag1,Ag3,C,O);D5=dihedral_angle(Ag2,Ag3,C,O)
D6=dihedral_angle(Ag1,Ag2,C,Ag3);D7=dihedral_angle(Ag1,Ag2,O,Ag3);D8=dihedral_angle(Ag1,Ag2,O,C);D9=dihedral_angle(Ag1,Ag3,O,C);D10=dihedral_angle(Ag2,Ag3,O,C)
D11=dihedral_angle(Ag1,Ag3,C,Ag2);D12=dihedral_angle(Ag1,Ag3,O,Ag2);D13=dihedral_angle(Ag1,C,O,Ag2);D14=dihedral_angle(Ag1,C,O,Ag3);D15=dihedral_angle(Ag2,C,O,Ag3)
D16=dihedral_angle(Ag2,Ag1,Ag3,C);D17=dihedral_angle(Ag2,Ag1,Ag3,O);D18=dihedral_angle(Ag2,Ag1,C,O);D19=dihedral_angle(Ag3,Ag1,C,O);D20=dihedral_angle(Ag3,Ag2,C,O)
D21=dihedral_angle(Ag2,Ag1,C,Ag3);D22=dihedral_angle(Ag2,Ag1,O,Ag3);D23=dihedral_angle(Ag2,Ag1,O,C);D24=dihedral_angle(Ag3,Ag1,O,C);D25=dihedral_angle(Ag3,Ag2,O,C)
D26=dihedral_angle(Ag3,Ag1,Ag2,C);D27=dihedral_angle(Ag3,Ag1,Ag2,O);D28=dihedral_angle(C,Ag1,Ag2,O);D29=dihedral_angle(C,Ag1,Ag3,O);D30=dihedral_angle(C,Ag2,Ag3,O)
descriptor_list=np.array([filename,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,
           a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,
           D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,D30])
pd.DataFrame(descriptor_list.reshape(1,71)).to_csv(filename+'-descriptors.csv',header=False,index=False,mode='a')





































