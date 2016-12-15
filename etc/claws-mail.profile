# claws-mail profile
noblacklist ~/.claws-mail
noblacklist ~/.signature
noblacklist ~/.gnupg

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
nogroups
nosound
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

