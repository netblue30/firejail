# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_es.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_es

mkdir ${HOME}/.tor-browser_es
allow  ${HOME}/.tor-browser_es

# Redirect
include torbrowser-launcher.profile
