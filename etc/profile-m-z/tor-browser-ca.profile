# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-ca.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-ca

mkdir ${HOME}/.tor-browser-ca
whitelist ${HOME}/.tor-browser-ca

# Redirect
include torbrowser-launcher.profile
