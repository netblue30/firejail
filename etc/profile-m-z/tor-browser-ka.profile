# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-ka.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-ka

mkdir ${HOME}/.tor-browser-ka
whitelist ${HOME}/.tor-browser-ka

# Redirect
include torbrowser-launcher.profile
