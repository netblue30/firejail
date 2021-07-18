# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_en-US.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_en-US

mkdir ${HOME}/.tor-browser_en-US
whitelist ${HOME}/.tor-browser_en-US

# Redirect
include torbrowser-launcher.profile
