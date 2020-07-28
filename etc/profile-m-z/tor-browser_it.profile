# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_it

mkdir ${HOME}/.tor-browser_it
whitelist ${HOME}/.tor-browser_it

# Redirect
include torbrowser-launcher.profile
