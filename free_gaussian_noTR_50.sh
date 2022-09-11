#!/bin/bash
# Reference: http://gaussian.com/thermo/

# Constants https://gaussian.com/constants/
h=15.19829010276831e-17 #HF*s 6.62606957/43.597467380841  e-15
k=3.16680964043046e-06 # HF/K 1.3806488 /43.597467380841 e-4
c=29979245800 # cm/s
R=3.166811235207172e-06 # H/K 8.3144621 * 0.001 * /627.5095/4.184 or 0.0003808798033989866

file_name=$1
T=`grep "Temperature " $file_name | awk '{print $2}'`
kT=`echo $k $T|awk '{printf "%10.12f",$1*$2}'`
N_total=`grep "Frequencies" $1|wc -l |awk '{print $1*3}'`
freq_cutoff=50 #cm-1

# Electronic energy
E=`grep "SCF Done" $file_name | tail -1 | awk '{print $5}'`
echo Electronic energy = $E

# Get Frequencies from Gaussian output
rm -f lnQ_vib.dat Svk.dat Evk.dat
grep Frequencies $1 | awk '{print $3 "   "$4 "   "$5}' | xargs|xargs -n1 > Frequency.dat
grep Frequencies $1 | awk '{print $3 "   "$4 "   "$5}' | xargs|xargs -n1|grep -v "-" > Frequency_positive.dat
N_total_positive=`cat Frequency_positive.dat|wc -l`
# Change small frequeicies to cutoff value
for N in `seq 1 $N_total_positive`
do
freq_N=`sed -n "${N}p" Frequency_positive.dat`
if [ `echo "$freq_N < $freq_cutoff" |bc` -eq 1 ];then
sed -i "${N}c $freq_cutoff" Frequency_positive.dat
fi
done
sum_frequency=`cat Frequency_positive.dat|awk '{sum += $1};END {printf "%10.12f",sum}'`

# Calculate Translational, Rotational, Vibrational, electronic contributions
for N in `seq 1 $N_total_positive`
do
frequency=`sed -n "${N}p" Frequency_positive.dat`
ln_Q_vib=`echo $h $frequency $k $T $c |awk '{printf "%10.12f",log((exp(-1*$1*$2*$5/(2*$3*$4)))/(1-exp(-1*$1*$2*$5/($3*$4))))}'`
echo $ln_Q_vib >> lnQ_vib.dat
hwc=`echo $h $frequency $c|awk '{printf "%10.12f",$1*$2*$3}'` # Theta*kB
S_v_k=`echo $hwc $kT $R|awk '{printf "%10.12f",$3*((($1/$2)/(exp(($1/$2))-1))-log(1-exp((-1*$1/$2))))}'`
E_v_k=`echo $hwc $k $kT $R|awk '{printf "%10.12f",$4*(($1/$2)*(0.5+1/(exp($1/$3)-1)))}'`
echo $S_v_k >> Svk.dat
echo $E_v_k >> Evk.dat
done
lnQ_vib=`cat lnQ_vib.dat|awk '{sum += $1};END {printf "%10.12f",sum}'`
lnQ_tran=0 #`grep "Translational" $1|tail -1|awk '{print $4}'`
lnQ_rota=0 #`grep "Rotational" $1|tail -1|awk '{print $4}'`
lnQ_elec=`grep Electronic $1 | tail -1|awk '{print $4}'`
lnQ_total=`echo $lnQ_vib $lnQ_tran $lnQ_rota $lnQ_elec | awk '{printf "%10.12f",$1+$2+$3+$4}'`
#echo lnQ_v=$lnQ_vib"   "lnQ_t=$lnQ_tran"   "lnQ_r=$lnQ_rota"   "lnQ_e=$lnQ_elec"   "lnQ_tot=$lnQ_total 

sum_Svk=`cat Svk.dat|awk '{sum += $1};END {printf "%10.12f",sum}'`
sum_Evk=`cat Evk.dat|awk '{sum += $1};END {printf "%10.12f",sum}'`
#echo $sum_Svk $sum_Evk

SPE=`grep "SCF Done" $1|tail -1|awk '{print $5}'`
ZPE=`echo $sum_frequency $h $c|awk '{printf "%10.12f",$1*$2*$3/2}'`
E_t=0 #`echo $R $T |awk '{printf "%10.12f",1.5*$1*$2}'`
E_r=0 #`echo $R $T |awk '{printf "%10.12f",1.5*$1*$2}'`
E_v=`echo $sum_Evk|awk '{printf "%10.12f",$1}'`
E_e=0
E_tot=`echo $E_t $E_r $E_v $E_e|awk '{printf "%10.12f",$1+$2+$3+$4}'`

S_t=0 #`echo $R $lnQ_tran |awk '{printf "%10.12f",$1*($2+1+1.5)}'`
S_r=0 #`echo $R $lnQ_rota |awk '{printf "%10.12f",$1*($2+1.5)}'`
S_v=`echo $sum_Svk | awk '{printf "%10.12f",$1}'`
S_e=`echo $R $lnQ_elec |awk '{printf "%10.12f",$1*($2+0)}'`
S_tot=`echo $S_t $S_r $S_v $S_e|awk '{printf "%10.12f",$1+$2+$3+$4}'`

H_corr=`echo $E_tot $k $T|awk '{printf "%10.12f",$1+$2*$3}'`
G_corr=`echo $H_corr $T $S_tot|awk '{printf "%10.12f",$1-$2*$3}'`

# Output
echo $ZPE|awk '{printf "Zero-point correction=                           %10.6f (Hartree/Particle)\n",$1}'
echo $E_tot|awk '{printf "Thermal correction to Energy=                    %10.6f\n",$1}'
echo $H_corr|awk '{printf "Thermal correction to Enthalpy=                  %10.6f\n",$1}'
echo $G_corr|awk '{printf "Thermal correction to Gibbs Free Energy=         %10.6f\n",$1}'
echo $SPE $ZPE|awk '{printf "Sum of electronic and zero-point Energies=          %10.6f\n",$1+$2}'
echo $SPE $E_tot|awk '{printf "Sum of electronic and thermal Energies=             %10.6f\n",$1+$2}'
echo $SPE $H_corr|awk '{printf "Sum of electronic and thermal Enthalpies=           %10.6f\n",$1+$2}'
echo $SPE $G_corr|awk '{printf "Sum of electronic and thermal Free Energies=        %10.6f\n",$1+$2}'

rm -f Frequency.dat Frequency_positive.dat lnQ_vib.dat Svk.dat Evk.dat
