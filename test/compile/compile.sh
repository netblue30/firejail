#!/bin/bash

arr[1]="TEST 1: standard compilation"
arr[2]="TEST 2: compile seccomp disabled"
arr[3]="TEST 3: compile user namespace disabled"
arr[4]="TEST 4: compile network disabled"
arr[5]="TEST 5: compile disable whitelist"
arr[6]="TEST 6: compile disable global config"
arr[7]="TEST 7: compile apparmor"
arr[8]="TEST 8: compile busybox"
arr[9]="TEST 9: compile apparmor enabled"

# remove previous reports and output file
cleanup() {
	rm -f report*
	rm -fr firejail
	rm -f oc* om*
}

print_title() {
	echo
	echo
	echo
	echo "**************************************************"
	echo $1
	echo "**************************************************"
}

DIST="$1"
while [ $# -gt 0 ]; do    # Until you run out of parameters . . .
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
tar -xJvf ../../$DIST.tar.xz
mv $DIST firejail

cd firejail
./configure --prefix=/usr --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test1
grep Error output-configure output-make >> ./report-test1
cp output-configure oc1
cp output-make om1
rm output-configure output-make


#*****************************************************************
# TEST 2
#*****************************************************************
# - disable seccomp configuration
#*****************************************************************
print_title "${arr[2]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-seccomp  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test2
grep Error output-configure output-make >> ./report-test2
cp output-configure oc2
cp output-make om2
rm output-configure output-make

#*****************************************************************
# TEST 3
#*****************************************************************
# - disable user namespace configuration
#*****************************************************************
print_title "${arr[3]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-userns  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test3
grep Error output-configure output-make >> ./report-test3
cp output-configure oc3
cp output-make om3
rm output-configure output-make

#*****************************************************************
# TEST 4
#*****************************************************************
# - disable networking
#*****************************************************************
print_title "${arr[4]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-network  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test4
grep Error output-configure output-make >> ./report-test4
cp output-configure oc4
cp output-make om4
rm output-configure output-make


#*****************************************************************
# TEST 5
#*****************************************************************
# - disable whitelist
#*****************************************************************
print_title "${arr[10]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-whitelist  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test5
grep Error output-configure output-make >> ./report-test5
cp output-configure oc5
cp output-make om5
rm output-configure output-make

#*****************************************************************
# TEST 6
#*****************************************************************
# - disable global config
#*****************************************************************
print_title "${arr[6]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-globalcfg  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test6
grep Error output-configure output-make >> ./report-test6
cp output-configure oc6
cp output-make om6
rm output-configure output-make

#*****************************************************************
# TEST 7
#*****************************************************************
# - enable apparmor
#*****************************************************************
print_title "${arr[7]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --enable-apparmor  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test7
grep Error output-configure output-make >> ./report-test7
cp output-configure oc7
cp output-make om7
rm output-configure output-make

#*****************************************************************
# TEST 8
#*****************************************************************
# - enable busybox workaround
#*****************************************************************
print_title "${arr[8]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --enable-busybox-workaround --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test8
grep Error output-configure output-make >> ./report-test8
cp output-configure oc8
cp output-make om8
rm output-configure output-make

#*****************************************************************
# TEST 9
#*****************************************************************
# - enable apparmor
#*****************************************************************
print_title "${arr[9]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --enable-apparmor --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test9
grep Error output-configure output-make >> ./report-test9
cp output-configure oc9
cp output-make om9
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
echo  "Legend:"
echo ${arr[1]}
echo ${arr[2]}
echo ${arr[3]}
echo ${arr[4]}
echo ${arr[5]}
echo ${arr[6]}
echo ${arr[7]}
echo ${arr[8]}
echo ${arr[9]}
