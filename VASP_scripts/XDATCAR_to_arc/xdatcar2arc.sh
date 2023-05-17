#!/bin/bash
################################################
# Transfer XDATCAR to movie.arc
# By Xijun Wang from USTC
# Email: wangxijun1016@gmail.com
################################################
xdat2xyz.pl
pos2cif.pl POSCAR
atom_number=`sed -n '7p' XDATCAR | awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}'`
step=`grep "Direct configuration=" XDATCAR | tail -1 | awk '{print $NF}'`
lattice_constant=`cat POSCAR.cif |grep _cell_|head -6|awk '{print $2}'|xargs|awk '{printf "PBC    %2.5f    %2.5f   %2.5f   %2.5f   %2.5f  %2.5f\n",$1,$2,$3,$4,$5,$6}'`

echo "!BIOSYM archive 3" > movie.arc
echo "PBC=ON" >> movie.arc

for x in `seq 1 $step`
do
echo $x
echo "     React      0          $x" >> movie.arc
echo "!DATE" >> movie.arc
echo $lattice_constant >> movie.arc
a=`echo $x $atom_number|awk '{print $1*($2+2)-($2-1)}'`
b=`echo $a $atom_number|awk '{print $1+$2-1}'`
sed -n "${a},${b}p" movie.xyz > xdatcar_to_arc.tmp
#cat xdatcar_to_arc.tmp|awk '{printf "%s",$1}' > element.tmp

seq 1 $atom_number > xdatcar_to_arc.tmp2
paste xdatcar_to_arc.tmp xdatcar_to_arc.tmp2 > xdatcar_to_arc.tmp3

cat xdatcar_to_arc.tmp3|awk '{printf "%s%18.9f%15.9f%15.9f CORE%5.0f      %s      %s %f\n",$1,$2,$3,$4,$5,$1,$1,$5}' >> movie.arc


echo "end" >> movie.arc
echo "end" >> movie.arc
done

