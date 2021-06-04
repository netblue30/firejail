# Firejail profile for googler clones
# Description: common profile for googler clones
# This file is overwritten after every install/update
# Persistent local customizations
include googler-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*

noblacklist ${HOME}/.w3m

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${HOME}/.w3m
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin env,python3*,sh,w3m
private-cache
private-dev
private-etc hosts,inputrc,ssl,terminfo
private-tmp

dbus-user none
dbus-system none
