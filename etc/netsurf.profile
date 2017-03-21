# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/netsurf.local

# Firejail profile for Mozilla Firefox (Iceweasel in Debian)
noblacklist ~/.config/netsurf
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

include /etc/firejail/whitelist-common.inc
