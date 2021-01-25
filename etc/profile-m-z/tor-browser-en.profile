# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-en.local

noblacklist ${HOME}/.tor-browser-en

mkdir ${HOME}/.tor-browser-en
whitelist ${HOME}/.tor-browser-en

# Redirect
include torbrowser-launcher.profile
