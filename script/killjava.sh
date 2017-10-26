#!/bin/bash

. `dirname ${OACIS_WORKDIR}`/config.cfg

function serverProc () {
    ssh $1 killall java
    ssh $1 killall start-precompute.sh
    ssh $1 killall start-comprun.sh
    ssh $1 killall noGUI-start-precompute.sh
    ssh $1 killall noGUI-start-comprun.sh
}

function clientProc () {
    ssh $1 killall java
}

serverProc $SERVER_SS >/dev/null 2>&1
clientProc $SERVER_C1 >/dev/null 2>&1
clientProc $SERVER_C2 >/dev/null 2>&1
clientProc $SERVER_C3 >/dev/null 2>&1

echo killed all jvm and scripts.
