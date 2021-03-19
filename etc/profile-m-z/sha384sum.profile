# Firejail profile for sha384sum
# Description: compute and check SHA384 message digest
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include sha384sum.local
# Persistent global definitions
include globals.local

private-bin sha384sum

# Redirect
include hasher-common.profile
