#!/bin/bash
dos2unix POSCAR
sed -n '6p' POSCAR
sed -n '6p' POSCAR | xargs -n1 | awk '{print "~/pot/" $1 "_pot"}' | sed '1i\cat' | sed '$a > POTCAR' | xargs > pot_tmp
chmod +x pot_tmp
./pot_tmp
rm -f pot_tmp
echo "grep TIT POTCAR"
grep TIT POTCAR
