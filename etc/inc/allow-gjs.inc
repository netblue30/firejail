# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-gjs.local

noblacklist ${PATH}/gjs
noblacklist ${PATH}/gjs-console
noblacklist /usr/lib/gjs
noblacklist /usr/lib/libgjs*
noblacklist /usr/lib/libmozjs-*
noblacklist /usr/lib64/gjs
noblacklist /usr/lib64/libgjs*
noblacklist /usr/lib64/libmozjs-*
