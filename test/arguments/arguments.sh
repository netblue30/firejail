#!/bin/bash

echo "TESTING: 1. regular bash session"
./bashrun.exp

echo "TESTING: 2. symbolic link to firejail"
./symrun.exp

echo "TESTING: 3. --join option"
./joinrun.exp

echo "TESTING: 4. --output option"
./outrun.exp
rm out
rm out.*


