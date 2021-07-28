# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_sv-SE.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_sv-SE

mkdir ${HOME}/.tor-browser_sv-SE
whitelist ${HOME}/.tor-browser_sv-SE

# Redirect
include torbrowser-launcher.profile
