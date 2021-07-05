# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_hu.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_hu

mkdir ${HOME}/.tor-browser_hu
allow  ${HOME}/.tor-browser_hu

# Redirect
include torbrowser-launcher.profile
