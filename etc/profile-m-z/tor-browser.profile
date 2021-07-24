# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser

mkdir ${HOME}/.tor-browser
allow  ${HOME}/.tor-browser

# Redirect
include torbrowser-launcher.profile
