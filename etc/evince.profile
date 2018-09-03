# Firejail profile for evince
# Description: Document (PostScript, PDF) viewer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/evince.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/evince
noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
# net none breaks AppArmor on Ubuntu systems
netfilter
no3d
nodbus
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

private-lib evince,gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libdjvulibre.so.*,libgconf-2.so.*,libpoppler-glib.so.*,librsvg-2.so.*

private-tmp

#memory-deny-write-execute - breaks application on Archlinux, issue 1803
noexec ${HOME}
noexec /tmp
