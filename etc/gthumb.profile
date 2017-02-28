# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gthumb.local

# gthumb profile
noblacklist ${HOME}/.config/gthumb

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
shell none
tracelog

private-bin gthumb
private-dev
private-tmp