# Firejail profile for palemoon
# This file is overwritten after every install/update
# Persistent local customizations
include palemoon.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/moonchild productions/pale moon
noblacklist ${HOME}/.moonchild productions/pale moon

mkdir ${HOME}/.cache/moonchild productions/pale moon
mkdir ${HOME}/.moonchild productions
whitelist ${HOME}/.cache/moonchild productions/pale moon
whitelist ${HOME}/.moonchild productions

# Palemoon can use the full firejail seccomp filter (unlike firefox >= 60)
seccomp
ignore seccomp

#private-bin palemoon
# private-etc must first be enabled in firefox-common.profile
#private-etc palemoon
#private-opt palemoon

# Redirect
include firefox-common.profile
