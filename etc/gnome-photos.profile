# Firejail profile for gnome-photos
# Description: Access, organize and share your photos with GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-photos.local
# Persistent global definitions
include /etc/firejail/globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.local/share/gnome-photos

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix
seccomp
shell none
tracelog

# private-bin gjs gnome-photos
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
