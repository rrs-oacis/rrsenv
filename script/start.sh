#!/bin/bash

. ./config.cfg

MAP=$1
TEAM=$2
DATECODE=`date +%y%m%d`

function serverProc {
    ssh $1 sh -c "'export LC_ALL=en_US.UTF-8; export DISPLAY=:0.0; cd /var/tmp/robocup/${2}/roborescue/boot; ./start-comprun.sh -m ../../MAP/${MAP}/map -c ../../MAP/${MAP}/config'"
    sleep 3

    ssh $1 sh -c "'export LC_ALL=en_US.UTF-8; export DISPLAY=:0.0; cd /var/tmp/robocup/${2}/roborescue/boot; tar cvf ../../LOG/${DATECODE}-${MAP}/${DATECODE}-${MAP}-${TEAM}.tar logs'"
    ssh $1 sh -c "'cd /var/tmp/robocup/${2}/roborescue/boot; echo ${DATECODE}-${MAP}-${TEAM}; sh ./print-lastscore.sh'"  | tee ${OACIS_WORKDIR}/score.txt
}

function clientProc {
    ssh $4 sh -c "\"sleep 10 ; cd /var/tmp/robocup/${5}/TEAM/${TEAM} ; bash ./start.sh $1 $1 $2 $2 $3 $3 `echo ${SERVER_SS}|sed -e 's/^.*@//'`\"" &
}

clientProc -1 0 0 $SERVER_C1 1
clientProc 0 -1 0 $SERVER_C2 2
clientProc 0 0 -1 $SERVER_C3 3

serverProc $SERVER_SS S

