#!/bin/bash

. `dirname ${OACIS_WORKDIR}`/config.cfg

MAP=$1
FAGENT=$2
PAGENT=$3
AAGENT=$4
DATECODE=`date +%y%m%d`

function serverProc {
    ssh $1 sh -c "'cat /tmp/.X100-lock | sed -e \"s/ //g\" | xargs kill'" >/dev/null 2>&1
    ssh $1 sh -c "'export LC_ALL=en_US.UTF-8; export DISPLAY=:0; cd /var/tmp/robocup/${2}/roborescue/boot; ./start-comprun.sh -m ../../MAP/${MAP}/map -c ../../MAP/${MAP}/config -t ${AAGENT}'" >${OACIS_WORKDIR}/server.log
    sleep 3

    ssh $1 sh -c "'cd /var/tmp/robocup/${2}/roborescue/boot; 7za a -m0=lzma2 ../../LOG/${DATECODE}-${MAP}/${DATECODE}-${MAP}-${AAGENT}.7z logs'"
    scp $1:"/var/tmp/robocup/${2}/LOG/${DATECODE}-${MAP}/${DATECODE}-${MAP}-${AAGENT}.7z" ${OACIS_WORKDIR}/simulation_log.7z
    ssh $1 sh -c "'cd /var/tmp/robocup/${2}/roborescue/boot; echo "${DATECODE},${MAP},${FAGENT},${PAGENT},${AAGENT},"; sh ./print-lastscore.sh'" | tee ${OACIS_WORKDIR}/score.txt
    ssh $1 sh -c "'export LC_ALL=en_US.UTF-8; export DISPLAY=:0; rm -rf /tmp/img_log; mkdir /tmp/img_log; cd /var/tmp/robocup/${2}/roborescue/boot; bash ./logextract.sh ./logs/rescue.log /tmp/img_log'"
    scp -r $1:/tmp/img_log ${OACIS_WORKDIR}/
    sh ./countimage.sh ${OACIS_WORKDIR}/img_log | tee ${OACIS_WORKDIR}/img_log/count.txt
}

function clientProc {
    ssh $4 sh -c "\"sleep 10 ; cd /var/tmp/robocup/${5}/AGENT/${6} ; bash ./start.sh $1 $1 $2 $2 $3 $3 `echo ${SERVER_SS}|sed -e 's/^.*@//'`\"" >${OACIS_WORKDIR}/agent${5}.log &
}

clientProc -1 0 0 $SERVER_C1 1 $FAGENT
clientProc 0 -1 0 $SERVER_C2 2 $PAGENT
clientProc 0 0 -1 $SERVER_C3 3 $AAGENT

serverProc $SERVER_SS S

