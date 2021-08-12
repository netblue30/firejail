# Firejail profile for ffmpeg
# Description: Tools for transcoding, streaming and playing of multimedia files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ffmpeg.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/devedeng
whitelist /usr/share/ffmpeg
whitelist /usr/share/qtchooser
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
# allow set_mempolicy, which is required to encode using libx265
seccomp !set_mempolicy
seccomp.block-secondary
shell none
tracelog

private-bin ffmpeg
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,nsswitch.conf,pkcs11,pki,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

# memory-deny-write-execute - it breaks old versions of ffmpeg
