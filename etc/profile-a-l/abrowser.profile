# Firejail profile for abrowser
# This file is overwritten after every install/update
# Persistent local customizations
include abrowser.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/mozilla
nodeny  ${HOME}/.mozilla

mkdir ${HOME}/.cache/mozilla/abrowser
mkdir ${HOME}/.mozilla
allow  ${HOME}/.cache/mozilla/abrowser
allow  ${HOME}/.mozilla

# private-etc must first be enabled in firefox-common.profile
#private-etc abrowser

# Redirect
include firefox-common.profile
