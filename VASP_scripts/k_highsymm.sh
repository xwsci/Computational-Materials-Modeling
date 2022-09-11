#!/bin/bash
N=10
demoFun(){
x[1]=`sed -n '1p' k_tmp|awk '{printf "%10.15lf",$1}'`
x[2]=`sed -n '2p' k_tmp|awk '{printf "%10.15lf",$1}'`
y[1]=`sed -n '1p' k_tmp|awk '{printf "%10.15lf",$2}'`
y[2]=`sed -n '2p' k_tmp|awk '{printf "%10.15lf",$2}'`
z[1]=`sed -n '1p' k_tmp|awk '{printf "%10.15lf",$3}'`
z[2]=`sed -n '2p' k_tmp|awk '{printf "%10.15lf",$3}'`

stepx1=`echo ${x[1]} ${x[2]} $N|awk '{printf "%10.15lf",($2-$1)/($3-1)}'`
stepy1=`echo ${y[1]} ${y[2]} $N|awk '{printf "%10.15lf",($2-$1)/($3-1)}'`
stepz1=`echo ${z[1]} ${z[2]} $N|awk '{printf "%10.15lf",($2-$1)/($3-1)}'`

for m in `seq 1 $N`
do
kx[m]=`echo ${x[1]} $stepx1 $m|awk '{printf "%10.8lf",$1+($3-1)*$2}'`
ky[m]=`echo ${y[1]} $stepy1 $m|awk '{printf "%10.8lf",$1+($3-1)*$2}'`
kz[m]=`echo ${z[1]} $stepz1 $m|awk '{printf "%10.8lf",$1+($3-1)*$2}'`
echo "${kx[m]}   ${ky[m]}   ${kz[m]}   0.0"
done
}
grep "0." k_high|head -2 > k_tmp
demoFun
grep "0." k_high|head -4|tail -2 > k_tmp
demoFun
grep "0." k_high|head -6|tail -2 > k_tmp
demoFun





