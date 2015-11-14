#!/bin/bash
rm -fr .etc
mkdir .etc

result=$(echo $1 | sed 's/\//\\\//g')
echo $result

FILES=`ls etc/*.profile`
for file in $FILES
do
	sed "s/\/etc/$result/g" $file > .$file
done

FILES=`ls etc/*.inc`
for file in $FILES
do
	sed "s/\/etc/$result/g" $file > .$file
done
