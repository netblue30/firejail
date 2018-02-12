# Firejail profile for icecat
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/icecat.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla

mkdir ${HOME}/.cache/mozilla/icecat
mkdir ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/icecat
whitelist ${HOME}/.mozilla

# private-etc must first be enabled in firefox-common.profile
#private-etc icecat

# Redirect
include /etc/firejail/firefox-common.profile
