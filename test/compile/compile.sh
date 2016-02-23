#!/bin/bash

arr[1]="TEST 1: standard compilation"
arr[2]="TEST 2: compile seccomp disabled"
arr[3]="TEST 3: compile chroot disabled"
arr[4]="TEST 4: compile bind disabled"
arr[5]="TEST 5: compile user namespace disabled"
arr[6]="TEST 6: compile network disabled"
arr[7]="TEST 7: compile X11 disabled"


# remove previous reports and output file
cleanup() {
	rm -f report*
	rm -fr firejail
}

print_title() {
	echo
	echo
	echo
	echo "**************************************************"
	echo $1
	echo "**************************************************"
}

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
# enable sudo
sudo ls -al


#*****************************************************************
# TEST 1
#*****************************************************************
# - checkout source code
# - check compilation
# - install
#*****************************************************************
print_title "${arr[1]}"
git clone https://github.com/netblue30/firejail.git
cd firejail
./configure --prefix=/usr --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
sudo make install 2>&1 | tee ../output-install
cd ..
grep Warning output-configure output-make output-install > ./report-test1
grep Error output-configure output-make output-install >> ./report-test1
rm output-configure output-make output-install


#*****************************************************************
# TEST 2
#*****************************************************************
# - disable seccomp configuration
# - check compilation
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
rm output-configure output-make

#*****************************************************************
# TEST 3
#*****************************************************************
# - disable chroot configuration
# - check compilation
#*****************************************************************
print_title "${arr[3]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-chroot  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test3
grep Error output-configure output-make >> ./report-test3
rm output-configure output-make

#*****************************************************************
# TEST 4
#*****************************************************************
# - disable bind configuration
# - check compilation
#*****************************************************************
print_title "${arr[4]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-bind  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test4
grep Error output-configure output-make >> ./report-test4
rm output-configure output-make

#*****************************************************************
# TEST 5
#*****************************************************************
# - disable user namespace configuration
# - check compilation
#*****************************************************************
print_title "${arr[5]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-userns  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test5
grep Error output-configure output-make >> ./report-test5
rm output-configure output-make

#*****************************************************************
# TEST 6
#*****************************************************************
# - disable user namespace configuration
# - check compilation
#*****************************************************************
print_title "${arr[6]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-network  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test6
grep Error output-configure output-make >> ./report-test6
rm output-configure output-make

#*****************************************************************
# TEST 7
#*****************************************************************
# - disable X11 support
# - check compilation
#*****************************************************************
print_title "${arr[6]}"
# seccomp
cd firejail
make distclean
./configure --prefix=/usr --disable-x11  --enable-fatal-warnings 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
cd ..
grep Warning output-configure output-make > ./report-test7
grep Error output-configure output-make >> ./report-test7
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
