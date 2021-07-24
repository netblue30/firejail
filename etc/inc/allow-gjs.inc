# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-gjs.local

nodeny  ${PATH}/gjs
nodeny  ${PATH}/gjs-console
nodeny  /usr/lib/gjs
nodeny  /usr/lib/libgjs*
nodeny  /usr/lib/libmozjs-*
nodeny  /usr/lib64/gjs
nodeny  /usr/lib64/libgjs*
nodeny  /usr/lib64/libmozjs-*
