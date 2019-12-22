# Firejail profile for pavucontrol
# Description: PulseAudio Volume Control [GTK]
# This file is overwritten after every install/update
# Persistent local customizations
include pavucontrol.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/pavucontrol.ini

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkfile ${HOME}/.config/pavucontrol.ini
whitelist ${HOME}/.config/pavucontrol.ini
whitelist /usr/share/pavucontrol
whitelist /usr/share/pavucontrol-qt
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodbus
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
private-bin pavucontrol
private-cache
private-dev
private-etc X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-lib
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
