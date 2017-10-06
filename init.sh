#!/bin/sh

WGETJAVA='wget -O'
WGETJAVA_OPTION='--no-check-certificate --no-cookies --header'
WGETSOUT='wget --no-check-certificate -O -'
if ! [ -x `which wget||echo /dev/null` ]; then
	if [ -x `which curl||echo /dev/null` ]; then
    WGETJAVA='curl -o'
    WGETJAVA_OPTION='-L -H'
		WGETSOUT='curl -L'
	fi
fi

cd `dirname $0`
BASEDIR=`pwd`

if [ -d 'MAP' -a -d 'AGENT' -a -d 'tmp' -a -d 'workspace' ]; then
    echo "[!] If you want to initialize, please remove 'MAP' or 'AGENT' or 'tmp' or 'workspace'.";
    exit 0;
fi

rm -rf MAP 2>/dev/null
rm -rf AGENT 2>/dev/null
rm -rf tmp 2>/dev/null
rm -rf workspace 2>/dev/null
rm -rf roborescue 2>/dev/null

mkdir MAP
mkdir AGENT
mkdir LOG
mkdir tmp
mkdir workspace

cd tmp

if ! [ -x `which javac||echo /dev/null` ]; then
    DL_JAVA_VER=8
    OS=`uname`
    OS_MODE=`uname -m`
    FILE_SUFFIX='NULL'
    if [ $OS = 'Linux' -a $OS_MODE = 'x86_64' ]; then
        FILE_SUFFIX='linux-x64.tar.gz'
    fi
    if [ $OS = 'Linux' -a $OS_MODE = 'i386' ]; then
        FILE_SUFFIX='linux-i586.tar.gz'
    fi

    FILENAME=${DL_JAVA_VER}-${FILE_SUFFIX}
    $WGETJAVA $FILENAME ${WGETJAVA_OPTION} "Cookie: oraclelicense=accept-securebackup-cookie" `$WGETSOUT http://www.oracle.com/technetwork/java/javase/downloads/index.html | grep -o "\/technetwork\/java/\javase\/downloads\/jdk${DL_JAVA_VER}-downloads-[0-9]*\.html" | head -1 | xargs -I@ echo "http://www.oracle.com"@ | xargs $WGETSOUT 2>/dev/null | grep -o "http.*jdk-${DL_JAVA_VER}u[0-9]*-${FILE_SUFFIX}" | head -1`

    DLSTAT=$?
    if [ $DLSTAT -ne 0 -o ! -e "${FILENAME}" ]; then
        echo '[!] Java Download Failed.';
        rm -f ${FILENAME}
        exit
    fi

    tar zxf $FILENAME
    JDKDIR=`find -maxdepth 1 -mindepth 1 -type d | sed -E 's%./%%g'`
    mv $JDKDIR ../
    TMPDIR=`pwd`
    export PATH="`dirname ${TMPDIR}`/${JDKDIR}/bin:${PATH}"

    rm -f ${FILENAME}
fi

$WGETSOUT https://raw.githubusercontent.com/tkmnet/rcrs-scripts/master/install-roborescue.sh | sh
mv ./* ../roborescue

