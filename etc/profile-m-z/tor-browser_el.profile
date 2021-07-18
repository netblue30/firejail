# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_el.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_el

mkdir ${HOME}/.tor-browser_el
whitelist ${HOME}/.tor-browser_el

# Redirect
include torbrowser-launcher.profile
