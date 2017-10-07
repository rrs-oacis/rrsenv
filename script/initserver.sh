#!/bin/bash

. ./config.cfg

cd `dirname $0`

echo Enter sudo password
stty -echo
read SUDOPW
stty echo

PKEY=`cat ~/.ssh/id_rsa.pub`

function serverProc {
#    ssh $1 sh -c "\"echo '${PKEY}' >> ~/.ssh/authorized_keys\""
#    ssh $1 sh -c "'cat ~/.ssh/authorized_keys | uniq | tee ~/.ssh/authorized_keys'"
    echo "$SUDOPW" | ssh -tt $1 sudo 'sh -c "mkdir -p /var/tmp/robocup ; chmod 777 /var/tmp/robocup"' | sed 1,2d
    ssh $1 mkdir -p /var/tmp/robocup/$2
    scp -r ../roborescue ${1}:/var/tmp/robocup/$2/roborescue
}

function clientProc {
#    ssh $1 sh -c "\"echo '${PKEY}' >> ~/.ssh/authorized_keys\""
#    ssh $1 sh -c "'cat ~/.ssh/authorized_keys | uniq | tee ~/.ssh/authorized_keys'"
    echo "$SUDOPW" | ssh -tt $1 sudo 'sh -c "mkdir -p /var/tmp/robocup ; chmod 777 /var/tmp/robocup"' | sed 1,2d
    ssh $1 mkdir -p /var/tmp/robocup/$2
}

clientProc $SERVER_C1 F
clientProc $SERVER_C2 P
clientProc $SERVER_C3 A
serverProc $SERVER_SS S

SUDOPW=""

