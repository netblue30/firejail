# Firejail profile for lifeograph
# Description: Lifeograph is a diary program to take personal notes
# This file is overwritten after every install/update
# Persistent local customizations
include lifeograph.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist ${DOCUMENTS}
whitelist /usr/share/lifeograph
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
private-bin lifeograph
private-cache
private-dev
private-etc @x11
private-tmp

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces
