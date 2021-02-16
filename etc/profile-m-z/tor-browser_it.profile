# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_it.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_it

mkdir ${HOME}/.tor-browser_it
whitelist ${HOME}/.tor-browser_it

# Redirect
include torbrowser-launcher.profile
