# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-is.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-is

mkdir ${HOME}/.tor-browser-is
allow  ${HOME}/.tor-browser-is

# Redirect
include torbrowser-launcher.profile
