# Firejail profile for dtui
# Description: TUI D-Bus debugger
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include dtui.local
# Persistent global definitions
include globals.local

private-bin dtui

memory-deny-write-execute

# Redirect
include dbus-debug-common.profile
