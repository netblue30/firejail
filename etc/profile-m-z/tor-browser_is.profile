# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_is.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_is

mkdir ${HOME}/.tor-browser_is
whitelist ${HOME}/.tor-browser_is

# Redirect
include torbrowser-launcher.profile
