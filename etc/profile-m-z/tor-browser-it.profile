# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-it.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-it

mkdir ${HOME}/.tor-browser-it
allow  ${HOME}/.tor-browser-it

# Redirect
include torbrowser-launcher.profile
