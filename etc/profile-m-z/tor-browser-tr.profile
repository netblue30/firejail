# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-tr

mkdir ${HOME}/.tor-browser-tr
whitelist ${HOME}/.tor-browser-tr

# Redirect
include torbrowser-launcher.profile
