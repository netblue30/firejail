# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_he.local

noblacklist ${HOME}/.tor-browser_he

mkdir ${HOME}/.tor-browser_he
whitelist ${HOME}/.tor-browser_he

# Redirect
include torbrowser-launcher.profile
