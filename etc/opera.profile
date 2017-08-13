# Firejail profile for opera
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/opera.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/opera
noblacklist ~/.config/opera
noblacklist ~/.opera
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/opera
mkdir ~/.config/opera
mkdir ~/.opera
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/opera
whitelist ~/.config/opera
whitelist ~/.opera
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

netfilter
nodvd
notv
