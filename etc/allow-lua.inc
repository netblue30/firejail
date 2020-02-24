# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-lua.local

noblacklist ${PATH}/lua*
noblacklist /usr/include/lauxlib.h
noblacklist /usr/include/lua*
noblacklist /usr/lib/liblua*
noblacklist /usr/lib/lua
noblacklist /usr/share/lua
noblacklist /usr/share/lua*
