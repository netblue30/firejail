# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-ga-ie.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-ga-ie

mkdir ${HOME}/.tor-browser-ga-ie
allow  ${HOME}/.tor-browser-ga-ie

# Redirect
include torbrowser-launcher.profile
