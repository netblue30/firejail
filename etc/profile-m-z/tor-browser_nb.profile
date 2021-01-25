# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_nb.local

noblacklist ${HOME}/.tor-browser_nb

mkdir ${HOME}/.tor-browser_nb
whitelist ${HOME}/.tor-browser_nb

# Redirect
include torbrowser-launcher.profile
