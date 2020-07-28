# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-ka

mkdir ${HOME}/.tor-browser-ka
whitelist ${HOME}/.tor-browser-ka

# Redirect
include torbrowser-launcher.profile
