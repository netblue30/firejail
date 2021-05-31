# Firejail profile for elinks
# Description: Advanced text-mode WWW browser
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include elinks.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.elinks

mkdir ${HOME}/.elinks
whitelist ${HOME}/.elinks

private-bin elinks

# Redirect
include links-common.profile
