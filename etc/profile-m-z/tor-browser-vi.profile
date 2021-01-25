# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser-vi.local

noblacklist ${HOME}/.tor-browser-vi

mkdir ${HOME}/.tor-browser-vi
whitelist ${HOME}/.tor-browser-vi

# Redirect
include torbrowser-launcher.profile
