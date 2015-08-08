#!/bin/bash

arr[1]="TEST 1: svn and standard compilation"
arr[2]="TEST 2: cppcheck"
arr[3]="TEST 3: compile seccomp disabled, chroot disabled, bind disabled"
arr[4]="TEST 4: rvtest"
arr[5]="TEST 5: expect test as root, no malloc perturb"
arr[6]="TEST 6: expect test as user, no malloc perturb"
arr[7]="TEST 7: expect test as root, malloc perturb"
arr[8]="TEST 8: expect test as user, malloc perturb"


# remove previous reports and output file
cleanup() {
	rm -f out-test
	rm -f output*
	rm -f report*
	rm -fr firejail-trunk
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
    	echo "./autotest.sh [--clean|--help]"
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
svn checkout svn://svn.code.sf.net/p/firejail/code-0/trunk firejail-trunk
cd firejail-trunk
./configure --prefix=/usr 2>&1 | tee ../output-configure
make -j4 2>&1 | tee ../output-make
sudo make install 2>&1 | tee ../output-install
cd src/tools
gcc -o rvtest rvtest.c
cd ../..
cd test
sudo ./configure > /dev/null
cd ../..
grep warning output-configure output-make output-install > ./report-test1
grep error output-configure output-make output-install >> ./report-test1
cat report-test1 > out-test1

#*****************************************************************
# TEST 2
#*****************************************************************
# - run cppcheck
#*****************************************************************
print_title "${arr[2]}"
cd firejail-trunk
cp /home/netblue/bin/cfg/std.cfg .
cppcheck --force . 2>&1 | tee ../output-cppcheck
cd ..
grep error output-cppcheck > report-test2
cat report-test2 > out-test2

#*****************************************************************
# TEST 3
#*****************************************************************
# - disable seccomp configuration
# - check compilation
#*****************************************************************
print_title "${arr[3]}"
# seccomp
cd firejail-trunk
make distclean
./configure --prefix=/usr --disable-seccomp 2>&1 | tee ../output-configure-noseccomp
make -j4 2>&1 | tee ../output-make-noseccomp
cd ..
grep warning output-configure-noseccomp output-make-noseccomp > ./report-test3
grep error output-configure-noseccomp output-make-noseccomp >> ./report-test3
# chroot
cd firejail-trunk
make distclean
./configure --prefix=/usr --disable-chroot 2>&1 | tee ../output-configure-nochroot
make -j4 2>&1 | tee ../output-make-nochroot
cd ..
grep warning output-configure-nochroot output-make-nochroot >> ./report-test3
grep error output-configure-nochroot output-make-nochroot >> ./report-test3
# bind
cd firejail-trunk
make distclean
./configure --prefix=/usr --disable-bind 2>&1 | tee ../output-configure-nobind
make -j4 2>&1 | tee ../output-make-nobind
cd ..
grep warning output-configure-nobind output-make-nobind >> ./report-test3
grep error output-configure-nobind output-make-nobind >> ./report-test3
# save result
cat report-test3 > out-test3

#*****************************************************************
# TEST 4
#*****************************************************************
# - rvtest
#*****************************************************************
print_title "${arr[4]}"
cd firejail-trunk
cd test
../src/tools/rvtest test.rv 2>/dev/null | tee ../../output-test4 | grep TESTING
cd ../..
grep TESTING output-test4 > ./report-test4
grep ERROR report-test4 > out-test4


#*****************************************************************
# TEST 5
#*****************************************************************
# - expect test as root, no malloc perturb
#*****************************************************************
print_title "${arr[5]}"
cd firejail-trunk/test
sudo ./test-root.sh 2>&1 | tee ../../output-test5 | grep TESTING
cd ../..
grep TESTING output-test5 > ./report-test5
grep ERROR report-test5 > out-test5

#*****************************************************************
# TEST 6
#*****************************************************************
# - expect test as user, no malloc perturb
#*****************************************************************
print_title "${arr[6]}"
cd firejail-trunk/test
./test.sh 2>&1 | tee ../../output-test6 | grep TESTING
cd ../..
grep TESTING output-test6 > ./report-test6
grep ERROR report-test6 > out-test6



#*****************************************************************
# TEST 7
#*****************************************************************
# - expect test as root, malloc perturb
#*****************************************************************
print_title "${arr[7]}"
export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
cd firejail-trunk/test
sudo ./test-root.sh 2>&1 | tee ../../output-test7 | grep TESTING
cd ../..
grep TESTING output-test7 > ./report-test7
grep ERROR report-test7 > out-test7

#*****************************************************************
# TEST 8
#*****************************************************************
# - expect test as user, malloc perturb
#*****************************************************************
print_title "${arr[8]}"
cd firejail-trunk/test
./test.sh 2>&1 | tee ../../output-test8| grep TESTING
cd ../..
grep TESTING output-test8 > ./report-test8
grep ERROR report-test8 > out-test8

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

wc -l out-test*
rm out-test*
echo




exit
