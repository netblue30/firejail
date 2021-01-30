# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-ar.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-ar

mkdir ${HOME}/.tor-browser-ar
whitelist ${HOME}/.tor-browser-ar

# Redirect
include torbrowser-launcher.profile
