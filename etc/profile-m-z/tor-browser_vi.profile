# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_vi.local

noblacklist ${HOME}/.tor-browser_vi

mkdir ${HOME}/.tor-browser_vi
whitelist ${HOME}/.tor-browser_vi

# Redirect
include torbrowser-launcher.profile
