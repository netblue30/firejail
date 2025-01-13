#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2025 Firejail Authors
# License GPL v2

set -e

test -z "$SOURCE_DATE_EPOCH" && SOURCE_DATE_EPOCH="$(date +%s)"

format='+%b %Y'
date="$(LC_ALL=C date -u -d "@$SOURCE_DATE_EPOCH" "$format" 2>/dev/null ||
	LC_ALL=C date -u -r "$SOURCE_DATE_EPOCH" "$format" 2>/dev/null ||
	LC_ALL=C date -u "$format")"

MONTH="$(printf '%s\n' "$date" | cut -f 1 -d ' ')"
YEAR="$(printf '%s\n' "$date" | cut -f 2 -d ' ')"

sed \
  -e "s/VERSION/$1/g" \
  -e "s/MONTH/$MONTH/g" \
  -e "s/YEAR/$YEAR/g"
