# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-id.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-id

mkdir ${HOME}/.tor-browser-id
allow  ${HOME}/.tor-browser-id

# Redirect
include torbrowser-launcher.profile
