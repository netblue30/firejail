# Firejail profile for pnpm
# Description: Fast, disk space efficient package manager
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include pnpm.local
# Persistent global definitions
include globals.local

# Redirect
include nodejs-common.profile
