# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_de

mkdir ${HOME}/.tor-browser_de
whitelist ${HOME}/.tor-browser_de

# Redirect
include torbrowser-launcher.profile
