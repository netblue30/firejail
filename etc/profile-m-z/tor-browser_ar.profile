# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_ar.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_ar

mkdir ${HOME}/.tor-browser_ar
allow  ${HOME}/.tor-browser_ar

# Redirect
include torbrowser-launcher.profile
