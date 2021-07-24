# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-fa.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-fa

mkdir ${HOME}/.tor-browser-fa
allow  ${HOME}/.tor-browser-fa

# Redirect
include torbrowser-launcher.profile
