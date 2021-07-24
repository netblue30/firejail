# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_fa.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_fa

mkdir ${HOME}/.tor-browser_fa
allow  ${HOME}/.tor-browser_fa

# Redirect
include torbrowser-launcher.profile
