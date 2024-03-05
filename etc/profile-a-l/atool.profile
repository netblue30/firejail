# Firejail profile for atool
# Description: Tool for managing file archives of various types
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include atool.local
# Persistent global definitions
include globals.local

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

noroot

private-tmp

# Redirect
include archiver-common.profile
