# Firejail profile for cliqz
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/cliqz.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/cliqz
noblacklist ${HOME}/.config/cliqz

mkdir ${HOME}/.cache/cliqz
mkdir ${HOME}/.config/cliqz
whitelist ${HOME}/.cache/cliqz
whitelist ${HOME}/.config/cliqz

# private-etc must first be enabled in firefox-common.profile
#private-etc cliqz

# Redirect
include /etc/firejail/firefox-common.profile
