#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2018 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

if [ -f /etc/debian_version ]; then
	libdir=$(dirname "$(dpkg -L firejail | grep fseccomp)")
	export PATH="$PATH:$libdir"
fi
export PATH="$PATH:/usr/lib/firejail:/usr/lib64/firejail"


if [ "$(uname -m)" = "x86_64" ]; then
    echo "TESTING: memory-deny-write-execute (test/filters/memwrexe.exp)"
    ./memwrexe.exp
elif [ "$(uname -m)" = "i686" ]; then
    echo "TESTING: memory-deny-write-execute (test/filters/memwrexe-32.exp)"
    ./memwrexe-32.exp
else
    echo "TESTING SKIP: memwrexe binary only running on x86_64 and i686."
fi

echo "TESTING: debug options (test/filters/debug.exp)"
./debug.exp

echo "TESTING: seccomp run files (test/filters/seccomp-run-files.exp)"
./seccomp-run-files.exp

echo "TESTING: seccomp postexec (test/filters/seccomp-postexec.exp)"
./seccomp-postexec.exp

echo "TESTING: noroot (test/filters/noroot.exp)"
./noroot.exp

echo "TESTING: capabilities (test/filters/caps.exp)"
./caps.exp

echo "TESTING: capabilities print (test/filters/caps-print.exp)"
./caps-print.exp

rm -f seccomp-test-file
if [ "$(uname -m)" = "x86_64" ]; then
       echo "TESTING: fseccomp (test/filters/fseccomp.exp)"
        ./fseccomp.exp
else
        echo "TESTING SKIP: fseccomp test implemented only for x86_64"
fi
rm -f seccomp-test-file


if [ "$(uname -m)" = "x86_64" ]; then
        echo "TESTING: protocol (test/filters/protocol.exp)"
        ./protocol.exp
else
        echo "TESTING SKIP: protocol, running only on x86_64"
fi

echo "TESTING: seccomp bad empty (test/filters/seccomp-bad-empty.exp)"
./seccomp-bad-empty.exp

if [ "$(uname -m)" = "x86_64" ]; then
	echo "TESTING: seccomp debug  (test/filters/seccomp-debug.exp)"
	./seccomp-debug.exp
elif [ "$(uname -m)" = "i686" ]; then
	echo "TESTING: seccomp debug  (test/filters/seccomp-debug-32.exp)"
	./seccomp-debug-32.exp
else
        echo "TESTING SKIP: protocol, running only on x86_64 and i686"
fi

echo "TESTING: seccomp errno (test/filters/seccomp-errno.exp)"
./seccomp-errno.exp

echo "TESTING: seccomp su (test/filters/seccomp-su.exp)"
./seccomp-su.exp

which strace 2>/dev/null
if [ $? -eq 0 ]; then
        echo "TESTING: seccomp ptrace (test/filters/seccomp-ptrace.exp)"
        ./seccomp-ptrace.exp
else
        echo "TESTING SKIP: ptrace, strace not found"
fi

echo "TESTING: seccomp chmod - seccomp lists (test/filters/seccomp-chmod.exp)"
./seccomp-chmod.exp

echo "TESTING: seccomp chmod profile - seccomp lists (test/filters/seccomp-chmod-profile.exp)"
./seccomp-chmod-profile.exp

# todo:  fix pwd and add seccomp-chown.exp

echo "TESTING: seccomp empty (test/filters/seccomp-empty.exp)"
./seccomp-empty.exp

if [ "$(uname -m)" = "x86_64" ]; then
        echo "TESTING: seccomp dual filter (test/filters/seccomp-dualfilter.exp)"
        ./seccomp-dualfilter.exp
else
        echo "TESTING SKIP: seccomp dual, not running on x86_64"
fi
