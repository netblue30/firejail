# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gnome-documents.local

# gnome-documents profile

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ~/.config/libreoffice

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
shell none
tracelog

private-tmp
private-dev
