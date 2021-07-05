# Firejail profile for Newsboat
# Description: RSS program
# This file is overwritten after every install/update
# Persistent local customizations
include newsboat.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/newsbeuter
nodeny  ${HOME}/.config/newsboat
nodeny  ${HOME}/.local/share/newsbeuter
nodeny  ${HOME}/.local/share/newsboat
nodeny  ${HOME}/.newsbeuter
nodeny  ${HOME}/.newsboat

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/newsboat
mkdir ${HOME}/.local/share/newsboat
mkdir ${HOME}/.newsboat
allow  ${HOME}/.config/newsbeuter
allow  ${HOME}/.config/newsboat
allow  ${HOME}/.local/share/newsbeuter
allow  ${HOME}/.local/share/newsboat
allow  ${HOME}/.newsbeuter
allow  ${HOME}/.newsboat
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
private-etc alternatives,ca-certificates,crypto-policies,lynx.cfg,lynx.lss,pki,resolv.conf,ssl,terminfo
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
