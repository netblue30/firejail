# bleachbit profile
include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
shell none
seccomp
protocol unix

# private-bin
# private-dev
# private-tmp
# private-etc

