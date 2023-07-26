# Firejail profile for cliqz
# This file is overwritten after every install/update
# Persistent local customizations
include cliqz.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/cliqz
noblacklist ${HOME}/.cliqz
noblacklist ${HOME}/.config/cliqz

mkdir ${HOME}/.cache/cliqz
mkdir ${HOME}/.cliqz
mkdir ${HOME}/.config/cliqz
whitelist ${HOME}/.cache/cliqz
whitelist ${HOME}/.cliqz
whitelist ${HOME}/.config/cliqz
whitelist /usr/share/cliqz

# private-etc must first be enabled in firefox-common.profile
#private-etc cliqz

# Redirect
include firefox-common.profile
