# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_id

mkdir ${HOME}/.tor-browser_id
whitelist ${HOME}/.tor-browser_id

# Redirect
include torbrowser-launcher.profile
