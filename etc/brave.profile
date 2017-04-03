# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/brave.local

# Profile for Brave browser
noblacklist ~/.config/brave
noblacklist ~/.pki
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

#caps.drop all
netfilter
#nonewprivs
#noroot
#protocol unix,inet,inet6,netlink
#seccomp

whitelist ${DOWNLOADS}

mkdir ~/.config/brave
whitelist ~/.config/brave
mkdir ~/.pki
whitelist ~/.pki

# lastpass, keepass
# for keepass we additionally need to whitelist our .kdbx password database
whitelist ~/.keepass
whitelist ~/.config/keepass
whitelist ~/.config/KeePass
whitelist ~/.lastpass
whitelist ~/.config/lastpass

include /etc/firejail/whitelist-common.inc

