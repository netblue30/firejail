# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_el.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_el

mkdir ${HOME}/.tor-browser_el
allow  ${HOME}/.tor-browser_el

# Redirect
include torbrowser-launcher.profile
