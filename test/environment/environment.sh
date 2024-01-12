#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
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

echo "TESTING: firejail in firejail - single sandbox (test/environment/firejail-in-firejail.exp)"
./firejail-in-firejail.exp

if command -v aplay && [[ $(aplay -l | grep -c "List of PLAYBACK") -gt 0 ]]
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

if command -v strace
then
	echo "TESTING: --allow-debuggers (test/environment/allow-debuggers.exp)"
	./allow-debuggers.exp
else
	echo "TESTING SKIP: strace not found"
fi

# to install ibus:
#       $ sudo apt-get install ibus-table-array30
#       $ ibus-setup

if find ~/.config/ibus/bus | grep unix-0
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

echo "TESTING: deterministic shutdown (test/environment/deterministic-shutdown.exp)"
./deterministic-shutdown.exp

echo "TESTING: keep fd (test/environment/keep-fd.exp)"
./keep-fd.exp

echo "TESTING: keep fd errors (test/environment/keep-fd-bad.exp)"
./keep-fd-bad.exp

echo "TESTING: retain umask (test/environment/umask.exp)"
(umask 123 && ./umask.exp)
