# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-zh-tw.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-zh-tw

mkdir ${HOME}/.tor-browser-zh-tw
whitelist ${HOME}/.tor-browser-zh-tw

# Redirect
include torbrowser-launcher.profile
