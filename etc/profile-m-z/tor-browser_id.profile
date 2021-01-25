# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_id.local

noblacklist ${HOME}/.tor-browser_id

mkdir ${HOME}/.tor-browser_id
whitelist ${HOME}/.tor-browser_id

# Redirect
include torbrowser-launcher.profile
