# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-nodejs.local

ignore read-only ${HOME}/.nvm
noblacklist ${HOME}/.nvm
noblacklist ${PATH}/node
noblacklist /usr/include/node

# Allow python for node-gyp (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc
