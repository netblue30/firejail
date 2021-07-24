# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_es-ES.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_es-ES

mkdir ${HOME}/.tor-browser_es-ES
allow  ${HOME}/.tor-browser_es-ES

# Redirect
include torbrowser-launcher.profile
