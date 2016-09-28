# dnsmasq profile
noblacklist /sbin
noblacklist /usr/sbin
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

caps
netfilter
nonewprivs
private
private-dev
nosound
no3d
protocol unix,inet,inet6,netlink
seccomp
