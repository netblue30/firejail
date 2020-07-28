# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-pl

mkdir ${HOME}/.tor-browser-pl
whitelist ${HOME}/.tor-browser-pl

# Redirect
include torbrowser-launcher.profile
