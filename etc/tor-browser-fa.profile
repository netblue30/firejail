# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-fa
whitelist ${HOME}/.tor-browser-fa

# Redirect
include /etc/firejail/torbrowser-launcher.profile
