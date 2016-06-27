# Audacity profile
noblacklist ~/.audacity-data

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nonewprivs
noroot
nogroups
#private-bin audacity
protocol unix,inet,inet6
seccomp
