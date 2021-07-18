# Firejail profile for gl-117
# Description: Action flight simulator
# This file is overwritten after every install/update
# Persistent local customizations
include gl-117.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gl-117

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.gl-117
whitelist ${HOME}/.gl-117
whitelist /usr/share/gl-117
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
shell none
tracelog

disable-mnt
private-bin gl-117
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,bumblebee,drirc,glvnd,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nvidia,pulse
private-tmp

dbus-user none
dbus-system none
