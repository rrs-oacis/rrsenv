#!/bin/sh

cd `dirname $0`
cd ./workspace
find ./ -name 'config.cfg' | xargs dirname | xargs -I @ sh -c 'cd @ ; ../../script/initsystem.sh'

