#!/bin/bash
dos2unix *
filename=data.csv
direct=`pwd`
cp $filename $filename.tmp
sed -i 's/,/ /g' $filename.tmp
len=`cat $filename.tmp|wc -l`
count=0
cat $filename.tmp | awk '{printf "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",$1,$2,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17}' > 1.Eads.dat
cat $filename.tmp | awk '{printf "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",$1,$3,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17}' > 2.e.dat
cat $filename.tmp | awk '{printf "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",$1,$4,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17}' > 3.Eb.dat
cat $filename.tmp | awk '{printf "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",$1,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17}' > 4.dband.dat

#n_sample=`echo $len|awk '{print $1-1}'`

for target in 1.Eads 2.e 3.Eb 4.dband #5.WF 6.alpha
do
sed -i "1c name $target f3 f4 f5 f6 i3 i4 i5 i6 I3 I4 I5 I6" $target.dat
mkdir -p $target
mv $target.dat $target/train.dat

cd $target
cp $direct/SISSO.in.IR+raman SISSO.in
#sed -i "s/xijun_nsample/$n_sample/g" SISSO.in
cp ~/script-SISSO .
bsub < script-SISSO
cd ..

done


















