# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-lua.local

noblacklist ${PATH}/lua*
noblacklist /usr/include/lua*
noblacklist /usr/lib/lua
noblacklist /usr/share/lua
