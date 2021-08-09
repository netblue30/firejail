# Firejail profile for cheese
# Description: taking pictures and movies from a webcam
# This file is overwritten after every install/update
# Persistent local customizations
include cheese.local
# Persistent global definitions
include globals.local

noblacklist ${VIDEOS}
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${VIDEOS}
whitelist ${PICTURES}
whitelist /usr/share/gnome-video-effects
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin cheese
private-cache
private-etc alternatives,clutter-1.0,dconf,drirc,fonts,gtk-3.0
private-tmp

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-system none
