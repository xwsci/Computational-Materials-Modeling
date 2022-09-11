#!/bin/bash
dos2unix POSCAR
echo "Enter atomic number, e.g., N1 N3 N5";read atom_number
echo $atom_number |xargs -n 1 > fix.tmp

for filename in  POSCAR
do
#echo $filename
## Fix atoms
#rm -f fix.tmp
#for x in `seq 1 33` # O
#do
#echo O$x >> fix.tmp
#done
#for x in `seq 1 36` # N
#do
#echo N$x >> fix.tmp
#done
#for x in `seq 1 72` # C
#do
#echo C$x >> fix.tmp
#done
#for x in `seq 1 45` # H
#do
#echo H$x >> fix.tmp
#done
#for x in `seq 1 2` # Zn
#do
#echo Zn$x >> fix.tmp
#done
#for x in `seq 1 7` # Ti
#do
#echo Ti$x >> fix.tmp
#done

# Identify atom type and numbers
sed -n '1,7p' $filename > head.tmp
echo "Selective dynamics" >> head.tmp
echo "Direct" >> head.tmp
atom1=`sed -n '6p' head.tmp|awk '{print $1}'`
atom2=`sed -n '6p' head.tmp|awk '{print $2}'`
atom3=`sed -n '6p' head.tmp|awk '{print $3}'`
atom4=`sed -n '6p' head.tmp|awk '{print $4}'`
atom5=`sed -n '6p' head.tmp|awk '{print $5}'`
atom6=`sed -n '6p' head.tmp|awk '{print $6}'`
atom7=`sed -n '6p' head.tmp|awk '{print $7}'`
atom8=`sed -n '6p' head.tmp|awk '{print $8}'`
totalN=`sed -n '7p' head.tmp|awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}'`
#echo $totalN
N1=`sed -n '7p' head.tmp|awk '{print $1}'`
N2=`sed -n '7p' head.tmp|awk '{print $2}'`
N3=`sed -n '7p' head.tmp|awk '{print $3}'`
N4=`sed -n '7p' head.tmp|awk '{print $4}'`
N5=`sed -n '7p' head.tmp|awk '{print $5}'`
N6=`sed -n '7p' head.tmp|awk '{print $6}'`
N7=`sed -n '7p' head.tmp|awk '{print $7}'`
N8=`sed -n '7p' head.tmp|awk '{print $8}'`

#echo $atom1 $atom2 $atom3 $atom4 $atom5 $atom6 $atom7 $atom8
#echo $N1 $N2 $N3 $N4 $N5 $N6 $N7 $N8
rm -f $atom1.tmp $atom2.tmp $atom3.tmp $atom4.tmp $atom5.tmp $atom6.tmp $atom7.tmp $atom8.tmp
for x in `seq 1 $N1`
do
echo ${atom1}$x >> $atom1.tmp
done

for x in `seq 1 $N2`
do
echo ${atom2}$x >> $atom2.tmp
done

for x in `seq 1 $N3`
do
echo ${atom3}$x >> $atom3.tmp
done

for x in `seq 1 $N4`
do
echo ${atom4}$x >> $atom4.tmp
done

for x in `seq 1 $N5`
do
echo ${atom5}$x >> $atom5.tmp
done

for x in `seq 1 $N6`
do
echo ${atom6}$x >> $atom6.tmp
done

for x in `seq 1 $N7`
do
echo ${atom7}$x >> $atom7.tmp
done

for x in `seq 1 $N8`
do
echo ${atom8}$x >> $atom8.tmp
done

# Get coordinates
grep -A $totalN "Direct" $filename |sed '1d' > coordinate.tmp
cat $atom1.tmp $atom2.tmp $atom3.tmp $atom4.tmp $atom5.tmp $atom6.tmp $atom7.tmp $atom8.tmp | head -$totalN > elements.tmp
rm -f $atom1.tmp $atom2.tmp $atom3.tmp $atom4.tmp $atom5.tmp $atom6.tmp $atom7.tmp $atom8.tmp
paste elements.tmp coordinate.tmp > coordinate2.tmp
rm -f elements.tmp coordinate.tmp

# Fix atoms
N_fix=`cat fix.tmp|wc -l`
for x in `seq 1 $N_fix`
do
fix_atom=`sed -n "${x}p" fix.tmp`
line_number=`grep -n $fix_atom coordinate2.tmp |head -1|cut -d: -f 1`
sed -i "${line_number}s/$/ F F F/g" coordinate2.tmp
done

# Relax atoms
for x in `grep -nv "F F F" coordinate2.tmp |cut -d: -f 1`
do
sed -i "${x}s/$/ T T T/g" coordinate2.tmp

done

cat coordinate2.tmp| awk '{print $2 "   "$3 "   "$4 "   "$5 "   "$6 "   "$7}' > coordinate3.tmp

cat head.tmp coordinate3.tmp > ${filename%.*}_fixed.vasp
rm -f coordinate2.tmp coordinate3.tmp fix.tmp head.tmp

done



