# Firejail profile alias for krita
# This file is overwritten after every install/update
# Persistent local customizations
include karbon.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.local/share/kxmlgui5/karbon

# Redirect
include krita.profile
