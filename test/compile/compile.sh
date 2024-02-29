#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

# not currently covered
#  --disable-suid          install as a non-SUID executable
#  --enable-fatal-warnings -W -Wall -Werror
#  --enable-gcov           Gcov instrumentation
#  --enable-contrib-install
#                          install contrib scripts
#  --enable-analyzer       enable GCC 10 static analyzer

# shellcheck source=config.sh
. "$(dirname "$0")/../../config.sh" || exit 1

arr[1]="TEST 1: standard compilation"
arr[2]="TEST 2: compile dbus proxy disabled"
arr[3]="TEST 3: compile chroot disabled"
arr[4]="TEST 4: compile firetunnel disabled"
arr[5]="TEST 5: compile user namespace disabled"
arr[6]="TEST 6: compile network disabled"
arr[7]="TEST 7: compile X11 disabled"
arr[8]="TEST 8: compile selinux"
arr[9]="TEST 9: compile file transfer disabled"
arr[10]="TEST 10: compile disable whitelist"
arr[11]="TEST 11: compile disable global config"
arr[12]="TEST 12: compile apparmor"
arr[13]="TEST 13: compile busybox"
arr[14]="TEST 14: compile overlayfs disabled"
arr[15]="TEST 15: compile private-home disabled"
arr[16]="TEST 16: compile disable manpages"
arr[17]="TEST 17: disable tmpfs as regular user"
arr[18]="TEST 18: disable private home"
arr[19]="TEST 19: enable ids"

# remove previous reports and output file
cleanup() {
	rm -f report*
	rm -fr firejail
	rm -f oc* om*
	rm -f output-configure
	rm -f output-make
}

print_title() {
	echo
	echo
	echo
	echo "**************************************************"
	echo "$1"
	echo "**************************************************"
}

DIST="$TARNAME-$VERSION"
while [[ $# -gt 0 ]]; do    # Until you run out of parameters . . .
	case "$1" in
	--clean)
		cleanup
		exit
		;;
	--help)
		echo "./compile.sh [--clean|--help]"
		exit
		;;
	esac
	shift       # Check next set of parameters.
done

cleanup


#*****************************************************************
# TEST 1
#*****************************************************************
# - checkout source code
#*****************************************************************
print_title "${arr[1]}"
echo "$DIST"
tar -xJvf ../../"$DIST.tar.xz"
mv "$DIST" firejail

cd firejail || exit 1
./configure --prefix=/usr --enable-fatal-warnings \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test1
grep Error output-configure output-make >> ./report-test1
cp output-configure oc1
cp output-make om1
rm output-configure output-make

#*****************************************************************
# TEST 2
#*****************************************************************
# - disable dbus proxy configuration
#*****************************************************************
print_title "${arr[2]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-dbusproxy \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test2
grep Error output-configure output-make >> ./report-test2
cp output-configure oc2
cp output-make om2
rm output-configure output-make

#*****************************************************************
# TEST 3
#*****************************************************************
# - disable chroot configuration
#*****************************************************************
print_title "${arr[3]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-chroot \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test3
grep Error output-configure output-make >> ./report-test3
cp output-configure oc3
cp output-make om3
rm output-configure output-make

#*****************************************************************
# TEST 4
#*****************************************************************
# - disable firetunnel configuration
#*****************************************************************
print_title "${arr[4]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-firetunnel \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test4
grep Error output-configure output-make >> ./report-test4
cp output-configure oc4
cp output-make om4
rm output-configure output-make

#*****************************************************************
# TEST 5
#*****************************************************************
# - disable user namespace configuration
#*****************************************************************
print_title "${arr[5]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-userns \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test5
grep Error output-configure output-make >> ./report-test5
cp output-configure oc5
cp output-make om5
rm output-configure output-make

#*****************************************************************
# TEST 6
#*****************************************************************
# - disable user namespace configuration
# - check compilation
#*****************************************************************
print_title "${arr[6]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-network \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test6
grep Error output-configure output-make >> ./report-test6
cp output-configure oc6
cp output-make om6
rm output-configure output-make

#*****************************************************************
# TEST 7
#*****************************************************************
# - disable X11 support
#*****************************************************************
print_title "${arr[7]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-x11 \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test7
grep Error output-configure output-make >> ./report-test7
cp output-configure oc7
cp output-make om7
rm output-configure output-make

