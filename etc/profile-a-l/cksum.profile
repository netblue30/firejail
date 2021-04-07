# Firejail profile for cksum
# Description: checksum and count the bytes in a file
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cksum.local
# Persistent global definitions
include globals.local

private-bin cksum

# Redirect
include hasher-common.profile
