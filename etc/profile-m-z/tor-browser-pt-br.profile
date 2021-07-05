# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-pt-br.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-pt-br

mkdir ${HOME}/.tor-browser-pt-br
allow  ${HOME}/.tor-browser-pt-br

# Redirect
include torbrowser-launcher.profile
