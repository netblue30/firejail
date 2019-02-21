# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-id

mkdir ${HOME}/.tor-browser-id
whitelist ${HOME}/.tor-browser-id

# Redirect
include torbrowser-launcher.profile
