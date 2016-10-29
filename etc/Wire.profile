# wire messenger profile

noblacklist ~/.config/Wire

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
nogroups
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-tmp
private-dev

# please note: the wire binary is currently identified with a capital W. This might change in future versions
