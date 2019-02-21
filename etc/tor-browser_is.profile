# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_is

mkdir ${HOME}/.tor-browser_is
whitelist ${HOME}/.tor-browser_is

# Redirect
include torbrowser-launcher.profile
