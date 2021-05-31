# Firejail profile for links2
# Description: Text WWW browser with a graphic version
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include links2.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.links2

mkdir ${HOME}/.links2
whitelist ${HOME}/.links2

private-bin links2

# Redirect
include links-common.local
