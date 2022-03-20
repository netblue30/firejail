# Firejail profile for npx
# Description: Part of the Node.js stack
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include npx.local
# Persistent global definitions
include globals.local

# Redirect
include nodejs-common.profile
