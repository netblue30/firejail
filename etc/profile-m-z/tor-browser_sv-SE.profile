# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_sv-SE.local

noblacklist ${HOME}/.tor-browser_sv-SE

mkdir ${HOME}/.tor-browser_sv-SE
whitelist ${HOME}/.tor-browser_sv-SE

# Redirect
include torbrowser-launcher.profile
