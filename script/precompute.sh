#!/bin/bash

. ./config.cfg

MAP=$1
TEAM=$2
DATECODE=`date +%y%m%d`

cd `dirname $0`

function serverProc {
    ssh $1 sh -c "'export LC_ALL=en_US.UTF-8; export DISPLAY=:0.0; cd /var/tmp/robocup/${2}/roborescue/boot; ./start-precompute.sh -m ../../MAP/${MAP}/map -c ../../MAP/${MAP}/config'"&
    sleep 10
}

function clientProc {
    rm /tmp/robocup-exitcode${5}.tmp
    sh -c "ssh $4 'export LC_ALL=en_US.UTF-8; export DISPLAY=:0.0; cd /var/tmp/robocup/${5}/TEAM/${TEAM}; bash ./precompute.sh $1 0 $2 0 $3 0 ${SERVER_SS}' ; echo $? > /tmp/robocup-exitcode${5}.tmp" &
}

sh ./killjava.sh

serverProc $SERVER_SS S
clientProc 1 0 0 $SERVER_C1 1
clientProc 0 1 0 $SERVER_C2 2
clientProc 0 0 1 $SERVER_C3 3


COUNTDOWN=0
while [ $COUNTDOWN -lt 120 ]; do
    sleep 5
    COUNTDOWN=`echo 5 $COUNTDOWN |awk '{print $1 + $2;}'`
    if [ -e /tmp/robocup-exitcode1.tmp -a -e /tmp/robocup-exitcode2.tmp -a -e /tmp/robocup-exitcode3.tmp ]; then
        COUNTDOWN=999
    fi
done

sh ./killjava.sh

echo 10 > /tmp/robocup-exitcode1.tmp
echo `cat /tmp/robocup-exitcode1.tmp` `cat /tmp/robocup-exitcode2.tmp` `cat /tmp/robocup-exitcode3.tmp` | awk '{print $1 + $2 + $3;}' | exit

