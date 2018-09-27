#!/bin/bash

echo "TESTING: 1.1 - simple args"
firejail ./args arg1 arg2

# simple quotes, testing spaces in file names
echo "TESTING: 1.2 - args with space and \""
firejail ./args "arg1 tail" "arg2 tail"

echo "TESTING: 1.3 - args with space and '"
firejail ./args 'arg1 tail' 'arg2 tail'

# escaped space in file names
echo "TESTING: 1.4 - args with space and \\"
firejail ./args arg1\ tail arg2\ tail

# & char appears in URLs - URLs should be quoted
echo "TESTING: 1.5 - args with & and \""
firejail ./args "arg1&tail" "arg2&tail"

echo "TESTING: 1.6 - args with & and '"
firejail ./args 'arg1&tail' 'arg2&tail'
