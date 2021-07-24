# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-python3.local

nodeny  ${PATH}/python3*
nodeny  /usr/include/python3*
nodeny  /usr/lib/python3*
nodeny  /usr/lib64/python3*
nodeny  /usr/local/lib/python3*
nodeny  /usr/share/python3*
