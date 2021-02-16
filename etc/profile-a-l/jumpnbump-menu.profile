# Firejail profile for jumpnbump-menu
# Description: Level selection and config menu for the Jump 'n Bump game
# This file is overwritten after every install/update
# Persistent local customizations
include jumpnbump-menu.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

private-bin jumpnbump-menu,python3*

# Redirect
include jumpnbump.profile
