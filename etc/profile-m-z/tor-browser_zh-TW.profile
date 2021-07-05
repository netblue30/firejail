# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_zh-TW.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser_zh-TW

mkdir ${HOME}/.tor-browser_zh-TW
allow  ${HOME}/.tor-browser_zh-TW

# Redirect
include torbrowser-launcher.profile
