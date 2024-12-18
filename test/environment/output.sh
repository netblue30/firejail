#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

i="0"

while [[ $i -lt 150000 ]]
do
	echo "message number $i"
	i=$((i+1))
done
