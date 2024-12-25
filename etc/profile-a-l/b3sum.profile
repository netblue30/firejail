# Firejail profile for b3sum
# Description: compute and check BLAKE3 message digest
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include b3sum.local
# Persistent global definitions
include globals.local

private-bin b3sum

# Redirect
include hasher-common.profile
