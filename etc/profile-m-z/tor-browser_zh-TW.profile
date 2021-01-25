# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_zh-TW.local

noblacklist ${HOME}/.tor-browser_zh-TW

mkdir ${HOME}/.tor-browser_zh-TW
whitelist ${HOME}/.tor-browser_zh-TW

# Redirect
include torbrowser-launcher.profile
