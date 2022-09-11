#!/bin/bash

N1=`sed -n '7p' POSCAR|awk '{print $1}'`
N2=`sed -n '7p' POSCAR|awk '{print $2}'`
N3=`sed -n '7p' POSCAR|awk '{print $3}'`
N4=`sed -n '7p' POSCAR|awk '{print $4}'`
N5=`sed -n '7p' POSCAR|awk '{print $5}'`
N6=`sed -n '7p' POSCAR|awk '{print $6}'`
N7=`sed -n '7p' POSCAR|awk '{print $7}'`
N8=`sed -n '7p' POSCAR|awk '{print $8}'`

charge1=`grep 00000000000000 POTCAR|sed  -n '1p'`
charge2=`grep 00000000000000 POTCAR|sed  -n '2p'`
charge3=`grep 00000000000000 POTCAR|sed  -n '3p'`
charge4=`grep 00000000000000 POTCAR|sed  -n '4p'`
charge5=`grep 00000000000000 POTCAR|sed  -n '5p'`
charge6=`grep 00000000000000 POTCAR|sed  -n '6p'`
charge7=`grep 00000000000000 POTCAR|sed  -n '7p'`
charge8=`grep 00000000000000 POTCAR|sed  -n '8p'`

N_atom=`sed -n '6p' POSCAR | xargs -n1|wc -l`
if [ $N_atom == 1 ];then
N2=0;N3=0;N4=0;N5=0;N6=0;N7=0;N8=0
charge2=0;charge3=0;charge4=0;charge5=0;charge6=0;charge7=0;charge8=0
elif [ $N_atom == 2 ];then
N3=0;N4=0;N5=0;N6=0;N7=0;N8=0
charge3=0;charge4=0;charge5=0;charge6=0;charge7=0;charge8=0
elif [ $N_atom == 3 ];then
N4=0;N5=0;N6=0;N7=0;N8=0
charge4=0;charge5=0;charge6=0;charge7=0;charge8=0
elif [ $N_atom == 4 ];then
N5=0;N6=0;N7=0;N8=0
charge5=0;charge6=0;charge7=0;charge8=0
elif [ $N_atom == 5 ];then
N6=0;N7=0;N8=0
charge6=0;charge7=0;charge8=0
elif [ $N_atom == 6 ];then
N7=0;N8=0
charge7=0;charge8=0
elif [ $N_atom == 7 ];then
N8=0
charge8=0
#elif [ $N_atom == 8 ];then
elif [ $N_atom == 9 ];then
echo "N_atom > 8, Error!"
fi

echo $N1 $N2 $N3 $N4 $N5 $N6 $N7 $N8 $charge1 $charge2 $charge3 $charge4 $charge5 $charge6 $charge7 $charge8 $1
total_e=`echo $N1 $N2 $N3 $N4 $N5 $N6 $N7 $N8 $charge1 $charge2 $charge3 $charge4 $charge5 $charge6 $charge7 $charge8 $1|awk '{print $1*$9+$2*$10+$3*$11+$4*$12+$5*$13+$6*$14+$7*$15+$8*$16-$17}'`
echo charge = $1
echo total eletron = $total_e
sed -i "s/^.*NELECT.*$/NELECT=$total_e/" INCAR


