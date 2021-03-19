# Firejail profile for md5sum
# Description: compute and check MD5 message digest
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include md5sum.local
# Persistent global definitions
include globals.local

private-bin md5sum

# Redirect
include hasher-common.profile
