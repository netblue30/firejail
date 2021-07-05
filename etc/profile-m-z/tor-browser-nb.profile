# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-nb.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-nb

mkdir ${HOME}/.tor-browser-nb
allow  ${HOME}/.tor-browser-nb

# Redirect
include torbrowser-launcher.profile
