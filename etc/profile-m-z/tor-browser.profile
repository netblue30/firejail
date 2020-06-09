# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser

mkdir ${HOME}/.tor-browser
whitelist ${HOME}/.tor-browser

# Redirect
include torbrowser-launcher.profile
