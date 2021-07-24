# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-en.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-en

mkdir ${HOME}/.tor-browser-en
allow  ${HOME}/.tor-browser-en

# Redirect
include torbrowser-launcher.profile
