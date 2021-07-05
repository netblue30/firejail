# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_da.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_da

mkdir ${HOME}/.tor-browser_da
allow  ${HOME}/.tor-browser_da

# Redirect
include torbrowser-launcher.profile
