# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-nb

mkdir ${HOME}/.tor-browser-nb
whitelist ${HOME}/.tor-browser-nb

# Redirect
include torbrowser-launcher.profile
