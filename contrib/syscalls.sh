#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

STRACE_OUTPUT_FILE="$(pwd)/strace_output.txt"
SYSCALLS_OUTPUT_FILE="$(pwd)/syscalls.txt"

if [ $# -eq 0 ]
then
	echo
	echo "   *** No program specified!!! ***"
	echo
	echo -e "Make this file executable and execute it as:\\n"
	echo -e "\\e[96m   syscalls.sh /full/path/to/program\\n"
	echo -e "\\e[39mif you saved this script in a directory in your PATH (e.g., in ${HOME}/bin), otherwise as:\\n"
	echo -e "\\e[96m   ./syscalls.sh /full/path/to/program\\n"
	echo -e "\\e[39mUse the full path to the respective program to avoid executing it sandboxed with Firejail\\n(if a Firejail profile for it already exits and 'sudo firecfg' was executed earlier)\\nin order to determine the necessary system calls."
	echo
	exit 0
else
	strace -cfo "$STRACE_OUTPUT_FILE" "$@" && awk '{print $NF}' "$STRACE_OUTPUT_FILE" | sed '/syscall\|-\|total/d' | sort -u | awk -vORS=, '{ print $1 }' | sed 's/,$/\n/' > "$SYSCALLS_OUTPUT_FILE"
	echo
	echo -e "\e[39mThese are the sorted syscalls:\n\e[93m"
	cat "$SYSCALLS_OUTPUT_FILE"
	echo
	echo -e "\e[39mThe sorted syscalls were saved to:\n\e[96m$SYSCALLS_OUTPUT_FILE\n\e[39m"
	exit 0
fi
