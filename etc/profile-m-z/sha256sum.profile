# Firejail profile for sha256sum
# Description: compute and check SHA256 message digest
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include sha256sum.local
# Persistent global definitions
include globals.local

private-bin sha256sum

# Redirect
include hasher-common.profile
