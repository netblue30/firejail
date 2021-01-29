# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include tor-browser-pt-br.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser-pt-br

mkdir ${HOME}/.tor-browser-pt-br
whitelist ${HOME}/.tor-browser-pt-br

# Redirect
include torbrowser-launcher.profile
