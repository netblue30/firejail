# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/chromium.local

# Chromium browser profile
noblacklist ~/.config/chromium
noblacklist ~/.cache/chromium
noblacklist ~/.pki
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/chromium
whitelist ~/.config/chromium
mkdir ~/.cache/chromium
whitelist ~/.cache/chromium
mkdir ~/.pki
whitelist ~/.pki

# lastpass, keepass
# for keepass we additionally need to whitelist our .kdbx password database
whitelist ~/.keepass
whitelist ~/.config/keepass
whitelist ~/.config/KeePass
whitelist ~/.lastpass
whitelist ~/.config/lastpass

# specific to Arch
whitelist ~/.config/chromium-flags.conf

include /etc/firejail/whitelist-common.inc
