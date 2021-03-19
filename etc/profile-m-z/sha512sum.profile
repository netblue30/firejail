# Firejail profile for sha512sum
# Description: compute and check SHA512 message digest
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include sha512sum.local
# Persistent global definitions
include globals.local

private-bin sha512sum

# Redirect
include hasher-common.profile
