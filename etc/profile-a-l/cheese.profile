# Firejail profile for cheese
# Description: taking pictures and movies from a webcam
# This file is overwritten after every install/update
# Persistent local customizations
include cheese.local
# Persistent global definitions
include globals.local

noblacklist ${VIDEOS}
noblacklist ${PICTURES}

include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist ${VIDEOS}
whitelist ${PICTURES}
whitelist /usr/libexec/gstreamer-1.0/gst-plugin-scanner
whitelist /usr/share/gnome-video-effects
whitelist /usr/share/gstreamer-1.0
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin cheese
private-cache
private-dev
private-etc alternatives,clutter-1.0,dconf,drirc,fonts,gtk-3.0,ld.so.preload
private-tmp

dbus-user filter
dbus-user.own org.gnome.Cheese
dbus-user.talk ca.desrt.dconf
dbus-system none
