# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-sv-se

mkdir ${HOME}/.tor-browser-sv-se
whitelist ${HOME}/.tor-browser-sv-se

# Redirect
include torbrowser-launcher.profile
