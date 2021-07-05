# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-de.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-de

mkdir ${HOME}/.tor-browser-de
allow  ${HOME}/.tor-browser-de

# Redirect
include torbrowser-launcher.profile
