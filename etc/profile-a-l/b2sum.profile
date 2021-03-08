# Firejail profile for b2sum
# Description: compute and check BLAKE2 message digest
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include b2sum.local
# Persistent global definitions
include globals.local

private-bin b2sum

# Redirect
include hasher-common.profile
