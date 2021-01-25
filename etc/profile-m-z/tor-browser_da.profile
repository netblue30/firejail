# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_da.local

noblacklist ${HOME}/.tor-browser_da

mkdir ${HOME}/.tor-browser_da
whitelist ${HOME}/.tor-browser_da

# Redirect
include torbrowser-launcher.profile
