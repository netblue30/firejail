# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-en-es
whitelist ${HOME}/.tor-browser-en-es

# Redirect
include /etc/firejail/torbrowser-launcher.profile
