# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_id.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_id

mkdir ${HOME}/.tor-browser_id
allow  ${HOME}/.tor-browser_id

# Redirect
include torbrowser-launcher.profile
