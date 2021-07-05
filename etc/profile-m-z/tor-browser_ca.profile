# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_ca.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_ca

mkdir ${HOME}/.tor-browser_ca
allow  ${HOME}/.tor-browser_ca

# Redirect
include torbrowser-launcher.profile
