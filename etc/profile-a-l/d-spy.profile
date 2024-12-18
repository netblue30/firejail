# Firejail profile for d-spy
# Description: D-Bus debugger for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include d-spy.local
# Persistent global definitions
include globals.local

private-bin d-spy

# Redirect
include dbus-debug-common.profile
