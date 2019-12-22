# Firejail profile for gnome-twitch
# Description: GNOME Twitch app for watching Twitch.tv streams without a browser or flash
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-twitch.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/gnome-twitch
noblacklist ${HOME}/.local/share/gnome-twitch

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/gnome-twitch
mkdir ${HOME}/.local/share/gnome-twitch
whitelist ${HOME}/.cache/gnome-twitch
whitelist ${HOME}/.local/share/gnome-twitch
include whitelist-common.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
#private-etc X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

