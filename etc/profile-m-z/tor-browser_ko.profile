# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

noblacklist ${HOME}/.tor-browser_ko

mkdir ${HOME}/.tor-browser_ko
whitelist ${HOME}/.tor-browser_ko

# Redirect
include torbrowser-launcher.profile
