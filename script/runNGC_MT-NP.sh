#!/bin/bash -e

#export LC_ALL=en_US.UTF-8
export LC_ALL=C
export LANG=en_US.UTF-8
export OACIS_WORKDIR=`pwd`

cd `dirname $0`

./killjava.sh
sleep 1
./setup_MT.sh $1 $2 $3 $4
sleep 2
./startNG_MT.sh $1 $2 $3 $4

if [ `cat ${OACIS_WORKDIR}/score.txt | wc -l` -ne 2 ] ; then
	exit 1
fi

if [ `cat ${OACIS_WORKDIR}/agent?.log| grep '\[FINISH\] Done connecting to server (' | wc -l` -ne 3 ] ; then
	exit 2
fi

