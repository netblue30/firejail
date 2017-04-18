# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gnome-maps.local

# gnome-maps profile

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them
noblacklist ${HOME}/.cache/champlain
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
netfilter
shell none
tracelog

# private-bin gjs gnome-maps
private-tmp
private-dev
# private-etc fonts
