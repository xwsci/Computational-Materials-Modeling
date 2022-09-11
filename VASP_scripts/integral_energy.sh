#!/bin/bash
mv integral_energy.dat integral_energy.dat.bk
grep E0 OSZICAR | awk '{print "   "$7}' > tmp.0
#grep E0 job2/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job3/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job4/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job5/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job6/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job7/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job8/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job9/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job10/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job11/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job12/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job13/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job14/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job15/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job16/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job17/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job18/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job19/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job20/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job21/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job22/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job23/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job24/OSZICAR | awk '{print "   "$7}' >> tmp.0
#grep E0 job25/OSZICAR | awk '{print "   "$7}' >> tmp.0

awk '$0=NR$0' tmp.0 > tmp

filename="tmp"
start_line=$1
end_line=`cat $filename | wc -l`
sed -n "${start_line},${end_line}p" $filename > tmp.1

new_line=`cat tmp.1 | wc -l`
t0=`sed -n '1p' tmp.1 | awk '{print $1}'`
t1=`sed -n '2p' tmp.1 | awk '{print $1}'`
dt=`echo $t1 $t0 | awk '{print $1-$2}'`
y0=`sed -n '1p' tmp.1 | awk '{print $2}'`

for x in `seq 1 $new_line`
do
sum=`sed -n "1,${x}p" tmp.1 | awk '{print $2}' | awk '{sum += $1};END {printf "%lf\n",sum}'`
tx=`sed -n "${x}p" tmp.1 | awk '{print $1}'`
yx=`sed -n "${x}p" tmp.1 | awk '{print $2}'`
e=`echo $sum $y0 $yx $dt $tx $t0 | awk '{printf "%lf\n",($1-0.5*($2+$3))*$4/($5-$6)}'` #[sum-1/2(y0+yn)]*dt/(tn-t0)
t_real=`echo $x $start_line | awk '{print $1+$2-1}'`
echo $x $e $t_real >> integral_energy.dat
done

rm -f tmp.0 tmp.1


