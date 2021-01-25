# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-pt-br.local

noblacklist ${HOME}/.tor-browser-pt-br

mkdir ${HOME}/.tor-browser-pt-br
whitelist ${HOME}/.tor-browser-pt-br

# Redirect
include torbrowser-launcher.profile
