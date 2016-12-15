################################
# Generic GUI application profile
################################
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

#
# depending on you usage, you can enable some of the commands below: 
#
# nogroups
# shell none
# private-bin program
# private-etc none
# private-dev
# private-tmp

