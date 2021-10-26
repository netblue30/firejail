# Firejail profile for Newsboat
# Description: RSS program
# This file is overwritten after every install/update
# Persistent local customizations
include newsboat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/newsbeuter
noblacklist ${HOME}/.config/newsboat
noblacklist ${HOME}/.local/share/newsbeuter
noblacklist ${HOME}/.local/share/newsboat
noblacklist ${HOME}/.newsbeuter
noblacklist ${HOME}/.newsboat

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/newsboat
mkdir ${HOME}/.local/share/newsboat
mkdir ${HOME}/.newsboat
whitelist ${HOME}/.config/newsbeuter
whitelist ${HOME}/.config/newsboat
whitelist ${HOME}/.local/share/newsbeuter
whitelist ${HOME}/.local/share/newsboat
whitelist ${HOME}/.newsbeuter
whitelist ${HOME}/.newsboat
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none

disable-mnt
private-bin gzip,lynx,newsboat,sh,w3m
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,ld.so.cache,ld.so.preload,lynx.cfg,lynx.lss,pki,resolv.conf,ssl,terminfo
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
