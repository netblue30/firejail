# Firejail profile for sha1sum
# Description: compute and check SHA1 message digest
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include sha1sum.local
# Persistent global definitions
include globals.local

private-bin sha1sum

# Redirect
include hasher-common.profile
