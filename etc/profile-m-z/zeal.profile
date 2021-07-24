# Firejail profile for zeal
# Description: Offline API documentation browser
# This file is overwritten after every install/update
# Persistent local customizations
include zeal.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/Zeal
nodeny  ${HOME}/.cache/Zeal
nodeny  ${HOME}/.local/share/Zeal

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/Zeal
mkdir ${HOME}/.config/qt5ct
mkdir ${HOME}/.config/Zeal
mkdir ${HOME}/.local/share/Zeal
allow  ${HOME}/.cache/Zeal
allow  ${HOME}/.config/Zeal
allow  ${HOME}/.local/share/Zeal
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin zeal
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,pki,protocols,resolv.conf,rpc,services,ssl,Trolltech.conf,X11,xdg
private-tmp

dbus-user none
dbus-system none

# memory-deny-write-execute - breaks on Arch
