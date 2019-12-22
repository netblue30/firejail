# Firejail profile for blender
# Description: Very fast and versatile 3D modeller/renderer
# This file is overwritten after every install/update
# Persistent local customizations
include blender.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/blender

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

# Allow usage of AMD GPU by OpenCL
noblacklist /sys/module
whitelist /sys/module/amdgpu
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
read-only /sys/module/amdgpu

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp

