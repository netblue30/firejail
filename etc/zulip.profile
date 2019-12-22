# Firejail profile for zulip
# Description: Real-time team chat based on the email threading model
# This file is overwritten after every install/update
# Persistent local customizations
include zulip.local
# Persistent global definitions
include globals.local

private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
ignore noexec /tmp

noblacklist ${HOME}/.config/Zulip

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Zulip
whitelist ${HOME}/.config/Zulip
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin locale,zulip
private-cache
private-dev
private-tmp
