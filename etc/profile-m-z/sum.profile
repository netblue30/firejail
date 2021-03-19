# Firejail profile for sum
# Description: checksum and count the blocks in a file
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include sum.local
# Persistent global definitions
include globals.local

private-bin sum

# Redirect
include hasher-common.profile
