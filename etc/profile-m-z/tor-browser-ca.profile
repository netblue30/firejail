# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-ca.local

noblacklist ${HOME}/.tor-browser-ca

mkdir ${HOME}/.tor-browser-ca
whitelist ${HOME}/.tor-browser-ca

# Redirect
include torbrowser-launcher.profile
