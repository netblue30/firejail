# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_de.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_de

mkdir ${HOME}/.tor-browser_de
whitelist ${HOME}/.tor-browser_de

# Redirect
include torbrowser-launcher.profile
