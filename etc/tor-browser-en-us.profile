# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-en-us

mkdir ${HOME}/.tor-browser-en-us
whitelist ${HOME}/.tor-browser-en-us

# Redirect
include /etc/firejail/torbrowser-launcher.profile
