#!/bin/bash

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

rm -f ./args
gcc -o args args.c

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

rm ./args
