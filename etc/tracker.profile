# tracker profile

# Tracker is started by systemd on most systems. Therefore it is not firejailed by default

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
protocol unix
seccomp
netfilter
shell none
tracelog

blacklist /tmp/.X11-unix

# private-bin tracker
# private-tmp
# private-dev
# private-etc fonts
