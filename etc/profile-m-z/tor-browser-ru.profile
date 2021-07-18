# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-ru.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-ru

mkdir ${HOME}/.tor-browser-ru
whitelist ${HOME}/.tor-browser-ru

# Redirect
include torbrowser-launcher.profile
