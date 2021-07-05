# Firejail profile for palemoon
# This file is overwritten after every install/update
# Persistent local customizations
include palemoon.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/moonchild productions/pale moon
nodeny  ${HOME}/.moonchild productions/pale moon

mkdir ${HOME}/.cache/moonchild productions/pale moon
mkdir ${HOME}/.moonchild productions
allow  ${HOME}/.cache/moonchild productions/pale moon
allow  ${HOME}/.moonchild productions

# Palemoon can use the full firejail seccomp filter (unlike firefox >= 60)
seccomp
ignore seccomp

#private-bin palemoon
# private-etc must first be enabled in firefox-common.profile
#private-etc palemoon
#private-opt palemoon

# Redirect
include firefox-common.profile
