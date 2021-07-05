# Firejail profile for Musixmatch
# This file is overwritten after every install/update
# Persistent local customizations
include musixmatch.local
# Persistent global definitions
include globals.local

nodeny  ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nogroups
noinput
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,machine-id,pki,pulse,ssl

