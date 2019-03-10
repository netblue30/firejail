# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-da

mkdir ${HOME}/.tor-browser-da
whitelist ${HOME}/.tor-browser-da

# Redirect
include torbrowser-launcher.profile
