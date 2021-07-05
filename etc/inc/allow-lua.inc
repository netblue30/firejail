# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-lua.local

nodeny  ${PATH}/lua*
nodeny  /usr/include
nodeny  /usr/lib/liblua*
nodeny  /usr/lib/lua
nodeny  /usr/lib64/liblua*
nodeny  /usr/lib64/lua
nodeny  /usr/share/lua
nodeny  /usr/share/lua*
