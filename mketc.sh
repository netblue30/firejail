#!/bin/sh
rm -fr .etc
mkdir .etc

for file in etc/*.profile etc/*.inc etc/*.net;
do
	sed "s;/etc/firejail;$1/firejail;g" $file > .$file
done

if [ "x$2" = "xyes" ]
then
sed -i -e '
1i# Workaround for systems where common UNIX utilities are symlinks to busybox.\
# If this is not your case you can remove --enable-busybox-workaround from\
# ./configure options, for added security.\
noblacklist \${PATH}/mount\
noblacklist \${PATH}/umount\
noblacklist \${PATH}/su\
noblacklist \${PATH}/sudo\
noblacklist \${PATH}/nc\
noblacklist \${PATH}/crontab\
' .etc/disable-common.inc
fi
