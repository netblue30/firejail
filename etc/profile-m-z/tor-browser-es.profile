# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-es.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-es

mkdir ${HOME}/.tor-browser-es
allow  ${HOME}/.tor-browser-es

# Redirect
include torbrowser-launcher.profile
