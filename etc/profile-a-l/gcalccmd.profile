# Firejail profile for gcalccmd
# Description: GNOME console calculator
# This file is overwritten after every install/update
# Persistent local customizations
include gcalccmd.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin gcalccmd

# Redirect
include gnome-calculator.profile
