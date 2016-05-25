# cmus profile
noblacklist ${HOME}/.config/cmus

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
nonewprivs
noroot

private-bin cmus
private-etc group
shell none
