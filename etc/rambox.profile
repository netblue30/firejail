# Firejail profile for rambox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/rambox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/Rambox
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.config/Rambox
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.config/Rambox
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
# tracelog
