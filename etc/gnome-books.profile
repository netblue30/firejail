# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gnome-books.local

# gnome-books profile

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them
noblacklist ~/.cache/org.gnome.Books

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
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

# private-bin gjs gnome-books
private-tmp
private-dev
#private-etc fonts

noexec ${HOME}
noexec /tmp
