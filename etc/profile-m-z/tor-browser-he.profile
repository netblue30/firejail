# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-he

mkdir ${HOME}/.tor-browser-he
whitelist ${HOME}/.tor-browser-he

# Redirect
include torbrowser-launcher.profile
