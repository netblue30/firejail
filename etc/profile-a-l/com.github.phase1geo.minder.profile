# Firejail profile for com.github.phase1geo.minder
# Description: Mind-mapping application
# This file is overwritten after every install/update
# Persistent local customizations
include com.github.phase1geo.minder.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/minder
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/minder
whitelist ${HOME}/.local/share/minder
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist ${PICTURES}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
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
protocol unix
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin com.github.phase1geo.minder
private-cache
private-dev
private-etc alternatives,dconf,fonts,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,X11,xdg
private-tmp

dbus-user filter
dbus-user.own com.github.phase1geo.minder
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces
