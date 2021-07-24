# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-el.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-el

mkdir ${HOME}/.tor-browser-el
allow  ${HOME}/.tor-browser-el

# Redirect
include torbrowser-launcher.profile
