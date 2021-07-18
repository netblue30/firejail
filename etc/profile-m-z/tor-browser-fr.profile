# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-fr.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-fr

mkdir ${HOME}/.tor-browser-fr
whitelist ${HOME}/.tor-browser-fr

# Redirect
include torbrowser-launcher.profile
