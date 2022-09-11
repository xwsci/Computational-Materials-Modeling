#!/bin/bash
filename=$1;name=`echo $filename|cut -d. -f 1`
N_atom=`grep "NAtoms=" $filename|head -1|awk '{print $2}'`

grep "Alpha spin orbitals" -A 1000 $filename > spin_alpha.tmp
grep "Beta  spin orbitals" -A 1000 $filename > spin_beta.tmp

for state in alpha beta
do
start_line=`grep -n '\---------------------------------' spin_$state.tmp|cut -d: -f 1|head -1`
end_line=`grep -n '\---------------------------------' spin_$state.tmp|cut -d: -f 1|head -2|tail -1`
#echo $start_line $end_line
sed -n "${start_line},${end_line}p" spin_$state.tmp > spin_$state.tmp2
cat spin_$state.tmp2 |awk '{print $2 "   "$3 "   "$7}' > spin_$state.tmp3

for N in `seq 1 $N_atom`
do
grep " $N " spin_$state.tmp3 |awk '{print $1}' |uniq >> spin_$state.tmp4
grep " $N " spin_$state.tmp3 |awk '{print $3}' | awk '{sum += $1} END {print sum}' >> spin_$state.tmp5
done

paste spin_$state.tmp4 spin_$state.tmp5 > spin_$state.tmp6
rm -f spin_$state.tmp rm -f spin_$state.tmp2 spin_$state.tmp3 spin_$state.tmp4 spin_$state.tmp5
done

paste spin_alpha.tmp6 spin_beta.tmp6 |awk '{print $1 "   "$2 "   "$4 "   "$2-$4}' > ${name}_NBOspin.dat
rm -f spin_alpha.tmp6 spin_beta.tmp6


