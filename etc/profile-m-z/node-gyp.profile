# Firejail profile for node-gyp
# Description: Node.js native addon build tool
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include node-gyp.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

# Redirect
include nodejs-common.profile
