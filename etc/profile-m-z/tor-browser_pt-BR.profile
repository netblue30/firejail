# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_pt-BR

mkdir ${HOME}/.tor-browser_pt-BR
whitelist ${HOME}/.tor-browser_pt-BR

# Redirect
include torbrowser-launcher.profile
