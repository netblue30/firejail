# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_pl.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_pl

mkdir ${HOME}/.tor-browser_pl
whitelist ${HOME}/.tor-browser_pl

# Redirect
include torbrowser-launcher.profile
