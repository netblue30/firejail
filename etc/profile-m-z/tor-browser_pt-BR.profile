# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_pt-BR.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_pt-BR

mkdir ${HOME}/.tor-browser_pt-BR
allow  ${HOME}/.tor-browser_pt-BR

# Redirect
include torbrowser-launcher.profile
