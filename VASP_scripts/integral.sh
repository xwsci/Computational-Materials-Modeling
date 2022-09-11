#!/bin/bash
####################################################################################################################
#This script can help you get the integral value from an 2 colurm input data.
#The x range is defined by the program user
###################################
#By xijun Wang from USTC /2/25/2016
#E-mail:wangxijun1016@gmail.com
#QQ:710340788
####################################################################################################################
#define integral function
function integral()
{
#get lines that contain numbers 
sed -n '/1/p;/2/p;/3/p;/4/p;/5/p;/6/p;/7/p;/8/p;/9/p;/0/p;' data_input.tmp | sort -n | uniq > data.tmp
#save into x,y data into arrays
awk '{print $1}' data.tmp > integral_x.tmp
awk '{print $2}' data.tmp > integral_y.tmp
line_number=`awk "{print NR}" data.tmp | tail -1`
i=1
for ((i=1;i<=$line_number;i++))
do
integral_x[$i]=`sed -n "${i}p" integral_x.tmp`
integral_y[$i]=`sed -n "${i}p" integral_y.tmp`
done
#calculate integral
for ((n=1;n<$line_number;n++))
do
m=`expr $n + 1`
S[$n]=`echo "${integral_x[$n]} ${integral_y[$n]} ${integral_x[$m]} ${integral_y[$m]}"|awk '{printf "%lf",0.5*($2+$4)*($3-$1)}'`
echo ${S[$n]} >> integral_S.tmp
done
S=`cat integral_S.tmp |awk '{a+=$1}END{print a}'`
echo $S

rm -f integral_x.tmp integral_y.tmp integral_S.tmp data.tmp
}

#define Energy range
echo "Please enter x range:";echo "x_min=";read x_min;echo "x_max=";read x_max
echo "The x range is $x_min ~ $x_max"
#get data in the defined x range
for filenames in data-test       ##Add file names here for bathing------------------------------1
do
awk -v xmin=$x_min -v xmax=$x_max '$1 >= xmin && $1 <= xmax {print $1}' ${filenames} > data_x.tmp
awk -v xmin=$x_min -v xmax=$x_max '$1 >= xmin && $1 <= xmax {print $2}' ${filenames} > data_y.tmp
paste data_x.tmp data_y.tmp > data_input.tmp
echo "Integral value = "
integral
rm -f data_input.tmp data_x.tmp data_y.tmp
done


