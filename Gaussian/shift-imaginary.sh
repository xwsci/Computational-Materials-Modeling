#!/bin/bash
Jobname=$1
FName=${Jobname%.*}
N_atom=`grep "NAtoms=" $FName.out | head -1 | awk '{print $2}'`
#echo $N_atom
# get imaginary_freq_coordinate
line1=`expr $N_atom + 7`
# 1st imaginary freq
grep -A $line1 "normal coordinates" $FName.out |tail -$N_atom|awk '{print $3 "   "$4 "   "$5}' > imaginary_freq.xyz
# 1st + 2nd imaginary freq
#grep -A $line1 "normal coordinates" $FName.out |tail -$N_atom|awk '{print $3+$6 "   "$4+$7 "   "$5+$8}' > imaginary_freq.xyz

# get Optimized_coordinate_1
line2=`grep -n "Standard orientation:" $FName.out | tail -1 | cut -d: -f 1`
line3=`expr $line2 + $N_atom + 4`
sed -n "${line2},${line3}p" $FName.out|tail -$N_atom|awk '{print $4 "   "$5 "   "$6}' > Optimized_coor_1.xyz

# get new position along the direction of imaginary frequency
paste imaginary_freq.xyz Optimized_coor_1.xyz |awk '{printf "%.6f   %.6f   %.6f\n",0.2*$1+$4,0.2*$2+$5,0.2*$3+$6}' > Final_input.xyz

# Generate Final_input.gjf
line4=`grep -n "#" $FName.gjf | tail -1 | cut -d: -f 1|awk '{print $1+4}'`
sed -n "1,${line4}p" $FName.gjf > head.tmp
line5=`expr $line4 + $N_atom + 1`
line6=`cat $FName.gjf|wc -l`
sed -n "${line5},${line6}p" $FName.gjf > tail.tmp

line7=`expr $line4 + 1`
line8=`expr $line4 + $N_atom`
sed -n "${line7},${line8}p" $FName.gjf > old_coor.xyz
paste Final_input.xyz old_coor.xyz|awk '{printf "%s   %.6f   %.6f   %.6f\n",$4,$1,$2,$3}' > new_coor.xyz

cat head.tmp new_coor.xyz tail.tmp > ${FName}-shift-imaginary.gjf
rm -f imaginary_freq.xyz Optimized_coor_1.xyz Final_input.xyz head.tmp tail.tmp old_coor.xyz new_coor.xyz

