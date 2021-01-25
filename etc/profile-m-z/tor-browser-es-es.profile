# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-es-es.local

noblacklist ${HOME}/.tor-browser-es-es

mkdir ${HOME}/.tor-browser-es-es
whitelist ${HOME}/.tor-browser-es-es

# Redirect
include torbrowser-launcher.profile
