# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/highlight.local

# highlight profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
netfilter
net none
no3d
shell none
tracelog

blacklist /tmp/.X11-unix

private-bin highlight
# private-etc none
private-tmp
private-dev



