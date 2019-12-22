# Firejail profile for gnome-sound-recorder
# Description: simple sound recordings for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-sound-recorder.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${HOME}/.local/share/flatpak
noblacklist ${HOME}/.local/share/Trash

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-etc X11,alsa,alternatives,asound.conf,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp
