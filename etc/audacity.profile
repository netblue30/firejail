# Audacity profile
noblacklist ~/.audacity-data

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix
seccomp
shell none
tracelog

private-bin audacity
private-dev
private-tmp
