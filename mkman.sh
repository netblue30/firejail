#!/bin/sh

sed "s/VERSION/$1/g" $2 > $3
MONTH=`LC_ALL=C date -u --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%b`
sed -i "s/MONTH/$MONTH/g" $3
YEAR=`LC_ALL=C date -u --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y`
sed -i "s/YEAR/$YEAR/g" $3
