#!/bin/bash
Jobname=$1
dos2unix $1
FName=${Jobname%.*}
sed -i "1c %chk=$FName.chk" $1
sed -i "2c %nprocshared=16" $1
cp ~/gaussian.sh $FName.sh
sed -i "s/filename/$FName/g" $FName.sh

bsub < $FName.sh

