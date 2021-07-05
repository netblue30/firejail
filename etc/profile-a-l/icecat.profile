# Firejail profile for icecat
# This file is overwritten after every install/update
# Persistent local customizations
include icecat.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/mozilla
nodeny  ${HOME}/.mozilla

mkdir ${HOME}/.cache/mozilla/icecat
mkdir ${HOME}/.mozilla
allow  ${HOME}/.cache/mozilla/icecat
allow  ${HOME}/.mozilla

# private-etc must first be enabled in firefox-common.profile
#private-etc icecat

# Redirect
include firefox-common.profile
