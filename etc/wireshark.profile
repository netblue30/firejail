# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/wireshark.local

# Firejail profile for 
noblacklist ${HOME}/.config/wireshark

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin wireshark
private-dev
private-tmp
