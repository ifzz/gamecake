cd `dirname $0`
cd ../../bin/dbg
./lua -e'dofile("../lua/apps.lua");apps.start("wettest");' $*

