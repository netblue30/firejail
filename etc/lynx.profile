# lynx profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
no3d
protocol unix,inet,inet6
seccomp
netfilter
shell none
tracelog

blacklist /tmp/.X11-unix

# private-bin lynx
private-tmp
private-dev
# private-etc none

