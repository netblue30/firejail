# Firejail profile for mumble
# Description: Low latency encrypted VoIP client
# This file is overwritten after every install/update
# Persistent local customizations
include mumble.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Mumble
noblacklist ${HOME}/.local/share/data/Mumble
noblacklist ${HOME}/.local/share/Mumble

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/Mumble
mkdir ${HOME}/.local/share/data/Mumble
mkdir ${HOME}/.local/share/Mumble
whitelist ${HOME}/.config/Mumble
whitelist ${HOME}/.local/share/data/Mumble
whitelist ${HOME}/.local/share/Mumble
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin mumble
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
