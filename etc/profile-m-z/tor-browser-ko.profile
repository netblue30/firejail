# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-ko.local

noblacklist ${HOME}/.tor-browser-ko

mkdir ${HOME}/.tor-browser-ko
whitelist ${HOME}/.tor-browser-ko

# Redirect
include torbrowser-launcher.profile
