# This script counts the number of lines of code throughout the
# project. We let gcc determine what is executable and what is not.
#
# Install gcov (Debian)
#     $ sudo apt install gcovr
# Clean firejail directory
#     $ cd firejail
#     $ make distclean
# Enable gcov instrumentation
#     $ ./configure --enable-gcov --enable-apparmor
#     $ make
# Don't install the new firejail, just run this script
#     $ ./linecnt.sh
#     firejail       13321
#     firemon        1143
#     firecfg        624
#     jailcheck      448
#     -------------------------------
#     fbuilder       712
#     fbwrap         62
#     fcopy          299
#     fnet           615
#     fnetfilter     89
#     fnetlock       229
#     fnettrace      803
#     fnettrace-dns  113
#     fnettrace-icmp 95
#     fnettrace-sni  109
#     fsec-optimize  116
#     fsec-print     205
#     ftee           135
#     fzenity        122
#     lib            975

#!/bin/bash

printf "firejail       " && gcovr src/firejail 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "firemon        " && gcovr src/firemon 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "firecfg        " && gcovr src/firecfg 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "jailcheck      " && gcovr src/jailcheck 2>/dev/null | grep TOTAL | awk '{print msg $2}'
echo "-------------------------------"
printf "fbuilder       " && gcovr src/fbuilder 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fbwrap         " && gcovr src/fbwrap 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fcopy          " && gcovr src/fcopy 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fnet           " && gcovr src/fnet 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fnetfilter     " && gcovr src/fnetfilter 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fnetlock       " && gcovr src/fnetlock 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fnettrace      " && gcovr src/fnettrace 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fnettrace-dns  " && gcovr src/fnettrace-dns 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fnettrace-icmp " && gcovr src/fnettrace-icmp 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fnettrace-sni  " && gcovr src/fnettrace-sni 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fsec-optimize  " && gcovr src/fsec-optimize 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fsec-print     " && gcovr src/fsec-print 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "ftee           " && gcovr src/ftee 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "fzenity        " && gcovr src/fzenity 2>/dev/null | grep TOTAL | awk '{print msg $2}'
printf "lib            " && gcovr src/lib 2>/dev/null | grep TOTAL | awk '{print msg $2}'
