# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-cs.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-cs

mkdir ${HOME}/.tor-browser-cs
allow  ${HOME}/.tor-browser-cs

# Redirect
include torbrowser-launcher.profile
