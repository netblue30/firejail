#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

basename="$(basename "$0")"

if test "$#" -lt 1; then
	printf '%s: error: missing option\n' "$basename" >&2
	exit 1
fi

case "$1" in
--version)
	printf '%s: version 1\n' "$basename"
	break
	;;
*)
	printf '%s: error: unknown option: %s\n' "$basename" "$1" >&2
	exit 1
	;;
esac
