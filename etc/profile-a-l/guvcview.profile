# Firejail profile for guvcview
# Description: GTK+ base UVC Viewer
# This file is overwritten after every install/update
# Persistent local customizations
include guvcview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/guvcview2

noblacklist ${PICTURES}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/guvcview2
whitelist ${HOME}/.config/guvcview2
whitelist ${PICTURES}
whitelist ${VIDEOS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin guvcview
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,glvnd,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nvidia,pango,pulse,X11
private-tmp

dbus-user none
dbus-system none
