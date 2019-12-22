# Firejail profile for archaudit-report
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include archaudit-report.local
# Persistent global definitions
include globals.local

noblacklist /var/lib/pacman

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private
private-bin arch-audit,archaudit-report,bash,cat,comm,cut,date,fold,grep,pacman,pactree,rm,sed,sort,whoneeds
#private-dev
#private-etc alternatives,ca-certificates,crypto-policies,dbus-1,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

memory-deny-write-execute
