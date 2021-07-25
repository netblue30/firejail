# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser_zh-CN.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser_zh-CN

mkdir ${HOME}/.tor-browser_zh-CN
whitelist ${HOME}/.tor-browser_zh-CN

# Redirect
include torbrowser-launcher.profile
