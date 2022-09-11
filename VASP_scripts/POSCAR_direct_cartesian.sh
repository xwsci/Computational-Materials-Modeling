#!/bin/bash
rm -f POSCAR-Cartesian
a1=`sed -n '3p' POSCAR|awk '{print $1}'`
a2=`sed -n '3p' POSCAR|awk '{print $2}'`
a3=`sed -n '3p' POSCAR|awk '{print $3}'`
a4=`sed -n '4p' POSCAR|awk '{print $1}'`
a5=`sed -n '4p' POSCAR|awk '{print $2}'`
a6=`sed -n '4p' POSCAR|awk '{print $3}'`
a7=`sed -n '5p' POSCAR|awk '{print $1}'`
a8=`sed -n '5p' POSCAR|awk '{print $2}'`
a9=`sed -n '5p' POSCAR|awk '{print $3}'`
N=`sed -n '7p' POSCAR |awk '{for(i=1;i<=NF;i++) sum += $i; print sum}'`
beginN=`grep -n Direct POSCAR|cut  -d  ":"  -f  1|awk '{print $1+1}'`
endN=`echo $beginN $N|awk '{print $1+$2-1}'`

for x in $(seq $beginN 1 $endN)
do
b1=`sed -n "${x}p" POSCAR|awk '{print $1}'`
b2=`sed -n "${x}p" POSCAR|awk '{print $2}'`
b3=`sed -n "${x}p" POSCAR|awk '{print $3}'`
#echo $b1 $b2 $b3
c1=`echo $a1 $b1 $a4 $b2 $a7 $b3|awk '{printf "%.9f",$1*$2+$3*$4+$5*$6}'`
c2=`echo $a2 $b1 $a5 $b2 $a8 $b3|awk '{printf "%.9f",$1*$2+$3*$4+$5*$6}'`
c3=`echo $a3 $b1 $a6 $b2 $a9 $b3|awk '{printf "%.9f",$1*$2+$3*$4+$5*$6}'`

echo $c1 $c2 $c3 >> POSCAR-Cartesian

done



