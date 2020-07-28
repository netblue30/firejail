# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_en

mkdir ${HOME}/.tor-browser_en
whitelist ${HOME}/.tor-browser_en

# Redirect
include torbrowser-launcher.profile
