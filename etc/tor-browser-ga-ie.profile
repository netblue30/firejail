# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-ga-ie

mkdir ${HOME}/.tor-browser-ga-ie
whitelist ${HOME}/.tor-browser-ga-ie

# Redirect
include torbrowser-launcher.profile
