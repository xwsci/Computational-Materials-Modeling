#!/bin/bash
#-----------------------------------------------------------------
#To use this script, make sure you have four subdirectories:
#	.
#	├── O
#	├── OH
#	├── OOH
#	└── sur
#-----------------------------------------------------------------

G_O2=-9.92
G_H2=-6.8
G_H2O=-14.22
PH=13
G_H=`echo $G_H2 $PH | awk '{print 0.5*$1-0.0591593*$2}' #1/2G_H2 - 0.0591593*PH`
direct=`pwd`

# DFT energy
DFT_E_sur=`grep "energy(sigma->0) =" $direct/sur/OUTCAR|tail -1|awk '{print $7}'`
DFT_E_OOH=`grep "energy(sigma->0) =" $direct/OOH/OUTCAR|tail -1|awk '{print $7}'`
DFT_E_O=`grep "energy(sigma->0) =" $direct/O/OUTCAR|tail -1|awk '{print $7}'`
DFT_E_OH=`grep "energy(sigma->0) =" $direct/OH/OUTCAR|tail -1|awk '{print $7}'`
echo "****************************************************************************************"
echo DFT E: $DFT_E_sur $DFT_E_OOH $DFT_E_O $DFT_E_OH
# G corr
G_corr_sur=0
#cd $direct/OOH/freq
G_corr_OOH=`cd $direct/OOH/freq;echo -e "501\n298.15" |vaspkit|grep "Thermal correction to G(T)"|awk '{print $(NF-1)}'`
G_corr_O=`cd $direct/O/freq;echo -e "501\n298.15" |vaspkit|grep "Thermal correction to G(T)"|awk '{print $(NF-1)}'`
G_corr_OH=`cd $direct/OH/freq;echo -e "501\n298.15" |vaspkit|grep "Thermal correction to G(T)"|awk '{print $(NF-1)}'`

# G
G_sur=`echo $DFT_E_sur`
G_OOH=`echo $DFT_E_OOH $G_corr_OOH|awk '{print $1+$2}'`
G_O=`echo $DFT_E_O $G_corr_O|awk '{print $1+$2}'`
G_OH=`echo $DFT_E_OH $G_corr_OH|awk '{print $1+$2}'`
echo G: $G_sur $G_OOH $G_O $G_OH
# G steps (U=0)
G_step1=`echo $G_sur $G_O2 $G_H|awk '{print $1+$2+4*$3}'`
G_step2=`echo $G_OOH $G_H|awk '{print $1+3*$2}'`
G_step3=`echo $G_O $G_H2O $G_H|awk '{print $1+$2+2*$3}'`
G_step4=`echo $G_OH $G_H2O $G_H|awk '{print $1+$2+$3}'`
G_step5=`echo $G_sur $G_H2O|awk '{print $1+2*$2}'`

rG_step1=`echo $G_step1 $G_step5|awk '{print $1-$2}'` #relative G
rG_step2=`echo $G_step2 $G_step5|awk '{print $1-$2}'` 
rG_step3=`echo $G_step3 $G_step5|awk '{print $1-$2}'` 
rG_step4=`echo $G_step4 $G_step5|awk '{print $1-$2}'` 
rG_step5=`echo $G_step5 $G_step5|awk '{print $1-$2}'` 

# G steps (U=1.23)
rG_step1_U123=`echo $rG_step1 $rG_step5 $PH|awk '{print $1-$2-4*(1.23-0.0591593*$3)}'` 
rG_step2_U123=`echo $rG_step2 $rG_step5 $PH|awk '{print $1-$2-3*(1.23-0.0591593*$3)}'`
rG_step3_U123=`echo $rG_step3 $rG_step5 $PH|awk '{print $1-$2-2*(1.23-0.0591593*$3)}'`
rG_step4_U123=`echo $rG_step4 $rG_step5 $PH|awk '{print $1-$2-(1.23-0.0591593*$3)}'`
rG_step5_U123=`echo $rG_step5 $rG_step5 $PH|awk '{print $1-$2}'`
echo "****************************************************************************************"
echo U=0: $rG_step1 $rG_step2 $rG_step3 $rG_step4 $rG_step5
echo U=1.23: $rG_step1_U123 $rG_step2_U123 $rG_step3_U123 $rG_step4_U123 $rG_step5_U123

