#!/bin/bash
mag_O=0;mag_Sr=0;mag_Ca=0;mag_K=0;mag_Ba=0;mag_Y=0;mag_La=0;mag_Sm=0;mag_Fe=4;mag_Co=5;mag_Cu=0;mag_Mg=0;mag_Mn=5;mag_Ni=5;mag_Ti=0;mag_N=0
U_O=0;U_Sr=0;U_Ca=0;U_K=0;U_Ba=0;U_Y=0;U_La=0;U_Sm=0;U_Fe=4;U_Co=3.4;U_Cu=4;U_Mg=0;U_Mn=3.9;U_Ni=6;U_Ti=3;U_N=0

#for x in `ls | grep "-"`
cp ~/INCAR_opt INCAR
x=POSCAR
N=`sed -n '6p' $x | awk '{print NF}'`
for y in `seq 1 $N`
do
N=`sed -n '7p' $x | xargs -n1 | sed -n "${y}p"`
element=`sed -n '6p' $x | xargs -n1 | sed -n "${y}p"`
if [ "$element" == "O" ];then
echo "$N*$mag_O" >> MAGMOM.tmp;echo $U_O >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Sr" ];then
echo "$N*$mag_Sr" >> MAGMOM.tmp;echo $U_Sr >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Ca" ];then
echo "$N*$mag_Ca" >> MAGMOM.tmp;echo $U_Ca >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "K" ];then
echo "$N*$mag_K" >> MAGMOM.tmp;echo $U_K >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Ba" ];then
echo "$N*$mag_Ba" >> MAGMOM.tmp;echo $U_Ba >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Y" ];then
echo "$N*$mag_Y" >> MAGMOM.tmp;echo $U_Y >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "La" ];then
echo "$N*$mag_La" >> MAGMOM.tmp;echo $U_La >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Sm" ];then
echo "$N*$mag_Sm" >> MAGMOM.tmp;echo $U_Sm >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Fe" ];then
echo "$N*$mag_Fe" >> MAGMOM.tmp;echo $U_Fe >> LDAUU.tmp;echo 2 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Co" ];then
echo "$N*$mag_Co" >> MAGMOM.tmp;echo $U_Co >> LDAUU.tmp;echo 2 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Cu" ];then
echo "$N*$mag_Cu" >> MAGMOM.tmp;echo $U_Cu >> LDAUU.tmp;echo 2 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Mg" ];then
echo "$N*$mag_Mg" >> MAGMOM.tmp;echo $U_Mg >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Mn" ];then
echo "$N*$mag_Mn" >> MAGMOM.tmp;echo $U_Mn >> LDAUU.tmp;echo 2 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Ni" ];then
echo "$N*$mag_Ni" >> MAGMOM.tmp;echo $U_Ni >> LDAUU.tmp;echo 2 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "Ti" ];then
echo "$N*$mag_Ti" >> MAGMOM.tmp;echo $U_Ti >> LDAUU.tmp;echo 2 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
elif [ "$element" == "N" ];then
echo "$N*$mag_N" >> MAGMOM.tmp;echo $U_N >> LDAUU.tmp;echo -1 >> LDAUL.tmp;echo 0 >> LDAUJ.tmp
fi
done
MAGMOM=`cat MAGMOM.tmp | xargs`
LDAUL=`cat LDAUL.tmp | xargs`
LDAUU=`cat LDAUU.tmp | xargs`
LDAUJ=`cat LDAUJ.tmp | xargs`
MAGMOM_line=`cat -n INCAR | grep "MAGMOM" | awk '{print $1}'`
LDAUL_line=`cat -n INCAR | grep "LDAUL" | awk '{print $1}'`
LDAUU_line=`cat -n INCAR | grep "LDAUU" | awk '{print $1}'`
LDAUJ_line=`cat -n INCAR | grep "LDAUJ" | awk '{print $1}'`

sed -i "${MAGMOM_line}c MAGMOM=$MAGMOM" INCAR
sed -i "${LDAUL_line}c LDAUL=$LDAUL" INCAR 
sed -i "${LDAUU_line}c LDAUU=$LDAUU" INCAR
sed -i "${LDAUJ_line}c LDAUJ=$LDAUJ" INCAR

#echo MAGMOM=$MAGMOM;echo LDAUL=$LDAUL;echo LDAUU=$LDAUU;echo LDAUJ=$LDAUJ


rm -f MAGMOM.tmp LDAUL.tmp LDAUU.tmp LDAUJ.tmp


