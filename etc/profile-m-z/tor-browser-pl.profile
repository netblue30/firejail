# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-pl.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-pl

mkdir ${HOME}/.tor-browser-pl
whitelist ${HOME}/.tor-browser-pl

# Redirect
include torbrowser-launcher.profile
