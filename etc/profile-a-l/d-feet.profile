# Firejail profile for d-feet
# Description: D-Bus debugger for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include d-feet.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/d-feet

# Allow python (disabled by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

mkdir ${HOME}/.config/d-feet
whitelist ${HOME}/.config/d-feet
whitelist /usr/share/d-feet

# breaks on Ubuntu
ignore net none

private-bin d-feet,python*

#memory-deny-write-execute # breaks on Arch (see issue #1803)

# Redirect
include dbus-debug-common.profile
