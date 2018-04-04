# Firejail profile for basilisk
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/basilisk.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/moonchild productions/basilisk
noblacklist ${HOME}/.moonchild productions/basilisk

mkdir ${HOME}/.cache/moonchild productions/basilisk
mkdir ${HOME}/.moonchild productions
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/moonchild productions/basilisk
whitelist ${HOME}/.moonchild productions

#private-bin basilisk
# private-etc must first be enabled in firefox-common.profile
#private-etc basilisk
#private-opt basilisk

# Redirect
include /etc/firejail/firefox-common.profile
