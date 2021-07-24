# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_tr.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_tr

mkdir ${HOME}/.tor-browser_tr
allow  ${HOME}/.tor-browser_tr

# Redirect
include torbrowser-launcher.profile
