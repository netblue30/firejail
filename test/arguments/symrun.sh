#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

mkdir symtest
ln -s /usr/bin/firejail symtest/faudit

# search for faudit in current directory
export PATH=$PATH:.
export FIREJAIL_TEST_ARGUMENTS=yes

echo "TESTING: 2.1 - simple args"
symtest/faudit arg1 arg2

# simple quotes, testing spaces in file names
echo "TESTING: 2.2 - args with space and \""
symtest/faudit "arg1 tail" "arg2 tail"

echo "TESTING: 2.3 - args with space and '"
symtest/faudit 'arg1 tail' 'arg2 tail'

# escaped space in file names
echo "TESTING: 2.4 - args with space and \\"
symtest/faudit arg1\ tail arg2\ tail

# & char appears in URLs - URLs should be quoted
echo "TESTING: 2.5 - args with & and \""
symtest/faudit "arg1&tail" "arg2&tail"

echo "TESTING: 2.6 - args with & and '"
symtest/faudit 'arg1&tail' 'arg2&tail'

rm -fr symtest
