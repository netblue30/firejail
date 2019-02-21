# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_el

mkdir ${HOME}/.tor-browser_el
whitelist ${HOME}/.tor-browser_el

# Redirect
include torbrowser-launcher.profile
