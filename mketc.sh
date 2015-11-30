#!/bin/bash
rm -fr .etc
mkdir .etc

result=$(echo $1 | sed 's/\//\\\//g')
echo $result

FILES=`ls etc/*.profile`
for file in $FILES
do
	sed "s/\/etc\/firejail/$result\/firejail/g" $file > .$file
done

FILES=`ls etc/*.inc`
for file in $FILES
do
	sed "s/\/etc\/firejail/$result\/firejail/g" $file > .$file
done

FILES=`ls etc/*.net`
for file in $FILES
do
	sed "s/\/etc\/firejail/$result\/firejail/g" $file > .$file
done
