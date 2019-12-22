# Firejail profile for standardnotes-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include standardnotes-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/Standard Notes Backups
noblacklist ${HOME}/.config/Standard Notes

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/Standard Notes Backups
mkdir ${HOME}/.config/Standard Notes
whitelist ${HOME}/Standard Notes Backups
whitelist ${HOME}/.config/Standard Notes
include whitelist-var-common.inc

apparmor
caps.drop all
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
protocol unix,inet,inet6,netlink
seccomp !chroot

disable-mnt
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

