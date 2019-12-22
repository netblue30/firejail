# Firejail profile for gnome-mplayer
# Description: GTK/Gnome interface around MPlayer
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-mplayer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnome-mplayer
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
shell none

# private-bin gnome-mplayer,mplayer
private-cache
private-dev
#private-etc X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

