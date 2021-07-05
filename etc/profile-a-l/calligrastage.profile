# Firejail profile alias for calligra
# This file is overwritten after every install/update
# Persistent local customizations
include calligrastage.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.local/share/kxmlgui5/calligrastage

# Redirect
include calligra.profile