#*****************************************************************
# TEST 8
#*****************************************************************
# - enable selinux
#*****************************************************************
print_title "${arr[8]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --enable-selinux \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test8
grep Error output-configure output-make >> ./report-test8
cp output-configure oc8
cp output-make om8
rm output-configure output-make

#*****************************************************************
# TEST 9
#*****************************************************************
# - disable file transfer
#*****************************************************************
print_title "${arr[9]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-file-transfer \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test9
grep Error output-configure output-make >> ./report-test9
cp output-configure oc9
cp output-make om9
rm output-configure output-make

#*****************************************************************
# TEST 10
#*****************************************************************
# - disable whitelist
#*****************************************************************
print_title "${arr[10]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-whitelist \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test10
grep Error output-configure output-make >> ./report-test10
cp output-configure oc10
cp output-make om10
rm output-configure output-make

#*****************************************************************
# TEST 11
#*****************************************************************
# - disable global config
#*****************************************************************
print_title "${arr[11]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-globalcfg \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test11
grep Error output-configure output-make >> ./report-test11
cp output-configure oc11
cp output-make om11
rm output-configure output-make

#*****************************************************************
# TEST 12
#*****************************************************************
# - enable apparmor
#*****************************************************************
print_title "${arr[12]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --enable-apparmor \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test12
grep Error output-configure output-make >> ./report-test12
cp output-configure oc12
cp output-make om12
rm output-configure output-make

#*****************************************************************
# TEST 13
#*****************************************************************
# - enable busybox workaround
#*****************************************************************
print_title "${arr[13]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --enable-busybox-workaround \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test13
grep Error output-configure output-make >> ./report-test13
cp output-configure oc13
cp output-make om13
rm output-configure output-make

#*****************************************************************
# TEST 14
#*****************************************************************
# - disable overlayfs
#*****************************************************************
print_title "${arr[14]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-overlayfs \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test14
grep Error output-configure output-make >> ./report-test14
cp output-configure oc14
cp output-make om14
rm output-configure output-make

#*****************************************************************
# TEST 15
#*****************************************************************
# - disable private home
#*****************************************************************
print_title "${arr[15]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-private-home \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test15
grep Error output-configure output-make >> ./report-test15
cp output-configure oc15
cp output-make om15
rm output-configure output-make

#*****************************************************************
# TEST 16
#*****************************************************************
# - disable manpages
#*****************************************************************
print_title "${arr[16]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-man \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test16
grep Error output-configure output-make >> ./report-test16
cp output-configure oc16
cp output-make om16
rm output-configure output-make

#*****************************************************************
# TEST 17
#*****************************************************************
# - disable tmpfs as regular user"
#*****************************************************************
print_title "${arr[17]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-usertmpfs \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test17
grep Error output-configure output-make >> ./report-test17
cp output-configure oc17
cp output-make om17
rm output-configure output-make

#*****************************************************************
# TEST 18
#*****************************************************************
# - disable private home feature
#*****************************************************************
print_title "${arr[18]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --disable-private-home \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test18
grep Error output-configure output-make >> ./report-test18
cp output-configure oc18
cp output-make om18
rm output-configure output-make

#*****************************************************************
# TEST 19
#*****************************************************************
# - enable ids
#*****************************************************************
print_title "${arr[19]}"
cd firejail || exit 1
make distclean
./configure --prefix=/usr --enable-fatal-warnings \
  --enable-ids \
  2>&1 | tee ../output-configure

make -j "$(nproc)" 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test19
grep Error output-configure output-make >> ./report-test19
cp output-configure oc19
cp output-make om19
rm output-configure output-make

#*****************************************************************
# PRINT REPORTS
#*****************************************************************
echo
echo
echo
echo
echo "**********************************************************"
echo "TEST RESULTS"
echo "**********************************************************"

wc -l report-test*
echo
echo "Legend:"
echo "${arr[1]}"
echo "${arr[2]}"
echo "${arr[3]}"
echo "${arr[4]}"
echo "${arr[5]}"
echo "${arr[6]}"
echo "${arr[7]}"
echo "${arr[8]}"
echo "${arr[9]}"
echo "${arr[10]}"
echo "${arr[11]}"
echo "${arr[12]}"
echo "${arr[13]}"
echo "${arr[14]}"
echo "${arr[15]}"
echo "${arr[16]}"
echo "${arr[17]}"
echo "${arr[18]}"
echo "${arr[19]}"
