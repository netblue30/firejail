# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_fa

mkdir ${HOME}/.tor-browser_fa
whitelist ${HOME}/.tor-browser_fa

# Redirect
include torbrowser-launcher.profile
