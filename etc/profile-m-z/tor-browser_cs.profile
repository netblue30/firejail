# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_cs.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_cs

mkdir ${HOME}/.tor-browser_cs
allow  ${HOME}/.tor-browser_cs

# Redirect
include torbrowser-launcher.profile
