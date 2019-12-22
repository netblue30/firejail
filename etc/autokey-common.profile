# Firejail profile for autokey
# Description: Desktop automation utility
# This file is overwritten after every install/update
# Persistent local customizations
include autokey-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.config/autokey
noblacklist ${HOME}/.local/share/autokey

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
# disable-exec.inc might break scripting functionality
#include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
