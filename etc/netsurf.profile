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

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

include /etc/firejail/whitelist-common.inc
