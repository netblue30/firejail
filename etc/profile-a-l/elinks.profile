# Firejail profile for elinks
# Description: Advanced text-mode WWW browser
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include elinks.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.elinks

mkdir ${HOME}/.elinks
allow  ${HOME}/.elinks

private-bin elinks

# Redirect
include links-common.profile
