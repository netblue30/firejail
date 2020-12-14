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
ignore include disable-devel.inc
ignore include disable-shell.inc
include archiver-common.inc

noroot

# private-bin atool,perl
# without login.defs atool complains and uses UID/GID 1000 by default
private-etc alternatives,group,login.defs,passwd
private-tmp
