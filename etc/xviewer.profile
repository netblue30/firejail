noblacklist ~/.config/xviewer

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
noroot
nonewprivs
protocol unix,inet,inet6
seccomp
tracelog
