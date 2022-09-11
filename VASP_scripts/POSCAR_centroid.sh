#!/bin/bash
####################################################################################################################
#This script helps you get fraction centroid from a POSCAR file.
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

atom_numbers=`awk 'NR==7{for(i=1;i<=NF;i++)atom_number_count+=$i;print atom_number_count}' POSCAR`
coordinate_begin_line=`sed -n '9p' POSCAR| awk '{print $1}' | awk '{print($0~/^[-]?([0-9])+[.]?([0-9])+$/)?"9":"10"}'`
if [ $coordinate_begin_line = "9" ]; then
echo "This is a relaxed system"
fi
if [ $coordinate_begin_line = "10" ]; then
echo "This is a fixed system"
fi

sed -n "${coordinate_begin_line},`expr ${coordinate_begin_line} - 1 + $atom_numbers`p" POSCAR > POSCAR_body.tmp

for ((i=1;i<=$atom_numbers;i++))
do
frac_coordinate_x[$i]=`sed -n "${i}p" POSCAR_body.tmp|awk '{print $1}'`
frac_coordinate_y[$i]=`sed -n "${i}p" POSCAR_body.tmp|awk '{print $2}'`
frac_coordinate_z[$i]=`sed -n "${i}p" POSCAR_body.tmp|awk '{print $3}'`
done

#calculate centroid
element1=`sed -n '6p' POSCAR| awk '{print $1}'`
element2=`sed -n '6p' POSCAR| awk '{print $2}'`
element3=`sed -n '6p' POSCAR| awk '{print $3}'`
element4=`sed -n '6p' POSCAR| awk '{print $4}'`
element5=`sed -n '6p' POSCAR| awk '{print $5}'`
element6=`sed -n '6p' POSCAR| awk '{print $6}'`
element_N1=`sed -n '7p' POSCAR| awk '{print $1}'`
element_N2=`sed -n '7p' POSCAR| awk '{print $2}'`
element_N3=`sed -n '7p' POSCAR| awk '{print $3}'`
element_N4=`sed -n '7p' POSCAR| awk '{print $4}'`
element_N5=`sed -n '7p' POSCAR| awk '{print $5}'`
element_N6=`sed -n '7p' POSCAR| awk '{print $6}'`
if [ "$element_N2" = "" ]; then
element_N2=0
fi
if [ "$element_N3" = "" ]; then
element_N3=0
fi
if [ "$element_N4" = "" ]; then
element_N4=0
fi
if [ "$element_N5" = "" ]; then
element_N5=0
fi
if [ "$element_N6" = "" ]; then
element_N6=0
fi
rm -f elements.tmp
for ((i=1;i<=$element_N1;i++))
do
echo "$element1 " >> elements.tmp
done
for ((i=1;i<=$element_N2;i++))
do
echo "$element2 " >> elements.tmp
done
for ((i=1;i<=$element_N3;i++))
do
echo "$element3 " >> elements.tmp
done
for ((i=1;i<=$element_N4;i++))
do
echo "$element4 " >> elements.tmp
done
for ((i=1;i<=$element_N5;i++))
do
echo "$element5 " >> elements.tmp
done
for ((i=1;i<=$element_N6;i++))
do
echo "$element6 " >> elements.tmp
done

