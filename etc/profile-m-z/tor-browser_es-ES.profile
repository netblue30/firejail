# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_es-ES.local

noblacklist ${HOME}/.tor-browser_es-ES

mkdir ${HOME}/.tor-browser_es-ES
whitelist ${HOME}/.tor-browser_es-ES

# Redirect
include torbrowser-launcher.profile
