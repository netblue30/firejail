# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-it.local

noblacklist ${HOME}/.tor-browser-it

mkdir ${HOME}/.tor-browser-it
whitelist ${HOME}/.tor-browser-it

# Redirect
include torbrowser-launcher.profile
