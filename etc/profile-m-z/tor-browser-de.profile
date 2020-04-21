# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-de

mkdir ${HOME}/.tor-browser-de
whitelist ${HOME}/.tor-browser-de

# Redirect
include torbrowser-launcher.profile
