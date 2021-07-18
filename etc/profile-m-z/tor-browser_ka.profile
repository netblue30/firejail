# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_ka.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_ka

mkdir ${HOME}/.tor-browser_ka
whitelist ${HOME}/.tor-browser_ka

# Redirect
include torbrowser-launcher.profile
