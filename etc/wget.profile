# wget profile
quiet
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
nogroups
nosound
no3d
protocol unix,inet,inet6
seccomp
shell none

blacklist /tmp/.X11-unix

# private-bin wget
# private-etc resolv.conf
private-dev
private-tmp

