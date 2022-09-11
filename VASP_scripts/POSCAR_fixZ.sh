#!/bin/bash
####################################################################################################################
#This script helps you fix atoms with Z coordinate less than a value in POSCAR.
###################################
#By xijun Wang from USTC /4/29/2016
#E-mail:wangxijun1016@gmail.com
#QQ:710340788
####################################################################################################################
#Check POSCAR
if [ ! -f "POSCAR" ]; then
echo "Error! There is no POSCAR file!\n" 
fi
dos2unix POSCAR
echo "Z=";read Z
atom_numbers=`awk 'NR==7{for(i=1;i<=NF;i++)atom_number_count+=$i;print atom_number_count}' POSCAR`
coordinate_begin_line=`sed -n '9p' POSCAR| awk '{print $1}' | awk '{print($0~/^[-]?([0-9])+[.]?([0-9])+$/)?"9":"10"}'`
sed -n "${coordinate_begin_line},`expr ${coordinate_begin_line} - 1 + $atom_numbers`p" POSCAR > POSCAR_body.tmp
if [ $coordinate_begin_line = "9" ]; then
for ((i=1;i<=$atom_numbers;i++))
do
frac_coordinate_x[$i]=`sed -n "${i}p" POSCAR_body.tmp|awk '{print $1}'`
frac_coordinate_y[$i]=`sed -n "${i}p" POSCAR_body.tmp|awk '{print $2}'`
frac_coordinate_z[$i]=`sed -n "${i}p" POSCAR_body.tmp|awk '{print $3}'`
done
head -7 POSCAR > POSCAR_fix
echo "Selective dynamics" >> POSCAR_fix
sed -n "8p" POSCAR >> POSCAR_fix
for ((i=1;i<=$atom_numbers;i++))
do
F_or_T=`echo "if(${frac_coordinate_z[$i]} < $Z) print "0" else print "1"" | bc`

if [ ${F_or_T} = 0 ]; then
echo "     ${frac_coordinate_x[$i]}         ${frac_coordinate_y[$i]}         ${frac_coordinate_z[$i]}   F   F   F" >> POSCAR_fix
else
echo "     ${frac_coordinate_x[$i]}         ${frac_coordinate_y[$i]}         ${frac_coordinate_z[$i]}   T   T   T" >> POSCAR_fix
fi
done
fi
if [ $coordinate_begin_line = "10" ]; then
echo "This is a fixed system"
fi
rm POSCAR_body.tmp -f
cp POSCAR POSCAR_fixbk
mv POSCAR_fix POSCAR
