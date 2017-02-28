# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/feh.local

# feh image viewer profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
net none
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none

private-bin feh
private-dev
private-etc feh
private-tmp