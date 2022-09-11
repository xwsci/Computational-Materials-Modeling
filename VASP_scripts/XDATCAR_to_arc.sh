#!/bin/bash
################################################
# Transfer XDATCAR to movie.arc
# By Xijun Wang from USTC
# Email: xijun@mail.ustc.edu.cn
################################################
atom_number=`sed -n '7p' XDATCAR | awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}'`
step=`grep "Direct configuration=" XDATCAR | tail -1 | awk '{print $NF}'`
lattice_constant="PBC    20.05500    20.05500   30.0000   90.0000   90.0000  120.0000"

echo "!BIOSYM archive 2" > movie.arc
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

for y in `seq 1 $atom_number`
do
element=`sed -n "${y}p" xdatcar_to_arc.tmp|awk '{print $1}'`
x1=`sed -n "${y}p" xdatcar_to_arc.tmp|awk '{printf "%0.9f",$2}'`
y1=`sed -n "${y}p" xdatcar_to_arc.tmp|awk '{printf "%0.9f",$3}'`
z1=`sed -n "${y}p" xdatcar_to_arc.tmp|awk '{printf "%0.9f",$4}'`

if [ ${#element} = "1" ]; then
echo $element $x1 $y1 $z1 $y|awk '{printf "%s%19.9f%15.9f%15.9f CORE%5.0f%2s %2s    0.0000%5.0f\n",$1,$2,$3,$4,$5,$1,$1,$5}' >> movie.arc
else
echo $element $x1 $y1 $z1 $y|awk '{printf "%s%18.9f%15.9f%15.9f CORE%5.0f%3s %2s   0.0000%5.0f\n",$1,$2,$3,$4,$5,$1,$1,$5}' >> movie.arc
fi

done
echo "end" >> movie.arc
echo "end" >> movie.arc
done



