#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

set -e

sed "s/@VERSION@/$1/g" $2 > $3
MONTH=`LC_ALL=C date -u --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%b`
sed -i "s/@MONTH@/$MONTH/g" $3
YEAR=`LC_ALL=C date -u --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y`
sed -i "s/@YEAR@/$YEAR/g" $3
