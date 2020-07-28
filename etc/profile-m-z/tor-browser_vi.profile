# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_vi

mkdir ${HOME}/.tor-browser_vi
whitelist ${HOME}/.tor-browser_vi

# Redirect
include torbrowser-launcher.profile
