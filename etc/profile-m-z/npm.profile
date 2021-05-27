# Firejail profile for npm
# Description: The Node.js Package Manager
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include npm.local
# Persistent global definitions
include globals.local

# Redirect
include nodejs-common.profile
