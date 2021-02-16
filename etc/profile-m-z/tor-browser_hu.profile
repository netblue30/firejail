# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_hu.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_hu

mkdir ${HOME}/.tor-browser_hu
whitelist ${HOME}/.tor-browser_hu

# Redirect
include torbrowser-launcher.profile
