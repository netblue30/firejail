# Firejail profile alias for Visual Studio Code
# This file is overwritten after every install/update
# Persistent local customizations
include vscodium.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.VSCodium

# Redirect
include code.profile
