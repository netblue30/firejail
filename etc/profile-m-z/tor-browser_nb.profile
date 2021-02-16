# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_nb.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_nb

mkdir ${HOME}/.tor-browser_nb
whitelist ${HOME}/.tor-browser_nb

# Redirect
include torbrowser-launcher.profile
