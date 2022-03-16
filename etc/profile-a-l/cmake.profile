# Firejail profile for cmake
# Description: A cross-platform open-source make system
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cmake.local
# Persistent global definitions
include globals.local

whitelist /usr/share/cmake
whitelist /usr/share/cmake-*

memory-deny-write-execute

# Redirect
include build-systems-common.profile
