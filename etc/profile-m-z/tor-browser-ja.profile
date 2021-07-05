# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-ja.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-ja

mkdir ${HOME}/.tor-browser-ja
allow  ${HOME}/.tor-browser-ja

# Redirect
include torbrowser-launcher.profile
