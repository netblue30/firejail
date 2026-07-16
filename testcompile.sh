#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

# A simple script testing all compile-time config options.

# shellcheck source=config.sh


#*****************************************************************
printf "default" > testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - default";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - standard compile";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "disable dbus proxy configuration" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --disable-dbusproxy 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR -  disable dbus proxy";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR -  disable dbus proxy";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "disable chroot configuration" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --enable-chroot 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - enable chroot";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - enable chroot";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "disable user namespace configuration" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --disable-userns 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable user namespace";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable user namespace";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "disable network namespace configuration" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --disable-network 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable network namespace";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable network namespace";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "disable X11 support" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --disable-x11 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable X11 support";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable X11 support";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "enable selinux" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --enable-selinux 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - enable selinux";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - enable selinux";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "disable file transfer" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --disable-file-transfer 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable file transfer";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable file transfer";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "enable apparmor" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --enable-apparmor 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - enable apparmor";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - enable apparmor";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "disable landlock" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --disable-landlock 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable landlock";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable landlock";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "disable output logging" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --disable-output 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable output logging";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable output logging";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "disable private-lib" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --disable-private-lib 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable private-lib";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - disable private-lib";
    exit 1
fi
echo " ...OK" >> testcompile.result


#*****************************************************************
printf "enable-only-syscfg-profile" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings --enable-only-syscfg-profiles 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR --enable-only-syscfg-profile";
    exit 1
fi

make 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR --enable-only-syscfg-profile";
    exit 1
fi
echo " ...OK" >> testcompile.result

#*****************************************************************
printf "enable force nonewprivs" >> testcompile.result
#*****************************************************************
make distclean

./configure --enable-fatal-warnings  --enable-force-nonewprivs 2>&1 | tee /tmp/testcompile-output
if grep -E '(WARNING|ERROR)' /tmp/testcompile-output; then
    echo "TESTING ERROR - enable force nonewprivs";
    exit 1
fi

make -j4 2>&1 | tee /tmp/testcompile-output
if grep -E -i 'error:' /tmp/testcompile-output; then
    echo "TESTING ERROR - enable force nonewprivs";
    exit 1
fi
echo " ...OK" >> testcompile.result


#*****************************************************************
echo "cleanup" >> testcompile.result
#*****************************************************************
make distclean
rm /tmp/testcompile-output
echo "*******************************************"
echo "All fine!!!" >> testcompile.result
cat testcompile.result



