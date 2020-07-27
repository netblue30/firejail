# Firejail profile for xfce4-screenshooter
# Description: Xfce screenshot tool
# This file is overwritten after every install/update
# Persistent local customizations
include xfce4-screenshooter.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/xfce4
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
tracelog

disable-mnt
private-bin xfce4-screenshooter,xfconf-query
private-dev
private-etc ca-certificates,crypto-policies,dconf,fonts,gtk-3.0,pki,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
