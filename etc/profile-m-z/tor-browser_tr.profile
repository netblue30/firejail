# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_tr

mkdir ${HOME}/.tor-browser_tr
whitelist ${HOME}/.tor-browser_tr

# Redirect
include torbrowser-launcher.profile
