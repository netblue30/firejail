# Firejail profile for gnome-documents
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-documents.local
# Persistent global definitions
include /etc/firejail/globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.config/libreoffice

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
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

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
