# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_ca.local

noblacklist ${HOME}/.tor-browser_ca

mkdir ${HOME}/.tor-browser_ca
whitelist ${HOME}/.tor-browser_ca

# Redirect
include torbrowser-launcher.profile
