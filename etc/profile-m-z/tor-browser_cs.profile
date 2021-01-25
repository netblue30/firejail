# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_cs.local

noblacklist ${HOME}/.tor-browser_cs

mkdir ${HOME}/.tor-browser_cs
whitelist ${HOME}/.tor-browser_cs

# Redirect
include torbrowser-launcher.profile
