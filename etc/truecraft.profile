# Firejail profile for truecraft
# This file is overwritten after every install/update
# Persistent local customizations
include truecraft.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mono
noblacklist ${HOME}/.config/truecraft

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/mono
mkdir ${HOME}/.config/truecraft
whitelist ${HOME}/.config/mono
whitelist ${HOME}/.config/truecraft
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
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,mono,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

