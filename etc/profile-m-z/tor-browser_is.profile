# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_is.local

noblacklist ${HOME}/.tor-browser_is

mkdir ${HOME}/.tor-browser_is
whitelist ${HOME}/.tor-browser_is

# Redirect
include torbrowser-launcher.profile
