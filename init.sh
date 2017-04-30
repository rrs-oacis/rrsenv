#!/bin/sh

WGETSOUT='wget --no-check-certificate -O -'
if ! [ -x `which wget||echo /dev/null` ]; then
	if [ -x `which curl||echo /dev/null` ]; then
		WGETSOUT='curl -L'
	fi
fi

cd `dirname $0`

if [ -d 'MAP' -a -d 'TEAM' -a -d 'tmp' -a -d 'workspace' ]; then
    echo "If you want to initialize, please remove 'MAP' or 'TEAM' or 'tmp' or 'workspace'.";
    exit 0;
fi

rm -rf MAP 2>/dev/null
rm -rf TEAM 2>/dev/null
rm -rf tmp 2>/dev/null
rm -rf workspace 2>/dev/null
rm -rf roborescue 2>/dev/null

mkdir MAP
mkdir TEAM
mkdir tmp
mkdir workspace

cd tmp
$WGETSOUT https://raw.githubusercontent.com/tkmnet/rcrs-scripts/master/install-roborescue.sh | sh
mv ./* ../roborescue

