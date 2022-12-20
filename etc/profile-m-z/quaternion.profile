# Firejail profile for quaternion
# Description: Desktop client for Matrix
# This file is overwritten after every install/update
# Persistent local customizations
include quaternion.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Quotient/quaternion
noblacklist ${HOME}/.config/Quotient

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/Quotient/quaternion
mkdir ${HOME}/.config/Quotient
whitelist ${HOME}/.cache/Quotient/quaternion
whitelist ${HOME}/.config/Quotient
whitelist ${DOWNLOADS}
whitelist /usr/share/Quotient/quaternion
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-bin quaternion
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,mime.types,nsswitch.conf,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
