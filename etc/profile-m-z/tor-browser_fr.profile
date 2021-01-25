# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_fr.local

noblacklist ${HOME}/.tor-browser_fr

mkdir ${HOME}/.tor-browser_fr
whitelist ${HOME}/.tor-browser_fr

# Redirect
include torbrowser-launcher.profile
