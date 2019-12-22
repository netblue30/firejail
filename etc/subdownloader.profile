# Firejail profile for subdownloader
# Description: Automatic download/upload of subtitles using fast hashing
# This file is overwritten after every install/update
# Persistent local customizations
include subdownloader.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/SubDownloader
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc

apparmor
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
protocol unix,inet,inet6
seccomp
shell none

private-cache
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
