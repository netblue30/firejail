# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-en
whitelist ${HOME}/.tor-browser-en

# Redirect
include /etc/firejail/torbrowser-launcher.profile
