# Firejail profile for gnote
# Description: A simple note-taking application for Gnome
# This file is overwritten after every install/update
# Persistent local customizations
include gnote.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnote
noblacklist ${HOME}/.local/share/gnote

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/gnote
mkdir ${HOME}/.local/share/gnote
whitelist ${HOME}/.config/gnote
whitelist ${HOME}/.local/share/gnote
whitelist /usr/libexec/webkit2gtk-4.0
whitelist /usr/share/gnote
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

disable-mnt
private-bin gnote
private-cache
private-dev
private-etc alternatives,dconf,fonts,gtk-3.0,ld.so.cache,ld.so.preload,pango,X11
private-tmp

dbus-user filter
dbus-user.own org.gnome.Gnote
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces
