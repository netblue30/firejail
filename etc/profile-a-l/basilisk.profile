# Firejail profile for basilisk
# This file is overwritten after every install/update
# Persistent local customizations
include basilisk.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/moonchild productions/basilisk
noblacklist ${HOME}/.moonchild productions/basilisk

mkdir ${HOME}/.cache/moonchild productions/basilisk
mkdir ${HOME}/.moonchild productions
whitelist ${HOME}/.cache/moonchild productions/basilisk
whitelist ${HOME}/.moonchild productions
whitelist /usr/share/basilisk

# Basilisk can use the full firejail seccomp filter (unlike firefox >= 60)
seccomp
ignore seccomp

#private-bin basilisk
# private-etc must first be enabled in firefox-common.profile
#private-etc basilisk
#private-opt basilisk

restrict-namespaces
ignore restrict-namespaces

# Redirect
include firefox-common.profile
