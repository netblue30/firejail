#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

echo "TESTING: 3.1 - simple args"
firejail --env=FIREJAIL_TEST_ARGUMENTS=yes --join=joinrun faudit arg1 arg2

# simple quotes, testing spaces in file names
echo "TESTING: 3.2 - args with space and \""
firejail --env=FIREJAIL_TEST_ARGUMENTS=yes --join=joinrun faudit "arg1 tail" "arg2 tail"

echo "TESTING: 3.3 - args with space and '"
firejail --env=FIREJAIL_TEST_ARGUMENTS=yes --join=joinrun faudit 'arg1 tail' 'arg2 tail'

# escaped space in file names
echo "TESTING: 3.4 - args with space and \\"
firejail --env=FIREJAIL_TEST_ARGUMENTS=yes --join=joinrun faudit arg1\ tail arg2\ tail

# & char appears in URLs - URLs should be quoted
echo "TESTING: 3.5 - args with & and \""
firejail --env=FIREJAIL_TEST_ARGUMENTS=yes --join=joinrun faudit "arg1&tail" "arg2&tail"

echo "TESTING: 3.6 - args with & and '"
firejail --env=FIREJAIL_TEST_ARGUMENTS=yes --join=joinrun faudit 'arg1&tail' 'arg2&tail'
