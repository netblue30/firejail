#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

echo "TESTING: DNS (test/environment/dns.exp)"
./dns.exp

echo "TESTING: doubledash (test/environment/doubledash.exp"
mkdir -- -testdir
touch -- -testdir/ttt
cp -- /bin/bash -testdir/.
./doubledash.exp
rm -fr -- -testdir

echo "TESTING: output (test/environment/output.exp)"
./output.exp

echo "TESTING: extract command (extract_command.exp)"
./extract_command.exp

echo "TESTING: environment variables (test/environment/env.exp)"
./env.exp

echo "TESTING: shell none(test/environment/shell-none.exp)"
./shell-none.exp

which dash
if [ "$?" -eq 0 ];
then
        echo "TESTING: dash (test/environment/dash.exp)"
        ./dash.exp
else
        echo "TESTING SKIP: dash not found"
fi

which csh
if [ "$?" -eq 0 ];
then
        echo "TESTING: csh (test/environment/csh.exp)"
        ./csh.exp
else
        echo "TESTING SKIP: csh not found"
fi

which zsh
if [ "$?" -eq 0 ];
then
        echo "TESTING: zsh (test/environment/zsh.exp)"
        ./csh.exp
else
        echo "TESTING SKIP: zsh not found"
fi

echo "TESTING: rlimit (test/environment/rlimit.exp)"
./rlimit.exp

echo "TESTING: rlimit profile (test/environment/rlimit-profile.exp)"
./rlimit-profile.exp

echo "TESTING: firejail in firejail - single sandbox (test/environment/firejail-in-firejail.exp)"
./firejail-in-firejail.exp

echo "TESTING: firejail in firejail - force new sandbox (test/environment/firejail-in-firejail2.exp)"
./firejail-in-firejail2.exp

which aplay
if [ "$?" -eq 0 ];
then
        echo "TESTING: sound (test/environment/sound.exp)"
        ./sound.exp
else
        echo "TESTING SKIP: aplay not found"
fi

echo "TESTING: nice (test/environment/nice.exp)"
./nice.exp

echo "TESTING: quiet (test/environment/quiet.exp)"
./quiet.exp


