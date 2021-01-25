# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_pl.local

noblacklist ${HOME}/.tor-browser_pl

mkdir ${HOME}/.tor-browser_pl
whitelist ${HOME}/.tor-browser_pl

# Redirect
include torbrowser-launcher.profile
