# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-pl.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-pl

mkdir ${HOME}/.tor-browser-pl
allow  ${HOME}/.tor-browser-pl

# Redirect
include torbrowser-launcher.profile
