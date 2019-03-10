# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-zh-tw

mkdir ${HOME}/.tor-browser-zh-tw
whitelist ${HOME}/.tor-browser-zh-tw

# Redirect
include torbrowser-launcher.profile
