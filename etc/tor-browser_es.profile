# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_es

mkdir ${HOME}/.tor-browser_es
whitelist ${HOME}/.tor-browser_es

# Redirect
include torbrowser-launcher.profile
