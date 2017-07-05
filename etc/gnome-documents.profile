# Persistent global definitions go here
include /etc/firejail/globals.local

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
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix
seccomp
shell none
tracelog

private-tmp
private-dev

noexec ${HOME}
noexec /tmp
