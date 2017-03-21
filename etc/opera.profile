# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/opera.local

# Opera browser profile
noblacklist ~/.config/opera
noblacklist ~/.opera
noblacklist ~/.pki
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/opera
whitelist ~/.config/opera
mkdir ~/.opera
whitelist ~/.opera
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc
