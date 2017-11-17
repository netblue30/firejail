# Firejail profile for fossamail
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/fossamail.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/fossamail
noblacklist ${HOME}/.fossamail
noblacklist ${HOME}/.gnupg

mkdir ${HOME}/.cache/fossamail
mkdir ${HOME}/.fossamail
mkdir ${HOME}/.gnupg
whitelist ${HOME}/.cache/fossamail
whitelist ${HOME}/.fossamail
whitelist ${HOME}/.gnupg
include /etc/firejail/whitelist-common.inc

# allow browsers
# Redirect
include /etc/firejail/firefox.profile
