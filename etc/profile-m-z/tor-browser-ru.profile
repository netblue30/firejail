# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-ru

mkdir ${HOME}/.tor-browser-ru
whitelist ${HOME}/.tor-browser-ru

# Redirect
include torbrowser-launcher.profile