sed -i 's/H /1.00794/g' elements.tmp;sed -i 's/He /4.002602/g' elements.tmp;sed -i 's/Li /6.941/g' elements.tmp;sed -i 's/Be /9.0121831/g' elements.tmp
sed -i 's/B /10.811/g' elements.tmp;sed -i 's/C /12.0107/g' elements.tmp;sed -i 's/N /14.0067/g' elements.tmp;sed -i 's/O /15.9994/g' elements.tmp
sed -i 's/F /18.998403163/g' elements.tmp;sed -i 's/Ne /20.1797/g' elements.tmp;sed -i 's/Na /22.98976928/g' elements.tmp;sed -i 's/Mg /24.3050/g' elements.tmp
sed -i 's/Al /26.9815385/g' elements.tmp;sed -i 's/Si /28.0855/g' elements.tmp
sed -i 's/P /30.973761998/g' elements.tmp;sed -i 's/S /32.065/g' elements.tmp;sed -i 's/Cl /35.453/g' elements.tmp;sed -i 's/Ar /39.948/g' elements.tmp
sed -i 's/K /39.0983/g' elements.tmp;sed -i 's/Ca /40.078/g' elements.tmp;sed -i 's/Sc /44.955908/g' elements.tmp;sed -i 's/Ti /47.867/g' elements.tmp
sed -i 's/V /50.9415/g' elements.tmp;sed -i 's/Cr /51.9961/g' elements.tmp;sed -i 's/Mn /54.938044/g' elements.tmp;sed -i 's/Fe /55.845/g' elements.tmp
sed -i 's/Co /58.933194/g' elements.tmp;sed -i 's/Ni /58.6934/g' elements.tmp;sed -i 's/Cu /63.546/g' elements.tmp;sed -i 's/Zn /65.38/g' elements.tmp
sed -i 's/Ga /69.723/g' elements.tmp;sed -i 's/Ge /72.64/g' elements.tmp;sed -i 's/As /74.921595/g' elements.tmp;sed -i 's/Se /78.971/g' elements.tmp
sed -i 's/Br /79.904/g' elements.tmp;sed -i 's/Kr /83.798/g' elements.tmp;sed -i 's/Rb /85.4678/g' elements.tmp;sed -i 's/Sr /87.62/g' elements.tmp
sed -i 's/Y /88.90584/g' elements.tmp;sed -i 's/Zr /91.224/g' elements.tmp;sed -i 's/Nb /92.90637/g' elements.tmp;sed -i 's/Mo /95.95/g' elements.tmp
sed -i 's/Tc /98.9072/g' elements.tmp;sed -i 's/Ru /101.07/g' elements.tmp;sed -i 's/Rh /102.90550/g' elements.tmp;sed -i 's/Pd /106.42/g' elements.tmp
sed -i 's/Ag /107.8682/g' elements.tmp;sed -i 's/Cd /112.414/g' elements.tmp;sed -i 's/In /114.818/g' elements.tmp;sed -i 's/Sn /118.710/g' elements.tmp
sed -i 's/Sb /121.760/g' elements.tmp;sed -i 's/Te /127.60/g' elements.tmp;sed -i 's/I /126.90447/g' elements.tmp;sed -i 's/Xe /131.293/g' elements.tmp
sed -i 's/Cs /132.90545196/g' elements.tmp;sed -i 's/Ba /137.327/g' elements.tmp;sed -i 's/La /138.90547/g' elements.tmp;sed -i 's/Ce /140.116/g' elements.tmp
sed -i 's/Pr /140.90766/g' elements.tmp;sed -i 's/Nd /144.242/g' elements.tmp;sed -i 's/Pm /144.9/g' elements.tmp;sed -i 's/Sm /150.36/g' elements.tmp
sed -i 's/Eu /151.964/g' elements.tmp;sed -i 's/Gd /157.25/g' elements.tmp;sed -i 's/Tb /158.92535/g' elements.tmp;sed -i 's/Dy /162.500/g' elements.tmp
sed -i 's/Ho /164.93033/g' elements.tmp;sed -i 's/Er /167.259/g' elements.tmp;sed -i 's/Tm /168.93422/g' elements.tmp;sed -i 's/Yb /173.054/g' elements.tmp
sed -i 's/Lu /174.9668/g' elements.tmp;sed -i 's/Hf /178.49/g' elements.tmp;sed -i 's/Ta /180.94788/g' elements.tmp;sed -i 's/W /183.84/g' elements.tmp
sed -i 's/Re /186.207/g' elements.tmp;sed -i 's/Os /190.23/g' elements.tmp;sed -i 's/Ir /192.217/g' elements.tmp;sed -i 's/Pt /195.084/g' elements.tmp
sed -i 's/Au /196.966569/g' elements.tmp;sed -i 's/Hg /200.59/g' elements.tmp;sed -i 's/Tl /204.3833/g' elements.tmp;sed -i 's/Pb /207.2/g' elements.tmp
sed -i 's/Bi /208.98040/g' elements.tmp;sed -i 's/Po /208.9824/g' elements.tmp;sed -i 's/At /209.9871/g' elements.tmp;sed -i 's/Rn /222.0176/g' elements.tmp
sed -i 's/Fr /223.0197/g' elements.tmp;sed -i 's/Ra /226.0245/g' elements.tmp;sed -i 's/Ac /227.0277/g' elements.tmp;sed -i 's/Th /232.0377/g' elements.tmp
sed -i 's/Pa /231.03588/g' elements.tmp;sed -i 's/U /238.02891/g' elements.tmp
#elements mass * coordinates (mc)
for ((j=1;j<=$atom_numbers;j++))
do
elements_mass[$j]=`sed -n "${j}p" elements.tmp`
done

for ((i=1;i<=$atom_numbers;i++))
do
mc_x[$i]=`echo "${frac_coordinate_x[$i]} ${elements_mass[$i]}"|awk '{printf "%lf",$1*$2}'`
mc_y[$i]=`echo "${frac_coordinate_y[$i]} ${elements_mass[$i]}"|awk '{printf "%lf",$1*$2}'`
mc_z[$i]=`echo "${frac_coordinate_z[$i]} ${elements_mass[$i]}"|awk '{printf "%lf",$1*$2}'`
done
rm -f mc_vector.tmp
for ((i=1;i<=$atom_numbers;i++))
do
echo ${mc_x[$i]} ${mc_y[$i]} ${mc_z[$i]} >> mc_vector.tmp
done
#calculate M
M=`awk '{sum += $1};END {print sum}' elements.tmp`;
#calculate centroid
Mcentroid_x=`cat mc_vector.tmp | awk '{print $1}' | awk '{sum_mc_vector_x += $1};END {print sum_mc_vector_x}'`
Mcentroid_y=`cat mc_vector.tmp | awk '{print $2}' | awk '{sum_mc_vector_y += $1};END {print sum_mc_vector_y}'`
Mcentroid_z=`cat mc_vector.tmp | awk '{print $3}' | awk '{sum_mc_vector_z += $1};END {print sum_mc_vector_z}'`
centroid_x=`echo "$Mcentroid_x $M"|awk '{printf "%lf",$1/$2}'`
centroid_y=`echo "$Mcentroid_y $M"|awk '{printf "%lf",$1/$2}'`
centroid_z=`echo "$Mcentroid_z $M"|awk '{printf "%lf",$1/$2}'`
echo "The fraction centroid coordinate is:"
echo "$centroid_x   $centroid_y   $centroid_z"

#clear
rm -f elements.tmp mc_vector.tmp POSCAR_body.tmp

