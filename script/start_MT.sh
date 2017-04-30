#!/bin/bash

. ./config.cfg

MAP=$1
FTEAM=$2
PTEAM=$3
ATEAM=$4
DATECODE=`date +%y%m%d`

function serverProc {
    ssh $1 sh -c "'export LC_ALL=en_US.UTF-8; export DISPLAY=:0.0; cd /var/tmp/robocup/${2}/roborescue/boot; ./start-comprun.sh -m ../../MAP/${MAP}/map -c ../../MAP/${MAP}/config'"
    sleep 3

    ssh $1 sh -c "'export LC_ALL=en_US.UTF-8; export DISPLAY=:0.0; cd /var/tmp/robocup/${2}/roborescue/boot; tar cvf ../../LOG/${DATECODE}-${MAP}/${DATECODE}-${MAP}-${FTEAM}-${PTEAM}-${ATEAM}.tar logs'"
    ssh $1 sh -c "'cd /var/tmp/robocup/${2}/roborescue/boot; echo ${DATECODE}-${MAP}-${FTEAM}-${PTEAM}-${ATEAM}; sh ./print-lastscore.sh'" | tee ${OACIS_WORKDIR}/score.txt
}

function clientProc {
    ssh $4 sh -c "\"sleep 10 ; cd /var/tmp/robocup/${5}/TEAM/${6} ; bash ./start.sh $1 $1 $2 $2 $3 $3 `echo ${SERVER_SS}|sed -e 's/^.*@//'`\"" &
}

clientProc -1 0 0 $SERVER_C1 1 $FTEAM
clientProc 0 -1 0 $SERVER_C2 2 $PTEAM
clientProc 0 0 -1 $SERVER_C3 3 $ATEAM

serverProc $SERVER_SS S

