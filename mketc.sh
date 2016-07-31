#!/bin/sh
rm -fr .etc
mkdir .etc

for file in etc/*.profile etc/*.inc etc/*.net;
do
	sed "s;/etc/firejail;$1/firejail;g" $file > .$file
done
