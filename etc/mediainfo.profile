# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/mediainfo.local

# mediainfo profile
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
net none
shell none
tracelog

blacklist /tmp/.X11-unix

private-bin mediainfo
private-tmp
private-dev
private-etc none




