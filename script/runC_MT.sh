#!/bin/bash -e

#export LC_ALL=en_US.UTF-8
export LC_ALL=C
export LANG=en_US.UTF-8
export DISPLAY=:0.0
export OACIS_WORKDIR=`pwd`

cd `dirname $0`

./setup_MT.sh $1 $2 $3 $4
sleep 2
./start_MT.sh $1 $2 $3 $4


