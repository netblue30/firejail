# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_ja.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_ja

mkdir ${HOME}/.tor-browser_ja
whitelist ${HOME}/.tor-browser_ja

# Redirect
include torbrowser-launcher.profile
