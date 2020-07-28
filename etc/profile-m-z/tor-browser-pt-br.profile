# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser-pt-br

mkdir ${HOME}/.tor-browser-pt-br
whitelist ${HOME}/.tor-browser-pt-br

# Redirect
include torbrowser-launcher.profile
