# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/iridium.local

# Iridium browser profile
noblacklist ~/.config/iridium
noblacklist ~/.cache/iridium
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

# chromium/iridium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/iridium
whitelist ~/.config/iridium
mkdir ~/.cache/iridium
whitelist ~/.cache/iridium
mkdir ~/.pki
whitelist ~/.pki

include /etc/firejail/whitelist-common.inc
