# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-nl

mkdir ${HOME}/.tor-browser-nl
whitelist ${HOME}/.tor-browser-nl

# Redirect
include torbrowser-launcher.profile
