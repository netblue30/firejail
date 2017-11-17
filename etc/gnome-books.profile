# Firejail profile for gnome-books
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-books.local
# Persistent global definitions
include /etc/firejail/globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.cache/org.gnome.Books

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

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

# private-bin gjs gnome-books
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
