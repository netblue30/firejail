# Firejail profile for gnome-builder
# Description: IDE for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-builder.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/gnome-builder
noblacklist ${HOME}/.config/gnome-builder
noblacklist ${HOME}/.local/share/gnome-builder

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
ipc-namespace
netfilter
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

private-cache
private-dev
#private-etc X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