# Overpotential
deltaG12=`echo $rG_step1_U123 $rG_step2_U123|awk '{print $2-$1}'`
deltaG23=`echo $rG_step2_U123 $rG_step3_U123|awk '{print $2-$1}'`
deltaG34=`echo $rG_step3_U123 $rG_step4_U123|awk '{print $2-$1}'`
deltaG45=`echo $rG_step4_U123 $rG_step5_U123|awk '{print $2-$1}'`

echo deltaG at U=1.23: $deltaG12 $deltaG23 $deltaG34 $deltaG45
overpotential=`echo $deltaG12 $deltaG23 $deltaG34 $deltaG45|xargs -n 1|awk 'BEGIN{max = -100000}{if($1 > max) max = $1}END{print max}'`
echo Overpotential: $overpotential

echo "****************************************************************************************"
echo For plotting the step chart in Origin or excel:
echo -e "0 $rG_step1 $rG_step1_U123\n1 $rG_step1 $rG_step1_U123\n"
echo -e "2 $rG_step2 $rG_step2_U123\n3 $rG_step2 $rG_step2_U123\n"
echo -e "4 $rG_step3 $rG_step3_U123\n5 $rG_step3 $rG_step3_U123\n"
echo -e "6 $rG_step4 $rG_step4_U123\n7 $rG_step4 $rG_step4_U123\n"
echo -e "8 $rG_step5 $rG_step5_U123\n9 $rG_step5 $rG_step5_U123\n"

echo -e "$rG_step1 $rG_step1_U123\n$rG_step2 $rG_step2_U123\n"
echo -e "$rG_step2 $rG_step2_U123\n$rG_step3 $rG_step3_U123\n"
echo -e "$rG_step3 $rG_step3_U123\n$rG_step4 $rG_step4_U123\n"
echo -e "$rG_step4 $rG_step4_U123\n$rG_step5 $rG_step5_U123"
echo "****************************************************************************************"
echo More info:
echo Binding free energies:
deltaG_OOH=`echo $G_OOH $G_H $G_H2O $G_sur|awk '{print $1+3*$2-2*$3-$4}'`
deltaG_O=`echo $G_O $G_H $G_H2O $G_sur|awk '{print $1+2*$2-$3-$4}'`
deltaG_OH=`echo $G_OH $G_H $G_H2O $G_sur|awk '{print $1+$2-$3-$4}'`
echo -e "\u0394"G_OOH*= $deltaG_OOH
echo -e "\u0394"G_O*= $deltaG_O
echo -e "\u0394"G_OH*= $deltaG_OH
echo Free energy change of each step when U = 0 V
deltaG1=`echo $deltaG_OOH $PH|awk '{print $1+(4*0.0591593*$2-4.92)}'`
deltaG2=`echo $deltaG_O $deltaG_OOH|awk '{print $1-$2}'`
deltaG3=`echo $deltaG_OH $deltaG_O|awk '{print $1-$2}'`
deltaG4=`echo $deltaG_OH|awk '{print -1*$1}'`
echo -e "\u0394"G1= $deltaG1
echo -e "\u0394"G2= $deltaG2
echo -e "\u0394"G3= $deltaG3
echo -e "\u0394"G4= $deltaG4
overpotential_from_binding=`echo $deltaG1 $deltaG2 $deltaG3 $deltaG4|xargs -n 1|awk 'BEGIN{max = -100000}{if($1 > max) max = $1}END{printf "%.3f",max}'| awk -v PH=$PH '{print $1+1.23-0.0591593*PH}'`
echo Overpotential derived from binding free energy: $overpotential_from_binding

