#!/bin/bash

echo "TESTING: 4.1 - simple args"
firejail --output=out ./argtest arg1 arg2

# simple quotes, testing spaces in file names
echo "TESTING: 4.2 - args with space and \""
firejail --output=out ./argtest "arg1 tail" "arg2 tail"

echo "TESTING: 4.3 - args with space and '"
firejail --output=out ./argtest 'arg1 tail' 'arg2 tail'

# escaped space in file names
echo "TESTING: 4.4 - args with space and \\"
firejail --output=out ./argtest arg1\ tail arg2\ tail

# & char appears in URLs - URLs should be quoted
echo "TESTING: 4.5 - args with & and \""
firejail --output=out ./argtest "arg1&tail" "arg2&tail"

echo "TESTING: 4.6 - args with & and '"
firejail --output=out ./argtest 'arg1&tail' 'arg2&tail'
