# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_nl.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_nl

mkdir ${HOME}/.tor-browser_nl
whitelist ${HOME}/.tor-browser_nl

# Redirect
include torbrowser-launcher.profile
