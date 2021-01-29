# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-en-us.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-en-us

mkdir ${HOME}/.tor-browser-en-us
whitelist ${HOME}/.tor-browser-en-us

# Redirect
include torbrowser-launcher.profile
