# Firejail profile for nvm
# Description: Node Version Manager - Simple bash script to manage multiple active node.js versions
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include nvm.local
# Persistent global definitions
include globals.local

ignore noroot

# Redirect
include nodejs-common.profile
