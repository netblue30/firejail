# Firejail profile for npm
# Description: The Node.js Package Manager
# This file is overwritten after every install/update

# Persistent local customizations
include npm.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*
blacklist ${RUNUSER}

noblacklist ${HOME}/.npm
noblacklist ${HOME}/.npmrc

#include allow-nodejs.inc
noblacklist ${PATH}/node
noblacklist /usr/include/node

noblacklist ${PATH}/bash
noblacklist ${PATH}/dash
noblacklist ${PATH}/sh

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-shell.inc
include /etc/firejail/disable-write-mnt.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
shell none

disable-mnt
private-dev
private-etc alternatives,ca-certificates,crypto-policies,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

dbus-user filter
dbus-user.own com.github.netblue30.firejail
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
dbus-system none
