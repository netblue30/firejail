# Firejail profile for gnome-system-log
# Description: View your system logs
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-system-log.local
# Persistent global definitions
include globals.local

# 'net none' breaks dbus
ignore net none

private-bin gnome-system-log
private-lib

memory-deny-write-execute

# Redirect
include system-log-common.profile
