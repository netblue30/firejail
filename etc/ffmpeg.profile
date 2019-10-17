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
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/ffmpeg
whitelist /usr/share/qtchooser
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none
tracelog

private-bin ffmpeg
private-cache
private-dev
private-etc alternatives,ca-certificates,hosts,pkcs11,pki,resolv.conf,ssl
private-tmp

# memory-deny-write-execute - it breaks old versions of ffmpeg
