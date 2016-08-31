# Firejail profile for Atom.
noblacklist ~/.atom
noblacklist ~/.config/Atom

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
nogroups
noroot
nosound
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp
