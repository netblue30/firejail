# simple-scan profile
noblacklist ~/.cache/simple-scan

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
#seccomp
netfilter
shell none
tracelog

# private-bin simple-scan
# private-tmp
# private-dev
# private-etc fonts
