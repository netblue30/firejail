#Persistent global definitions go here
include /etc/firejail/globals.local

#This file is overwritten during software install.
#Persistent customizations should go in a .local file.
include /etc/firejail/rambox.local

# Rambox profile for firejail
noblacklist ~/.config/Rambox
noblacklist ~/.pki
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
#tracelog

whitelist ${DOWNLOADS}
mkdir ~/.config/Rambox
whitelist ~/.config/Rambox
mkdir ~/.pki
whitelist ~/.pki

include /etc/firejail/whitelist-common.inc

