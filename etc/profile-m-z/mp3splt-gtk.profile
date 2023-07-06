# Firejail profile for mp3splt-gtk
# Description: GTK utility for mp3/ogg splitting without decoding
# This file is overwritten after every install/update
# Persistent local customizations
include mp3splt-gtk.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.mp3splt-gtk

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
tracelog

private-bin mp3splt-gtk
private-cache
private-dev
private-etc @games,@x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
