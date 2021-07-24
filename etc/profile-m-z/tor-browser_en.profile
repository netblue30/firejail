# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_en.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_en

mkdir ${HOME}/.tor-browser_en
allow  ${HOME}/.tor-browser_en

# Redirect
include torbrowser-launcher.profile
