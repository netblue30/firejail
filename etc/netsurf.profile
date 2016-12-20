# Firejail profile for Mozilla Firefox (Iceweasel in Debian)
noblacklist ~/.config/netsurf
noblacklist ~/.cache/netsurf
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
tracelog

whitelist ${DOWNLOADS}
mkdir ~/.config/netsurf
whitelist ~/.config/netsurf
mkdir ~/.cache/netsurf
whitelist ~/.cache/netsurf

# lastpass, keepass
# for keepass we additionally need to whitelist our .kdbx password database
whitelist ~/.keepass
whitelist ~/.config/keepass
whitelist ~/.config/KeePass
whitelist ~/.lastpass
whitelist ~/.config/lastpass

include /etc/firejail/whitelist-common.inc
