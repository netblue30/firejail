# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/atom-beta.local

# Firejail profile for Atom Beta.
noblacklist ~/.atom
noblacklist ~/.config/Atom

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
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

private-dev
private-tmp
