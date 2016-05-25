# kmail profile
noblacklist ${HOME}/.gnupg

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
nonewprivs
noroot
tracelog
