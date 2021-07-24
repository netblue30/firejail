# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_ko.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_ko

mkdir ${HOME}/.tor-browser_ko
allow  ${HOME}/.tor-browser_ko

# Redirect
include torbrowser-launcher.profile
