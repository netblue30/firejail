# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_ja.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_ja

mkdir ${HOME}/.tor-browser_ja
allow  ${HOME}/.tor-browser_ja

# Redirect
include torbrowser-launcher.profile
