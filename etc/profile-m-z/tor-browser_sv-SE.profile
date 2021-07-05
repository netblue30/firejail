# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_sv-SE.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_sv-SE

mkdir ${HOME}/.tor-browser_sv-SE
allow  ${HOME}/.tor-browser_sv-SE

# Redirect
include torbrowser-launcher.profile
