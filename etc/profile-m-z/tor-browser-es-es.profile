# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-es-es.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-es-es

mkdir ${HOME}/.tor-browser-es-es
whitelist ${HOME}/.tor-browser-es-es

# Redirect
include torbrowser-launcher.profile
