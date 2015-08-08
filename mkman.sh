#!/bin/bash

sed "s/VERSION/$1/g" $2 > $3
MONTH=`date +%b`
sed -i "s/MONTH/$MONTH/g" $3
YEAR=`date +%Y`
sed -i "s/YEAR/$YEAR/g" $3
