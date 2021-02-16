# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-sv-se.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-sv-se

mkdir ${HOME}/.tor-browser-sv-se
whitelist ${HOME}/.tor-browser-sv-se

# Redirect
include torbrowser-launcher.profile
