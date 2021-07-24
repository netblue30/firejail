# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-ko.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-ko

mkdir ${HOME}/.tor-browser-ko
allow  ${HOME}/.tor-browser-ko

# Redirect
include torbrowser-launcher.profile
