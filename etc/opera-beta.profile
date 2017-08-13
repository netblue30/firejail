# Firejail profile for opera-beta
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/opera-beta.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/opera-beta
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/opera
mkdir ~/.config/opera-beta
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/opera
whitelist ~/.config/opera-beta
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

netfilter
nodvd
notv
