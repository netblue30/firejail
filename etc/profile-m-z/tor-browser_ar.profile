# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_ar.local

noblacklist ${HOME}/.tor-browser_ar

mkdir ${HOME}/.tor-browser_ar
whitelist ${HOME}/.tor-browser_ar

# Redirect
include torbrowser-launcher.profile
