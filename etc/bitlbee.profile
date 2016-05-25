# BitlBee instant messaging profile
noblacklist /sbin
noblacklist /usr/sbin
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

protocol unix,inet,inet6
private
private-dev
seccomp
netfilter
nonewprivs
