# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_ga-IE.local

noblacklist ${HOME}/.tor-browser_ga-IE

mkdir ${HOME}/.tor-browser_ga-IE
whitelist ${HOME}/.tor-browser_ga-IE

# Redirect
include torbrowser-launcher.profile
