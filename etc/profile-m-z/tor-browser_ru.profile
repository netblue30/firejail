# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_ru.local

noblacklist ${HOME}/.tor-browser_ru

mkdir ${HOME}/.tor-browser_ru
whitelist ${HOME}/.tor-browser_ru

# Redirect
include torbrowser-launcher.profile
