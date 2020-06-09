# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-cs

mkdir ${HOME}/.tor-browser-cs
whitelist ${HOME}/.tor-browser-cs

# Redirect
include torbrowser-launcher.profile
