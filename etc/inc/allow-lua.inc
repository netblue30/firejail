# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-lua.local

noblacklist ${PATH}/lua*
noblacklist /usr/include
noblacklist /usr/lib/liblua*
noblacklist /usr/lib/lua
noblacklist /usr/lib64/liblua*
noblacklist /usr/lib64/lua
noblacklist /usr/share/lua*
