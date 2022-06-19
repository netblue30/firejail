# Firejail profile for peek
# This file is overwritten after every install/update
# Persistent local customizations
include peek.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/peek
noblacklist ${PICTURES}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

#mkdir ${HOME}/.cache/peek
#whitelist ${HOME}/.cache/peek
#whitelist ${PICTURES}
#whitelist ${VIDEOS}
#include whitelist-common.inc
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
seccomp.block-secondary
tracelog

disable-mnt
private-bin bash,convert,ffmpeg,firejail,fish,peek,sh,which,zsh
private-dev
private-etc alternatives,dconf,firejail,fonts,gtk-3.0,ld.so.cache,ld.so.preload,login.defs,pango,passwd,X11
private-tmp

dbus-user filter
dbus-user.own com.uploadedlobster.peek
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.FileManager1
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.gnome.Shell.Screencast
dbus-system none

memory-deny-write-execute
