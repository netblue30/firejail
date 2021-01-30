# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_fa.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_fa

mkdir ${HOME}/.tor-browser_fa
whitelist ${HOME}/.tor-browser_fa

# Redirect
include torbrowser-launcher.profile
