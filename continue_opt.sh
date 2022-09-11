#!/bin/bash
Jobname=$1
FName=${Jobname%.*}
N_atom=`grep "NAtoms=" $FName.out | head -1 | awk '{print $2}'`

# get Optimized_coordinate_1
line2=`grep -n "Input orientation" $FName.out | tail -1 | cut -d: -f 1`
line3=`expr $line2 + $N_atom + 4`
sed -n "${line2},${line3}p" $FName.out|tail -$N_atom|awk '{print $4 "   "$5 "   "$6}' > Optimized_coor_1.xyz

# Generate Final_input.gjf
line4=`grep -n "#" $FName.gjf | tail -1 | cut -d: -f 1|awk '{print $1+4}'`
sed -n "1,${line4}p" $FName.gjf > head.tmp
line5=`expr $line4 + $N_atom + 1`
line6=`cat $FName.gjf|wc -l`
sed -n "${line5},${line6}p" $FName.gjf > tail.tmp

line7=`expr $line4 + 1`
line8=`expr $line4 + $N_atom`
sed -n "${line7},${line8}p" $FName.gjf > old_coor.xyz
paste Optimized_coor_1.xyz old_coor.xyz|awk '{printf "%s   %.6f   %.6f   %.6f\n",$4,$1,$2,$3}' > new_coor.xyz

cat head.tmp new_coor.xyz tail.tmp > ${FName}.gjf
rm -f imaginary_freq.xyz Optimized_coor_1.xyz head.tmp tail.tmp old_coor.xyz new_coor.xyz

#mv $FName.out $FName-job1.out
#myg16 ${FName}-job2.gjf
