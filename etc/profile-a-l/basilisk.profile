# Firejail profile for basilisk
# This file is overwritten after every install/update
# Persistent local customizations
include basilisk.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/moonchild productions/basilisk
nodeny  ${HOME}/.moonchild productions/basilisk

mkdir ${HOME}/.cache/moonchild productions/basilisk
mkdir ${HOME}/.moonchild productions
allow  ${HOME}/.cache/moonchild productions/basilisk
allow  ${HOME}/.moonchild productions

# Basilisk can use the full firejail seccomp filter (unlike firefox >= 60)
seccomp
ignore seccomp

#private-bin basilisk
# private-etc must first be enabled in firefox-common.profile
#private-etc basilisk
#private-opt basilisk

# Redirect
include firefox-common.profile
