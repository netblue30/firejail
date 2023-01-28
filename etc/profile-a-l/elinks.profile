# Firejail profile for elinks
# Description: Advanced text-mode WWW browser
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include elinks.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.elinks

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

mkdir ${HOME}/.elinks
whitelist ${HOME}/.elinks

private-bin elinks

read-write ${HOME}/.elinks

# Redirect
include links-common.profile
