# Firejail profile for fossamail
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/fossamail.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/fossamail
noblacklist ~/.fossamail
noblacklist ~/.gnupg

mkdir ~/.cache/fossamail
mkdir ~/.fossamail
mkdir ~/.gnupg
whitelist ~/.cache/fossamail
whitelist ~/.fossamail
whitelist ~/.gnupg
include /etc/firejail/whitelist-common.inc

# allow browsers
# Redirect
include /etc/firejail/firefox.profile
