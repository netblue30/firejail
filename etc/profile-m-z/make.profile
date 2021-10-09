# Firejail profile for make
# Description: GNU make utility to maintain groups of programs
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include make.local
# Persistent global definitions
include globals.local

memory-deny-write-execute

# Redirect
include build-systems-common.profile
