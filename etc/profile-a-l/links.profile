# Firejail profile for links
# Description: Text WWW browser
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include links.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.links

mkdir ${HOME}/.links
allow  ${HOME}/.links

private-bin links

# Redirect
include links-common.profile
