#!/bin/bash

echo "TESTING: default profiles installed in /etc"
PROFILES=`ls /etc/firejail/*.profile`
for PROFILE in $PROFILES
do
	echo "TESTING: $PROFILE"
	./test-profile.exp $PROFILE
done

