#!/bin/bash

i="0"

while  [ $i -lt 150000 ]
do
	echo message number $i
	i=$[$i+1]
done
