#!/bin/bash
bondlength(){
c1=`sed -n "${1}p" CONTCAR-Cartesian`
c2=`sed -n "${2}p" CONTCAR-Cartesian`
d=`echo $c1 $c2|awk '{print sqrt(($1-$4)*($1-$4)+($2-$5)*($2-$5)+($3-$6)*($3-$6))}'`
A=`sed -n "${x}p" xijun.element.tmp`
B=`sed -n "${y}p" xijun.element.tmp`
if [ $d != 0 -a `echo "$d <= 3"|bc` -eq 1 ]
then
echo $1-$2 $A-$B $d
fi
}

N=`cat CONTCAR-Cartesian|wc -l`
N_element=`sed -n '6p' CONTCAR | xargs -n1|wc -l`
rm -f xijun.element.tmp
if [ $N_element = 1 ];then
element1=`sed -n "6p" CONTCAR|awk '{print $1}'`
N_element1=`sed -n "7p" CONTCAR|awk '{printf "%d",$1}'`
for yy in $(seq 1 1 $N_element1)
do
echo $element1 >> xijun.element.tmp
done
fi
if [ $N_element = 2 ];then
element1=`sed -n "6p" CONTCAR|awk '{print $1}'`
element2=`sed -n "6p" CONTCAR|awk '{print $2}'`
N_element1=`sed -n "7p" CONTCAR|awk '{printf "%d",$1}'`
N_element2=`sed -n "7p" CONTCAR|awk '{printf "%d",$2}'`
for yy in $(seq 1 1 $N_element1)
do
echo $element1 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element2)
do
echo $element2 >> xijun.element.tmp
done
fi
if [ $N_element = 3 ];then
element1=`sed -n "6p" CONTCAR|awk '{print $1}'`
element2=`sed -n "6p" CONTCAR|awk '{print $2}'`
element3=`sed -n "6p" CONTCAR|awk '{print $3}'`
N_element1=`sed -n "7p" CONTCAR|awk '{printf "%d",$1}'`
N_element2=`sed -n "7p" CONTCAR|awk '{printf "%d",$2}'`
N_element3=`sed -n "7p" CONTCAR|awk '{printf "%d",$3}'`
for yy in $(seq 1 1 $N_element1)
do
echo $element1 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element2)
do
echo $element2 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element3)
do
echo $element3 >> xijun.element.tmp
done
fi
if [ $N_element = 4 ];then
element1=`sed -n "6p" CONTCAR|awk '{print $1}'`
element2=`sed -n "6p" CONTCAR|awk '{print $2}'`
element3=`sed -n "6p" CONTCAR|awk '{print $3}'`
element4=`sed -n "6p" CONTCAR|awk '{print $4}'`
N_element1=`sed -n "7p" CONTCAR|awk '{printf "%d",$1}'`
N_element2=`sed -n "7p" CONTCAR|awk '{printf "%d",$2}'`
N_element3=`sed -n "7p" CONTCAR|awk '{printf "%d",$3}'`
N_element4=`sed -n "7p" CONTCAR|awk '{printf "%d",$4}'`
for yy in $(seq 1 1 $N_element1)
do
echo $element1 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element2)
do
echo $element2 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element3)
do
echo $element3 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element4)
do
echo $element4 >> xijun.element.tmp
done
fi
if [ $N_element = 5 ];then
element1=`sed -n "6p" CONTCAR|awk '{print $1}'`
element2=`sed -n "6p" CONTCAR|awk '{print $2}'`
element3=`sed -n "6p" CONTCAR|awk '{print $3}'`
element4=`sed -n "6p" CONTCAR|awk '{print $4}'`
element5=`sed -n "6p" CONTCAR|awk '{print $5}'`
N_element1=`sed -n "7p" CONTCAR|awk '{printf "%d",$1}'`
N_element2=`sed -n "7p" CONTCAR|awk '{printf "%d",$2}'`
N_element3=`sed -n "7p" CONTCAR|awk '{printf "%d",$3}'`
N_element4=`sed -n "7p" CONTCAR|awk '{printf "%d",$4}'`
N_element5=`sed -n "7p" CONTCAR|awk '{printf "%d",$5}'`
for yy in $(seq 1 1 $N_element1)
do
echo $element1 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element2)
do
echo $element2 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element3)
do
echo $element3 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element4)
do
echo $element4 >> xijun.element.tmp
done
for yy in $(seq 1 1 $N_element5)
do
echo $element5 >> xijun.element.tmp
done
fi

for x in $(seq 1 1 $N)
do
for y in $(seq 1 1 $N)
do
if [ $x -lt $y ]
then
if [ `echo "$x >= 20"|bc` -eq 1 -o `echo "$y >= 20"|bc` -eq 1 ]
then
bondlength $x $y
fi
fi
done
done





