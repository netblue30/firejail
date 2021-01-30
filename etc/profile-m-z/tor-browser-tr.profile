# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-tr.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-tr

mkdir ${HOME}/.tor-browser-tr
whitelist ${HOME}/.tor-browser-tr

# Redirect
include torbrowser-launcher.profile
