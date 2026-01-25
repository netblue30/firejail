#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

# not currently covered
#  --disable-suid          install as a non-SUID executable
#  --enable-fatal-warnings -W -Wall -Werror
#  --enable-gcov           Gcov instrumentation
#  --enable-contrib-install
#                          install contrib scripts
#  --enable-analyzer       enable GCC 10 static analyzer

# shellcheck source=config.sh
rm -fr firejail
. "$(dirname "$0")/../../config.sh" || exit 1

arr[1]="1: standard compilation"
arr[2]="2: compile --disable-dbusproxy"
arr[3]="3: compile --disable-chroot"
arr[4]="4: compile --disable-userns"
arr[5]="5: compile --disable-network"
arr[6]="6: compile --disable-x11"
arr[7]="7: compile --enable-selinux"
arr[8]="8: compile --disable-file-transfer"
arr[9]="9: compile --enable-apparmor"
arr[10]="10: compile --enable-busybox-workaround"
arr[11]="11: compile --disable-private-home"
arr[12]="12: compile --disable-sandbox-check"
arr[13]="13: compile --disable-landlock"
arr[14]="14: compile --disable-output"
arr[16]="16: compile --disable-private-lib"
arr[17]="17: compile --disable-suid"
arr[18]="18: compile --enable-contrib-install"
arr[19]="19: compile --enable-only-syscfg-profiles"
arr[20]="20: compile --enable-force-nonewprivs"

print_title() {
	echo
	echo
	echo
	echo "**************************************************"
	echo "TESTING $1"
	echo "**************************************************"
}

DIST="$TARNAME-$VERSION"
while [[ $# -gt 0 ]]; do    # Until you run out of parameters . . .
	case "$1" in
	--clean)
		rm -fr firejail
		exit
		;;
	--help)
		echo "./compile.sh [--clean|--help]"
		exit
		;;
	esac
	shift       # Check next set of parameters.
done

rm -fr firejail
echo "$DIST"
tar -xJvf ../../"$DIST.tar.xz"
mv "$DIST" firejail

#*****************************************************************
# TEST 1
#*****************************************************************
# - checkout source code
#*****************************************************************
print_title "${arr[1]}"
cd firejail || exit 1

./configure --enable-fatal-warnings 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 2
#*****************************************************************
# - disable dbus proxy configuration
#*****************************************************************
print_title "${arr[2]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-dbusproxy 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
cd ..

#*****************************************************************
# TEST 3
#*****************************************************************
# - disable chroot configuration
#*****************************************************************
print_title "${arr[3]}"
cd firejail || exit 1
make distclean

./configure --enable-fatal-warnings --disable-chroot 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 4
#*****************************************************************
# - disable user namespace configuration
#*****************************************************************
print_title "${arr[4]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-userns 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 5
#*****************************************************************
# - disable user namespace configuration
#*****************************************************************
print_title "${arr[5]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-network 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 6
#*****************************************************************
# - disable X11 support
#*****************************************************************
print_title "${arr[6]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-x11 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 7
#*****************************************************************
# - enable selinux
#*****************************************************************
print_title "${arr[7]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --enable-selinux 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 8
#*****************************************************************
# - disable file transfer
#*****************************************************************
print_title "${arr[8]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-file-transfer 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 9
#*****************************************************************
# - enable apparmor
#*****************************************************************
print_title "${arr[9]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --enable-apparmor 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 10
#*****************************************************************
# - enable busybox workaround
#*****************************************************************
print_title "${arr[10]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --enable-busybox-workaround 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 11
#*****************************************************************
# - disable private home
#*****************************************************************
print_title "${arr[11]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-private-home 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 12
#*****************************************************************
# - disable sandbox check
#*****************************************************************
print_title "${arr[12]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-sandbox-check 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 13
#*****************************************************************
# - disable landlock
#*****************************************************************
print_title "${arr[13]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-landlock 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 14
#*****************************************************************
# - disable --output logging
#*****************************************************************
print_title "${arr[14]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-output 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
cd ..

#*****************************************************************
# TEST 16
#*****************************************************************
# - disable private-lib
#*****************************************************************
print_title "${arr[16]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-private-lib 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 17
#*****************************************************************
# - disable suid
#*****************************************************************
print_title "${arr[17]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --disable-suid 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 18
#*****************************************************************
# - enable contrib install
#*****************************************************************
print_title "${arr[18]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --enable-contrib-install 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 19
#*****************************************************************
# --enable-only-syscfg-profile
#*****************************************************************
print_title "${arr[19]}"
cd firejail || exit 1

./configure --enable-fatal-warnings --enable-only-syscfg-profiles 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..

#*****************************************************************
# TEST 20
#*****************************************************************
# - enable force nonewprivs
#*****************************************************************
print_title "${arr[20]}"
cd firejail || exit 1

./configure --enable-fatal-warnings  --enable-force-nonewprivs 2>&1 | tee output
if grep -E '(WARNING|ERROR)' output; then
    echo "TESTING ERROR";
    exit 1
fi

make -j4 2>&1 | tee output
if grep -E -i 'error:' output; then
    echo "TESTING ERROR";
    exit 1
fi
make distclean
cd ..


#*****************************************************************
# cleanup
#*****************************************************************
rm -fr firejail
