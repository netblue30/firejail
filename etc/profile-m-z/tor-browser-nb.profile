# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-nb.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-nb

mkdir ${HOME}/.tor-browser-nb
whitelist ${HOME}/.tor-browser-nb

# Redirect
include torbrowser-launcher.profile
