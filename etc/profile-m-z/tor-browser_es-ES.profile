# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_es-ES

mkdir ${HOME}/.tor-browser_es-ES
whitelist ${HOME}/.tor-browser_es-ES

# Redirect
include torbrowser-launcher.profile
