# Firejail profile for iridium
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/iridium.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/iridium
noblacklist ~/.config/iridium

include /etc/firejail/disable-common.inc
# chromium/iridium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/iridium
mkdir ~/.config/iridium
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/iridium
whitelist ~/.config/iridium
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

netfilter
nodvd
notv
