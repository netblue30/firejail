# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-fa.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-fa

mkdir ${HOME}/.tor-browser-fa
whitelist ${HOME}/.tor-browser-fa

# Redirect
include torbrowser-launcher.profile
