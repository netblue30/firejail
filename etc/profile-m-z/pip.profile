# Firejail profile for pip
# Description: package manager for Python packages
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include meson.local
# Persistent global definitions
include globals.local

ignore read-only ${HOME}/.local/lib

# Allow python3 (blacklisted by disable-interpreters.inc)
include allow-python3.inc

#whitelist ${HOME}/.local/lib/python*

private-bin pip,pip[0-9].[0-9],pip[0-9].[0-9],python3*

# Redirect
include build-systems-common.profile
