# Firejail profile for cliqz
# This file is overwritten after every install/update
# Persistent local customizations
include cliqz.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/cliqz
nodeny  ${HOME}/.cliqz
nodeny  ${HOME}/.config/cliqz

mkdir ${HOME}/.cache/cliqz
mkdir ${HOME}/.cliqz
mkdir ${HOME}/.config/cliqz
allow  ${HOME}/.cache/cliqz
allow  ${HOME}/.cliqz
allow  ${HOME}/.config/cliqz

# private-etc must first be enabled in firefox-common.profile
#private-etc cliqz

# Redirect
include firefox-common.profile
