# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-cs.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-cs

mkdir ${HOME}/.tor-browser-cs
whitelist ${HOME}/.tor-browser-cs

# Redirect
include torbrowser-launcher.profile
