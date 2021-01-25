# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-zh-tw.local

noblacklist ${HOME}/.tor-browser-zh-tw

mkdir ${HOME}/.tor-browser-zh-tw
whitelist ${HOME}/.tor-browser-zh-tw

# Redirect
include torbrowser-launcher.profile
