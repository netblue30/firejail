# wget profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
nogroups
nosound
protocol unix,inet,inet6
seccomp
shell none


# private-bin wget
# private-etc resolv.conf
private-dev
private-tmp

