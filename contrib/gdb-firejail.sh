#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2
set -x

# gdb setuid helper script.
# This script forks a background process as the current user which will
# immediately send itself a `STOP` signal.  Then gdb running as root will
# attach to that process, which will send it the `CONT` signal to continue
# execution.  Then the backgrounded process will exec the program with the
# given arguments.  This will allow the root gdb to trace the unprivileged
# setuid firejail process from the absolute beginning.

if [ -z "${1##*/firejail}" ]; then
	FIREJAIL=$1
else
	# First argument is not named firejail, then add default unless environment
	# variable already set.
	set -- ${FIREJAIL:=$(command -v firejail)} "$@"
fi

bash -c "kill -STOP \$\$; exec \"\$0\" \"\$@\"" "$@" &
sudo gdb -e "$FIREJAIL" -p "$!"
