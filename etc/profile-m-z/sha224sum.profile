# Firejail profile for sha224sum
# Description: compute and check SHA224 message digest
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include sha224sum.local
# Persistent global definitions
include globals.local

private-bin sha224sum

# Redirect
include hasher-common.profile
