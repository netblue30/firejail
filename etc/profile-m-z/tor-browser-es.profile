# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-es.local

noblacklist ${HOME}/.tor-browser-es

mkdir ${HOME}/.tor-browser-es
whitelist ${HOME}/.tor-browser-es

# Redirect
include torbrowser-launcher.profile
