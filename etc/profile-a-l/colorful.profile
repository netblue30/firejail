# Firejail profile for colorful
# Description: simple 2D sideview shooter
# This file is overwritten after every install/update
# Persistent local customizations
include colorful.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.suve/colorful

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.suve/colorful
whitelist ${HOME}/.suve/colorful
whitelist /usr/share/suve
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin colorful
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,pulse
private-tmp

dbus-user none
dbus-system none
