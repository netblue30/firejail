# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_fr.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_fr

mkdir ${HOME}/.tor-browser_fr
allow  ${HOME}/.tor-browser_fr

# Redirect
include torbrowser-launcher.profile
