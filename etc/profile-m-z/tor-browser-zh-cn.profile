# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-zh-cn.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser-zh-cn

mkdir ${HOME}/.tor-browser-zh-cn
allow  ${HOME}/.tor-browser-zh-cn

# Redirect
include torbrowser-launcher.profile
