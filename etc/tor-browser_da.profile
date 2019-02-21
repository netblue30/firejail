# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_da

mkdir ${HOME}/.tor-browser_da
whitelist ${HOME}/.tor-browser_da

# Redirect
include torbrowser-launcher.profile
