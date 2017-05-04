#!/bin/sh

cd `dirname $0`
cd ./workspace
echo '#!/bin/sh' > /tmp/_rrsenv.$$.sh
find ./ -name 'config.cfg' | xargs dirname | xargs -I @ echo "cd @ ; ../../script/initserver.sh ; cd .." >> /tmp/_rrsenv.$$.sh
sh /tmp/_rrsenv.$$.sh
