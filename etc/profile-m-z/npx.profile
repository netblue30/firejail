# Firejail profile for npx
# Description: Execute npm package binaries
quiet
# Persistent local customizations
include npx.local
# Persistent global definitions
include globals.local

# Redirect
include nodejs-common.profile
