# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-el.local

noblacklist ${HOME}/.tor-browser-el

mkdir ${HOME}/.tor-browser-el
whitelist ${HOME}/.tor-browser-el

# Redirect
include torbrowser-launcher.profile
