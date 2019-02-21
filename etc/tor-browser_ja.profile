# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_ja

mkdir ${HOME}/.tor-browser_ja
whitelist ${HOME}/.tor-browser_ja

# Redirect
include torbrowser-launcher.profile
