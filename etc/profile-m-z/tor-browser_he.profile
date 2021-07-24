# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_he.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_he

mkdir ${HOME}/.tor-browser_he
allow  ${HOME}/.tor-browser_he

# Redirect
include torbrowser-launcher.profile
