# Firejail profile for standardnotes-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include standardnotes-desktop.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/Standard Notes Backups
nodeny  ${HOME}/.config/Standard Notes

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/Standard Notes Backups
mkdir ${HOME}/.config/Standard Notes
allow  ${HOME}/Standard Notes Backups
allow  ${HOME}/.config/Standard Notes
include whitelist-var-common.inc

apparmor
caps.drop all
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
protocol unix,inet,inet6,netlink
seccomp !chroot

disable-mnt
private-dev
private-tmp
private-etc alternatives,ca-certificates,crypto-policies,fonts,host.conf,hostname,hosts,ld.so.cache,pki,resolv.conf,ssl,xdg

dbus-user none
dbus-system none
