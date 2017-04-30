#!/bin/bash -e

#export LC_ALL=en_US.UTF-8
export LC_ALL=C
export LANG=en_US.UTF-8
export DISPLAY=:0.0

cd `dirname $0`

./setup.sh $1 $2
sleep 2
./precompute.sh $1 $2
sleep 2
./start.sh $1 $2

