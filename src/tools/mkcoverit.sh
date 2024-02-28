#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

# unpack firejail archive
ARCFIREJAIL=`ls *.tar.xz| grep firejail`
if [ "$?" -eq 0 ];
then
	echo "preparing $ARCFIREJAIL"
	DIRFIREJAIL=`basename $ARCFIREJAIL  .tar.xz`
	rm -fr $DIRFIREJAIL
	tar -xJvf $ARCFIREJAIL
	cd $DIRFIREJAIL
	./configure --prefix=/usr
	cd ..
else
	echo "Error: firejail source archive missing"
	exit 1
fi


# unpack firetools archive
ARCFIRETOOLS=`ls *.tar.bz2 | grep firetools`
if [ "$?" -eq 0 ];
then
	echo "preparing $ARCFIRETOOLS"
	DIRFIRETOOLS=`basename $ARCFIRETOOLS .tar.bz2`
	rm -fr $DIRFIRETOOLS
	tar -xjvf $ARCFIRETOOLS
	cd $DIRFIRETOOLS
	pwd
	./configure --prefix=/usr
	cd ..

else
	echo "Error: firetools source archive missing"
	exit 1
fi

# move firetools in firejail source tree
mkdir -p $DIRFIREJAIL/extras
mv $DIRFIRETOOLS $DIRFIREJAIL/extras/firetools

# build
cd $DIRFIREJAIL
cov-build --dir cov-int make -j "$(nproc)" extras
tar czvf myproject.tgz cov-int
