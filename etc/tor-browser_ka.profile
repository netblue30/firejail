# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_ka

mkdir ${HOME}/.tor-browser_ka
whitelist ${HOME}/.tor-browser_ka

# Redirect
include torbrowser-launcher.profile
