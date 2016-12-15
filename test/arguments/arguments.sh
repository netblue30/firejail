#!/bin/bash

[ -f argtest ] || make argtest

echo "TESTING: 1. regular bash session"
./bashrun.exp
sleep 1

echo "TESTING: 2. symbolic link to firejail"
./symrun.exp
rm -fr symtest
sleep 1

echo "TESTING: 3. --join option"
./joinrun.exp
sleep 1

echo "TESTING: 4. --output option"
./outrun.exp
rm out
rm out.*


