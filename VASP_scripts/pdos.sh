#!/bin/bash
echo "113" > parameter-113
vaspkit < parameter-113

for x in `sed -n '6p' POSCAR`
do
cat PDOS_${x}_UP.dat | awk '{print $1}'|sed "1c energy_up" > dos_energy
cat PDOS_${x}_UP.dat | awk '{print $NF}'|sed "1c ${x}_up" > dos_${x}_up.tmp
cat PDOS_${x}_DW.dat | awk '{print $NF}'|sed "1c ${x}_dw" > dos_${x}_dw.tmp
paste dos_${x}_up.tmp dos_${x}_dw.tmp > dos_${x}.tmp
rm dos_${x}_up.tmp dos_${x}_dw.tmp
done
ls dos_*.tmp |xargs|sed 's/^/paste dos_energy /g'|sed 's/$/ > pdos.dat/g' > command.tmp
chmod +x command.tmp
./command.tmp 
rm dos_${x}.tmp command.tmp dos_energy parameter-113
sed -i '2d' pdos.dat
#sed "s/\t/ /g"

