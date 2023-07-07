#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2023 Firejail Authors
# License GPL v2

set -e

sed -i "s/VERSION/$1/g" "$2"
MONTH="$(LC_ALL=C date -u --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%b)"
sed -i "s/MONTH/$MONTH/g" "$2"
YEAR="$(LC_ALL=C date -u --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y)"
sed -i "s/YEAR/$YEAR/g" "$2"
