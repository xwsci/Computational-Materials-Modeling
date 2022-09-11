#!/bin/bash
Jobname=$1
FName=${Jobname%.*}
N_atom=`grep "NAtoms=" $FName.out | head -1 | awk '{print $2}'`
echo "%chk=$FName.chk" > $FName.gjf
echo "%nprocshared=16" >> $FName.gjf
echo "%mem=32GB" >> $FName.gjf
echo "#p IRC=(CalcFC,maxpoints=300,stepsize=5) genecp nosymm empiricaldispersion=gd3 temperature=473 um06l" >> $FName.gjf
echo "" >> $FName.gjf
echo "$FName" >> $FName.gjf
echo "" >> $FName.gjf
Charge=`grep "Multiplicity" $1|head -1|awk '{print $3}'`
Multiplicity=`grep "Multiplicity" $1|head -1|awk '{print $5 $6}'|sed 's/=//g'`
echo "$Charge $Multiplicity" >> $FName.gjf

# get Optimized_coordinate_1
line2=`grep -n "Input orientation" $FName.out | tail -1 | cut -d: -f 1`
line3=`expr $line2 + $N_atom + 4`
sed -n "${line2},${line3}p" $FName.out|tail -$N_atom|awk '{print $4 "   "$5 "   "$6}' > optimized_coor.tmp

# get Atomic Symbol
line4=`expr $N_atom + 1`
grep -A$line4 "Symbolic Z-matrix:" $1|sed '1,2d'|awk '{print $1}'|head -$N_atom > symbol.tmp
paste symbol.tmp  optimized_coor.tmp >> $FName.gjf
echo "" >> $FName.gjf

# tail
sed -i 's/$/ /g' symbol.tmp
light_element=`grep "C \|O \|H \|N \|P \|B \|F \|S" symbol.tmp|sort|uniq|xargs`
metal_element=`grep -v "C \|O \|H \|N \|P \|B \|F \|S" symbol.tmp|sort|uniq|xargs`
echo "$light_element 0" >> $FName.gjf
echo "def2svp" >> $FName.gjf
echo "****" >> $FName.gjf
echo "$metal_element 0" >> $FName.gjf
echo "def2tzvp" >> $FName.gjf
echo "****" >> $FName.gjf
echo "" >> $FName.gjf
echo "$metal_element 0" >> $FName.gjf
echo "def2tzvp" >> $FName.gjf
echo "" >> $FName.gjf
echo "" >> $FName.gjf
echo "" >> $FName.gjf
sed -i 's/$/ /g' symbol.tmp

rm symbol.tmp optimized_coor.tmp





