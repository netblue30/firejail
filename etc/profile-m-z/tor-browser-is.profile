# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-is

mkdir ${HOME}/.tor-browser-is
whitelist ${HOME}/.tor-browser-is

# Redirect
include torbrowser-launcher.profile
