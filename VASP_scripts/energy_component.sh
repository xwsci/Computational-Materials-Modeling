#!/bin/bash
filename="OUTCAR"
E_sigma0=`grep "energy without entropy" $filename|tail -1|awk '{print $8}'`
E_sol=`grep "Solvation  Ediel_sol" $filename|tail -1|awk '{print $4}'`
E_atom_elec=`echo $E_sigma0 $E_sol|awk '{print $1-$2}'`
E_disp=`grep Edisp $filename|tail -1|awk '{print $3}'`
E=`eout|tail -1`
echo E_atom_elec E_sol E_sigma0 E_disp E
echo $E_atom_elec $E_sol $E_sigma0 $E_disp $E |awk '{printf "%lf\t%lf\t%lf\t%lf\t%lf\n",$1,$2,$3,$4,$5}'




