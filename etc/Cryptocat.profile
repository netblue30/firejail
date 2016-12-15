# Firejail profile for 
noblacklist ${HOME}/.config/Cryptocat

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

private-dev
private-tmp
