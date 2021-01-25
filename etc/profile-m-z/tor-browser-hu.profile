# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-hu.local

noblacklist ${HOME}/.tor-browser-hu

mkdir ${HOME}/.tor-browser-hu
whitelist ${HOME}/.tor-browser-hu

# Redirect
include torbrowser-launcher.profile
