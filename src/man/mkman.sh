#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

set -e

MONTH="$(LC_ALL=C date -u --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%b)"
YEAR="$(LC_ALL=C date -u --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y)"

sed \
  -e "s/VERSION/$1/g" \
  -e "s/MONTH/$MONTH/g" \
  -e "s/YEAR/$YEAR/g"
