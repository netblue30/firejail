#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C


echo "TESTING: timeout (test/environment/timeout.exp)"
./timeout.exp

echo "TESTING: DNS (test/environment/dns.exp)"
./dns.exp

echo "TESTING: machine-id (test/environment/machineid.exp)"
./machineid.exp

echo "TESTING: hosts file (test/environment/hostfile.exp)"
./hostfile.exp

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

which dash 2>/dev/null
if [ "$?" -eq 0 ];
then
        echo "TESTING: dash (test/environment/dash.exp)"
        ./dash.exp
else
        echo "TESTING SKIP: dash not found"
fi

which csh 2>/dev/null
if [ "$?" -eq 0 ];
then
        echo "TESTING: csh (test/environment/csh.exp)"
        ./csh.exp
else
        echo "TESTING SKIP: csh not found"
fi

which zsh 2>/dev/null
if [ "$?" -eq 0 ];
then
        echo "TESTING: zsh (test/environment/zsh.exp)"
        ./zsh.exp
else
        echo "TESTING SKIP: zsh not found"
fi

echo "TESTING: firejail in firejail - single sandbox (test/environment/firejail-in-firejail.exp)"
./firejail-in-firejail.exp

which aplay 2>/dev/null
if [ "$?" -eq 0 ] && [ "$(aplay -l | grep -c "List of PLAYBACK")" -gt 0 ];
then
        echo "TESTING: sound (test/environment/sound.exp)"
        ./sound.exp
else
        echo "TESTING SKIP: no aplay or sound card found"
fi

echo "TESTING: nice (test/environment/nice.exp)"
./nice.exp

echo "TESTING: quiet (test/environment/quiet.exp)"
./quiet.exp

which strace 2>/dev/null
if [ "$?" -eq 0 ];
then
        echo "TESTING: --allow-debuggers (test/environment/allow-debuggers.exp)"
        ./allow-debuggers.exp
else
        echo "TESTING SKIP: strace not found"
fi

# to install ibus:
#       $ sudo apt-get install ibus-table-array30
#       $ ibus-setup

find ~/.config/ibus/bus | grep unix-0
if [ "$?" -eq 0 ];
then
	echo "TESTING: ibus (test/environment/ibus.exp)"
	./ibus.exp
else
        echo "TESTING SKIP: ibus not configured"
fi

echo "TESTING: rlimit (test/environment/rlimit.exp)"
./rlimit.exp

echo "TESTING: rlimit profile (test/environment/rlimit-profile.exp)"
./rlimit-profile.exp

echo "TESTING: rlimit join (test/environment/rlimit-join.exp)"
./rlimit-join.exp

echo "TESTING: rlimit errors (test/environment/rlimit-bad.exp)"
./rlimit-bad.exp

echo "TESTING: rlimit errors profile (test/environment/rlimit-bad-profile.exp)"
./rlimit-bad-profile.exp

echo "TESTING: deterministic exit code (test/environment/deterministic-exit-code.exp)"
./deterministic-exit-code.exp

echo "TESTING: retain umask (test/environment/umask.exp)"
(umask 123 && ./umask.exp)
