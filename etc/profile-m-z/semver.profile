# Firejail profile for semver
# Description: Part of the Node.js stack
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include semver.local
# Persistent global definitions
include globals.local

# Redirect
include nodejs-common.profile
