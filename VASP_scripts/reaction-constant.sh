####################################################################################################################
#This script can help you get the reaction constant using Arrhenius equation:
#A=kbT/h B=-1/RT
#k=A*exp(B*Ga)
#Units conversion:
#1HF=2625.5 KJ/mol
#1eV=96.4869 KJ/mol
#1kcal/mol=4.18400 KJ/mol
###################################
#By xijun Wang from USTC /2/25/2016
#E-mail:wangxijun1016@gmail.com
#QQ:710340788
####################################################################################################################
#!/bin/bash
kb=1.380662e-23;	#J/K/mol
R=8.314462175;	#J/K/mol
h=6.626176e-34;
echo "Please input the Temperature (K)";read Temperature	#K
echo "Please choose your Energy unit"
A=`echo "$kb $Temperature $h"|awk '{printf "%Le",$1*$2/$3}'`
B=`echo "$R $Temperature"|awk '{printf "%Le",-1/($1*$2)}'`
index_HF=2625500
index_eV=96486.9
index_kcal=4184
index_KJ=1000

select E_unit in eV KJ/mol kcal/mol HF
do
case $E_unit in
eV)
echo "Please input you Activation Energy value";read Ga
k=`echo "$A $B $Ga $index_eV"|awk '{printf "%Le",$1*exp($2*$3*$4)}'`;echo "k= "$k
exit
;;
KJ/mol)
echo "Please input you Activation Energy value";read Ga
k=`echo "$A $B $Ga $index_KJ"|awk '{printf "%Le",$1*exp($2*$3*$4)}'`;echo "k= "$k
exit
;;
kcal/mol)
echo "Please input you Activation Energy value";read Ga
k=`echo "$A $B $Ga $index_kcal"|awk '{printf "%Le",$1*exp($2*$3*$4)}'`;echo "k= "$k
exit
;;
HF)
echo "Please input you Activation Energy value";read Ga
k=`echo "$A $B $Ga $index_HF"|awk '{printf "%Le",$1*exp($2*$3*$4)}'`;echo "k= "$k
exit
;;
esac
done
   
