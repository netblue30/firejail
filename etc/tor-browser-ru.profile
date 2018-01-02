# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-ru
whitelist ${HOME}/.tor-browser-ru

# Redirect
include /etc/firejail/torbrowser-launcher.profile
