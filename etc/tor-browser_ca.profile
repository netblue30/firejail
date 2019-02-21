# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_ca

mkdir ${HOME}/.tor-browser_ca
whitelist ${HOME}/.tor-browser_ca

# Redirect
include torbrowser-launcher.profile
