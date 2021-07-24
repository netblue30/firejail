# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-ar.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-ar

mkdir ${HOME}/.tor-browser-ar
allow  ${HOME}/.tor-browser-ar

# Redirect
include torbrowser-launcher.profile
