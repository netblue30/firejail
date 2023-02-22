# Firejail profile for Viber
# This file is overwritten after every install/update
# Persistent local customizations
include Viber.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.ViberPC
noblacklist ${PATH}/dig

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.ViberPC
whitelist ${DOWNLOADS}
whitelist ${HOME}/.ViberPC
include whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp !chroot

disable-mnt
private-bin awk,bash,dig,sh,Viber
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,hosts,ld.so.cache,ld.so.preload,localtime,machine-id,mailcap,nsswitch.conf,pki,proxychains.conf,pulse,resolv.conf,ssl,X11
private-tmp

# restrict-namespaces
