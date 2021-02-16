# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-da.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-da

mkdir ${HOME}/.tor-browser-da
whitelist ${HOME}/.tor-browser-da

# Redirect
include torbrowser-launcher.profile
