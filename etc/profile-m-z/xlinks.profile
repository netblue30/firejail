# Firejail profile for xlinks
# Description: Text WWW browser (X11)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include xlinks.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.xlinks

mkdir ${HOME}/.xlinks
whitelist ${HOME}/.xlinks

private-bin xlinks

# Redirect
include links-common.profile
