# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-es-es

mkdir ${HOME}/.tor-browser-es-es
whitelist ${HOME}/.tor-browser-es-es

# Redirect
include torbrowser-launcher.profile
