# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-nl.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-nl

mkdir ${HOME}/.tor-browser-nl
whitelist ${HOME}/.tor-browser-nl

# Redirect
include torbrowser-launcher.profile
