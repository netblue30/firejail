#!/bin/sh

set -e
src=$1
dir=$2
build=$3
log=test/${dir}.log

echo src:$src
echo dir:$dir
echo log:$log
echo build:$build

(cd $src/$dir && BUILD_ROOT=$build ./${dir}.sh 2>&1) | tee $log
grep -a TESTING $log && ! grep -a -q "TESTING ERROR" $log

exit 0
