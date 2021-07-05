# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-hu.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-hu

mkdir ${HOME}/.tor-browser-hu
allow  ${HOME}/.tor-browser-hu

# Redirect
include torbrowser-launcher.profile
