# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-en-us.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-en-us

mkdir ${HOME}/.tor-browser-en-us
allow  ${HOME}/.tor-browser-en-us

# Redirect
include torbrowser-launcher.profile
