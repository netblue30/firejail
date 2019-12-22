# Firejail profile for evolution
# Description: Groupware suite with mail client and organizer
# This file is overwritten after every install/update
# Persistent local customizations
include evolution.local
# Persistent global definitions
include globals.local

noblacklist /var/mail
noblacklist /var/spool/mail
noblacklist ${HOME}/.bogofilter
noblacklist ${HOME}/.cache/evolution
noblacklist ${HOME}/.config/evolution
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.local/share/evolution
noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
# no3d breaks under wayland
#no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

