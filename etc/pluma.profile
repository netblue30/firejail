# Firejail profile for Xed
noblacklist ${HOME}/.config/pluma

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
net none
nogroups
nonewprivs
noroot
nosound
seccomp
shell none
tracelog

private-bin pluma
private-dev
private-tmp
