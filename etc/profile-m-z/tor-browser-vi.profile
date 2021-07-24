# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-vi.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-vi

mkdir ${HOME}/.tor-browser-vi
allow  ${HOME}/.tor-browser-vi

# Redirect
include torbrowser-launcher.profile
