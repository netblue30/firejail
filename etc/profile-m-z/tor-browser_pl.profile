# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_pl

mkdir ${HOME}/.tor-browser_pl
whitelist ${HOME}/.tor-browser_pl

# Redirect
include torbrowser-launcher.profile
