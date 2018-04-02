# Firejail profile for evince
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/evince.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/evince

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
# net none breaks AppArmor on Ubuntu systems
netfilter
no3d
# nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin evince,evince-previewer,evince-thumbnailer
private-dev
private-etc fonts

#private-lib - seems to be breaking on Gnome Shell 3.26.2, Mutter WM, issue 1711
private-lib evince,gdk-pixbuf-2.0,gio,gvfs/libgvfscommon.so,libgconf-2.so.4,libpoppler-glib.so.8,librsvg-2.so.2

private-tmp

#memory-deny-write-execute - breaks application on Archlinux, issue 1803
noexec ${HOME}
noexec /tmp
