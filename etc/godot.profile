# Firejail profile for godot
# Description: multi-platform 2D and 3D game engine with a feature-rich editor
# This file is overwritten after every install/update
# Persistent local customizations
include godot.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/godot
noblacklist ${HOME}/.config/godot
noblacklist ${HOME}/.local/share/godot

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog


# private-bin godot
private-cache
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp
