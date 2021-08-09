# Firejail profile for OpenArena
# Description: deathmatch FPS game based on GPL idTech3 technology
# This file is overwritten after every install/update
# Persistent local customizations
include openarena.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.openarena

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.openarena
whitelist ${HOME}/.openarena
whitelist /usr/share/openarena
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
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin bash,cut,glxinfo,grep,head,openarena,openarena_ded,quake3,zenity
private-cache
private-dev
private-etc drirc,machine-id,openal,passwd,selinux,udev,xdg
private-tmp

dbus-user none
dbus-system none
