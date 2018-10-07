# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-ko

mkdir ${HOME}/.tor-browser-ko
whitelist ${HOME}/.tor-browser-ko

# Redirect
include /etc/firejail/torbrowser-launcher.profile
