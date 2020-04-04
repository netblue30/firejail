#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2020 Firejail Authors
# License GPL v2

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
' etc/disable-common.inc
