# Firejail profile for meson
# Description: A high productivity build system
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include meson.local
# Persistent global definitions
include globals.local

# Allow python3 (blacklisted by disable-interpreters.inc)
include allow-python3.inc

private-bin meson,python3*

# Redirect
include build-systems-common.profile
