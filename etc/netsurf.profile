# Firejail profile for Mozilla Firefox (Iceweasel in Debian)

noblacklist ~/.config/netsurf
noblacklist ~/.cache/netsurf
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
tracelog
nonewprivs
noroot

whitelist ${DOWNLOADS}
mkdir ~/.config
mkdir ~/.config/netsurf
whitelist ~/.config/netsurf
mkdir ~/.cache
mkdir ~/.cache/netsurf
whitelist ~/.cache/netsurf

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

include /etc/firejail/whitelist-common.inc



