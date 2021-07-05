# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_nb.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_nb

mkdir ${HOME}/.tor-browser_nb
allow  ${HOME}/.tor-browser_nb

# Redirect
include torbrowser-launcher.profile
