# Firejail profile for inox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/inox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/inox
noblacklist ~/.config/inox
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/inox
mkdir ~/.config/inox
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/inox
whitelist ~/.config/inox
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

netfilter
nodvd
notv
