# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_ga-IE.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_ga-IE

mkdir ${HOME}/.tor-browser_ga-IE
allow  ${HOME}/.tor-browser_ga-IE

# Redirect
include torbrowser-launcher.profile
