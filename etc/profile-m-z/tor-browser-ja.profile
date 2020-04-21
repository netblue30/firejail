# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-ja

mkdir ${HOME}/.tor-browser-ja
whitelist ${HOME}/.tor-browser-ja

# Redirect
include torbrowser-launcher.profile
